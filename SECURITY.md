# Security Policy

## Reporting a vulnerability

Please report vulnerabilities privately through GitHub's
[private vulnerability reporting](https://github.com/alanmatiasdev/php-grpc/security/advisories/new).
Do not open a public issue for security problems.

Include the affected image tag, how to reproduce the problem and its impact. You can expect an
acknowledgement within a few days.

## Supported images

Only the images published from `main` are supported: PHP 8.2, 8.3, 8.4 and 8.5 in the `fpm`,
`fpm-alpine`, `cli-alpine` and `test-runner` variants.

## How the images are protected

- Every image is scanned with Trivy before it is published; HIGH and CRITICAL vulnerabilities that
  have a fix block the publish.
- Images are pushed to the registry when a release is cut and by a weekly rebuild on the latest base
  images (which does not create a release). Pull requests build and scan without publishing, and
  Dependabot proposes base image bumps.
- Published images carry an SBOM and provenance attestation and are signed with cosign (keyless).
- Dependencies (PHP base images, Composer, GitHub Actions) are tracked by Dependabot.
