# Lab 05 — "It works on my machine"

## Story

A teammate sends you a small project and says "just run it." On their
machine, it does. On yours, something's missing, or something's a
version too old or too new — and the project itself never wrote down
what it actually needs, so neither of you can tell *why* without
guessing.

This lab's starter lives in `examples/works-on-my-machine/<your
language>/` — `examples/` is where every persistent project in this
course lives, starting here. From here through the rest of the
course, you work in one of three tracks — Python, Go, or Java — and
this is the first lab where that choice actually matters: pick the one
your team (or you, if working solo) will use, and follow that section
below.

## Learning objectives

After this lab you should be able to:

- Explain why "it runs for me" is not evidence that a program is
  correctly packaged or reproducible.
- Use your track's own toolchain to make a project's dependencies, or
  its required tool version, explicit and enforced, not just "whatever
  happens to be on this machine."
- Explain what your track's manifest file is responsible for, and what
  happens when a project asks for something the machine running it
  doesn't have.
- Explain, at a high level, what the devcontainer configuration in
  this repository provisions for all three languages, not just yours.

## Before you start

### Python

- Lab 04 complete.
- Current directory: `examples/works-on-my-machine/python/` for all
  commands below, unless stated otherwise.
- `uv` installed. If you're in this repository's Codespace/devcontainer,
  it's already set up (see the root [`README.md`](../../README.md)). If
  you don't have it yet, install it with:
  `curl -LsSf https://astral.sh/uv/0.11.21/install.sh | sh` (pinned to
  the same version as the devcontainer, so everyone in this course is
  running the same `uv`).

### Go

- Lab 04 complete.
- Current directory: `examples/works-on-my-machine/go/` for all
  commands below, unless stated otherwise.
