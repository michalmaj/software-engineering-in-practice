#!/usr/bin/env bash
# Runs every course-health invariant this repo cares about, the same way
# locally and in CI. The GitHub Actions workflow (.github/workflows/
# course-health.yml) only sets up Python/uv/Go/JDK and then calls this
# script — all the actual checking logic lives here, so you can run the
# exact same checks on your own machine before pushing:
#
#   ./scripts/check-course.sh
#
# Structural/content checks (lab layout, README pairs, broken links,
# decisions/ leakage, AI-attribution strings, EN/PL code-block parity)
# live in scripts/check_course_structure.py, since that's naturally
# text-processing work. Everything below is toolchain-execution: syntax
# checks, lockfile freshness, and each example project's own test suite.
set -uo pipefail

cd "$(dirname "$0")/.."

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "This check must be run from a Git clone of the repository."
  echo "GitHub source archives are not supported by the repository health check."
  exit 1
fi

# Projects that deliberately ship a pyproject.toml without a committed
# uv.lock — right now, only the Lab 05 Python starter, whose whole point
# is having the student generate and commit their own uv.lock. Any other
# project with no lockfile is a real problem, not another exception, so
# it's not auto-detected: it has to be added here on purpose.
KNOWN_UNLOCKED_PROJECTS=("examples/works-on-my-machine/python")

is_known_unlocked() {
  local dir="$1" known
  for known in "${KNOWN_UNLOCKED_PROJECTS[@]}"; do
    [ "$dir" = "$known" ] && return 0
  done
  return 1
}

FAILED=0
fail() {
  echo "FAIL  $1"
  FAILED=1
}
ok() {
  echo "OK    $1"
}

echo "== Structure and content checks =="
if ! python3 scripts/check_course_structure.py; then
  echo
  echo "Structural checks failed — fix these before anything else. Skipping"
  echo "the slower toolchain checks below, since they can't tell you"
  echo "anything useful while the repo's basic shape is broken."
  exit 1
fi
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

  if [ "$has_lock" -eq 0 ] && ! is_known_unlocked "$dir"; then
    fail "$dir: no committed uv.lock and not in KNOWN_UNLOCKED_PROJECTS (top of this script) — commit a uv.lock, or add it there if it's deliberately unlocked like Lab 05"
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
notifier_java_dir="examples/notifier/java"
if [ -d "$notifier_java_dir" ]; then
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
else
  echo "  (no $notifier_java_dir — skipping)"
fi
echo

echo "== Java capstone starter (committed Gradle Wrapper) =="
java_dir="examples/capstone-starters/java"
if [ -d "$java_dir" ]; then
  wrapper_ok=1
  for f in gradlew gradlew.bat gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties; do
    if [ ! -s "$java_dir/$f" ]; then
      fail "$java_dir/$f missing or empty — Gradle Wrapper isn't fully committed"
      wrapper_ok=0
    fi
  done
  if [ ! -x "$java_dir/gradlew" ]; then
    fail "$java_dir/gradlew is not executable (chmod +x it and commit the mode change)"
    wrapper_ok=0
  fi

  if [ "$wrapper_ok" -eq 1 ]; then
    ok "Gradle Wrapper files present and executable"
    echo "  -- $java_dir --"
    if (cd "$java_dir" && ./gradlew test); then
      ok "$java_dir: ./gradlew test passed"
    else
      fail "$java_dir: ./gradlew test failed"
    fi
    (cd "$java_dir" && ./gradlew --stop > /dev/null 2>&1) || true
    rm -rf "$java_dir/build" "$java_dir/.gradle"
  else
    echo "      Skipping ./gradlew test — wrapper isn't intact."
  fi
else
  echo "  (no $java_dir — skipping)"
fi
echo

# This is a second, deliberately explicit copy of the capstone check
# above rather than a loop over every `*/gradlew` — generalizing Java
# project discovery (the same way Python/Go are already discovered via
# `*/pyproject.toml` and `*/go.mod`) is a later migration stage's job,
# once there's more than one or two Gradle starters to justify it.
echo "== Java works-on-my-machine starter (committed Gradle Wrapper) =="
java_womm_dir="examples/works-on-my-machine/java"
if [ -d "$java_womm_dir" ]; then
  wrapper_ok=1
  for f in gradlew gradlew.bat gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties; do
    if [ ! -s "$java_womm_dir/$f" ]; then
      fail "$java_womm_dir/$f missing or empty — Gradle Wrapper isn't fully committed"
      wrapper_ok=0
    fi
  done
  if [ ! -x "$java_womm_dir/gradlew" ]; then
    fail "$java_womm_dir/gradlew is not executable (chmod +x it and commit the mode change)"
    wrapper_ok=0
  fi

  if [ "$wrapper_ok" -eq 1 ]; then
    ok "Gradle Wrapper files present and executable"
    echo "  -- $java_womm_dir --"
    if (cd "$java_womm_dir" && ./gradlew test); then
      ok "$java_womm_dir: ./gradlew test passed"
    else
      fail "$java_womm_dir: ./gradlew test failed"
    fi
    (cd "$java_womm_dir" && ./gradlew --stop > /dev/null 2>&1) || true
    rm -rf "$java_womm_dir/build" "$java_womm_dir/.gradle"
  else
    echo "      Skipping ./gradlew test — wrapper isn't intact."
  fi
