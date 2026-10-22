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

if [[ "$dockerfile" == *test-runner* ]]; then
  # What the former third-party base promised: Laravel-ready extensions and the usual CI tooling
  for ext in bcmath bz2 calendar exif gd gettext gmp imap intl ldap mbstring mysqli opcache pcntl pdo_mysql pdo_pgsql pdo_sqlite pgsql redis shmop soap sockets sqlite3 sysvmsg sysvsem sysvshm xsl zip curl dom; do
    name=$ext
    [[ "$ext" == opcache ]] && name='Zend OPcache' # registered under its product name
    run php -r "exit(extension_loaded('$name') ? 0 : 1);" || { echo "::error::missing PHP extension: $ext ($image)"; missing=1; }
  done
  [[ -z "${missing:-}" ]] || exit 1
  for tool in node npm yarn git mysql unzip; do
    run sh -c "command -v $tool" >/dev/null || { echo "::error::missing tool: $tool ($image)"; exit 1; }
  done
  check "npm" "$(sed -nE 's/^ARG NPM_VERSION=(.*)/\1/p' "$dockerfile")" "$(run npm --version)"
  check "yarn" "$(sed -nE 's/^ARG YARN_VERSION=(.*)/\1/p' "$dockerfile")" "$(run yarn --version)"
fi
