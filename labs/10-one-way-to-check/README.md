# Lab 10 — One obvious way to check the project

## Story

A new contributor asks: "how do I run the tests again? And was it
the formatter or the analyzer first?" You've typed these commands so
many times you don't think about them anymore — which is exactly why a
newcomer shouldn't have to ask.

## Learning objectives

After this lab you should be able to:

- Wrap a sequence of commands in a small, readable shell script.
- Explain why a project-level script is preferable to a README
  instruction the reader has to copy by hand.
- Explain what "no hidden magic" means for automation you write
  yourself.

## Before you start

- Lab 09 complete, in whichever track you're following: your
  formatter, your analyzer, and your tests all succeed individually.
- **A note for Windows:** this course runs on Git Bash on Windows, not
  WSL and not Docker. Git doesn't store a Unix executable bit the same
  way Linux and macOS do, so a script that works when you type
  `./scripts/check.sh` on your machine might not be directly executable
  on a teammate's. The portable way to invoke any of these scripts, on
  every system this course supports, is:
  ```bash
  bash scripts/check.sh
  ```
  That always works, because it never relies on the file's own
  executable bit — you're just telling `bash` to run a file, the same
  way you'd tell it to run any other script. Still mark the scripts
  executable (`chmod +x scripts/*.sh`) below; where direct execution
  does work on your system, it's a convenient shortcut, not the only
  supported way.

### Python

- Current directory: `examples/restaurant-bill/python/`.

### Go

- Current directory: `examples/restaurant-bill/go/`.

### Java

- Current directory: `examples/restaurant-bill/java/`. Your scripts
  wrap the committed `./gradlew`, never a globally installed `gradle` —
  this project doesn't assume one exists.

## Your task

Create a `scripts/` directory with four scripts, each runnable from
anywhere (they `cd` to the project root themselves, so your current
directory when you invoke them doesn't matter):

1. `scripts/test.sh` — runs the test suite.
2. `scripts/check.sh` — runs the formatter check and the static
   analyzer (in that order), then the test suite.
3. `scripts/format.sh` — actually reformats the code (not just a
   check).
4. `scripts/run.sh` — runs the application.

Make all four executable (`chmod +x scripts/*.sh`). Each script should
be short enough that reading it, top to bottom, tells you exactly what
it does — no separate documentation should be required to understand
one.

### Python

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

uv run pytest
```

That's `scripts/test.sh` in full. `scripts/check.sh` runs
`uv run ruff format --check .`, then `uv run ruff check .`, then
`uv run pytest`. `scripts/format.sh` runs `uv run ruff format .`.
`scripts/run.sh` runs `uv run python main.py`.

### Go

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

go test ./...
```

That's `scripts/test.sh` in full. `scripts/format.sh` runs
`gofmt -w .`. `scripts/run.sh` runs `go run main.go`. `scripts/check.sh`
is the one script that needs more than a single command, because of
the `gofmt -l` quirk from Lab 09 (it lists problems but never fails on
its own):

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== gofmt =="
unformatted="$(gofmt -l .)"
if [ -n "$unformatted" ]; then
  echo "Not formatted:"
  echo "$unformatted"
  exit 1
fi

echo "== go vet =="
go vet ./...

echo "== go test =="
go test ./...
```

### Java

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

./gradlew test --console=plain
```

That's `scripts/test.sh` in full. `scripts/format.sh` runs
`./gradlew spotlessApply --console=plain`. `scripts/run.sh` runs
`./gradlew run --console=plain`. `scripts/check.sh` runs all three
Gradle checks in order:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export PMD_JAVA_DISABLE_AUX_CLASSPATH_WARNINGS=true

echo "== spotless (formatter) =="
./gradlew spotlessCheck --console=plain

echo "== pmd (static analysis) =="
./gradlew pmdMain --console=plain

echo "== tests =="
./gradlew test --console=plain
```

(The exported variable just silences a harmless PMD warning from
Lab 09 — it doesn't change what gets checked.)

## Acceptance criteria

- All four scripts exist, are executable, and work when invoked with
  `bash scripts/<name>.sh` from a different starting directory (e.g.
  your home directory).
- `scripts/check.sh` exits with a non-zero status if formatting,
  static analysis, or tests fail — a newcomer should see one clear
  failure, not silently continue.
- Reading any one script takes less than thirty seconds to understand.

## Verification

### Python

```bash
cd ~
bash /path/to/examples/restaurant-bill/python/scripts/test.sh
bash /path/to/examples/restaurant-bill/python/scripts/check.sh
bash /path/to/examples/restaurant-bill/python/scripts/run.sh
cd -
```

### Go

```bash
cd ~
bash /path/to/examples/restaurant-bill/go/scripts/test.sh
bash /path/to/examples/restaurant-bill/go/scripts/check.sh
bash /path/to/examples/restaurant-bill/go/scripts/run.sh
cd -
```

### Java

```bash
cd ~
bash /path/to/examples/restaurant-bill/java/scripts/test.sh
bash /path/to/examples/restaurant-bill/java/scripts/check.sh
bash /path/to/examples/restaurant-bill/java/scripts/run.sh
cd -
```

(Replace `/path/to/` with your actual repository path.) Expected: all
three complete successfully with no manual `cd` on your part.

## Think about it

- What would happen to `scripts/check.sh` if one of its commands
  failed partway through, and the script didn't stop immediately? What
  line in your script prevents that?
- Is there anything about what these scripts do that isn't visible just
  by reading them? If a teammate asked "what does `check.sh` actually
  run," could you just show them the file?

## If you get stuck

### Python

- **Hint 1:** Start every script with `#!/usr/bin/env bash` and `set
  -euo pipefail` — the second line stops the script immediately on the
  first failing command.
- **Hint 2:** To make a script work regardless of the caller's current
  directory, put `cd "$(dirname "$0")/.."` near the top, right after
  `set -euo pipefail`.
- **Hint 3:** `chmod +x scripts/*.sh` makes all four executable at once.

### Go

- **Hint 1:** The same `set -euo pipefail` habit applies here — without
  it, `scripts/check.sh` would keep running `go vet` even if `gofmt`
  found something, which defeats the point.
- **Hint 2:** `unformatted="$(gofmt -l .)"` captures the command's
  output into a variable instead of printing it immediately — `[ -n
  "$unformatted" ]` then checks whether that variable is non-empty.
- **Hint 3:** If `scripts/run.sh` can't find `main.go` when called from
  another directory, double check the `cd "$(dirname "$0")/.."` line
  is actually the first thing after `set -euo pipefail`.

### Java

- **Hint 1:** `--console=plain` keeps Gradle's output simple and
  script-friendly — without it, Gradle's fancier terminal output can
  look strange when piped or logged.
- **Hint 2:** If `scripts/run.sh` seems to hang the first time from a
  fresh checkout, that's Gradle downloading its distribution again —
  same as the very first run back in Lab 06.
- **Hint 3:** All four scripts call `./gradlew`, never a bare `gradle`
  — if you typed `gradle` by mistake in one of them, that's almost
  certainly the bug.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Act IV (starting at
Lab 16) assumes a clean tree from here on.

## What's next

You've taken a one-file monolith and turned it into a small,
well-tested, consistently-checked project, in your language of choice.
Act II is done — for all three tracks, and so is everything through
Act VI: Go and Java keep going all the way to the capstone now, in the
same language you've been using since this act.

Continue to [Lab 11 — The client changed their mind](../11-changed-requirements/README.md).
