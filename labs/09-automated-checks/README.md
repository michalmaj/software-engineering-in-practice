# Lab 09 — Machines can check boring things

## Story

Your last code review took ten minutes to converge on: tabs versus
spaces, an unused import, and whether a string should use single or
double quotes. None of that was about whether the code does the right
thing — that's what tests are for, even if (as Lab 08 just showed you)
tests only catch what someone thought to write a test for. Style
arguments are still wasting review time on a question a machine can
answer instead.

This is the one lab where the three tracks genuinely use different
tools, because Python, Go, and Java genuinely disagree about where
formatting ends and static analysis begins. Read only your track's
section.

## Learning objectives

After this lab you should be able to:

- Distinguish what a formatter checks from what a static analyzer
  checks, and both from what a test checks.
- Add and configure a dev-only tool in your project's own manifest.
- Run your track's formatter and analyzer, and read their output.

## Before you start

- Lab 08 complete, in whichever track you're following: the tax bug is
  fixed and the full suite is green.

### Python

- Current directory: `examples/restaurant-bill/python/`.

### Go

- Current directory: `examples/restaurant-bill/go/`. `gofmt` and
  `go vet` ship with the Go toolchain you already installed in Lab 06
  — nothing new to install.

### Java

- Current directory: `examples/restaurant-bill/java/`. This track adds
  two Gradle plugins (a formatter and a static analyzer) — both
  resolve from Maven Central the first time you run them, the same way
  the JUnit 5 dependency did in Lab 06.

## Your task

### Python

1. Add `ruff` as a dev dependency in `pyproject.toml` (alongside
   `pytest`), then run `uv sync`.
2. Add a `[tool.ruff]` section to `pyproject.toml` with
   `target-version = "py313"` and `line-length = 100`.
3. Run `uv run ruff format --check .` — this tells you whether your
   files are already formatted the way Ruff would format them, without
   changing anything.
4. Run `uv run ruff check .` — this looks for actual code issues
   (unused imports, unused variables, and similar), which is a different
   question from formatting.
5. Temporarily add an unused import (for example, `import math`) to the
   top of `billing/calculator.py`. Run `uv run ruff check .` again and
   read the specific rule it reports. Remove the import once you've seen
   the message.
6. Fix anything real that either command reported about your own code
   from Labs 06-08 — for example, if `ruff check .` flags an unsorted
   import block in a test file, that's real; reorder it.

### Go

1. Run `gofmt -l .`. This *lists* files that aren't formatted the way
   `gofmt` would format them — but notice its exit code is `0` even
   when it finds something, so a plain `gofmt -l .` in a script would
   silently pass either way. You'll fix that in Lab 10; for now, know
   that "any output at all" means "something needs formatting."
2. Run `go vet ./...` — this looks for real mistakes `gofmt` can't see
   (suspicious `Printf` calls, unreachable code, and similar), which is
   a different question from formatting.
3. Temporarily change one of the `fmt.Printf` format verbs in
   `billing/cli.go` so it doesn't match its argument's type — for
   example, change `"Total: $%.2f\n"` to `"Total: %d\n"` where the
   argument is still a `float64`. Run `go vet ./...` again and read what
   it reports. Change the format string back once you've seen the
   message.
