#!/usr/bin/env bash
# Runs every course-health invariant this repo cares about, the same way
# locally and in CI. The GitHub Actions workflow (.github/workflows/
# course-health.yml) only sets up Python/uv/Go/JDK and then calls this
# script — all the actual checking logic lives here, so you can run the
# exact same checks on your own machine before pushing:
#
#   ./scripts/check-course.sh
#
# Structure of this script:
#   - Structural/content checks (lab layout, README pairs, broken links,
#     decisions/ leakage, AI-attribution strings, EN/PL code-block
#     parity) live in scripts/check_course_structure.py, since that's
#     naturally text-processing work.
#   - The PROJECT REGISTRY below is the authoritative list of every
#     example project this repo is supposed to ship, and what kind of
#     check each one needs. It exists so that an accidentally deleted
#     project directory or manifest makes this script FAIL, instead of
#     the normal `git ls-files`-based discovery loops just quietly not
#     finding it and reporting nothing. See docs/maintainers/course-health.md
#     for how to add a project to it.
#   - Everything after the registry is toolchain-execution: syntax
#     checks, lockfile freshness, and each example project's own test
#     suite, dispatched by the registry.
set -uo pipefail

cd "$(dirname "$0")/.."
REPO_ROOT="$(pwd)"

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "This check must be run from a Git clone of the repository."
  echo "GitHub source archives are not supported by the repository health check."
  exit 1
fi

FAILED=0
fail() {
  echo "FAIL  $1"
  FAILED=1
}
warn() {
  echo "WARN  $1"
}
ok() {
  echo "OK    $1"
}

# ---------------------------------------------------------------------------
# Project registry
#
# Format: "checktype|relative/path/to/project"
#
# checktype is one of:
#   py            Python project with a committed uv.lock — `uv run pytest`.
#   py-unlocked   Python project that deliberately ships no uv.lock yet
#                 (Lab 05's whole point is having the student create one) —
#                 run in a throwaway copy so `uv run` never writes a lock
#                 file into the tracked tree.
#   go            Go project — `go test ./...`.
#   java-test     Java project with a committed Gradle Wrapper — `./gradlew test`.
#   java-run      Java project with a committed Gradle Wrapper whose checked
#                 behavior is its printed output, not a test suite (Act II's
#                 restaurant-bill, which is deliberately untested) —
#                 `./gradlew run` plus a grep for the expected receipt line.
#   java-javac    Java project with no Gradle Wrapper at all (the notifier
#                 example) — `javac` + `java` directly.
#   sh-smoke      Script run directly with no test suite and no Gradle
#                 (restaurant-bill's Python/Go sides) — run it and grep for
#                 the expected receipt line.
#
# A project that *looks* like a check-type but has no test suite on
# purpose (e.g. restaurant-bill) is registered with the checktype that
# matches what it actually has, not forced into "py"/"go"/"java-test"
# just to look uniform.
PROJECT_REGISTRY=(
  "py-unlocked|examples/works-on-my-machine/python"
  "py|examples/discount-codes/version-a/python"
  "py|examples/discount-codes/version-b/python"
  "py|examples/team-inventory/python"
  "py|examples/order-api/python"
  "py|examples/capstone-starters/python"
  "py|examples/notifier/python"

  "go|examples/works-on-my-machine/go"
  "go|examples/discount-codes/version-a/go"
  "go|examples/discount-codes/version-b/go"
  "go|examples/team-inventory/go"
  "go|examples/order-api/go"
  "go|examples/capstone-starters/go"
  "go|examples/notifier/go"

  "java-test|examples/works-on-my-machine/java"
  "java-test|examples/discount-codes/version-a/java"
  "java-test|examples/discount-codes/version-b/java"
  "java-test|examples/team-inventory/java"
  "java-test|examples/order-api/java"
  "java-test|examples/capstone-starters/java"
  "java-run|examples/restaurant-bill/java"
  "java-javac|examples/notifier/java"

  "sh-smoke|examples/restaurant-bill/python"
  "sh-smoke|examples/restaurant-bill/go"
)

