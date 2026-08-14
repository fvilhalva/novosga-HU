# Tutorial de Execução — NovoSGA 2.3 + HU-Speaker (chamada por voz)

Guia completo para subir a solução **do zero** e para o **uso diário**, incluindo
os problemas reais já resolvidos. Ambiente de referência: **Windows + WSL2
(Ubuntu) + Docker Desktop**.

---

## 0. Arquitetura (o que fala com o quê)

```mermaid
flowchart LR
    B["Navegador<br/>(Painel de senhas)"] -->|"GET /{painel}/voz/{senha}"| N
    subgraph HOST["WSL2 (host)"]
      N["NovoSGA 2.3<br/>(symfony serve :8000)"]
    end
    subgraph DK["Docker"]
      PG[("PostgreSQL :5434")]
      MC["Mercure :3000<br/>(tempo real)"]
      MP["Mailpit<br/>(e-mail teste)"]
      HS["HU-Speaker :8082<br/>(Piper TTS)"]
    end
    N --> PG
    N --> MC
    N -->|"JWT HS256 + /speak/synthesize + /speak/download"| HS
    N -->|"áudio WAV"| B
```

- **NovoSGA 2.3** (Symfony) roda no host via `symfony serve`; a infra
  (Postgres, Mercure, Mailpit) roda em Docker.
- **HU-Speaker** (FastAPI + Piper) roda em Docker na porta **8082**.
- A voz é **servidor→servidor**: o painel chama o NovoSGA, que assina um JWT e
  chama o HU-Speaker; o segredo nunca vai ao navegador.

> ⚠️ **Conflitos de porta neste PC** (já contornados): a **5432** é usada por um
> PostgreSQL nativo do Windows e a **8081** pelo Docker Desktop. Por isso o banco
> foi publicado em **5434** e o app roda em **8000**.

---

## 1. Pré-requisitos (instalar uma vez)

- **WSL2 (Ubuntu)** + **Docker Desktop** (com integração WSL ligada).
- **PHP 8.3** com extensões: `pdo_pgsql, intl, mbstring, xml, zip, curl`.
- **Composer 2.x**, **Symfony CLI**, **openssl**.

Conferir:
```bash
php -v && composer --version && symfony version && docker --version
```

---

## 2. HU-Speaker (primeira vez)

Pasta: `~/Faculdade/estagio/HU-Speaker`

```bash
cd ~/Faculdade/estagio/HU-Speaker

# 2.1 rede externa que o compose do HU-Speaker espera
docker network create sga-net 2>/dev/null || true

# 2.2 modelo de voz Piper (~63 MB) - NÃO vem no git
curl -fL -o src/hu_speaker/models/pt_BR-faber-medium.onnx \
  "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx?download=true"

# 2.3 conferir o .env: JWT_SECRET_KEY definido (guarde esse valor!)
grep JWT_SECRET_KEY .env

# 2.4 sobe (com build, pois o modelo entra na imagem)
docker compose up -d --build
```

Verificar:
```bash
curl -s http://localhost:8082/health      # -> {"status":"ok"}
```

> O `JWT_SECRET_KEY` do HU-Speaker **tem que ser idêntico** ao
> `HU_SPEAKER_JWT_SECRET` do NovoSGA (passo 3.5). É isso que autentica a chamada.

---

## 3. NovoSGA 2.3 (primeira vez)

Pasta: `~/Faculdade/estagio/novosga-HU`

```bash
cd ~/Faculdade/estagio/novosga-HU
```

### 3.1 Banco na porta 5434 (evita o PostgreSQL nativo do Windows)
No `compose.override.yaml`, o serviço `database` publica **`5434:5432`**
(já configurado). E crie o override local do banco:

```bash
cat > .env.local <<'EOF'
DATABASE_URL="postgresql://app:!ChangeMe!@127.0.0.1:5434/app?serverVersion=16&charset=utf8"
EOF
```
> `.env.local` é ignorado pelo git — é o lugar certo para ajustes locais.

### 3.2 Sobe a infra (Postgres, Mercure, Mailpit)
```bash
docker compose up -d
```

### 3.3 Dependências PHP
```bash
composer install
```

### 3.4 Chaves JWT do NovoSGA (login/API OAuth)
```bash
mkdir -p config/jwt
openssl genrsa -out config/jwt/private.pem 2048
openssl rsa -in config/jwt/private.pem -pubout -out config/jwt/public.pem
```

### 3.5 Apontar para o HU-Speaker (no `.env`)
Garanta estas duas linhas no `.env` (o segredo = `JWT_SECRET_KEY` do HU-Speaker):
```env
HU_SPEAKER_URL=http://localhost:8082
HU_SPEAKER_JWT_SECRET=<mesmo valor do JWT_SECRET_KEY do HU-Speaker>
```

### 3.6 Criar o schema do banco (migrations)
```bash
php bin/console doctrine:migrations:migrate -n
```

### 3.7 Popular os dados — escolha UM caminho

**Caminho A — instalação limpa (começar do zero):**
```bash
php bin/console novosga:install
```

**Caminho B — migrar os dados da 1.x → 2.3 (usado no HU):**
```bash
# 1) carrega o dump antigo num schema "legado"
sed 's/public\./legado./g' backup_novosga.sql > legado.sql
#    cria o schema "legado" + o role "novosga" (o dump 1.x tem "OWNER TO novosga")
docker compose exec -T -e PGPASSWORD='!ChangeMe!' database psql -U app -d app -c \
  "DROP SCHEMA IF EXISTS legado CASCADE; CREATE SCHEMA legado; DO \$\$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='novosga') THEN CREATE ROLE novosga; END IF; END \$\$;"
#    importa o dump no schema legado
docker compose exec -T -e PGPASSWORD='!ChangeMe!' database psql -U app -d app < legado.sql

# 2) roda o script de migração (já inclui: fix de microssegundos + seed de contadores)
docker compose exec -T -e PGPASSWORD='!ChangeMe!' database \
  psql -U app -d app -v ON_ERROR_STOP=1 < migracao_1x_para_2.3.sql
```
> O `migracao_1x_para_2.3.sql` já corrige dois problemas que travavam a 2.3:
> **(1)** remove microssegundos dos `created_at` (senão dá **500 no login**);
> **(2)** semeia a tabela `contador` (senão dá **"Error updating ticket counter"**
> na Triagem).

