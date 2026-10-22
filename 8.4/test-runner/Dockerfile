FROM node:24-bookworm-slim@sha256:55fb5f5a527ea2c5c4a95f963e48ef90aa38c7b346054fdc8ee9957a2b55d205 AS node

FROM php:8.4.27-cli
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2
ARG NPM_VERSION=12.2.1
ARG YARN_VERSION=1.22.22

ENV COMPOSER_HOME=/composer \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PATH=./vendor/bin:/composer/vendor/bin:${PATH}

ADD --checksum=sha256:9c26dd516b8147235c4e924c52e2f076fb2b3f278f5457e88918518ebfee9e01 https://github.com/mlocati/docker-php-extension-installer/releases/download/2.12.3/install-php-extensions /usr/local/bin/

COPY --from=composer:2@sha256:da624c2c705d54e2f5a9bb77a5dc6c7d091711433ebefd7035672e84c2010fee /usr/bin/composer /usr/bin/composer

# Node.js from the official image; npm is upgraded because the bundled one lags behind security fixes
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    apt-get update && apt-get install -y --no-install-recommends \
        git \
        mariadb-client \
        unzip; \
    install-php-extensions \
        bcmath bz2 calendar exif gd gmp imap intl ldap mysqli pcntl pcov \
        pdo_mysql pdo_pgsql pgsql redis soap xsl zip \
        grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION}; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    rm -rf /usr/local/lib/node_modules/corepack; \
    ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm; \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx; \
    npm install -g "npm@${NPM_VERSION}" "yarn@${YARN_VERSION}"; \
    npm cache clean --force