else
  echo "  (no $java_womm_dir — skipping)"
fi
echo

# Act II's restaurant-bill starters are intentionally pre-Lab-06: one
# monolithic entry point each, no package split, no tests, and the
# tax-before-discount bug Lab 08 teaches students to find. This section
# only confirms each one still runs and produces the expected receipt
# for the committed example order (the same $38 order that doesn't
# trigger the buggy discount path) — it must never run Lab 07's tests
# or Lab 08's fix on the student's behalf.
echo "== Act II restaurant-bill starters (black-box smoke test) =="
EXPECTED_RECEIPT_LINE='Total: $46.74'

py_bill_starter="examples/restaurant-bill/python/bill.py"
if [ -f "$py_bill_starter" ]; then
  if py_bill_output=$(python3 "$py_bill_starter" 2>&1) && printf '%s\n' "$py_bill_output" | grep -qF "$EXPECTED_RECEIPT_LINE"; then
    ok "$py_bill_starter: runs and produces the expected receipt"
  else
    fail "$py_bill_starter: did not run, or produced an unexpected receipt"
    printf '%s\n' "$py_bill_output" | sed 's/^/      /'
  fi
else
  echo "  (no $py_bill_starter — skipping)"
fi

go_bill_dir="examples/restaurant-bill/go"
if [ -f "$go_bill_dir/main.go" ]; then
  if go_bill_output=$(cd "$go_bill_dir" && go run main.go 2>&1) && printf '%s\n' "$go_bill_output" | grep -qF "$EXPECTED_RECEIPT_LINE"; then
    ok "$go_bill_dir: runs and produces the expected receipt"
  else
    fail "$go_bill_dir: did not run, or produced an unexpected receipt"
    printf '%s\n' "$go_bill_output" | sed 's/^/      /'
  fi
else
  echo "  (no $go_bill_dir/main.go — skipping)"
fi

java_bill_dir="examples/restaurant-bill/java"
if [ -d "$java_bill_dir" ]; then
  wrapper_ok=1
  for f in gradlew gradlew.bat gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties; do
    if [ ! -s "$java_bill_dir/$f" ]; then
      fail "$java_bill_dir/$f missing or empty — Gradle Wrapper isn't fully committed"
      wrapper_ok=0
    fi
  done
  if [ ! -x "$java_bill_dir/gradlew" ]; then
    fail "$java_bill_dir/gradlew is not executable (chmod +x it and commit the mode change)"
    wrapper_ok=0
  fi

  if [ "$wrapper_ok" -eq 1 ]; then
    ok "Gradle Wrapper files present and executable"
    if java_bill_output=$(cd "$java_bill_dir" && ./gradlew run --console=plain --quiet 2>&1); then
      if printf '%s\n' "$java_bill_output" | grep -qF "$EXPECTED_RECEIPT_LINE"; then
        ok "$java_bill_dir: runs and produces the expected receipt"
      else
        fail "$java_bill_dir: ran but produced an unexpected receipt"
        printf '%s\n' "$java_bill_output" | sed 's/^/      /'
      fi
    else
      fail "$java_bill_dir: ./gradlew run failed"
      printf '%s\n' "$java_bill_output" | sed 's/^/      /'
    fi
    (cd "$java_bill_dir" && ./gradlew --stop > /dev/null 2>&1) || true
    rm -rf "$java_bill_dir/build" "$java_bill_dir/.gradle"
  else
    echo "      Skipping ./gradlew run — wrapper isn't intact."
  fi
else
  echo "  (no $java_bill_dir — skipping)"
fi
echo

if [ "$FAILED" -eq 1 ]; then
  echo "Course health check FAILED. See the FAIL lines above for what to fix."
  exit 1
fi

echo "Course health check passed."
