FROM node:24-bookworm-slim@sha256:c86ecead9e55a5210ac1727de38a4ca840bf03dcaf34dc9749addbf383b1920c AS node

FROM php:8.6.0-cli
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2
ARG NPM_VERSION=12.2.1
ARG YARN_VERSION=1.22.22
ARG UNDICI_VERSION=6.29.1
# phpredis 6.3.0 does not build on PHP 8.6; use a develop commit that is green on 8.6 upstream
ARG REDIS_REF=a17268cf750e552a86ce20d16e18e7fb6b384384

ENV COMPOSER_HOME=/composer \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PATH=./vendor/bin:/composer/vendor/bin:/root/.yarn/bin:${PATH}

ADD --checksum=sha256:d7ecb2087962a272c1d9806069ff6095cd25bf6553d7452db2007db5fa11875f https://github.com/mlocati/docker-php-extension-installer/releases/download/2.13.3/install-php-extensions /usr/local/bin/

COPY --from=composer:2@sha256:da624c2c705d54e2f5a9bb77a5dc6c7d091711433ebefd7035672e84c2010fee /usr/bin/composer /usr/bin/composer

# Node.js from the official image; npm is upgraded because the bundled one lags behind security fixes
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

# hadolint ignore=SC2086,DL3003
RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    cp /usr/local/include/php/main/php_config.h /tmp/php_config.h.orig; \
    printf '#include <stddef.h>\n#include <string.h>\n#define INI_INT(name) ((zend_long) zend_ini_long((name), strlen(name), 0))\n#define INI_FLT(name) zend_ini_double((name), strlen(name), 0)\n#define INI_STR(name) zend_ini_string_ex((name), strlen(name), 0, NULL)\n#define INI_BOOL(name) ((bool) INI_INT(name))\n#define XtOffsetOf(s, f) offsetof(s, f)\n#define zval_dtor(z) zval_ptr_dtor_nogc(z)\n' >> /usr/local/include/php/main/php_config.h; \
    apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        git \
        mariadb-client \
        unzip; \
    install-php-extensions \
        bcmath bz2 calendar exif gd gettext gmp imap intl ldap mysqli opcache pcntl pcov \
        pdo_mysql pdo_pgsql pgsql shmop soap sockets sysvmsg sysvsem sysvshm xsl zip \
        grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION}; \
    cp /tmp/php_config.h.orig /usr/local/include/php/main/php_config.h; \
    # the GitHub tarball omits the liblzf submodule that pecl requires, so build from a full clone
    apt-get install -y --no-install-recommends $PHPIZE_DEPS; \
    redis_src="$(mktemp -d)"; \
    git -C "$redis_src" init -q; \
    git -C "$redis_src" remote add origin https://github.com/phpredis/phpredis.git; \
    git -C "$redis_src" fetch -q --depth 1 origin "${REDIS_REF}"; \
    git -C "$redis_src" checkout -q FETCH_HEAD; \
    git -C "$redis_src" submodule update --init --depth 1; \
    cd "$redis_src"; \
    phpize; \
    ./configure --enable-redis-lzf; \
    make -j"$(nproc)"; \
    make install; \
    docker-php-ext-enable redis; \
    cd /; \
    rm -rf "$redis_src"; \
    apt-get purge -y --auto-remove $PHPIZE_DEPS; \
    printf 'memory_limit=-1\n' > "$PHP_INI_DIR/conf.d/zz-test-runner.ini"; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    rm -rf /usr/local/lib/node_modules/corepack; \
    ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm; \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx; \
    npm install -g "npm@${NPM_VERSION}" "yarn@${YARN_VERSION}"; \
    # npm bundles an undici with CVE-2026-109869; swap in the patched release until npm ships it
    undici_tmp="$(mktemp -d)"; \
    npm pack "undici@${UNDICI_VERSION}" --silent --pack-destination "$undici_tmp"; \
    tar -xzf "$undici_tmp"/undici-*.tgz -C "$undici_tmp"; \
    rm -rf /usr/local/lib/node_modules/npm/node_modules/undici; \
    cp -r "$undici_tmp/package" /usr/local/lib/node_modules/npm/node_modules/undici; \
    rm -rf "$undici_tmp"; \
    npm cache clean --force
