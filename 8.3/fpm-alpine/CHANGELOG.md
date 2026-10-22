# Changelog: php-grpc 8.3-fpm-alpine

Changes to this image. Releases are tagged `8.3-fpm-alpine/vX.Y.Z`. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [v1.0.0] - 2026-10-22

Docker tags: `alanmatias/php-grpc:8.3-fpm-alpine` (floating) and `alanmatias/php-grpc:8.3.36-fpm-alpine` (PHP 8.3.36).

### Included

- `php:8.3.36-fpm-alpine` with `grpc` 1.84.0 and `protobuf` 5.36.2, plus Composer.

### Fixed

- The `grpc` extension did not load: `libstdc++` was only part of the build toolchain and was removed with it, so PHP printed `Unable to load dynamic library 'grpc'` at startup. The library is now kept as a runtime dependency. Images published before this release are affected; pull the image again.

### Security

- Built on PHP 8.3.36, which fixes the critical remote code execution vulnerabilities CVE-2026-109618 and CVE-2026-109619 announced on 21 October 2026.
- Smoke-tested and scanned with Trivy before it is published; fixable HIGH and CRITICAL findings block the publish.
- Published with an SBOM and provenance, and signed with cosign (keyless).
- Built and scanned against the latest base image every week; published to the registry on release.
- Build inputs are pinned: `grpc`, `protobuf` and Composer (digest).
