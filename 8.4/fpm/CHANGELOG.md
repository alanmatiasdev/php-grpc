# Changelog: php-grpc 8.4-fpm

Changes to this image. Releases are tagged `8.4-fpm/vX.Y.Z`. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [v1.0.0] - 2026-10-22

Docker tags: `alanmatias/php-grpc:8.4-fpm` (floating) and `alanmatias/php-grpc:8.4.27-fpm` (PHP 8.4.27).

### Included

- `php:8.4.27-fpm` with `grpc` 1.84.0 and `protobuf` 5.36.2, plus Composer.

### Security

- Built on PHP 8.4.27, which fixes the critical remote code execution vulnerabilities CVE-2026-109618 and CVE-2026-109619 announced on 21 October 2026.
- Smoke-tested and scanned with Trivy before it is published; fixable HIGH and CRITICAL findings block the publish.
- Published with an SBOM and provenance, and signed with cosign (keyless).
- Built and scanned against the latest base image every week; published to the registry on release.
- Build inputs are pinned: `install-php-extensions` 2.12.3 (checksum verified), `grpc`, `protobuf` and Composer (digest).
