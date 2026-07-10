#!/bin/bash
set -e

cd /var/www/html

# Instala as dependências só se ainda não existir vendor/
if [ ! -f vendor/autoload.php ]; then
    echo ">> vendor/ nao encontrado. Rodando composer install..."
    composer install --no-interaction --prefer-dist --ignore-platform-req=ext-pdo
fi

# Pastas que o instalador e o Doctrine precisam escrever
mkdir -p config var/log var/cache
chown -R www-data:www-data config var vendor 2>/dev/null || true
chmod -R 777 config var

echo ">> Subindo Apache..."
exec apache2-foreground