# "py-unlocked" projects are still discovered and run the same way "py"
# ones are (both have a pyproject.toml, found by the same `git ls-files`
# loops below) — this lookup only answers the one question that's
# different about them: are they exempt from the "must have a committed
# uv.lock" rule?
is_registered_unlocked() {
  local dir="$1" entry entry_type entry_path
  for entry in "${PROJECT_REGISTRY[@]}"; do
    entry_type="${entry%%|*}"
    entry_path="${entry#*|}"
    [ "$entry_type" = "py-unlocked" ] && [ "$entry_path" = "$dir" ] && return 0
  done
  return 1
}

registry_paths_of_type() {
  local want="$1" entry entry_type entry_path
  for entry in "${PROJECT_REGISTRY[@]}"; do
    entry_type="${entry%%|*}"
    entry_path="${entry#*|}"
    [ "$entry_type" = "$want" ] && echo "$entry_path"
  done
}

# ---------------------------------------------------------------------------
# Gradle isolation
#
# In CI (GitHub Actions), gradle/actions/setup-gradle@v6 already caches the
# default Gradle user home, so we use it as-is — it's a fresh, disposable VM
# with nothing else running. On a maintainer's own machine, forcing all of
# this script's `./gradlew --stop` calls at the *default* ~/.gradle would
# shut down any unrelated Gradle daemon the maintainer has running for other
# work (another project open in an IDE, for instance). A separate, stable
# (not re-created per run) GRADLE_USER_HOME keeps this script's daemons
# completely isolated from that, while still being a real on-disk cache
# directory, so repeated local runs don't redownload the Gradle
# distribution or dependencies every time — verified: first run against a
# fresh isolated home took ~18s (one-time download), every run after was
# ~3s, the same as using the default home.
if [ "${GITHUB_ACTIONS:-}" != "true" ]; then
  export GRADLE_USER_HOME="${TMPDIR:-/tmp}/software-engineering-in-practice-course-health-gradle-home"
  mkdir -p "$GRADLE_USER_HOME"
fi

# Runs a Gradle Wrapper command in $1 without ever deleting a build/ or
# .gradle/ directory that existed before this invocation — only ones this
# invocation itself created. Always stops the daemon it may have started
# (safe: see the GRADLE_USER_HOME isolation note above) before reporting.
#
# Usage: run_gradle_wrapper <dir> <gradle-args...>
# Prints the command's combined output; returns its exit code.
run_gradle_wrapper() {
  local dir="$1"
  shift
  local had_build=0 had_gradle_dir=0
  [ -d "$dir/build" ] && had_build=1
  [ -d "$dir/.gradle" ] && had_gradle_dir=1

  local output status
  output=$(cd "$dir" && ./gradlew "$@" 2>&1)
  status=$?
  printf '%s\n' "$output"

  (cd "$dir" && ./gradlew --stop > /dev/null 2>&1) || true
  [ "$had_build" -eq 0 ] && rm -rf "$dir/build"
  [ "$had_gradle_dir" -eq 0 ] && rm -rf "$dir/.gradle"

  return "$status"
}

check_gradle_wrapper_committed() {
  local dir="$1"
  local wrapper_ok=1
  local f
  for f in gradlew gradlew.bat gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties; do
    if [ ! -s "$dir/$f" ]; then
      fail "$dir/$f missing or empty — Gradle Wrapper isn't fully committed"
      wrapper_ok=0
    fi
  done
  if [ ! -x "$dir/gradlew" ]; then
    fail "$dir/gradlew is not executable (chmod +x it and commit the mode change)"
    wrapper_ok=0
  fi
  return $((1 - wrapper_ok))
}

# ---------------------------------------------------------------------------
echo "== Structure and content checks =="
if ! python3 scripts/check_course_structure.py; then
  echo
  echo "Structural checks failed — fix these before anything else. Skipping"
  echo "the slower toolchain checks below, since they can't tell you"
  echo "anything useful while the repo's basic shape is broken."
  exit 1
fi
echo

echo "== Project registry (every expected example project is present) =="
registry_failed=0

