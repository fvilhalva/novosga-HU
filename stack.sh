#!/usr/bin/env bash
#
# stack.sh - orquestra NovoSGA 2.3 + HU-Speaker (chamada por voz)
#
# Uso:
#   ./stack.sh setup [--migrate | --fresh]   # instala tudo do zero
#   ./stack.sh start                         # liga tudo (infra + app)
#   ./stack.sh stop                          # desliga tudo
#   ./stack.sh restart                       # stop + start
#   ./stack.sh status                        # o que está rodando
#   ./stack.sh check                         # testa a integração de voz
#   ./stack.sh reset [-y]                     # ZERA o banco (down -v) - destrutivo
#   ./stack.sh help
#
# setup --migrate : popula o banco com o snapshot 2.3 já migrado (dados_migrados.sql)
# setup --fresh   : popula com instalação limpa (novosga:install)
# setup (sem flag): prepara tudo, mas não popula dados (você escolhe depois)
#
set -euo pipefail

# --------------------------------------------------------------------------
# Configuração (pode sobrescrever via variável de ambiente)
# --------------------------------------------------------------------------
NOVOSGA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HU_DIR="${HU_SPEAKER_DIR:-$(cd "$NOVOSGA_DIR/.." 2>/dev/null && pwd)/HU-Speaker}"
DB_PORT="${DB_PORT:-5434}"
DB_USER="${DB_USER:-app}"
DB_NAME="${DB_NAME:-app}"
DB_PASS="${DB_PASS:-!ChangeMe!}"
APP_PORT="${APP_PORT:-8000}"
HU_URL="${HU_URL:-http://localhost:8082}"
MODEL_REL="src/hu_speaker/models/pt_BR-faber-medium.onnx"
MODEL_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx?download=true"

# --------------------------------------------------------------------------
# Helpers de log
# --------------------------------------------------------------------------
log()  { printf '\033[1;34m>>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32mOK\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mXX\033[0m %s\n' "$*" >&2; exit 1; }

dc_novosga() { ( cd "$NOVOSGA_DIR" && docker compose "$@" ); }
dc_hu()      { ( cd "$HU_DIR" && docker compose "$@" ); }
psql_app()   { dc_novosga exec -T -e PGPASSWORD="$DB_PASS" database psql -U "$DB_USER" -d "$DB_NAME" "$@"; }

# --------------------------------------------------------------------------
# Pré-requisitos
# --------------------------------------------------------------------------
check_prereqs() {
  log "Conferindo pré-requisitos..."
  local missing=0
  for c in docker php composer symfony openssl curl; do
    command -v "$c" >/dev/null 2>&1 || { warn "faltando: $c"; missing=1; }
  done
  [ "$missing" -eq 0 ] || die "Instale os itens faltando e rode de novo."
  [ -d "$HU_DIR" ] || die "Pasta do HU-Speaker não encontrada em: $HU_DIR (defina HU_SPEAKER_DIR)"
  ok "pré-requisitos presentes"
}

wait_db() {
  log "Aguardando o PostgreSQL ficar pronto..."
  for _ in $(seq 1 30); do
    if dc_novosga exec -T database pg_isready -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1; then
      ok "banco pronto"; return 0
    fi
    sleep 2
  done
  die "banco não respondeu a tempo"
}

# --------------------------------------------------------------------------
# Checagem do segredo JWT compartilhado (NovoSGA <-> HU-Speaker)
# --------------------------------------------------------------------------
check_secret() {
  local a b
  a=$(grep -hE '^HU_SPEAKER_JWT_SECRET=' "$NOVOSGA_DIR/.env" "$NOVOSGA_DIR/.env.local" 2>/dev/null | tail -1 | cut -d= -f2- | tr -d '"'"'"' \r')
  b=$(grep -hE '^JWT_SECRET_KEY='       "$HU_DIR/.env" 2>/dev/null           | tail -1 | cut -d= -f2- | tr -d '"'"'"' \r')
  if [ -z "$a" ] || [ -z "$b" ]; then
    warn "Segredo JWT não configurado dos dois lados (HU_SPEAKER_JWT_SECRET / JWT_SECRET_KEY)."
    return 1
  fi
  if [ "$a" != "$b" ]; then
    warn "HU_SPEAKER_JWT_SECRET (NovoSGA) != JWT_SECRET_KEY (HU-Speaker) -> a voz vai falhar com 'Invalid token'."
    return 1
  fi
  ok "segredo JWT confere dos dois lados"
}

