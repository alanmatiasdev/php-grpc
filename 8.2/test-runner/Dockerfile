FROM kirschbaumdevelopment/laravel-test-runner:8.2@sha256:a6fec75a9010f4816c8df75c2a29ef0931448d1ced2489bc125088be6b01812a
LABEL maintainer="Alan Matias <me@alanmatias.dev>"

ARG GRPC_VERSION=1.84.0
ARG PROTOBUF_VERSION=5.36.2

RUN apt-get update && apt-get install -y \
    php8.2-dev \
    make \
    autoconf \
    gcc \
    g++ \
    pkg-config \
    libgrpc-dev \
    protobuf-compiler \
    && pecl install grpc-${GRPC_VERSION} protobuf-${PROTOBUF_VERSION} \
    && echo "extension=grpc.so" > /etc/php/8.2/cli/conf.d/20-grpc.ini \
    && echo "extension=protobuf.so" > /etc/php/8.2/cli/conf.d/20-protobuf.ini \
    && apt-get purge -y --auto-remove make autoconf gcc g++ pkg-config libgrpc-dev protobuf-compiler php8.2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*