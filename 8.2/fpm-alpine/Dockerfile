FROM php:8.2.35-fpm-alpine
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

RUN apk add --no-cache libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        grpc-dev \
        protobuf-dev \
    && pecl install grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION} \
    && docker-php-ext-enable grpc protobuf \
    && apk del .build-deps

COPY --from=composer:2@sha256:da624c2c705d54e2f5a9bb77a5dc6c7d091711433ebefd7035672e84c2010fee /usr/bin/composer /usr/bin/composer

WORKDIR /var/www