# --------------------------------------------------------------------------
# SETUP
# --------------------------------------------------------------------------
setup_huspeaker() {
  log "== HU-Speaker =="
  ( cd "$HU_DIR"
    docker network create sga-net >/dev/null 2>&1 || true
    if [ ! -f "$MODEL_REL" ]; then
      log "Baixando modelo Piper (~63MB)..."
      curl -fL -o "$MODEL_REL" "$MODEL_URL"
    else
      ok "modelo Piper já presente"
    fi
    [ -f .env ] || die "HU-Speaker/.env não existe (precisa de JWT_SECRET_KEY)"
    log "Subindo HU-Speaker (build)..."
    log "  1o build baixa torch (CPU) + modelo Kokoro (~centenas de MB) — pode demorar."
    docker compose up -d --build
  )
}

setup_novosga() {
  log "== NovoSGA 2.3 =="
  cd "$NOVOSGA_DIR"

  # .env.local com o banco na porta correta (evita o Postgres nativo do Windows)
  if ! grep -qs "5434\|:${DB_PORT}/" .env.local 2>/dev/null; then
    log "Escrevendo .env.local (DATABASE_URL na porta ${DB_PORT})"
    {
      echo '# gerado por stack.sh - overrides locais (não versionado)'
      echo "DATABASE_URL=\"postgresql://${DB_USER}:${DB_PASS}@127.0.0.1:${DB_PORT}/${DB_NAME}?serverVersion=16&charset=utf8\""
    } >> .env.local
  else
    ok ".env.local já aponta para a porta ${DB_PORT}"
  fi

  log "Subindo infra (Postgres/Mercure/Mailpit)..."
  docker compose up -d

  if [ ! -f vendor/autoload.php ]; then log "composer install..."; composer install; else ok "vendor/ já instalado"; fi

  if [ ! -f config/jwt/private.pem ]; then
    log "Gerando chaves JWT do NovoSGA..."
    mkdir -p config/jwt
    openssl genrsa -out config/jwt/private.pem 2048
    openssl rsa -in config/jwt/private.pem -pubout -out config/jwt/public.pem
  else
    ok "chaves JWT já existem"
  fi

  # garante o segredo do HU-Speaker no .env.local (NÃO versionado; sobrepõe o
  # placeholder do .env commitado). A URL já vem com default no .env.
  if ! grep -qs '^HU_SPEAKER_JWT_SECRET=' .env.local; then
    local s; s=$(grep -hE '^JWT_SECRET_KEY=' "$HU_DIR/.env" 2>/dev/null | tail -1 | cut -d= -f2-)
    [ -n "$s" ] && echo "HU_SPEAKER_JWT_SECRET=${s}" >> .env.local && warn "HU_SPEAKER_JWT_SECRET copiado do HU-Speaker para .env.local"
  fi

  wait_db
  log "Rodando migrations..."
  php bin/console doctrine:migrations:migrate -n --allow-no-migration
  ok "schema criado"
}

populate_migrate() {
  log "== Carga de dados migrados (1.x -> 2.3) =="
  cd "$NOVOSGA_DIR"
  local users; users=$(psql_app -tAc "SELECT count(*) FROM usuarios" 2>/dev/null | tr -d ' \r' || echo 0)
  if [ "${users:-0}" != "0" ]; then warn "Já existem usuários ($users) - pulando carga de dados."; return 0; fi
  [ -f dados_migrados.sql ] || die "dados_migrados.sql não encontrado"
  log "Carregando dados_migrados.sql (snapshot já em formato 2.3)..."
  psql_app -v ON_ERROR_STOP=1 < dados_migrados.sql >/dev/null
  ok "dados carregados (login: admin / 123456)"
}

populate_fresh() {
  log "== Instalação limpa (novosga:install) =="
  cd "$NOVOSGA_DIR"
  php bin/console novosga:install
}

cmd_setup() {
  check_prereqs
  setup_huspeaker
  setup_novosga
  case "${1:-}" in
    --migrate) populate_migrate ;;
    --fresh)   populate_fresh ;;
    "")        warn "Sem --migrate/--fresh: banco vazio. Rode depois: ./stack.sh setup --migrate" ;;
    *)         die "opção inválida: $1 (use --migrate ou --fresh)" ;;
  esac
  check_secret || true
  start_app
  echo; ok "Setup concluído -> http://localhost:${APP_PORT}"
}

# --------------------------------------------------------------------------
# START / STOP / STATUS
# --------------------------------------------------------------------------
start_app() {
  log "Iniciando o app (symfony serve)..."
  ( cd "$NOVOSGA_DIR" && symfony serve -d >/dev/null 2>&1 || true )
}