- Go 1.27.x installed (see the root README's toolchain table) — if
  you're in this repository's Codespace/devcontainer, it's already
  there.

### Java

- Lab 04 complete.
- Current directory: `examples/works-on-my-machine/java/` for all
  commands below, unless stated otherwise.
- JDK 21 installed (see the root README's toolchain table). No global
  Gradle install — this starter ships its own committed Gradle
  Wrapper, which is all you need.

## Your task

### Python

1. Without installing anything, try: `python3 main.py`. Read the
   error.
2. Open `pyproject.toml` and identify which package the project
   depends on.
3. Run `uv sync`. Look at what appeared in this directory afterward.
4. Run `uv run python main.py`. Compare this result with step 1.
5. Run `uv run pytest` and confirm the test suite passes.
6. Back in the repository root, in a new file
   `labs/05-works-on-my-machine/notes/my-observations.txt`, write, in
   your own words: (a) why step 1 failed, (b) what `uv sync` created
   and why, (c) what would happen to a teammate who only ran
   `python3 main.py` on their own machine without ever running `uv
   sync`.
7. Open `.devcontainer/devcontainer.json` at the repository root and
   find the line that provisions Python. Add one more sentence to your
   notes file: what provisions Go and Java in this same file?

### Go

1. Confirm the starter works exactly as committed:
   ```bash
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
   `go build ./...` again (still the default `auto`, no env var). This
   succeeds, every time, because `1.27` is a real, released version Go
   can always resolve, whether or not it already happened to be on
   this exact machine. That's the actual lesson: `auto` quietly does
   whatever the real, committed `go.mod` needs; `local` does nothing
   and complains loudly.
6. Confirm `go test ./...` passes again on the restored, committed
   state — that's what Course Health checks.
7. Back in the repository root, in a new file
   `labs/05-works-on-my-machine/notes/my-observations.txt`, write, in
   your own words: (a) what `GOTOOLCHAIN=local` actually refused to do
   in step 3, (b) why step 4's failure is a different *kind* of
   failure than step 3's, even though both are failures, (c) what
   would happen to a teammate whose machine only has Go 1.27 if this
   project's committed `go.mod` genuinely required 1.28.
8. Open `.devcontainer/devcontainer.json` at the repository root and
   find the line that provisions Go. Add one more sentence to your
   notes file: what provisions Python and Java in this same file?

### Java

1. Confirm the starter works exactly as committed:
   ```bash
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
5. Back in the repository root, in a new file
   `labs/05-works-on-my-machine/notes/my-observations.txt`, write, in
   your own words: (a) what exactly Gradle refused to do in step 3 and
   why, (b) where the required Java version actually lives in this
   project (it isn't a comment, and nobody has to remember it by
   hand), (c) what would happen to a teammate who tried to build this
   project with JDK 17 instead of 21.
6. Open `.devcontainer/devcontainer.json` at the repository root and
   find the line that provisions Java. Add one more sentence to your
   notes file: what provisions Python and Go in this same file?

## Acceptance criteria

### Python

- `uv run pytest` passes inside `examples/works-on-my-machine/python/`.
- `.venv/` and `uv.lock` exist in that directory (uv created them; do
  not hand-write either).
- `uv.lock`, created by `uv sync` (not shipped with the starter), is
  committed to the repository. A lock file is only useful to a
  teammate if it's checked in.
- `labs/05-works-on-my-machine/notes/my-observations.txt` answers all
  three points from step 6, plus the devcontainer question from step 7.

### Go

- `go test ./...` and `go run .` both pass on the final, restored
  state (`go.mod` back to `go 1.27`) — Course Health checks exactly
  this.
- `go.mod` is committed unchanged from the starter (`go 1.27`); the
  bump to `1.28` existed only in your own working copy while you ran
  the experiment, never committed.
- `labs/05-works-on-my-machine/notes/my-observations.txt` answers all
  three points from step 7, plus the devcontainer question from step 8.

### Java

- `./gradlew test build` passes on the final, restored state
  (`JavaLanguageVersion.of(21)`) — Course Health checks exactly this.
- `build.gradle` is committed unchanged from the starter
  (`JavaLanguageVersion.of(21)`); the change to `25` existed only in
  your own working copy while you ran the experiment, never committed.
- `labs/05-works-on-my-machine/notes/my-observations.txt` answers all
  three points from step 5, plus the devcontainer question from step 6.

## Verification

### Python

```bash
cd examples/works-on-my-machine/python
uv run pytest
test -f uv.lock && echo "lock file exists"
test -d .venv && echo "virtualenv exists"
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

### Go

```bash
cd examples/works-on-my-machine/go
cat go.mod
go test ./...
go run .
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

Expected: `go.mod` shows `go 1.27` (not `1.28` — if it shows `1.28`,
you forgot to restore it before finishing); `go test ./...` prints
`ok`; `go run .` prints `It works on my machine!`.

### Java

```bash
cd examples/works-on-my-machine/java
grep JavaLanguageVersion build.gradle
./gradlew test build
cd -
test -f labs/05-works-on-my-machine/notes/my-observations.txt && echo "notes exist"
```

Expected: the `grep` line shows `JavaLanguageVersion.of(21)` (not
`25` — if it shows `25`, you forgot to restore it before finishing);
`./gradlew test build` ends in `BUILD SUCCESSFUL`.

## Think about it

- Your track's manifest states what the project needs; a lock file (or
  a pinned toolchain version) states exactly which version satisfies
  that, down to the last digit. Why do you need both instead of just
  one?
- If two teammates on different operating systems build this same
  project from the same committed manifest, should they end up with
  compatible results? Why?
- The devcontainer configuration provisions all three languages
  system-wide, but this lab's actual exercise is about a
  project-level requirement (a Python dependency, a Go toolchain
  version, a Java language version) layered on top of that. What's
  the difference between "the language runtime is available on this
  machine" and "this specific project's requirements are
  reproducible"?

## If you get stuck

### Python

- **Hint 1:** The whole lab is three commands: `uv sync`, `uv run
  python main.py`, `uv run pytest`. Everything else is reading and
  writing notes.
- **Hint 2:** If `python3 main.py` "just works" for you without `uv
  sync`, it's because `cowsay` happens to already be installed
  globally on your machine — that's exactly the trap this lab is
  about. Try it in a completely fresh Codespace to see the failure for
  real.
- **Hint 3:** `uv run <command>` runs `<command>` inside the project's
  own managed environment, without you needing to manually activate
  anything.

### Go

- **Hint 1:** If step 3's error doesn't mention `1.28` at all, confirm
  you actually saved `go.mod` after editing it — `go build` reads the
  file fresh each time, it doesn't cache the old requirement.
- **Hint 2:** `GOTOOLCHAIN` is a real environment variable Go itself
  reads, not something this lab invented — `go env GOTOOLCHAIN` shows
  your machine's actual default (normally `auto`) when you don't
  override it on the command line.
- **Hint 3:** If you forget whether you restored `go.mod`, `cat
  go.mod` tells you immediately — it should say `go 1.27`, matching
  what `git diff go.mod` would show as no change at all.

### Java

- **Hint 1:** If `./gradlew build` seems to hang or do nothing after
  you change the Java version, give it a few seconds — Gradle is
  actually checking your installed JDKs before it can tell you none of
  them match.
- **Hint 2:** The error names the exact requirement it couldn't
  satisfy (`languageVersion=25`) — that's `build.gradle`'s
  `JavaLanguageVersion.of(...)` line talking back to you, not a
  generic Gradle failure message.
- **Hint 3:** If you forget whether you restored `build.gradle`, `git
  diff build.gradle` tells you immediately — it should show no
  changes at all.

Before moving on: commit and push everything from this lab, including
whatever your track generates (Python's `uv.lock`, included; Go's and
Java's manifests stay as committed, with no generated lock artifact to
add) (`git add -A && git commit -m "..."; git push`). Nothing later
assumes a clean tree yet, but Act IV (starting at Lab 16) does — get in
the habit now.

## What's next

You now have one small, reproducible project, in whichever language
you chose. Real projects, though, don't stay in a single file for
long. Next, you'll deal with a script that has grown past the point
where "just one file" still works.

Continue to [Lab 06 — From script to project](../06-from-script-to-project/README.md).
