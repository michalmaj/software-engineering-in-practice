#!/usr/bin/env bash
set -euo pipefail

# Compares an installed version against a minimum, using sort -V.
# version_at_least "3.13.2" "3.13" -> 0 (true) / 1 (false)
version_at_least() {
  local have="$1"
  local want="$2"
  [ "$(printf '%s\n%s\n' "$want" "$have" | sort -V | head -1)" = "$want" ]
}

check() {
  local name="$1"
  local cmd="$2"
  local extract="$3"   # shell snippet that prints just the version number
  local minimum="$4"

  if ! command -v "$cmd" > /dev/null 2>&1; then
    echo "MISSING  $name — not on PATH (need >= $minimum)"
    return
  fi

  local have
  have="$(eval "$extract" 2>&1 || true)"
  if [ -z "$have" ]; then
    echo "UNKNOWN  $name — installed, but couldn't parse its version"
    return
  fi

  if version_at_least "$have" "$minimum"; then
    echo "OK       $name $have (>= $minimum required)"
  else
    echo "TOO OLD  $name $have — need >= $minimum"
  fi
}

echo "Checking your environment against what this course's labs need:"
echo

check "Git (Lab 01)" git \
  'git --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1' \
  "2.30"

check "Python 3 (Lab 01)" python3 \
  'python3 --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+"' \
  "3.13"

check "uv (Lab 05)" uv \
  'uv --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1' \
  "0.11.21"

check "Go (Lab 14)" go \
  'go version | grep -oE "go[0-9]+\.[0-9]+(\.[0-9]+)?" | head -1 | sed "s/^go//"' \
  "1.25"

check "Java (Lab 14)" java \
  'java -version 2>&1 | grep -oE "\"[0-9]+(\.[0-9]+)*" | head -1 | tr -d "\""' \
  "21"

echo
echo "Missing something, or is a version too old? See the root README's"
echo "toolchain table for how to install or upgrade it."
