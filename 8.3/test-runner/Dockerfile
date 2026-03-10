FROM kirschbaumdevelopment/laravel-test-runner:8.3
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

RUN apt-get update && apt-get install -y \
    php8.3-dev \
    make \
    autoconf \
    gcc \
    g++ \
    pkg-config \
    libgrpc-dev \
    protobuf-compiler \
    && pecl install grpc protobuf \
    && echo "extension=grpc.so" > /etc/php/8.3/cli/conf.d/20-grpc.ini \
    && echo "extension=protobuf.so" > /etc/php/8.3/cli/conf.d/20-protobuf.ini \
    && apt-get purge -y --auto-remove make autoconf gcc g++ pkg-config libgrpc-dev protobuf-compiler php8.3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
