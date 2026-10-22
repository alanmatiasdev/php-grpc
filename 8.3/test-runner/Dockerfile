FROM kirschbaumdevelopment/laravel-test-runner:8.3@sha256:abd7138516427a3d81b23a2e4a21c09bcbf6ce8db5cc6566207d8dd29ae341da
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

RUN apt-get update && apt-get install -y \
    php8.3-dev \
    make \
    autoconf \
    gcc \
    g++ \
    pkg-config \
    libgrpc-dev \
    protobuf-compiler \
    && pecl install grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION} \
    && echo "extension=grpc.so" > /etc/php/8.3/cli/conf.d/20-grpc.ini \
    && echo "extension=protobuf.so" > /etc/php/8.3/cli/conf.d/20-protobuf.ini \
    && apt-get purge -y --auto-remove make autoconf gcc g++ pkg-config libgrpc-dev protobuf-compiler php8.3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