while IFS='|' read -r entry_type entry_path; do
  case "$entry_type" in
    py|py-unlocked)
      [ -f "$entry_path/pyproject.toml" ] || { fail "$entry_path: registered Python project is missing pyproject.toml"; registry_failed=1; }
      ;;
    go)
      [ -f "$entry_path/go.mod" ] || { fail "$entry_path: registered Go project is missing go.mod"; registry_failed=1; }
      ;;
    java-test|java-run)
      [ -f "$entry_path/gradlew" ] || { fail "$entry_path: registered Java project is missing gradlew"; registry_failed=1; }
      ;;
    java-javac)
      [ -d "$entry_path" ] || { fail "$entry_path: registered Java project directory is missing"; registry_failed=1; }
      ;;
    sh-smoke)
      [ -d "$entry_path" ] || { fail "$entry_path: registered smoke-test project directory is missing"; registry_failed=1; }
      ;;
  esac
done < <(printf '%s\n' "${PROJECT_REGISTRY[@]}")

# The reverse direction: a manifest exists that the registry above doesn't
# know about. This must never be silently skipped — but it's also not
# automatically a failure (the generic test loops below still pick it up
# and run it regardless of registry membership), just a prompt to update
# the registry on purpose.
while IFS= read -r pyproject; do
  dir=$(dirname "$pyproject")
  [ "$dir" = "." ] && continue
  if ! printf '%s\n' "${PROJECT_REGISTRY[@]}" | grep -qF "|$dir"; then
    warn "$dir: has a pyproject.toml but isn't in PROJECT_REGISTRY (top of this script) — it will still be tested, but add it to the registry so a future deletion is caught"
  fi
done < <(git ls-files -- '*/pyproject.toml')

while IFS= read -r gomod; do
  dir=$(dirname "$gomod")
  [ "$dir" = "." ] && continue
  if ! printf '%s\n' "${PROJECT_REGISTRY[@]}" | grep -qF "|$dir"; then
    warn "$dir: has a go.mod but isn't in PROJECT_REGISTRY (top of this script) — it will still be tested, but add it to the registry so a future deletion is caught"
  fi
done < <(git ls-files -- '*/go.mod')

while IFS= read -r gradlew_file; do
  dir=$(dirname "$gradlew_file")
  if ! printf '%s\n' "${PROJECT_REGISTRY[@]}" | grep -qF "|$dir"; then
    warn "$dir: has a committed Gradle Wrapper but isn't in PROJECT_REGISTRY (top of this script) — add it (java-test or java-run) so a future deletion is caught"
  fi
done < <(git ls-files -- '*/gradlew')

[ "$registry_failed" -eq 0 ] && ok "Every registered project's manifest is present"
[ "$registry_failed" -eq 1 ] && FAILED=1
echo

echo "== Python syntax (py_compile) =="
py_syntax_failed=0
while IFS= read -r pyfile; do
  if ! python3 -m py_compile "$pyfile" 2> /tmp/py_compile_err.$$; then
    fail "$pyfile: syntax error"
    sed 's/^/      /' /tmp/py_compile_err.$$
    py_syntax_failed=1
  fi
  rm -f /tmp/py_compile_err.$$
done < <(git ls-files -- '*.py')
[ "$py_syntax_failed" -eq 0 ] && ok "All tracked *.py files compile"
echo

echo "== Shell script syntax (bash -n) =="
sh_syntax_failed=0
while IFS= read -r shfile; do
  if ! bash -n "$shfile" 2> /tmp/bash_n_err.$$; then
    fail "$shfile: syntax error"
    sed 's/^/      /' /tmp/bash_n_err.$$
    sh_syntax_failed=1
  fi
  rm -f /tmp/bash_n_err.$$
done < <(git ls-files -- '*.sh')
[ "$sh_syntax_failed" -eq 0 ] && ok "All tracked *.sh files pass bash -n"
echo

