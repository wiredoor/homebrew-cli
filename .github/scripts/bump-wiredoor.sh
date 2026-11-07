#!/usr/bin/env bash
# Bump Formula/wiredoor.rb to a new wiredoor-cli release.
#
# Usage: bump-wiredoor.sh <version> [dist-dir]
#   <version>   Release version, with or without leading "v" (e.g. 1.2.3 or v1.2.3)
#   [dist-dir]  Optional directory containing the release tarballs. If omitted,
#               tarballs are downloaded from the GitHub release.
set -euo pipefail

VERSION="${1:?usage: $0 <version> [dist-dir]}"
VERSION="${VERSION#v}"
DIST="${2:-}"
REPO="wiredoor/wiredoor-cli"
FORMULA="$(cd "$(dirname "$0")/../.." && pwd)/Formula/wiredoor.rb"
TARGETS=(darwin_arm64 darwin_amd64 linux_arm64 linux_amd64)

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for target in "${TARGETS[@]}"; do
  file="wiredoor_${VERSION}_${target}.tar.gz"
  if [[ -n "$DIST" ]]; then
    path="$DIST/$file"
  else
    path="$tmp/$file"
    curl -fsSL -o "$path" "https://github.com/${REPO}/releases/download/v${VERSION}/${file}"
  fi
  [[ -f "$path" ]] || { echo "missing $path" >&2; exit 1; }
  sha="$(sha256sum "$path" | cut -d' ' -f1)"

  # Rewrite the url line for this target, then the sha256 on the following line.
  sed -i -E "/_${target}\.tar\.gz\"/{
    s#/v[^/]+/wiredoor_[^_]+_${target}\.tar\.gz#/v${VERSION}/wiredoor_${VERSION}_${target}.tar.gz#
    n
    s#sha256 \"[0-9a-f]+\"#sha256 \"${sha}\"#
  }" "$FORMULA"
  echo "${target}: ${sha}"
done

# Sanity check: every url line must reference the new version.
expected=${#TARGETS[@]}
actual="$(grep -cF "${VERSION}" "$FORMULA")"
if [[ "$actual" -ne "$expected" ]]; then
  echo "expected ${expected} references to ${VERSION} in formula, found ${actual}" >&2
  exit 1
fi
echo "Formula updated to ${VERSION}"
