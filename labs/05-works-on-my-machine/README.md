# Lab 05 — "It works on my machine"

## Story

A teammate sends you `main.py` and says "just run it, it prints a nice
message." You try `python3 main.py`. It crashes. Their machine and
yours are apparently not the same machine.

This lab's code lives in `examples/works-on-my-machine/python/` —
`examples/` is where every persistent project in this course lives,
starting here. The rest of this page is the Python path; there's a
Go and Java preview of this same reproducibility lesson at the very
end. Labs 06-10 (Act II) also have real Go and Java tracks now, built
around a different, self-contained project — you don't need this
lab's Go/Java preview to start there.

## Learning objectives

After this lab you should be able to:

- Explain why "it runs for me" is not evidence that a program is correctly
  packaged.
- Use `uv` to create a reproducible Python environment from a project
  manifest.
- Explain what `pyproject.toml` and `uv.lock` are each responsible for.
- Explain, at a high level, what the devcontainer configuration in this
  repository is for.

## Before you start

- Lab 04 complete.
- Current directory: `examples/works-on-my-machine/python/` for all
  commands below, unless stated otherwise.
- `uv` installed. If you're in this repository's Codespace/devcontainer,
  it's already set up (see the root [`README.md`](../../README.md)). If
  you don't have it yet, install it with:
  `curl -LsSf https://astral.sh/uv/0.11.21/install.sh | sh` (pinned to
  the same version as the devcontainer, so everyone in this course is
  running the same `uv`)

## Your task

1. Without installing anything, try: `python3 main.py`. Read the error.
2. Open `pyproject.toml` and identify which package the project depends
   on.
3. Run `uv sync`. Look at what appeared in this directory afterward.
4. Run `uv run python main.py`. Compare this result with step 1.
5. Run `uv run pytest` and confirm the test suite passes.
6. Back in the repository root, in a new file
   `labs/05-works-on-my-machine/notes/my-observations.txt`, write, in
   your own words: (a) why step 1 failed, (b) what `uv sync` created
   and why, (c) what would happen to a teammate who only ran
   `python3 main.py` on their own machine without ever running `uv sync`.
7. Open `.devcontainer/devcontainer.json` at the repository root and find
   the line that provisions Python. Add one more sentence to your notes
   file: what tool provisions Go and Java in this same file?

## Acceptance criteria

- `uv run pytest` passes inside `examples/works-on-my-machine/python/`.
- `.venv/` and `uv.lock` exist in that directory (uv created them; do not
  hand-write either).
- `uv.lock`, created by `uv sync` (not shipped with the starter), is
  committed to the repository. A lock file is only useful to a teammate
  if it's checked in.
- `labs/05-works-on-my-machine/notes/my-observations.txt` answers all
  three points from step 6, plus the devcontainer question from step 7.

## Verification

