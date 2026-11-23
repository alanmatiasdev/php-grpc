FROM php:8.6.0-cli-alpine3.24
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

ADD --checksum=sha256:d7ecb2087962a272c1d9806069ff6095cd25bf6553d7452db2007db5fa11875f https://github.com/mlocati/docker-php-extension-installer/releases/download/2.13.3/install-php-extensions /usr/local/bin/

RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    cp /usr/local/include/php/main/php_config.h /tmp/php_config.h.orig; \
    printf '#include <stddef.h>\n#define XtOffsetOf(s, f) offsetof(s, f)\n' >> /usr/local/include/php/main/php_config.h; \
    apk upgrade --no-cache; \
    install-php-extensions grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION}; \
    cp /tmp/php_config.h.orig /usr/local/include/php/main/php_config.h

COPY --from=composer:2@sha256:da624c2c705d54e2f5a9bb77a5dc6c7d091711433ebefd7035672e84c2010fee /usr/bin/composer /usr/bin/composer

WORKDIR /var/www