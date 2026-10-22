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

### Security

- Images are now scanned with Trivy, smoke-tested, rebuilt weekly, and published with an SBOM,
  provenance and a cosign signature. See the README for details.

### Changed

- Build inputs are pinned: `install-php-extensions` (with checksum), `grpc` 1.84.0, `protobuf`
  5.36.2, Composer and the `test-runner` base image by digest.
- Tags are overwritten on every weekly rebuild: the PHP version stays the same, OS packages are
  refreshed.
