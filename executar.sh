# 1. sobe a infra (postgres + mercure + mailpit)
docker compose up -d

# 2. dependências PHP
composer install

# 3. chaves do OAuth (o que o Dockerfile de prod faz via openssl)
mkdir -p config/jwt
openssl genrsa -out config/jwt/private.pem 2048
openssl rsa -in config/jwt/private.pem -pubout -out config/jwt/public.pem

# 4. cria o schema do banco
php bin/console doctrine:migrations:migrate -n

# 5. sobe o app
symfony serve -d        # https://localhost:8000