#!/usr/bin/env bash
set -euo pipefail

# Portable version comparison — no GNU-only tools (no `sort -V`), so this
# works with stock macOS's bash/grep/sort too.

# version_ge "2.43.0" "2.30" -> true if the first is >= the second,
# comparing however many dot-separated components the second one has.
version_ge() {
  local have="$1" want="$2"
  local IFS=.
  local -a h w
  read -ra h <<< "$have"
  read -ra w <<< "$want"
  local i
  for ((i = 0; i < ${#w[@]}; i++)); do
    local hp=${h[i]:-0} wp=${w[i]:-0}
    if ((10#$hp > 10#$wp)); then return 0; fi
    if ((10#$hp < 10#$wp)); then return 1; fi
  done
  return 0
}

# version_is_series "3.13.2" "3.13" -> true if `have` is exactly `want`,
# or `want` followed by a `.patch` — i.e. matching major.minor series.
version_is_series() {
  local have="$1" series="$2"
  [ "$have" = "$series" ] && return 0
  case "$have" in
    "$series".*) return 0 ;;
    *) return 1 ;;
  esac
}

check() {
  local name="$1"
  local cmd="$2"
  local extract="$3"     # shell snippet that prints just the version number
  local requirement="$4" # "ge:2.30", "series:3.13", or "exact:0.11.21"

  local kind="${requirement%%:*}" want="${requirement#*:}"
  local label
  case "$kind" in
    ge) label=">= $want" ;;
    series) label="$want.x" ;;
    exact) label="exactly $want" ;;
  esac

  if ! command -v "$cmd" > /dev/null 2>&1; then
    echo "MISSING  $name — not on PATH (need $label)"
    return
  fi

  local have
  have="$(eval "$extract" 2>&1 || true)"
  if [ -z "$have" ]; then
    echo "UNKNOWN  $name — installed, but couldn't parse its version (need $label)"
    return
  fi

  local ok=1
  case "$kind" in
    ge) version_ge "$have" "$want" && ok=0 ;;
    series) version_is_series "$have" "$want" && ok=0 ;;
    exact) [ "$have" = "$want" ] && ok=0 ;;
  esac

  if [ "$ok" -eq 0 ]; then
    echo "OK       $name $have (need $label)"
  else
    echo "MISMATCH $name $have — need $label"
  fi
}

echo "Checking your environment against what this course's labs need:"
echo

check "Git (Lab 01)" git \
  'git --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1' \
  "ge:2.30"

check "Python 3 (Lab 01)" python3 \
  'python3 --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+"' \
  "series:3.13"

check "uv (Lab 05)" uv \
  'uv --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1' \
  "exact:0.11.21"

check "Go (Lab 14)" go \
  'go version | grep -oE "go[0-9]+\.[0-9]+(\.[0-9]+)?" | head -1 | sed "s/^go//"' \
  "series:1.25"

check "Java (Lab 14)" java \
  'java -version 2>&1 | grep -oE "\"[0-9]+(\.[0-9]+)*" | head -1 | tr -d "\""' \
  "series:21"

echo
echo "Missing something, or does a version not match? See the root README's"
echo "toolchain table for how to install or switch to the exact version."