### 3.8 Subir o app
```bash
symfony serve -d          # http://localhost:8000
```

### 3.9 Entrar
Abra **http://localhost:8000** e faça login:
- Caminho A: o usuário criado pelo `novosga:install`.
- Caminho B: **`admin` / `123456`** (migrado da 1.x, hash MD5 preservado).

---

## 4. Verificar a integração de voz (3 níveis)

**Nível 1 — HU-Speaker vivo:**
```bash
curl -s http://localhost:8082/health          # {"status":"ok"}
```

**Nível 2 — NovoSGA autentica e sintetiza (servidor→servidor):**
```bash
cd ~/Faculdade/estagio/novosga-HU
SECRET=$(grep -hE '^HU_SPEAKER_JWT_SECRET=' .env.local .env 2>/dev/null | tail -1 | cut -d= -f2- | tr -d '"'"'"' \r')
JWT=$(SECRET="$SECRET" php -r '$s=getenv("SECRET");$b=fn($d)=>rtrim(strtr(base64_encode($d),"+/","-_"),"=");$h=$b(json_encode(["alg"=>"HS256","typ"=>"JWT"]));$n=time();$p=$b(json_encode(["sub"=>"novosga-service","source_system"=>"novosga","iat"=>$n,"exp"=>$n+120]));echo "$h.$p.".$b(hash_hmac("sha256","$h.$p",$s,true));')
curl -s -X POST http://localhost:8082/speak/synthesize \
  -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" \
  -d '{"text":"teste","language":"pt_BR","length_scale":1.0}'
```
Esperado: `{"id":"...","status":"completed"}`. Se vier `{"detail":"Invalid token"}`
→ os segredos não batem (passo 2.3 vs 3.5).

**Nível 3 — fluxo real do painel:** com um **Painel** cadastrado (tem `publicId`)
e uma **senha chamada**:
```bash
curl -s -o voz.wav -w "%{http_code} %{content_type}\n" \
  "http://localhost:8000/<publicId>/voz/<senhaId>"     # 200 audio/wav
```

---

## 5. Uso diário (ligar / desligar)

**Ligar** (2 comandos):
```bash
cd ~/Faculdade/estagio/HU-Speaker && docker compose up -d
cd ~/Faculdade/estagio/novosga-HU && docker compose up -d && symfony serve -d
```
App em **http://localhost:8000**.

**Desligar:**
```bash
cd ~/Faculdade/estagio/novosga-HU && symfony server:stop && docker compose stop
cd ~/Faculdade/estagio/HU-Speaker && docker compose stop
```

**Status / logs:**
```bash
symfony server:status
tail -f ~/Faculdade/estagio/novosga-HU/var/log/dev.log     # erros do NovoSGA
docker compose -f ~/Faculdade/estagio/HU-Speaker/docker-compose.yml logs -f
```

---

## 6. Solução de problemas (os perrengues reais)

| Sintoma | Causa | Correção |
|--------|-------|----------|
| Login dá **500** "Could not convert database value ... DateTimeImmutable" | `created_at` migrado com microssegundos | Já corrigido no `migracao_1x_para_2.3.sql` (seção 10.5); se ocorrer, rode o `date_trunc('second', ...)` nas colunas timestamp |
| Triagem: **"Error updating ticket counter"** | Tabela `contador` sem linha para o serviço | Já corrigido no script (seção 10.6, semeia `contador` a partir de `servicos_unidades`) |
| **connection timeout** na porta 5432 | PostgreSQL **nativo do Windows** brigando com o container | Usar **5434** (compose.override + `.env.local`) — passos 3.1 |
| HU-Speaker **`{"detail":"Invalid token"}`** | `HU_SPEAKER_JWT_SECRET` ≠ `JWT_SECRET_KEY` | Igualar os segredos (passos 2.3 e 3.5) |
| HU-Speaker **500 "Piper model not found"** | Modelo `.onnx` ausente | Baixar o modelo e `docker compose up -d --build` (passo 2.2) |
| HU-Speaker não sobe: rede `sga-net` não existe | Rede externa do compose | `docker network create sga-net` (passo 2.1) |
| `symfony serve` diz **Not Running** | Daemon caiu | `symfony serve -d` de novo |

---

## 7. Resumo de portas e credenciais

| Serviço | URL / porta |
|---------|-------------|
| NovoSGA 2.3 (app) | http://localhost:8000 |
| HU-Speaker (TTS) | http://localhost:8082 (`/health`, `/docs`) |
| PostgreSQL | localhost:**5434** (db/user `app`, senha `!ChangeMe!`) |
| Mercure (tempo real) | http://localhost:3000 |
| Mailpit (e-mail teste) | porta mapeada dinamicamente — ver `docker compose ps` |

**Login (após migração 1.x):** `admin` / `123456`.

> Em **produção** os valores mudam: portas oficiais (8081/5432), segredos fortes
> (`JWT_SECRET_KEY`, `MERCURE_*`, `POSTGRES_PASSWORD`), `APP_ENV=prod` e o app
> servido por um servidor web real (não `symfony serve`).
