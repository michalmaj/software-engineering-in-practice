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
  echo "  -- $dir --"
  if ! (cd "$dir" && uv run pytest -q); then
    fail "$dir: pytest failed"
    pytest_failed=1
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

if [ "$FAILED" -eq 1 ]; then
  echo "Course health check FAILED. See the FAIL lines above for what to fix."
  exit 1
fi

echo "Course health check passed."