4. Run `go test ./...` to confirm the suite is still green (vet and
   gofmt don't run your tests for you).

### Java

1. Add two plugins to `build.gradle`'s `plugins` block:
   ```gradle
   id 'pmd'
   id 'com.diffplug.spotless' version '8.10.3'
   ```
2. Add a `spotless` block configuring Google's Java formatter:
   ```gradle
   spotless {
       java {
           googleJavaFormat()
       }
   }
   ```
3. Run `./gradlew spotlessCheck`. Google's formatter uses 2-space
   indentation, which is very likely not what Labs 06-08 used — expect
   this to report violations on your own files the first time, not just
   on a deliberately broken example. That's normal; it's not the same
   as a test failing.
4. Run `./gradlew spotlessApply` to actually reformat everything, then
   `./gradlew spotlessCheck` again to confirm it's clean now.
5. Create `config/pmd/ruleset.xml`:
   ```xml
   <?xml version="1.0"?>
   <ruleset name="restaurant-bill"
       xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">
       <description>Minimal ruleset for the restaurant-bill Java track: a couple of
       real-mistake checks, not a full default category (which flags
       System.out.println, the whole point of this CLI).</description>

       <rule ref="category/java/bestpractices.xml/UnusedLocalVariable"/>
       <rule ref="category/java/bestpractices.xml/UnusedPrivateField"/>
       <rule ref="category/java/errorprone.xml/EmptyCatchBlock"/>
   </ruleset>
   ```
   This project intentionally does **not** use PMD's full default rule
   categories — one of them (`SystemPrintln`) would flag every
   `System.out.printf` call in `Cli.java`, which is this program's
   entire job. A small, hand-picked ruleset is a legitimate choice, not
   a shortcut.
6. Add a `pmd` block to `build.gradle`:
   ```gradle
   pmd {
       toolVersion = '7.28.0'
       ruleSetFiles = files('config/pmd/ruleset.xml')
       ruleSets = []
   }
   ```
7. Run `./gradlew pmdMain`. It should pass — your Lab 06-08 code has no
   unused locals, unused fields, or empty catch blocks.
8. Temporarily add a genuinely unused local variable to `Cli.java` (not
   named `unused...` or `ignored...` — PMD deliberately ignores
   variables named that way, which is itself worth noticing). Run
   `./gradlew pmdMain` again and read what it reports. Remove the
   variable once you've seen the message.
9. Run `./gradlew test` to confirm the suite is still green (Spotless
   and PMD don't run your tests for you).

## Acceptance criteria

### Python

- `pyproject.toml` lists `ruff` as a dev dependency and has a
  `[tool.ruff]` section.
- `uv run ruff format --check .` reports no files needing changes.
- `uv run ruff check .` reports no issues.

### Go

- `gofmt -l .` produces no output.
- `go vet ./...` reports nothing.

### Java

- `build.gradle` configures both the `spotless` and `pmd` blocks shown
  above, and `config/pmd/ruleset.xml` exists.
- `./gradlew spotlessCheck` and `./gradlew pmdMain` both succeed.

All tracks: the test suite from Labs 07-08 still passes — none of this
changed behavior.

## Verification

### Python

```bash
cd examples/restaurant-bill/python
uv run ruff format --check .
uv run ruff check .
uv run pytest
cd -
```

Expected: both Ruff commands report nothing to fix, and `pytest` still
passes.

### Go

```bash
cd examples/restaurant-bill/go
gofmt -l .
go vet ./...
go test ./...
cd -
```

Expected: `gofmt -l .` prints nothing, `go vet` prints nothing, and
`go test` passes.

### Java

```bash
cd examples/restaurant-bill/java
./gradlew spotlessCheck
./gradlew pmdMain
./gradlew test
cd -
```

Expected: all three succeed.

## Think about it

- Which of the tools you've now used on this project could, in
  principle, tell you your code is "correct"? Which ones can only tell
  you it's "consistent" or "free of obvious mistakes"?
- Why run the formatter and the static analyzer as two separate steps
  instead of one?

## If you get stuck

### Python

- **Hint 1:** `uv add --dev ruff` adds the dependency for you instead of
  hand-editing `pyproject.toml`, if you'd rather not edit TOML by hand.
- **Hint 2:** `ruff format` rewrites files to match its style; `ruff
  format --check` only reports what *would* change, without touching
  anything — use `--check` first.
- **Hint 3:** If `ruff check .` reports nothing at all on your own code,
  that's a valid outcome, not a sign you did something wrong — it means
  your Lab 06-08 code was already clean.

### Go

- **Hint 1:** `gofmt -l .` only *lists* filenames; it never fails on its
  own. A script that wants to fail needs to check whether that output
  is non-empty itself — that's exactly what Lab 10 has you build.
- **Hint 2:** `gofmt -w .` (instead of `-l`) actually rewrites files to
  fix formatting, the same way `ruff format` (without `--check`) does
  for Python.
- **Hint 3:** If `go vet ./...` reports nothing at all on your own code,
  that's a valid outcome — it means your Lab 06-08 code had no vet-level
  issues to begin with.

### Java

- **Hint 1:** If `spotlessApply` seems to do nothing, check you saved
  the files it changed — some editors cache a file's contents until you
  click back into them.
- **Hint 2:** PMD's warning about "the wrong java version" for
  `auxClasspath` is harmless for this project — it's PMD being cautious
  about classpath detection, not a real problem with your code.
- **Hint 3:** If `pmdMain` reports nothing at all on your own code,
  that's a valid outcome — it means your Lab 06-08 code had none of the
  three issues this ruleset checks for.

Before moving on: commit and push everything from this lab
(`git add -A && git commit -m "..."; git push`). Nothing later assumes
a clean tree yet, but Act IV (starting at Lab 16) does — get in the
habit now.

## What's next

You now have three different kinds of automated feedback: tests,
formatting, and static analysis. Right now you have to remember several
different commands, in the right order, every single time. Next, you'll
give yourself — and everyone after you — exactly one way to run them.

Continue to [Lab 10 — One obvious way to check the project](../10-one-way-to-check/README.md).
