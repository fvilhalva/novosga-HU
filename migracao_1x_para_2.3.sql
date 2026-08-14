-- =============================================================================
-- Migração NovoSGA 1.x  ->  2.3  (script de PARTIDA, não é "restore")
--
-- PRÉ-REQUISITOS:
--   1) Banco 2.3 já criado com o schema novo em "public"
--      (php bin/console doctrine:migrations:migrate -n).
--   2) Dump antigo carregado num schema separado chamado "legado".
--
-- COMO CARREGAR O DUMP ANTIGO NO SCHEMA "legado":
--   No psql, dentro do database "app":
--       CREATE SCHEMA legado;
--       -- edite o backup_novosga.sql trocando "public." por "legado."
--       -- (ou use: SET search_path = legado; antes de importar, se o dump
--       --  não qualificar os nomes) e então importe o arquivo.
--   Dica prática: sed 's/public\./legado./g' backup_novosga.sql > legado.sql
--   e importe o legado.sql.
--
-- ORDEM: respeita dependências (unidade -> serviço -> usuário -> vínculos).
--
-- >>> ATENÇÃO <<<  O schema REAL da 2.3 é o que está no banco após as
-- migrations, e pode ter colunas NOT NULL a mais do que os arquivos de init
-- sugerem (ex.: unidades.timezone, prioridades.cor). ANTES de rodar, confira
-- as colunas reais no DBeaver (ou \d <tabela>) e ajuste os DEFAULT marcados
-- com  -- [CONFERIR]  abaixo.
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- 1) UNIDADES
--    Antigo: id, grupo_id, codigo, nome, status, stat_imp, msg_imp
--    Novo:   id, nome, descricao, ativo, impressao_* ..., (timezone? [CONFERIR])
-- -----------------------------------------------------------------------------
INSERT INTO public.unidades
    (id, nome, descricao, ativo,
     impressao_cabecalho, impressao_rodape,
     impressao_exibir_data, impressao_exibir_prioridade,
     impressao_exibir_nome_unidade, impressao_exibir_nome_servico,
     impressao_exibir_mensagem_servico
     /* , timezone  -- [CONFERIR] se existir e for NOT NULL, adicione aqui */)
SELECT
    u.id,
    u.nome,
    u.nome                      AS descricao,        -- 1.x não tinha descrição
    (u.status = 1)              AS ativo,
    COALESCE(u.msg_imp, '')     AS impressao_cabecalho,
    ''                          AS impressao_rodape,
    TRUE, TRUE, TRUE, TRUE, TRUE
    /* , 'America/Campo_Grande'  -- [CONFERIR] default de timezone */
FROM legado.unidades u;

-- -----------------------------------------------------------------------------
-- 2) PRIORIDADES
--    Antigo: id, nome, descricao, peso, status
--    Novo:   id, nome, descricao, peso, ativo, (cor? [CONFERIR])
-- -----------------------------------------------------------------------------
INSERT INTO public.prioridades
    (id, nome, descricao, peso, ativo
     /* , cor  -- [CONFERIR] se NOT NULL: peso=0 -> '#0000FF', senão '#FF0000' */)
SELECT
    p.id, p.nome, p.descricao, p.peso, (p.status = 1) AS ativo
    /* , CASE WHEN p.peso = 0 THEN '#0000FF' ELSE '#FF0000' END */
FROM legado.prioridades p;

-- -----------------------------------------------------------------------------
-- 3) LOCAIS
--    Antigo: id, nome    Novo: id, nome (UNIQUE)
--    CUIDADO: nome é UNIQUE na 2.3; se houver nomes repetidos no 1.x, falha.
-- -----------------------------------------------------------------------------
INSERT INTO public.locais (id, nome)
SELECT l.id, l.nome FROM legado.locais l;

-- -----------------------------------------------------------------------------
-- 4) SERVICOS
--    Antigo: id, macro_id, descricao(100), nome, status, peso
--    Novo:   id, macro_id, nome, descricao(250), ativo, peso
-- -----------------------------------------------------------------------------
INSERT INTO public.servicos (id, macro_id, nome, descricao, ativo, peso)
SELECT s.id, s.macro_id, s.nome, s.descricao, (s.status = 1) AS ativo, s.peso
FROM legado.servicos s;

-- -----------------------------------------------------------------------------
-- 5) PERFIS  (antigo "cargos" -> novo "perfis")
--    Antigo: id, nome, descricao, esquerda, direita, nivel (árvore nested-set)
--    Novo:   id, nome, descricao, modulos (TEXT)
--    A coluna "modulos" define as permissões no modelo novo. Como o modelo
--    de permissão mudou (cargos_mod_perm -> string em perfis.modulos), aqui
--    migro só nome/descrição. Ajuste "modulos" manualmente pela interface
--    admin depois, ou preencha conforme o formato esperado pela 2.3. [CONFERIR]
-- -----------------------------------------------------------------------------
INSERT INTO public.perfis (id, nome, descricao, modulos)
SELECT c.id, c.nome, c.descricao, NULL::text AS modulos
FROM legado.cargos c;

