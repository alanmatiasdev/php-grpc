# PHP with gRPC Docker Images

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-alanmatias-blue)](https://hub.docker.com/u/alanmatias)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/alanmatias/php-grpc/graphs/commit-activity)

Pre-built Docker images with PHP 8.2 and gRPC/Protobuf extensions ready to use.

## Available Images

| Image                      | Base                    | Use Case                    | Size   |
| -------------------------- | ----------------------- | --------------------------- | ------ |
| `php-grpc:8.2-fpm`         | php:8.2-fpm             | Production web applications | ~200MB |
| `php-grpc:8.2-fpm-alpine`  | php:8.2-fpm-alpine      | Lightweight production      | ~100MB |
| `php-grpc:8.2-cli-alpine`  | php:8.2-cli-alpine3.21  | CLI scripts & microservices | ~90MB  |
| `php-grpc:8.2-test-runner` | laravel-test-runner:8.2 | Testing & CI/CD             | ~300MB |

## Getting Images

All images are available on Docker Hub and can be pulled directly:

```bash
# Pull specific variants
docker pull alanmatias/php-grpc:8.2-fpm
docker pull alanmatias/php-grpc:8.2-fpm-alpine
docker pull alanmatias/php-grpc:8.2-cli-alpine
docker pull alanmatias/php-grpc:8.2-test-runner

# Or pull all at once
docker pull alanmatias/php-grpc:8.2-fpm && \
docker pull alanmatias/php-grpc:8.2-fpm-alpine && \
docker pull alanmatias/php-grpc:8.2-cli-alpine && \
docker pull alanmatias/php-grpc:8.2-test-runner
```

**Docker Hub Repository**: [alanmatias/php-grpc](https://hub.docker.com/r/alanmatias/php-grpc)

### Image Tags

- `latest` - Points to `8.2-fpm` (production-ready)
- `8.2-fpm` - Full Debian-based FPM image
- `8.2-fpm-alpine` - Lightweight Alpine FPM image
- `8.2-cli-alpine` - CLI-only Alpine image
- `8.2-test-runner` - Testing and CI/CD image

## Features

- ✅ PHP 8.2 with gRPC extension
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

- **php-grpc:8.2-test-runner**: Based on Laravel test runner
- Includes additional testing tools
- Ideal for CI/CD pipelines

## Extensions Included

- `grpc` - gRPC extension for PHP
- `protobuf` - Protocol Buffers extension
- Standard PHP 8.2 extensions

## Environment Variables

| Variable  | Default    | Description                   |
| --------- | ---------- | ----------------------------- |
| `WORKDIR` | `/var/www` | Application working directory |

## Building Locally

```bash
# Clone the repository
git clone https://github.com/alanmatias/php-grpc.git
cd php-grpc

# Build specific variant
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
