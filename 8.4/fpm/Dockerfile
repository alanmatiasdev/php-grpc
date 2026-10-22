FROM php:8.4.27-fpm
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

ADD --checksum=sha256:9c26dd516b8147235c4e924c52e2f076fb2b3f278f5457e88918518ebfee9e01 https://github.com/mlocati/docker-php-extension-installer/releases/download/2.12.3/install-php-extensions /usr/local/bin/

COPY --from=composer:2@sha256:da624c2c705d54e2f5a9bb77a5dc6c7d091711433ebefd7035672e84c2010fee /usr/bin/composer /usr/bin/composer

RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    apt-get update && apt-get install -y --no-install-recommends \
        unzip \
        zlib1g-dev \
        libzip-dev; \
    install-php-extensions grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION}; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        zlib1g-dev \
        libzip-dev; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www# q
# q2