echo "== Python lockfile freshness (uv lock --check) =="
lock_failed=0
while IFS= read -r pyproject; do
  dir=$(dirname "$pyproject")
  if git ls-files --error-unmatch "$dir/uv.lock" > /dev/null 2>&1; then
    if ! (cd "$dir" && uv lock --check) > /tmp/uv_lock_err.$$ 2>&1; then
      fail "$dir: uv.lock is out of date with pyproject.toml"
      sed 's/^/      /' /tmp/uv_lock_err.$$
      lock_failed=1
    fi
    rm -f /tmp/uv_lock_err.$$
  fi
done < <(git ls-files -- '*/pyproject.toml' 'pyproject.toml')
[ "$lock_failed" -eq 0 ] && ok "Every committed uv.lock matches its pyproject.toml"
echo

echo "== Python project test suites (uv run pytest) =="
pytest_failed=0
while IFS= read -r pyproject; do
  dir=$(dirname "$pyproject")
  has_lock=0
  git ls-files --error-unmatch "$dir/uv.lock" > /dev/null 2>&1 && has_lock=1

  if [ "$has_lock" -eq 0 ] && ! is_registered_unlocked "$dir"; then
    fail "$dir: no committed uv.lock and not registered as py-unlocked (top of this script) — commit a uv.lock, or register it there if it's deliberately unlocked like Lab 05"
    pytest_failed=1
    continue
  fi

  echo "  -- $dir --"
  if [ "$has_lock" -eq 0 ]; then
    # Deliberately unlocked (Lab 05): run in a throwaway copy so the
    # uv.lock that `uv run` generates never touches the real tree —
    # the health check must stay side-effect free, and must not do
    # part of the lab's own exercise (creating that lock file) for the
    # student.
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT
    cp -R "$dir/." "$tmp_dir/"
    if ! (cd "$tmp_dir" && uv run pytest -q); then
      fail "$dir: pytest failed (run in a temporary copy — deliberately unlocked)"
      pytest_failed=1
    fi
    rm -rf "$tmp_dir"
    trap - EXIT
  else
    if ! (cd "$dir" && uv run pytest -q); then
      fail "$dir: pytest failed"
      pytest_failed=1
    fi
  fi
done < <(git ls-files -- '*/pyproject.toml' 'pyproject.toml')
[ "$pytest_failed" -eq 0 ] && ok "All Python project test suites pass"
echo

echo "== Go project test suites (go test ./...) =="
go_failed=0
while IFS= read -r gomod; do
  dir=$(dirname "$gomod")
  echo "  -- $dir --"
  if ! (cd "$dir" && go test ./...); then
    fail "$dir: go test failed"
    go_failed=1
  fi
done < <(git ls-files -- '*/go.mod' 'go.mod')
[ "$go_failed" -eq 0 ] && ok "All Go project test suites pass"
echo