-- -----------------------------------------------------------------------------
-- 6) DEPARTAMENTOS  (antigo "grupos" -> novo "departamentos")
--    Antigo: id, nome, descricao, esquerda, direita, nivel
--    Novo:   id, nome, descricao, ativo
-- -----------------------------------------------------------------------------
INSERT INTO public.departamentos (id, nome, descricao, ativo)
SELECT g.id, g.nome, g.descricao, TRUE FROM legado.grupos g;

-- -----------------------------------------------------------------------------
-- 7) USUARIOS
--    Antigo: id, login, nome, sobrenome, senha(md5), ult_acesso, status, session_id
--    Novo:   id, login, nome, sobrenome, email(UNIQUE null), senha, ativo,
--            ultimo_acesso, ip, session_id, algorithm, admin, salt
--    >>> Senha MD5 do 1.x funciona direto: algorithm='md5', salt=NULL. <<<
--    admin = TRUE se o usuário tiver cargo Administrador (cargo_id = 1).
-- -----------------------------------------------------------------------------
INSERT INTO public.usuarios
    (id, login, nome, sobrenome, email, senha, ativo,
     ultimo_acesso, ip, session_id, algorithm, admin, salt)
SELECT
    u.id, u.login, u.nome, u.sobrenome,
    NULL              AS email,          -- 1.x não tinha email
    u.senha,                             -- hash MD5 preservado
    (u.status = 1)    AS ativo,
    u.ult_acesso      AS ultimo_acesso,
    NULL              AS ip,
    u.session_id,
    'md5'             AS algorithm,      -- casa com o hasher md5 do security.yaml
    COALESCE((SELECT TRUE FROM legado.usu_grup_cargo ugc
              WHERE ugc.usuario_id = u.id AND ugc.cargo_id = 1 LIMIT 1),
             FALSE)   AS admin,
    NULL              AS salt
FROM legado.usuarios u;

-- -----------------------------------------------------------------------------
-- 8) LOTACOES  (antigo "usu_grup_cargo" -> novo "lotacoes")
--    Antigo: usuario_id, grupo_id, cargo_id
--    Novo:   usuario_id, unidade_id, perfil_id  (UNIQUE usuario_id+unidade_id)
--    Mapa: o grupo do vínculo -> a(s) unidade(s) cujo grupo_id = esse grupo.
--          cargo_id -> perfil_id (mesmos IDs, migrados no passo 5).
-- -----------------------------------------------------------------------------
INSERT INTO public.lotacoes (usuario_id, unidade_id, perfil_id)
SELECT DISTINCT ugc.usuario_id, un.id AS unidade_id, ugc.cargo_id AS perfil_id
FROM legado.usu_grup_cargo ugc
JOIN legado.unidades un ON un.grupo_id = ugc.grupo_id;
-- OBS: usuários ligados a um grupo "raiz" sem unidade correspondente
-- (ex.: admin no grupo 1) não geram lotação aqui — o admin acessa via flag admin.

-- -----------------------------------------------------------------------------
-- 9) SERVICOS_UNIDADES  (antigo "uni_serv" -> novo "servicos_unidades")
--    Antigo: unidade_id, servico_id, local_id, sigla(1), status, peso
--    Novo:   servico_id, unidade_id, local_id, departamento_id, sigla(3),
--            ativo, peso, prioridade(bool), numero_inicial, numero_final,
--            incremento, mensagem
-- -----------------------------------------------------------------------------
-- NOTA: no schema real da 2.3 NÃO existe coluna "prioridade"; no lugar há
-- "tipo" e "maximo" (ambas nullable), que deixamos em branco.
INSERT INTO public.servicos_unidades
    (servico_id, unidade_id, local_id, departamento_id, sigla, ativo, peso,
     numero_inicial, numero_final, incremento, mensagem)
SELECT
    us.servico_id, us.unidade_id, us.local_id,
    NULL            AS departamento_id,
    us.sigla,
    (us.status = 1) AS ativo,
    us.peso,
    1               AS numero_inicial,
    NULL            AS numero_final,
    1               AS incremento,
    NULL            AS mensagem
FROM legado.uni_serv us;

