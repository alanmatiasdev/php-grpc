FROM kirschbaumdevelopment/laravel-test-runner:8.4@sha256:7528c7537d865e35306f97b964616bb26e738a62876e3fd392857b688a8d2113
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

RUN apt-get update && apt-get install -y \
    php8.4-dev \
    make \
    autoconf \
    gcc \
    g++ \
    pkg-config \
    libgrpc-dev \
    protobuf-compiler \
    && pecl install grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION} \
    && echo "extension=grpc.so" > /etc/php/8.4/cli/conf.d/20-grpc.ini \
    && echo "extension=protobuf.so" > /etc/php/8.4/cli/conf.d/20-protobuf.ini \
    && apt-get purge -y --auto-remove make autoconf gcc g++ pkg-config libgrpc-dev protobuf-compiler php8.4-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*