echo "== Java notifier example (javac + run) =="
for notifier_java_dir in $(registry_paths_of_type java-javac); do
  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' EXIT
  if ! javac "$notifier_java_dir"/*.java -d "$tmp_dir" > /tmp/notifier_javac_err.$$ 2>&1; then
    fail "$notifier_java_dir: javac failed to compile"
    sed 's/^/      /' /tmp/notifier_javac_err.$$
  elif ! (cd "$tmp_dir" && java -cp . NotifierCheck) > /tmp/notifier_run_err.$$ 2>&1; then
    fail "$notifier_java_dir: NotifierCheck failed"
    sed 's/^/      /' /tmp/notifier_run_err.$$
  else
    ok "$notifier_java_dir: javac + NotifierCheck passed"
  fi
  rm -f /tmp/notifier_javac_err.$$ /tmp/notifier_run_err.$$
  rm -rf "$tmp_dir"
  trap - EXIT
done
echo

echo "== Java projects with a test suite (committed Gradle Wrapper) =="
for java_dir in $(registry_paths_of_type java-test); do
  echo "== $java_dir =="
  if check_gradle_wrapper_committed "$java_dir"; then
    ok "Gradle Wrapper files present and executable"
    echo "  -- $java_dir --"
    if run_gradle_wrapper "$java_dir" test; then
      ok "$java_dir: ./gradlew test passed"
    else
      fail "$java_dir: ./gradlew test failed"
    fi
  else
    echo "      Skipping ./gradlew test — wrapper isn't intact."
  fi
  echo
done

# Act II's restaurant-bill starters are intentionally pre-Lab-06: one
# monolithic entry point each, no package split, no tests, and the
# tax-before-discount bug Lab 08 teaches students to find. This section
# only confirms each one still runs and produces the expected receipt
# for the committed example order (the same $38 order that doesn't
# trigger the buggy discount path) — it must never run Lab 07's tests
# or Lab 08's fix on the student's behalf.
echo "== Act II restaurant-bill starters (black-box smoke test) =="
EXPECTED_RECEIPT_LINE='Total: $46.74'

for sh_smoke_dir in $(registry_paths_of_type sh-smoke); do
  case "$sh_smoke_dir" in
    */python)
      bill_script="$sh_smoke_dir/bill.py"
      if [ -f "$bill_script" ]; then
        if bill_output=$(python3 "$bill_script" 2>&1) && printf '%s\n' "$bill_output" | grep -qF "$EXPECTED_RECEIPT_LINE"; then
          ok "$bill_script: runs and produces the expected receipt"
        else
          fail "$bill_script: did not run, or produced an unexpected receipt"
          printf '%s\n' "$bill_output" | sed 's/^/      /'
        fi
      else
        fail "$bill_script: registered sh-smoke project is missing its entry point"
      fi
      ;;
    */go)
      if [ -f "$sh_smoke_dir/main.go" ]; then
        if bill_output=$(cd "$sh_smoke_dir" && go run main.go 2>&1) && printf '%s\n' "$bill_output" | grep -qF "$EXPECTED_RECEIPT_LINE"; then
          ok "$sh_smoke_dir: runs and produces the expected receipt"
        else
          fail "$sh_smoke_dir: did not run, or produced an unexpected receipt"
          printf '%s\n' "$bill_output" | sed 's/^/      /'
        fi
      else
        fail "$sh_smoke_dir/main.go: registered sh-smoke project is missing its entry point"
      fi
      ;;
    *)
      fail "$sh_smoke_dir: sh-smoke registry entry doesn't end in /python or /go — don't know how to run it"
      ;;
  esac
done

for java_run_dir in $(registry_paths_of_type java-run); do
  if check_gradle_wrapper_committed "$java_run_dir"; then
    ok "Gradle Wrapper files present and executable"
    if java_bill_output=$(run_gradle_wrapper "$java_run_dir" run --console=plain --quiet); then
      if printf '%s\n' "$java_bill_output" | grep -qF "$EXPECTED_RECEIPT_LINE"; then
        ok "$java_run_dir: runs and produces the expected receipt"
      else
        fail "$java_run_dir: ran but produced an unexpected receipt"
        printf '%s\n' "$java_bill_output" | sed 's/^/      /'
      fi
    else
      fail "$java_run_dir: ./gradlew run failed"
      printf '%s\n' "$java_bill_output" | sed 's/^/      /'
    fi
  else
    echo "      Skipping ./gradlew run — wrapper isn't intact."
  fi
done
echo

# Black-box HTTP contract checks against the order-api starters —
# real requests over real sockets, never importing any of the three
# servers' own code. This only checks the shared HTTP contract every
# track already ships pre-Lab-21 — it must never check Lab 21's
# per-item validation rule, or anything from Labs 22-25, all of which
# is student work. Post-Lab-25 behavior (SQLite, notes, retry,
# logging, priority) is verified separately, by hand, against
# disposable reference solutions — never against this committed
# baseline, and never wired into this script. See
# docs/maintainers/course-health.md for why that split exists.
echo "== order-api starter HTTP contract (black-box, all three tracks) =="
contract_harness="scripts/contract-tests/order-api/starter/check_contract.py"
if [ -f "$contract_harness" ]; then
  if python3 "$contract_harness"; then
    ok "order-api starter contract: all three tracks passed"
  else
    fail "order-api starter contract: see output above"
  fi
else
  fail "$contract_harness: missing — the order-api starter contract can't be verified"
fi
echo

if [ "$FAILED" -eq 1 ]; then
  echo "Course health check FAILED. See the FAIL lines above for what to fix."
  exit 1
fi

echo "Course health check passed."
