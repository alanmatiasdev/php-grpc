FROM php:8.2-fpm
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    apt-get update && apt-get install -y --no-install-recommends \
        unzip \
        zlib1g-dev \
        libzip-dev; \
    install-php-extensions grpc protobuf; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        zlib1g-dev \
        libzip-dev; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www