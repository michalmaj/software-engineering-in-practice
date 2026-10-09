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
    return 1
  fi

  local have
  have="$(eval "$extract" 2>&1 || true)"
  if [ -z "$have" ]; then
    echo "UNKNOWN  $name — installed, but couldn't parse its version (need $label)"
    return 1
  fi

  local ok=1
  case "$kind" in
    ge) version_ge "$have" "$want" && ok=0 ;;
    series) version_is_series "$have" "$want" && ok=0 ;;
    exact) [ "$have" = "$want" ] && ok=0 ;;
  esac

  if [ "$ok" -eq 0 ]; then
    echo "OK       $name $have (need $label)"
    return 0
  else
    echo "MISMATCH $name $have — need $label"
    return 1
  fi
}

echo "This checks every tool used anywhere in the course, across all three"
echo "language tracks at once — it's a shared reference tool, not a"
echo "single-track pass/fail gate, and not something Lab 01 requires you to"
echo "run. If you've already picked a track, only your own track's row (plus"
echo "Git) needs to say OK right now — MISSING on the other two languages is"
echo "completely normal and expected, not a sign anything is broken. Each"
echo "row names the first lab that actually needs it, so a MISSING or"
echo "MISMATCH for a lab you haven't reached yet isn't something to fix"
echo "today either."
echo

ANY_FAILED=0

check "Git (needed from the very start, to clone this repository)" git \
  'git --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1' \
  "ge:2.30" || ANY_FAILED=1

if command -v curl > /dev/null 2>&1; then
  echo "OK       curl (needed from Lab 21 on, for every track; also used by the Python track's uv installer) available"
else
  echo "MISSING  curl (needed from Lab 21 on, for every track; also used by the Python track's uv installer) — not on PATH"
  ANY_FAILED=1
fi

check "Python 3 — Python track only, from Lab 05 on" python3 \
  'python3 --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+"' \
  "series:3.13" || ANY_FAILED=1

check "uv — Python track only, from Lab 05 on" uv \
  'uv --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1' \
  "exact:0.11.21" || ANY_FAILED=1

check "Go — Go track only, from Lab 05 on" go \
  'go version | grep -oE "go[0-9]+\.[0-9]+(\.[0-9]+)?" | head -1 | sed "s/^go//"' \
  "series:1.27" || ANY_FAILED=1

check "Java runtime — Java track only, from Lab 05 on" java \
  'java -version 2>&1 | grep -oE "\"[0-9]+(\.[0-9]+)*" | head -1 | tr -d "\""' \
  "series:21" || ANY_FAILED=1

# A JRE isn't enough — this course compiles Java, it doesn't just run it.
# Some systems (stock macOS included) have a `java`/`javac` stub on PATH
# that prints an "install a JDK" message instead of a version; that
# already surfaces as UNKNOWN below, not a false OK.
check "javac / JDK — Java track only, from Lab 05 on" javac \
  'javac --version 2>&1 | grep -oE "[0-9]+(\.[0-9]+)*" | head -1' \
  "series:21" || ANY_FAILED=1

echo
echo "Missing something, or does a version not match, for the track and lab"
echo "you're actually on right now? See the root README's toolchain table"
echo "for how to install or switch to the required version."

exit "$ANY_FAILED"
