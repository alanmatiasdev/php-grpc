# Changelog: php-grpc 8.4-test-runner

Changes to this image. Releases are tagged `8.4-test-runner/vX.Y.Z`. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [v2.0.0] - 2026-10-22

Docker tags: `alanmatias/php-grpc:8.4-test-runner` (floating) and `alanmatias/php-grpc:8.4.27-test-runner` (PHP 8.4.27).

### Changed (breaking)

The image is no longer built on `kirschbaumdevelopment/laravel-test-runner`. It is built here from the official `php` image (Debian), so the PHP patch version is pinned and the image is rebuilt weekly. The earlier image, based on Ubuntu 22.04, is `v1`; it was never tagged.

- Debian instead of Ubuntu: `apt-get install php8.x-<ext>` no longer works. Use `install-php-extensions <ext>`.
- Node.js 24 instead of 20 (Node 20 is end of life). npm and Yarn are pinned.
- `pcov` is installed for code coverage; `phpdbg` is not available.
- `mysql` comes from MariaDB's client.
- `COMPOSER_HOME`, `COMPOSER_ALLOW_SUPERUSER` and `./vendor/bin` in `PATH` are unchanged.

### Fixed

- The previous 8.3 and 8.4 images installed `php8.2-dev` and could run PHP 8.2 instead of the tag's version. This image always runs PHP 8.4.27.

### Included

- Based on `php:8.4.27-cli`.
- Extensions: `bcmath`, `bz2`, `calendar`, `exif`, `gd`, `gmp`, `imap`, `intl`, `ldap`, `mysqli`, `pcntl`, `pcov`, `pdo_mysql`, `pdo_pgsql`, `pgsql`, `redis`, `soap`, `xsl`, `zip`, `grpc` 1.84.0, `protobuf` 5.36.2.
- Tools: Composer, Node.js 24, npm, Yarn, git, unzip, MariaDB client.

### Security

- Built on PHP 8.4.27, which fixes the critical remote code execution vulnerabilities CVE-2026-109618 and CVE-2026-109619 announced on 21 October 2026.
- Smoke-tested and scanned with Trivy before it is published; fixable HIGH and CRITICAL findings block the publish.
- Published with an SBOM and provenance, and signed with cosign (keyless).
- Built and scanned against the latest base image every week; published to the registry on release.
- Build inputs are pinned: `install-php-extensions` 2.12.3 (checksum verified), `grpc`, `protobuf`, npm, Yarn, and the Composer and Node.js images (digest).