```bash
cd examples/works-on-my-machine/python
uv run pytest
test -f uv.lock && echo "lock file exists"
test -d .venv && echo "virtualenv exists"
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

## Think about it

- `uv.lock` pins exact versions; `pyproject.toml` states a version range.
  Why do you need both instead of just one?
- If two teammates run `uv sync` on the same `pyproject.toml` +
  `uv.lock` on different operating systems, should they end up with the
  same dependency versions? Why?
- The devcontainer configuration provisions Python, Go, and Java
  system-wide, but this lab still uses `uv` for Python dependencies
  specifically. What's the difference between "the language runtime is
  available" and "this project's dependencies are reproducible"?

## If you get stuck

- **Hint 1:** The whole lab is three commands: `uv sync`, `uv run python
  main.py`, `uv run pytest`. Everything else is reading and writing notes.
- **Hint 2:** If `python3 main.py` "just works" for you without `uv sync`,
  it's because `cowsay` happens to already be installed globally on your
  machine — that's exactly the trap this lab is about. Try it in a
  completely fresh Codespace to see the failure for real.
- **Hint 3:** `uv run <command>` runs `<command>` inside the project's own
  managed environment, without you needing to manually activate anything.

Before moving on: commit and push everything from this lab, `uv.lock`
included (`git add -A && git commit -m "..."; git push`). Nothing later
assumes a clean tree yet, but Act IV (starting at Lab 16) does — get in
the habit now.

## What's next

You now have one small, reproducible project. Real projects, though, don't
stay in a single file for long. Next, you'll deal with a script that has
grown past the point where "just one file" still works.

Continue to [Lab 06 — From script to project](../06-from-script-to-project/README.md).

## Preview: the same lesson in Go and Java

Everything above this section is the real, complete Lab 05 in Python.

The two sections below are a **preview** of this specific
reproducibility lesson, not of the whole course: a self-contained way
to feel it using Go's and Java's own toolchains. They're optional —
Act II's Go and Java tracks (Lab 06 onward) use a different project
and don't require you to have done this preview first. Past Lab 10,
though, Go and Java don't continue yet; Labs 11-30 are Python-only for
now.

### Go (preview)

Starter: `examples/works-on-my-machine/go/`. Requires Go 1.27.x (see
the root README's toolchain table).

1. Confirm the starter works exactly as committed:
   ```bash
   cd examples/works-on-my-machine/go
   go test ./...
   go run .
   ```
   Expect `ok` and `It works on my machine!`.
2. In your own working copy — not the committed file — open `go.mod`
   and bump the `go` line one minor version higher than this course's
   current baseline (`go 1.27` becomes `go 1.28`), to simulate a
   project that now asks for a newer Go than a strict teammate's
   machine has.
3. Run `GOTOOLCHAIN=local go build ./...`. Read the error. It's real:
   `GOTOOLCHAIN=local` tells Go "never download a different toolchain,
   only use what's already on this machine" — the same trade-off a
   strict offline or locked-down CI machine might make on purpose.
4. Run the same build again *without* `GOTOOLCHAIN=local`, i.e. with
   Go's actual default (`auto`): `go build ./...`. You'll see one of
   two things, depending on whether Go 1.28 has shipped by the time
   you try this: either it downloads and the build proceeds, or it
   fails with `toolchain not available`. Either way, notice this is a
   *different* failure than step 3's — `auto` actually tried to help;
   it just can't invent a release that doesn't exist yet. `local`
   didn't try at all.
5. Change `go.mod` back to `go 1.27` — the real, committed value. Run
   `go build ./...` again (still the default `auto`, no env var).
   This succeeds, every time, because `1.27` is a real, released
   version Go can always resolve, whether or not it already happened
   to be on this exact machine. That's the actual lesson: `auto`
   quietly does whatever the real, committed `go.mod` needs; `local`
   does nothing and complains loudly.
6. Confirm `go test ./...` passes again on the restored, committed
   state — that's what Course Health checks.

What this is teaching: `go.mod`'s `go` line is a real, enforced
requirement, the same way `pyproject.toml` and `uv.lock` are for
Python — not a comment nobody checks.

### Java (preview)

Starter: `examples/works-on-my-machine/java/`. Requires JDK 21 and the
committed Gradle Wrapper — no global Gradle install.

1. Confirm the starter works exactly as committed:
   ```bash
   cd examples/works-on-my-machine/java
   ./gradlew test build
   ```
   Expect `BUILD SUCCESSFUL`.
2. In your own working copy, open `build.gradle` and find
   `JavaLanguageVersion.of(21)`. Change `21` to `25`.
3. Run `./gradlew build` again. Read the error — Gradle tells you
   plainly that no installed JDK matches what the project now asks
   for, and that it isn't configured to download one either.
4. Change `25` back to `21`. Run `./gradlew build` once more and
   confirm it's green again.

What this is teaching: the toolchain version lives in `build.gradle`,
committed next to the code, the same reason the Gradle Wrapper itself
pins which Gradle runs this project — neither is left to whatever
happens to already be on a machine.
