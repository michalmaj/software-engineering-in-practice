#!/usr/bin/env bash
set -euo pipefail

check() {
  local name="$1"
  local cmd="$2"
  local version_flag="${3:---version}"
  if command -v "$cmd" > /dev/null 2>&1; then
    echo "OK   $name ($("$cmd" "$version_flag" 2>&1 | head -1))"
  else
    echo "MISSING  $name — not on PATH"
  fi
}

echo "Checking your environment against what this course's labs need:"
echo
check "Git (Lab 01)" git
check "Python 3 (Lab 01)" python3
check "uv (Lab 05)" uv
check "Go (Lab 14)" go version
check "Java (Lab 14)" java -version
echo
echo "Missing something you need for the lab you're on? See the root README's toolchain table."
