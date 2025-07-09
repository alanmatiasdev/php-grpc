FROM php:8.2-fpm-alpine
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        grpc-dev \
        protobuf-dev \
    && pecl install grpc protobuf \
    && docker-php-ext-enable grpc protobuf \
    && apk del .build-deps

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www