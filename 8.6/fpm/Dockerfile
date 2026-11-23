FROM php:8.6.0-fpm
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

ADD --checksum=sha256:d7ecb2087962a272c1d9806069ff6095cd25bf6553d7452db2007db5fa11875f https://github.com/mlocati/docker-php-extension-installer/releases/download/2.13.3/install-php-extensions /usr/local/bin/

COPY --from=composer:2@sha256:da624c2c705d54e2f5a9bb77a5dc6c7d091711433ebefd7035672e84c2010fee /usr/bin/composer /usr/bin/composer

RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        unzip \
        zlib1g-dev \
        libzip-dev; \
    install-php-extensions grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION}; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        zlib1g-dev \
        libzip-dev; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www