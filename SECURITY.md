# Security Policy

## Reporting a vulnerability

Please report vulnerabilities privately through GitHub's
[private vulnerability reporting](https://github.com/alanmatiasdev/php-grpc/security/advisories/new).
Do not open a public issue for security problems.

Include the affected image tag, how to reproduce the problem and its impact. You can expect an
acknowledgement within a few days.

## Supported images

Only the images published from `main` are supported: PHP 8.2, 8.3 and 8.4 in the `fpm`,
`fpm-alpine`, `cli-alpine` and `test-runner` variants.

## How the images are protected

- Every image is scanned with Trivy before it is published; HIGH and CRITICAL vulnerabilities that
  have a fix block the publish. The `test-runner` images extend a third-party base, so their findings
  are reported in the Security tab but do not block.
- Images are rebuilt weekly to pick up base image patches.
- Published images carry an SBOM and provenance attestation and are signed with cosign (keyless).
- Dependencies (PHP base images, Composer, GitHub Actions) are tracked by Dependabot.