cmd_start() {
  [ -d "$HU_DIR" ] || die "HU-Speaker não encontrado em $HU_DIR"
  log "Ligando HU-Speaker..."; dc_hu up -d
  log "Ligando infra do NovoSGA..."; dc_novosga up -d
  wait_db
  start_app
  ok "Tudo no ar -> http://localhost:${APP_PORT}"
}

cmd_stop() {
  log "Parando o app..."; ( cd "$NOVOSGA_DIR" && symfony server:stop >/dev/null 2>&1 || true )
  log "Parando infra do NovoSGA..."; dc_novosga stop || true
  log "Parando HU-Speaker..."; dc_hu stop || true
  ok "Tudo parado"
}

cmd_reset() {
  # Zera o ambiente do NovoSGA: derruba a infra E apaga o volume do Postgres.
  # Uso típico: trocar de --fresh para --migrate num banco limpo.
  local yes=0
  case "${1:-}" in -y|--yes) yes=1 ;; esac
  warn "Isto vai APAGAR o volume do Postgres (todos os dados locais do NovoSGA)."
  if [ "$yes" -ne 1 ]; then
    printf '\033[1;33m!!\033[0m Confirma? digite "sim" para continuar: '
    local ans; read -r ans
    [ "$ans" = "sim" ] || { log "cancelado (nada foi apagado)"; return 0; }
  fi
  log "Parando o app..."; ( cd "$NOVOSGA_DIR" && symfony server:stop >/dev/null 2>&1 || true )
  log "Derrubando infra do NovoSGA + volume (down -v)..."; dc_novosga down -v
  ok "Ambiente zerado. Rode: ./stack.sh setup --migrate (ou --fresh)"
}

cmd_status() {
  echo "== Containers =="
  dc_novosga ps 2>/dev/null | grep -viE 'obsolete|version attribute' || true
  dc_hu ps 2>/dev/null | grep -viE 'obsolete|version attribute' || true
  echo "== App Symfony =="
  ( cd "$NOVOSGA_DIR" && symfony server:status 2>/dev/null | grep -iE 'running|not running|http' | head -1 ) || true
}

# --------------------------------------------------------------------------
# CHECK (testa a integração de voz)
# --------------------------------------------------------------------------
cmd_check() {
  log "Nível 1 - HU-Speaker vivo"
  curl -sf -m 8 "${HU_URL}/health" && echo || die "HU-Speaker não respondeu em ${HU_URL}/health"

  log "Nível 2 - NovoSGA autentica e sintetiza (servidor->servidor)"
  check_secret || warn "segredo divergente - o teste abaixo deve falhar"
  local secret jwt resp model ok_all=1
  secret=$(grep -hE '^HU_SPEAKER_JWT_SECRET=' "$NOVOSGA_DIR/.env" "$NOVOSGA_DIR/.env.local" 2>/dev/null | tail -1 | cut -d= -f2- | tr -d '"'"'"' \r')
  jwt=$(SECRET="$secret" php -r '$s=getenv("SECRET");$b=fn($d)=>rtrim(strtr(base64_encode($d),"+/","-_"),"=");$h=$b(json_encode(["alg"=>"HS256","typ"=>"JWT"]));$n=time();$p=$b(json_encode(["sub"=>"novosga-service","source_system"=>"novosga","iat"=>$n,"exp"=>$n+120]));echo "$h.$p.".$b(hash_hmac("sha256","$h.$p",$s,true));')

  # Testa cada modelo de voz disponível.
  for model in piper kokoro; do
    log "  testando modelo: ${model}"
    resp=$(curl -s -m 60 -X POST "${HU_URL}/speak/synthesize" -H "Authorization: Bearer $jwt" -H "Content-Type: application/json" -d "{\"text\":\"teste de voz\",\"language\":\"pt_BR\",\"length_scale\":1.0,\"model\":\"${model}\"}")
    echo "    resposta: $resp"
    if echo "$resp" | grep -q '"status":"completed"'; then
      ok "  modelo ${model} OK"
    else
      warn "  modelo ${model} falhou (veja a resposta acima)"
      ok_all=0
    fi
  done

  [ "$ok_all" -eq 1 ] && ok "Integração de voz OK (todos os modelos)" || die "Ao menos um modelo falhou na síntese"
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------
usage() { sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

case "${1:-help}" in
  setup)   shift; cmd_setup "${1:-}" ;;
  start)   cmd_start ;;
  stop)    cmd_stop ;;
  restart) cmd_stop; cmd_start ;;
  status)  cmd_status ;;
  check)   cmd_check ;;
  reset)   shift; cmd_reset "${1:-}" ;;
  help|-h|--help) usage ;;
  *) die "comando desconhecido: $1 (use: setup|start|stop|restart|status|check|reset|help)" ;;
esac
