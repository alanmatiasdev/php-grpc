FROM kirschbaumdevelopment/laravel-test-runner:8.5@sha256:d65f48bb109a0d7dc8236fe80b67474bcfe21edfbabfc0069956969cecdefd5b
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

RUN apt-get update && apt-get install -y \
    php8.5-dev \
    make \
    autoconf \
    gcc \
    g++ \
    pkg-config \
    libgrpc-dev \
    protobuf-compiler \
    && pecl install grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION} \
    && echo "extension=grpc.so" > /etc/php/8.5/cli/conf.d/20-grpc.ini \
    && echo "extension=protobuf.so" > /etc/php/8.5/cli/conf.d/20-protobuf.ini \
    && apt-get purge -y --auto-remove make autoconf gcc g++ pkg-config libgrpc-dev protobuf-compiler php8.5-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*