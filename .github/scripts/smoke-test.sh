#!/usr/bin/env bash
# Usage: smoke-test.sh <image> <dockerfile-dir>
# Fails if the built image does not ship the PHP and extension versions pinned in its Dockerfile.
set -euo pipefail

image="$1"
dockerfile="$2/Dockerfile"

run() { docker run --rm --entrypoint "" "$image" "$@"; }

check() { # <what> <expected> <actual>
  if [[ "$2" != "$3" ]]; then
    echo "::error::$1: expected '$2', got '$3' ($image)"
    exit 1
  fi
  echo "ok: $1 = $3"
}

# Base images pinned to php:X.Y.Z-* must really report that PHP version
expected_php=$(sed -nE 's/^FROM php:([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/p' "$dockerfile")
if [[ -n "$expected_php" ]]; then
  check "PHP version" "$expected_php" "$(run php -r 'echo PHP_VERSION;')"
fi

grpc=$(sed -nE 's/^ARG GRPC_VERSION=(.*)/\1/p' "$dockerfile")
protobuf=$(sed -nE 's/^ARG PROTOBUF_VERSION=(.*)/\1/p' "$dockerfile")
check "grpc extension" "$grpc" "$(run php -r "echo phpversion('grpc');")"
check "protobuf extension" "$protobuf" "$(run php -r "echo phpversion('protobuf');")"

if grep -q 'composer' "$dockerfile"; then
  run composer --version --no-ansi
fi

if [[ "$dockerfile" == *fpm* ]]; then
  run php-fpm -t
fi