-- -----------------------------------------------------------------------------
-- 10) SERVICOS_USUARIOS  (antigo "usu_serv" -> novo "servicos_usuarios")
--     Antigo: unidade_id, servico_id, usuario_id
--     Novo:   servico_id, unidade_id, usuario_id, peso
-- -----------------------------------------------------------------------------
INSERT INTO public.servicos_usuarios (servico_id, unidade_id, usuario_id, peso)
SELECT us.servico_id, us.unidade_id, us.usuario_id, 1 AS peso
FROM legado.usu_serv us;

-- -----------------------------------------------------------------------------
-- ATENDIMENTOS e HISTÓRICO: NÃO migrados neste script.
--   Motivo: no seu dump são só 9 registros de teste e o histórico está vazio.
--   Além disso exigem: status int->texto (de-para), extrair nm_cli/ident_cli
--   para a tabela "clientes", e recalcular tempos. Para o TESTE, recomendo
--   começar a operação do zero (fila limpa). Fica como passo separado se e
--   quando você precisar preservar o histórico real da 1.5.1.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- 10.5) REMOVER MICROSSEGUNDOS DAS COLUNAS DE AUDITORIA
--     As colunas created_at/updated_at/deleted_at da 2.3 são timestamp(6) e têm
--     DEFAULT now(). Como inserimos via SQL sem preenchê-las, o now() gravou
--     valores COM microssegundos (ex.: 18:13:03.66729). As entidades da 2.3 leem
--     essas colunas como DateTimeImmutable no formato 'Y-m-d H:i:s' (sem micros),
--     o que causa erro 500 ("Could not convert database value ...") já no login.
--     Truncamos para segundos em todas as colunas timestamp das tabelas migradas.
-- -----------------------------------------------------------------------------
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT table_name, column_name FROM information_schema.columns
    WHERE table_schema='public' AND datetime_precision=6 AND data_type LIKE 'timestamp%'
      AND table_name IN ('unidades','prioridades','locais','servicos','perfis',
                         'departamentos','usuarios','lotacoes',
                         'servicos_unidades','servicos_usuarios')
  LOOP
    EXECUTE format(
      'UPDATE public.%I SET %I = date_trunc(''second'', %I) WHERE %I IS NOT NULL AND %I <> date_trunc(''second'', %I)',
      r.table_name, r.column_name, r.column_name, r.column_name, r.column_name, r.column_name);
  END LOOP;
END $$;

-- -----------------------------------------------------------------------------
-- 10.6) CONTADORES DE SENHA (por unidade + serviço)
--     Na 2.3 o contador é por (unidade_id, servico_id) e a emissão de senha faz
--     UPDATE contador ... WHERE numero = <atual>; se a linha não existir, o app
--     lança "Error updating ticket counter" na Triagem. Normalmente a linha é
--     criada ao adicionar o serviço à unidade (UnidadeService: numero =
--     numero_inicial). Como inserimos os vínculos via SQL, semeamos aqui.
-- -----------------------------------------------------------------------------
INSERT INTO public.contador (unidade_id, servico_id, numero)
SELECT su.unidade_id, su.servico_id, COALESCE(su.numero_inicial, 1)
FROM public.servicos_unidades su
WHERE NOT EXISTS (
    SELECT 1 FROM public.contador c
    WHERE c.unidade_id = su.unidade_id AND c.servico_id = su.servico_id
);

-- -----------------------------------------------------------------------------
-- 11) CORRIGIR SEQUENCES (porque inserimos IDs explícitos)
--     Sem isso, o próximo INSERT pela aplicação colide com IDs já usados.
-- -----------------------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('public.unidades','id'),      COALESCE((SELECT MAX(id) FROM public.unidades),1));
SELECT setval(pg_get_serial_sequence('public.prioridades','id'),   COALESCE((SELECT MAX(id) FROM public.prioridades),1));
SELECT setval(pg_get_serial_sequence('public.locais','id'),        COALESCE((SELECT MAX(id) FROM public.locais),1));
SELECT setval(pg_get_serial_sequence('public.servicos','id'),      COALESCE((SELECT MAX(id) FROM public.servicos),1));
SELECT setval(pg_get_serial_sequence('public.perfis','id'),        COALESCE((SELECT MAX(id) FROM public.perfis),1));
SELECT setval(pg_get_serial_sequence('public.departamentos','id'), COALESCE((SELECT MAX(id) FROM public.departamentos),1));
SELECT setval(pg_get_serial_sequence('public.usuarios','id'),      COALESCE((SELECT MAX(id) FROM public.usuarios),1));
SELECT setval(pg_get_serial_sequence('public.lotacoes','id'),      COALESCE((SELECT MAX(id) FROM public.lotacoes),1));

-- Se tudo parecer certo, troque para COMMIT. Enquanto testa, use ROLLBACK
-- para não sujar o banco.
COMMIT;
-- ROLLBACK;
