#!/usr/bin/env bash
# Usage: release-notes.sh <image-dir> <docker-tag> <release>
# Prints Markdown release notes for one image: the commits that touched its directory since the
# previous release of the same variant, grouped by Conventional Commit type.
set -euo pipefail

dir="$1"
docker_tag="$2"
release="$3"
image="${IMAGE:-alanmatias/php-grpc}"

php_of() { sed -nE 's/^FROM php:([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/p' | head -n1; }

suffix="${docker_tag#*-}"
php=$(php_of < "$dir/Dockerfile")
line="${php%.*}"
pattern="^${line//./\\.}\\.[0-9]+-${suffix//./\\.}(-r[0-9]+)?\$"
previous=$(git tag --list | grep -E "$pattern" | grep -vxF "$release" | sort -V | tail -n1 || true)

tags="\`${image}:${docker_tag}\` (floating), \`${image}:${php}-${suffix}\` (latest revision for PHP ${php})"
if [[ "$release" =~ -r[0-9]+$ ]]; then
  tags+=", \`${image}:${release}\` (this revision)"
fi
echo "Docker tags: ${tags}."
echo

if [[ -n "$previous" ]]; then
  previous_php=$(git show "${previous}:${dir}/Dockerfile" | php_of)
  if [[ "$previous_php" != "$php" ]]; then
    echo "PHP updated from ${previous_php} to ${php}."
    echo
  fi
  range="${previous}..HEAD"
else
  range="HEAD"
fi

log=$(git log --no-merges --format='%h%x09%s' "$range" -- "$dir")

section() { # <title> <subject regex>
  local items
  items=$(RE="$2" awk -F'\t' -v repo="${GITHUB_REPOSITORY:-}" '
    $2 ~ ENVIRON["RE"] {
      subject = $2
      sub(/^[a-z]+(\([^)]*\))?!?: /, "", subject)
      if (repo != "") printf "- %s ([%s](https://github.com/%s/commit/%s))\n", subject, $1, repo, $1
      else printf "- %s (%s)\n", subject, $1
    }' <<< "$log")
  if [[ -n "$items" ]]; then
    printf '### %s\n\n%s\n\n' "$1" "$items"
  fi
}

section "Breaking changes" '^[a-z]+(\([^)]*\))?!: '
section "Features" '^feat(\([^)]*\))?: '
section "Fixes" '^fix(\([^)]*\))?: '
section "Performance" '^perf(\([^)]*\))?: '
section "Other changes" '^(docs|ci|build|chore|refactor|test|style)(\([^)]*\))?: '

if [[ -n "$previous" && -n "${GITHUB_REPOSITORY:-}" ]]; then
  echo "**Full changelog:** https://github.com/${GITHUB_REPOSITORY}/compare/${previous}...${release}"
fi
