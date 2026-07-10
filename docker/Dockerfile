FROM php:7.2-apache

# Debian Buster virou EOL e foi pro arquivo -> aponta o apt pro archive.debian.org
RUN sed -i 's|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g; /buster-updates/d' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libonig-dev \
    gettext \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring gettext \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Composer 2.2 (LTS, roda tranquilo em PHP 7.2)
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# VirtualHost apontando pra public/ com AllowOverride pro .htaccess
COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# php.ini custom (session.save_path etc.)
COPY docker/php/novosga.ini /usr/local/etc/php/conf.d/zz-novosga.ini

# Entrypoint: instala deps (se faltar), ajusta permissões e sobe o apache
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["entrypoint.sh"]