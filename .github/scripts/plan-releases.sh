#!/usr/bin/env bash
# Prints the images that need a release as a JSON array: [{"dir":"8.4/fpm","release":"8.4.27-fpm"}].
#
# A release is named after the PHP version in the image's Dockerfile and its variant, like the
# Docker tag (8.4.27-fpm):
#   - no release yet for that PHP version: cut it (8.4.27-fpm)
#   - same PHP version, but a releasable commit (feat, fix, perf, revert or a breaking change)
#     touched the image since its last release: add a revision (8.4.27-fpm-r2)
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

releasable='^(feat|fix|perf|revert)(\([^)]*\))?!?: |^[a-z]+(\([^)]*\))?!: '
tags=$(git tag --list)

plan='[]'
while IFS=$'\t' read -r dir tag; do
  php=$(sed -nE 's/^FROM php:([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/p' "$dir/Dockerfile" | head -n1)
  if [[ -z "$php" ]]; then
    echo "::error::no 'FROM php:X.Y.Z-*' line in $dir/Dockerfile" >&2
    exit 1
  fi

  suffix="${tag#*-}"
  base="${php}-${suffix}"
  pattern="^${php//./\\.}-${suffix//./\\.}(-r[0-9]+)?\$"
  last=$(grep -E "$pattern" <<< "$tags" | sort -V | tail -n1 || true)

  release=""
  if [[ -z "$last" ]]; then
    release="$base"
  elif git log --format=%s "${last}..HEAD" -- "$dir" | grep -Eq "$releasable"; then
    rev=1
    [[ "$last" =~ -r([0-9]+)$ ]] && rev="${BASH_REMATCH[1]}"
    release="${base}-r$((rev + 1))"
  fi

  if [[ -n "$release" ]]; then
    plan=$(jq -c --arg dir "$dir" --arg release "$release" '. + [{dir: $dir, release: $release}]' <<< "$plan")
  fi
done < <(jq -r '.[] | [.dir, .tag] | @tsv' .github/images.json)

echo "$plan"
