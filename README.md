# PHP with gRPC Docker Images

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-alanmatias-blue)](https://hub.docker.com/u/alanmatias)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/alanmatias/php-grpc/graphs/commit-activity)

Pre-built Docker images with PHP 8.2, 8.3 and 8.4 and gRPC/Protobuf extensions ready to use.

## Available Images

| Image                      | Base                    | Use Case                    | Size   |
| -------------------------- | ----------------------- | --------------------------- | ------ |
| `php-grpc:8.2-fpm`         | php:8.2-fpm             | Production web applications | ~200MB |
| `php-grpc:8.2-fpm-alpine`  | php:8.2-fpm-alpine      | Lightweight production      | ~100MB |
| `php-grpc:8.2-cli-alpine`  | php:8.2-cli-alpine3.24  | CLI scripts & microservices | ~90MB  |
| `php-grpc:8.2-test-runner` | php:8.2-cli             | Testing & CI/CD             | —      |
| `php-grpc:8.3-fpm`         | php:8.3-fpm             | Production web applications | ~200MB |
| `php-grpc:8.3-fpm-alpine`  | php:8.3-fpm-alpine      | Lightweight production      | ~100MB |
| `php-grpc:8.3-cli-alpine`  | php:8.3-cli-alpine3.24  | CLI scripts & microservices | ~90MB  |
| `php-grpc:8.3-test-runner` | php:8.3-cli             | Testing & CI/CD             | —      |
| `php-grpc:8.4-fpm`         | php:8.4-fpm             | Production web applications | ~200MB |
| `php-grpc:8.4-fpm-alpine`  | php:8.4-fpm-alpine      | Lightweight production      | ~100MB |
| `php-grpc:8.4-cli-alpine`  | php:8.4-cli-alpine3.24  | CLI scripts & microservices | ~90MB  |
| `php-grpc:8.4-test-runner` | php:8.4-cli             | Testing & CI/CD             | —      |

## Getting Images

All images are available on Docker Hub and can be pulled directly:

```bash
# PHP 8.2
docker pull alanmatias/php-grpc:8.2-fpm
docker pull alanmatias/php-grpc:8.2-fpm-alpine
docker pull alanmatias/php-grpc:8.2-cli-alpine
docker pull alanmatias/php-grpc:8.2-test-runner

# PHP 8.3
docker pull alanmatias/php-grpc:8.3-fpm
docker pull alanmatias/php-grpc:8.3-fpm-alpine
docker pull alanmatias/php-grpc:8.3-cli-alpine
docker pull alanmatias/php-grpc:8.3-test-runner

# PHP 8.4
docker pull alanmatias/php-grpc:8.4-fpm
docker pull alanmatias/php-grpc:8.4-fpm-alpine
docker pull alanmatias/php-grpc:8.4-cli-alpine
docker pull alanmatias/php-grpc:8.4-test-runner
```

**Docker Hub Repository**: [alanmatias/php-grpc](https://hub.docker.com/r/alanmatias/php-grpc)

### Image Tags

**PHP 8.2**
- `8.2-fpm` - Full Debian-based FPM image
- `8.2-fpm-alpine` - Lightweight Alpine FPM image
- `8.2-cli-alpine` - CLI-only Alpine image
- `8.2-test-runner` - Testing and CI/CD image

**PHP 8.3**
- `8.3-fpm` - Full Debian-based FPM image
- `8.3-fpm-alpine` - Lightweight Alpine FPM image
- `8.3-cli-alpine` - CLI-only Alpine image
- `8.3-test-runner` - Testing and CI/CD image

**PHP 8.4**
- `8.4-fpm` - Full Debian-based FPM image
- `8.4-fpm-alpine` - Lightweight Alpine FPM image
- `8.4-cli-alpine` - CLI-only Alpine image
- `8.4-test-runner` - Testing and CI/CD image

### Security

The current images are built on PHP 8.2.35, 8.3.36 and 8.4.27, which fix the critical remote code execution vulnerabilities CVE-2026-109618 and CVE-2026-109619 announced on 21 October 2026. See the [PHP security announcement](https://www.php.net/archive/2026.php#2026-10-21-5) for details. If you pinned an older version tag, update to the tags above.

> **Alpine users:** images published before this fix could not load the `grpc` extension (missing `libstdc++`). Pull the Alpine tags again; see the [changelog](CHANGELOG.md) for how to check.

#### Supply chain

- Every image is built, smoke-tested (PHP, gRPC and Protobuf versions) and scanned with [Trivy](https://trivy.dev) before it is published. Fixable `HIGH` and `CRITICAL` vulnerabilities block the publish.
- All images are rebuilt every Monday so base image patches reach the floating and pinned tags. A pinned tag such as `8.4.27-fpm` therefore keeps the same PHP version but may receive OS-level updates.
- Published images include an SBOM and a provenance attestation, and are signed with [cosign](https://github.com/sigstore/cosign) (keyless). To verify an image:

```bash
cosign verify alanmatias/php-grpc:8.4-fpm \
  --certificate-identity-regexp '^https://github.com/alanmatiasdev/php-grpc/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

To report a vulnerability, see [SECURITY.md](SECURITY.md).

### Version Tags

Every image built from an official `php` base also gets a tag with the full PHP version, so you can pin to an exact release:

| Floating tag      | Pinned tag (example)  |
| ----------------- | --------------------- |
| `8.2-fpm`         | `8.2.35-fpm`          |
| `8.2-fpm-alpine`  | `8.2.35-fpm-alpine`   |
| `8.3-fpm`         | `8.3.36-fpm`          |
| `8.4-fpm-alpine`  | `8.4.27-fpm-alpine`   |

The same pattern applies to `cli-alpine` (e.g. `8.4.27-cli-alpine3.21`). Floating tags always point to the latest build; pinned tags are published for each patch release.

```bash
docker pull alanmatias/php-grpc:8.4.27-fpm
```

## Features

- ✅ PHP 8.2, 8.3 and 8.4 with gRPC extension
- ✅ Protobuf extension included
- ✅ Composer pre-installed
- ✅ Optimized for production use
- ✅ Multiple variants for different use cases
- ✅ Regular security updates

## Quick Start

### For Web Applications (FPM)

```dockerfile
FROM alanmatias/php-grpc:8.2-fpm

COPY . /var/www
RUN composer install --no-dev --optimize-autoloader

EXPOSE 9000
```

### For CLI Applications

```dockerfile
FROM alanmatias/php-grpc:8.2-cli-alpine

COPY . /var/www
RUN composer install --no-dev

CMD ["php", "app.php"]
```

### For Testing

```dockerfile
FROM alanmatias/php-grpc:8.2-test-runner

COPY . /var/www
RUN composer install

CMD ["./vendor/bin/phpunit"]
```

## Usage Examples

### Docker Compose with Nginx

```yaml
version: "3.8"
services:
  app:
    image: alanmatias/php-grpc:8.2-fpm-alpine
    volumes:
      - ./src:/var/www
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./src:/var/www
    depends_on:
      - app
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### gRPC Client Example

```php
<?php
require_once 'vendor/autoload.php';

// Example gRPC client usage
$client = new Grpc\ChannelCredentials::createInsecure();
$channel = new Grpc\Channel('localhost:50051', [
    'credentials' => $client
]);

// Your gRPC service calls here
```

### Building Protobuf Files

```bash
# Generate PHP classes from .proto files
docker run --rm -v $(pwd):/var/www alanmatias/php-grpc:8.2-cli-alpine \
  protoc --php_out=./generated --grpc_out=./generated \
  --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin \
  ./protos/*.proto
```

## Image Details

### FPM Variants

- **php-grpc:8.2-fpm**: Full Debian-based image with all development tools
- **php-grpc:8.2-fpm-alpine**: Lightweight Alpine-based for production

Both include:

- PHP-FPM process manager
- gRPC and Protobuf extensions
- Composer package manager
- Working directory set to `/var/www`

### CLI Variant

- **php-grpc:8.2-cli-alpine**: Minimal CLI image for scripts and microservices
- Perfect for background workers and console applications
- Includes all gRPC/Protobuf functionality

### Test Runner

- **php-grpc:8.2-test-runner**: Debian-based CLI image built from the official `php` image, for running Laravel and PHP test suites in CI
- Extensions: `bcmath`, `bz2`, `calendar`, `exif`, `gd`, `gmp`, `imap`, `intl`, `ldap`, `mysqli`, `pcntl`, `pcov`, `pdo_mysql`, `pdo_pgsql`, `pgsql`, `redis`, `soap`, `xsl`, `zip`, plus `grpc` and `protobuf`
- Tools: Composer, Node.js 24, npm, Yarn, git and the MySQL/MariaDB client
- Code coverage uses `pcov` (there is no `phpdbg`)
- Add other extensions with `install-php-extensions <name>` (or `docker-php-ext-install`)

## Extensions Included

- `grpc` - gRPC extension for PHP
- `protobuf` - Protocol Buffers extension
- Standard PHP extensions (8.2, 8.3 and 8.4)

## Environment Variables

| Variable  | Default    | Description                   |
| --------- | ---------- | ----------------------------- |
| `WORKDIR` | `/var/www` | Application working directory |

## Building Locally

```bash
# Clone the repository
git clone https://github.com/alanmatias/php-grpc.git
cd php-grpc

# Build specific variant (replace 8.2 with 8.3 or 8.4 as needed)
docker build -t my-php-grpc:fpm ./8.2/fpm
docker build -t my-php-grpc:cli ./8.2/cli-alpine
docker build -t my-php-grpc:test ./8.2/test-runner
```

## Performance Tips

1. **Use Alpine variants** for production to reduce image size
2. **Multi-stage builds** to minimize final image size
3. **Volume caching** for composer dependencies
4. **Health checks** for FPM containers

```dockerfile
# Example optimized Dockerfile
FROM alanmatias/php-grpc:8.2-fpm-alpine as deps
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts

FROM alanmatias/php-grpc:8.2-fpm-alpine
COPY --from=deps /var/www/vendor ./vendor
COPY . .
RUN composer dump-autoload --optimize

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD php-fpm-healthcheck || exit 1
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with different PHP versions
5. Submit a pull request

## Support

- 🐛 Issues: [GitHub Issues](https://github.com/alanmatias/php-grpc/issues)

---

**Maintained by [Alan Matias](https://alanmatias.dev)**
