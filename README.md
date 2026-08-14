![NovoSGA](doc/images/github-banner.png)

# NovoSGA 2.3 + HU-Speaker (chamada por voz)

> **Fork do [NovoSGA](https://github.com/novosga/novosga)** com integração de
> **chamada de senha por voz** via **HU-Speaker** — um serviço de síntese de
> fala (TTS) próprio, baseado em [Piper](https://github.com/rhasspy/piper),
> desenvolvido para o cenário de **ambulatório** (Hospital Universitário).
>
> O NovoSGA original **não possui** integração de voz. Toda a camada de TTS
> descrita aqui foi adicionada neste fork.

![license](https://img.shields.io/github/license/novosga/novosga)

---

## Sobre

O NovoSGA é um sistema de gerenciamento de senha de atendimento criado em 2012
por [Rogério Lino](https://github.com/rogeriolino) e mantido pela comunidade
NovoSGA e pela [Mangati](https://mangati.com). É gratuito, traduzido para
Inglês, Espanhol e Português, e amplamente usado em órgãos públicos, estatais e
empresas.

Este fork mantém 100% da base 2.3 e acrescenta a **convocação por voz no painel
de senhas**: quando uma senha é chamada, o painel busca um áudio WAV gerado pelo
HU-Speaker e o reproduz automaticamente.

---

## O que este fork adiciona

Em relação ao NovoSGA upstream, este fork inclui:

| Componente | Arquivo / local | Papel |
|-----------|------------------|-------|
| **Cliente HU-Speaker** | `src/Service/HuSpeakerClient.php` | Assina o JWT de serviço (HS256), chama `/speak/synthesize` e `/speak/download`. |
| **Endpoint de voz do painel** | `src/Controller/PainelController.php` → rota `painel_voz` (`GET /{publicId}/voz/{senha}`) | Monta a frase, sintetiza no HU-Speaker (servidor→servidor) e faz **proxy** do WAV para o navegador. |
| **Fiação de serviço** | `config/services.yaml` | Injeta `HU_SPEAKER_URL` e `HU_SPEAKER_JWT_SECRET` no `HuSpeakerClient`. |
| **Variáveis de ambiente** | `.env` (bloco `hu-speaker`) | `HU_SPEAKER_URL`, `HU_SPEAKER_JWT_SECRET`. |
| **Orquestrador** | `estagio.sh` | Sobe **NovoSGA + HU-Speaker + infra** com um comando (`setup/start/stop/status/check`). |
| **Documentação** | `docs/tutorial-execucao.md` | Passo a passo manual detalhado + solução de problemas reais. |
| **Migração de dados 1.x** | `backup_novosga.sql`, `migracao_1x_para_2.3.sql` | Migra uma base NovoSGA 1.x para o modelo 2.3 (com fixes de microssegundos e seed de contadores). |

> **HU-Speaker é um projeto separado** (FastAPI + Piper), mantido no seu próprio
> repositório. Este README cobre o lado NovoSGA e como orquestrar os dois juntos.

### Como a voz funciona (servidor → servidor)

```mermaid
flowchart LR
    B["Navegador<br/>(Painel de senhas)"] -->|"GET /{painel}/voz/{senha}"| N
    subgraph HOST["Host"]
      N["NovoSGA 2.3<br/>(symfony serve :8000)"]
    end
    subgraph DK["Docker"]
      PG[("PostgreSQL :5434")]
      MC["Mercure :3000<br/>(tempo real)"]
      MP["Mailpit<br/>(e-mail de teste)"]
      HS["HU-Speaker :8082<br/>(Piper TTS)"]
    end
    N --> PG
    N --> MC
    N -->|"JWT HS256 + /speak/synthesize + /speak/download"| HS
    N -->|"áudio WAV"| B
```

O segredo JWT **nunca vai ao navegador**: o painel só chama o NovoSGA, que
assina o token e conversa com o HU-Speaker. A frase é gerada soletrando a senha
dígito a dígito para o Piper (ex.: `A001` → *"Senha A zero zero um"*).

---

## Requisitos

- **Docker** + **Docker Compose**
- **PHP ≥ 8.2** com extensões `pdo_pgsql`, `intl`, `mbstring`, `xml`, `zip`, `curl`, `ctype`, `iconv`
- **Composer 2.x**
- **Symfony CLI** (`symfony`)
- **openssl** e **curl**
- O **repositório do HU-Speaker** disponível localmente

Conferir:

```bash
php -v && composer --version && symfony version && docker --version
```

---

## Estrutura esperada de pastas

O `estagio.sh` procura o HU-Speaker em `../HU-Speaker` por padrão (ou no caminho
apontado por `HU_SPEAKER_DIR`). Deixe os dois repositórios lado a lado:

```
pasta-pai/
├── novosga-HU-feat-ambulatorio/   ← este repositório
└── HU-Speaker/                    ← o serviço de voz (repo próprio)
```

Antes do primeiro `setup`, garanta que o HU-Speaker tenha um `.env` com
`JWT_SECRET_KEY` definido — esse valor precisa ser idêntico ao
`HU_SPEAKER_JWT_SECRET` do NovoSGA (o script ajuda a alinhar isso).

---

## Execução com `estagio.sh` (recomendado)

O `estagio.sh` orquestra tudo. **Ele exige o HU-Speaker presente** (ver estrutura
de pastas acima) — sem ele, o `setup`/`start` aborta no check de pré-requisitos.

### Primeira vez (instalação do zero)

```bash
chmod +x estagio.sh          # se necessário

./estagio.sh setup --fresh   # instalação limpa
# ou
./estagio.sh setup --migrate # populando com dados migrados da 1.x
```

O `setup` executa, em ordem:

1. **Pré-requisitos** — confere `docker`, `php`, `composer`, `symfony`, `openssl`, `curl` e a pasta do HU-Speaker.
2. **HU-Speaker** — cria a rede `sga-net`, baixa o modelo Piper (~63 MB, se ausente) e sobe o serviço com build.
3. **Infra do NovoSGA** — sobe PostgreSQL, Mercure e Mailpit via Docker.
4. **`.env.local`** — grava o `DATABASE_URL` na porta **5434** (evita conflito com um PostgreSQL nativo na 5432).
5. **Dependências** — `composer install` (se `vendor/` ausente).
6. **Chaves JWT** — gera `config/jwt/{private,public}.pem` (login/OAuth do NovoSGA).
7. **Vars do HU-Speaker** — garante `HU_SPEAKER_URL` e `HU_SPEAKER_JWT_SECRET` no `.env`.
8. **Migrations** — cria o schema do banco (`doctrine:migrations:migrate`).
9. **Popular o banco** — conforme a flag (ver abaixo).
10. **Checagem de segredo** — avisa se os JWTs dos dois lados divergirem.
11. **Sobe o app** — `symfony serve -d` em `http://localhost:8000`.

### Flags do `setup`

| Comando | Efeito |
|---------|--------|
| `./estagio.sh setup --fresh` | Instalação limpa via `novosga:install`. **Não** usa os dados da 1.x. |
| `./estagio.sh setup --migrate` | Migra os dados da 1.x → 2.3 (carrega `backup_novosga.sql` no schema `legado` e roda `migracao_1x_para_2.3.sql`). Login final: **`admin` / `123456`**. |
| `./estagio.sh setup` | Prepara tudo, mas deixa o banco **vazio** (você popula depois). |

> ⚠️ **Idempotência da migração:** o `--migrate` só popula se **não houver
> usuários** no banco. Se você já rodou um `--fresh` antes (que cria o admin),
> um `--migrate` posterior é **ignorado**. Para trocar de `--fresh` para
> `--migrate`, zere o banco primeiro:
> ```bash
> ./estagio.sh stop
> docker compose down -v      # apaga o volume do Postgres
> ./estagio.sh setup --migrate
> ```

### Uso diário

```bash
./estagio.sh start     # liga HU-Speaker + infra + app
./estagio.sh stop      # desliga tudo
./estagio.sh restart   # stop + start
./estagio.sh status    # o que está rodando (containers + app Symfony)
./estagio.sh check     # testa a integração de voz (ver abaixo)
./estagio.sh help      # ajuda
```

### Validando a voz — `./estagio.sh check`

Testa a integração em dois níveis:

- **Nível 1** — HU-Speaker vivo (`GET /health`).
- **Nível 2** — o NovoSGA gera um JWT e pede uma síntese (`POST /speak/synthesize`).
  Se falhar com *"Invalid token"*, os segredos JWT dos dois lados estão diferentes.

### Variáveis que você pode sobrescrever

O script aceita overrides por variável de ambiente:

| Variável | Padrão | Uso |
|----------|--------|-----|
| `HU_SPEAKER_DIR` | `../HU-Speaker` | Caminho do repositório do HU-Speaker |
| `DB_PORT` | `5434` | Porta do Postgres no host |
| `DB_USER` / `DB_NAME` / `DB_PASS` | `app` / `app` / `!ChangeMe!` | Credenciais do banco |
| `APP_PORT` | `8000` | Porta do app |
| `HU_URL` | `http://localhost:8082` | URL do HU-Speaker |

Exemplo:

```bash
HU_SPEAKER_DIR=~/projetos/HU-Speaker APP_PORT=8001 ./estagio.sh setup --fresh
```

---

## Execução manual (alternativa ao script)

Se preferir controlar cada passo (ou não tiver o HU-Speaker e quiser só o
NovoSGA), o passo a passo completo — incluindo os perrengues já resolvidos —
está em [`docs/tutorial-execucao.md`](docs/tutorial-execucao.md). Em resumo:

```bash
# 1. infra (postgres + mercure + mailpit)
docker compose up -d

# 2. banco na porta 5434 (evita conflito com Postgres nativo na 5432)
echo 'DATABASE_URL="postgresql://app:!ChangeMe!@127.0.0.1:5434/app?serverVersion=16&charset=utf8"' >> .env.local

# 3. dependências
composer install

# 4. chaves JWT (login/OAuth)
mkdir -p config/jwt
openssl genrsa -out config/jwt/private.pem 2048
openssl rsa -in config/jwt/private.pem -pubout -out config/jwt/public.pem

# 5. schema
php bin/console doctrine:migrations:migrate -n

# 6. popular (escolha um)
php bin/console novosga:install        # limpo
#   — ou a migração 1.x (ver seção abaixo)

# 7. subir
symfony serve -d                       # http://localhost:8000
```

---

## Migração de dados 1.x → 2.3

A cadeia de migração envolve **três arquivos**, nesta ordem:

1. `backup_novosga.sql` — dump da base 1.x (os dados de origem).
2. Um `sed 's/public\./legado./g'` gera `legado.sql`, carregado no schema `legado`.
3. `migracao_1x_para_2.3.sql` — lê do schema `legado` e insere no modelo 2.3.

O `migracao_1x_para_2.3.sql` **não popula sozinho** — ele é só o passo de
transformação (`INSERT ... SELECT FROM legado.*`) e depende dos dados já
carregados no schema `legado`. Ele também corrige dois problemas conhecidos da
2.3: remove microssegundos dos `created_at` (senão dá **500 no login**) e semeia
a tabela `contador` (senão dá **"Error updating ticket counter"** na Triagem).

O `estagio.sh setup --migrate` automatiza toda essa cadeia.

---

## Solução de problemas

| Sintoma | Causa | Correção |
|---------|-------|----------|
| `setup`/`start` aborta: "Pasta do HU-Speaker não encontrada" | HU-Speaker não está em `../HU-Speaker` | Coloque o repo lado a lado ou defina `HU_SPEAKER_DIR` |
| **connection timeout** na 5432 | PostgreSQL nativo brigando com o container | Usar a **5434** (já é o padrão do script / `.env.local`) |
| Voz falha com `{"detail":"Invalid token"}` | `HU_SPEAKER_JWT_SECRET` ≠ `JWT_SECRET_KEY` do HU-Speaker | Igualar os segredos dos dois lados |
| HU-Speaker: **"Piper model not found"** | Modelo `.onnx` ausente | Baixar o modelo e subir com `--build` (o `setup` faz isso) |
| HU-Speaker não sobe: rede `sga-net` inexistente | Rede externa do compose | `docker network create sga-net` (o `setup` faz isso) |
| `--migrate` "pulou" a migração | Já havia usuários no banco | `docker compose down -v` e rode o `--migrate` num banco zerado |
| Login dá **500** (DateTimeImmutable) | `created_at` com microssegundos | Já tratado no `migracao_1x_para_2.3.sql` |

---

## Portas e credenciais

| Serviço | URL / porta |
|---------|-------------|
| NovoSGA 2.3 (app) | http://localhost:8000 |
| HU-Speaker (TTS) | http://localhost:8082 (`/health`, `/docs`) |
| PostgreSQL | localhost:**5434** (db/user `app`, senha `!ChangeMe!`) |
| Mercure (tempo real) | http://localhost:3000 |
| Mailpit (e-mail de teste) | porta mapeada dinamicamente — ver `docker compose ps` |

**Login após migração 1.x:** `admin` / `123456`.

> Em **produção**, troque tudo: portas oficiais, segredos fortes
> (`JWT_SECRET_KEY`, `MERCURE_*`, `POSTGRES_PASSWORD`), `APP_ENV=prod` e um
> servidor web real no lugar do `symfony serve`.

---

## Licença

Herdada do NovoSGA (MIT):

```
Copyright (c) 2012-present Rogerio Lino

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```