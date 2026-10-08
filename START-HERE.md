# Start here

[Zacznij tutaj (po polsku) →](START-HERE.pl.md)

This page gets you from "I have never used a terminal" to "I have my
own copy of this course on my computer, open in VS Code, ready for
Lab 01." It does not explain what the course is about yet — that's in
the main [`README.md`](README.md). This page is only about the
computer part.

## What you'll have when you're done

- Your own **fork** of this course on GitHub (your own copy, under
  your own account).
- A **clone** of that fork on your own computer (a local copy you can
  edit).
- That copy open in **VS Code**, with a working terminal inside it.
- A clear idea of what to do if something doesn't match what this
  page says.

You will **not** install Python, Go, or Java yet. Those come later,
once you've picked which language track you're using — this page is
only about getting the repository itself onto your machine.

## Pick your system

| Your computer | Guide |
|---|---|
| Windows 11 | [`docs/setup/windows.md`](docs/setup/windows.md) |
| macOS | [`docs/setup/macos.md`](docs/setup/macos.md) |
| Linux | [`docs/setup/linux.md`](docs/setup/linux.md) |

Each guide is a single, complete path: open a terminal, install Git
and VS Code if you don't have them, fork and clone this repository,
and open it in VS Code. Follow the one for your system from the top —
you don't need to read the other two.

Prefer to skip installing anything on your own machine? See
[GitHub Codespaces](#github-codespaces-the-no-install-option) below
instead — it's still supported, just no longer the default path.

## Already partway through this?

You don't need to start over.

- **"I already forked this repository on GitHub, but haven't cloned
  it yet."** Skip to the "Clone your fork" step in your system's
  guide above.
- **"I already have a local copy of this repository on my computer."**
  Go straight to
  [`docs/setup/already-have-a-fork.md`](docs/setup/already-have-a-fork.md) —
  it tells you how to find it, open it, and check it's actually in a
  safe state, without recreating anything.
- **"Something went wrong and I'm not sure what state I'm in."** See
  [`docs/setup/troubleshooting.md`](docs/setup/troubleshooting.md).

## When you're ready for Lab 01

You're ready once every one of these is true:

- [ ] I have my own fork on GitHub.
- [ ] I have a copy of it on my computer.
- [ ] I know where on my disk that copy lives.
- [ ] VS Code opens that project.
- [ ] A terminal works inside VS Code.
- [ ] On Windows, that terminal is Git Bash.
- [ ] `git status` works and doesn't show an error.
- [ ] `git remote -v` shows **my own** GitHub username, not the
  instructor's.
- [ ] I know where to find Lab 01's instructions.
- [ ] I know what to do if I get stuck later.

That's this course's actual definition of "ready for Lab 01." If all
ten are true, open
[`labs/01-workstation/README.md`](labs/01-workstation/README.md) and
start.

## GitHub Codespaces (the no-install option)

Codespaces runs this course in a browser-based environment instead of
on your own machine — nothing to install locally, but it needs a
stable internet connection for every session, and GitHub's free tier
has monthly usage limits.

1. Fork this repository (**Fork** button, top right of the GitHub
   page), the same as the local path.
2. On **your fork**, open **Code → Codespaces → Create codespace on
   main**.
3. Open the integrated terminal (**Terminal → New Terminal**).
4. Open [`labs/01-workstation/README.md`](labs/01-workstation/README.md)
   and begin.

The Codespace's terminal is already Bash, so the "on Windows, that
terminal is Git Bash" checklist item above doesn't apply — any Bash
prompt satisfies it.
