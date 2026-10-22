# Changelog

All notable changes to these images are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Images are published continuously, so
entries are grouped by change rather than by version.

## [Unreleased]

### Fixed

- **Alpine images (`fpm-alpine`, `cli-alpine`, PHP 8.2, 8.3 and 8.4): the `grpc` extension did not
  load.** `libstdc++` was only installed as part of the build toolchain and was removed together
  with it, so PHP printed `Unable to load dynamic library 'grpc'` at startup and gRPC was
  unavailable. The library is now kept as a runtime dependency.

  **Affected:** every Alpine image published before this fix, including the floating tags
  (`8.x-fpm-alpine`, `8.x-cli-alpine`) and the pinned ones (`8.x.y-fpm-alpine`, `8.x.y-cli-alpine`).
  The Debian-based `fpm` images were not affected.

  **Action:** pull the image again. To check an image you already run:

  ```bash
  docker run --rm <image> php -r 'var_dump(extension_loaded("grpc"));'
  ```

  It should print `bool(true)` with no startup warning.

### Changed (breaking) — `test-runner` images

The `test-runner` images no longer extend `kirschbaumdevelopment/laravel-test-runner`. They are now
built here from the official `php:X.Y.Z-cli` image (Debian), so they get pinned PHP patch versions
(`8.4.27-test-runner`) and the same scan as the other variants.

Differences you may notice:

- **OS and package manager:** Debian instead of Ubuntu 22.04. `apt-get install php8.x-<ext>` no
  longer works; use `install-php-extensions <ext>` or `docker-php-ext-install`.
- **Node.js 24** instead of 20 (Node 20 is end of life). npm and Yarn are pinned.
- **Coverage:** `pcov` is installed; `phpdbg` is not.
- **MySQL client:** `mysql` is provided by MariaDB's client.
- **PHP version:** the previous 8.3 and 8.4 images installed `php8.2-dev` and could run PHP 8.2
  instead of the tag's version. The new images always run the version in the tag.
- `COMPOSER_HOME`, `COMPOSER_ALLOW_SUPERUSER` and `./vendor/bin` in `PATH` are kept.

### Security

- Images are now scanned with Trivy, smoke-tested, and published with an SBOM, provenance and a
  cosign signature. See the README for details.

### Changed

- Build inputs are pinned: `install-php-extensions` (with checksum), `grpc` 1.84.0, `protobuf`
  5.36.2, Composer and the Node.js image by digest.
- Images are pushed to the registry only when a release is cut. Releases are per image and named
  after the PHP version (`8.4.27-fpm`, and `8.4.27-fpm-r2` for a change that keeps the same PHP
  version), with notes generated from the Conventional Commits that touched the image. A weekly
  run builds and scans without publishing.
