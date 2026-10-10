# Software Engineering in Practice

[Czytaj po polsku →](README.pl.md)

**New here? → [Start here](START-HERE.md)** walks you through setting
up your computer (Windows, macOS, or Linux) and opening this
repository — no terminal, Git, or GitHub experience assumed.

[![Course Health](https://github.com/michalmaj/software-engineering-in-practice/actions/workflows/course-health.yml/badge.svg)](https://github.com/michalmaj/software-engineering-in-practice/actions/workflows/course-health.yml)
[![Python 3.13](https://img.shields.io/badge/Python-3.13-blue)](https://www.python.org/)
[![Go 1.27](https://img.shields.io/badge/Go-1.27-00ADD8)](https://go.dev/)
[![Java 21](https://img.shields.io/badge/Java-21-ED8B00)](https://adoptium.net/)
[![30 Labs](https://img.shields.io/badge/30%20Labs-orange)](#course-map)
[![Bilingual EN | PL](https://img.shields.io/badge/EN%20%7C%20PL-9cf)](README.pl.md)
[![License: MIT](https://img.shields.io/badge/code-MIT-yellow)](LICENSE)
[![License: CC BY 4.0](https://img.shields.io/badge/content-CC%20BY%204.0-lightgrey)](LICENSE-CONTENT.md)
[![Codespaces — ready](https://img.shields.io/badge/Codespaces%20%E2%80%94%20ready-success)](#github-codespaces)

> From terminal to team — learning to build software that survives change.

## What this course is

30 lab sessions, 90 minutes each: a hands-on Software Engineering lab
course told as one continuous, progressive story, not a catalogue of
technologies. It's built for university students taking a Software
Engineering lab course — no prior professional development experience
assumed, just basic programming in the language you'll pick for your
track (Python, Go, or Java).

## Core idea

> Programming is about making a program work. Software engineering is
> about making software safe to change, understand, review, reproduce,
> operate, and hand over.

Every lab exists because the previous state of the project created a
problem worth solving. You meet a problem before you meet its name.

## Course journey

```text
workstation → terminal → Git → project → tests → design →
collaboration → CI → APIs / data / failures → release →
team project → handover
```

| Act | Labs  | Theme                              |
|-----|-------|-------------------------------------|
| I   | 01-05 | I am a developer                    |
| II  | 06-10 | Code is not yet a project           |
| III | 11-15 | Software must survive change        |
| IV  | 16-20 | You do not work alone               |
| V   | 21-25 | The system lives in a larger world  |
| VI  | 26-30 | You are the engineering team        |

## Start here

New to terminals, Git, or GitHub? Follow
[`START-HERE.md`](START-HERE.md) first — it picks the right guide for
your computer (Windows, macOS, or Linux) and walks you through
installing Git and VS Code, forking this repository, and cloning it,
assuming no prior experience.

Already comfortable with Git and a terminal? The short version:

1. Fork this repository (**Fork** button, top right of the GitHub
   page).
2. Clone your fork and open it in VS Code — see
   [`START-HERE.md`](START-HERE.md) for the exact commands for your
   system.
3. Open [`labs/01-workstation/README.md`](labs/01-workstation/README.md)
   and begin.

Prefer a browser-based environment instead of installing anything
locally? See [GitHub Codespaces](#github-codespaces) below.

## Local setup (the default path)

Windows, macOS, and Linux are all equally supported, first-class paths
— not a fallback. [`START-HERE.md`](START-HERE.md) and the guides
under [`docs/setup/`](docs/setup/) walk through each one in full,
click-by-click detail.

Getting the repository itself onto your computer only needs Git — no
Docker Desktop, no WSL, no GitHub Desktop. You will **not** need
Python, Go, or a JDK until you reach the lab where you pick a language
track — installing all three toolchains up front isn't necessary and
isn't expected for Lab 01.

Once you've picked a language track, later labs do need a real
toolchain, and we won't pretend otherwise:

| Tool   | Required version |
|--------|-------------------|
| Python | 3.13.x             |
| `uv`   | 0.11.21 exactly    |
| Go     | 1.27.x             |
| JDK    | 21                 |

Gradle is **not** a global requirement: Java starters ship their own
committed Gradle Wrapper (`./gradlew`), so all you need locally is a
JDK. To check your toolchain against this table at any point, run
`./scripts/check-environment.sh` — it's a reference tool for later
labs, not a gate for Lab 01.

## GitHub Codespaces

Prefer not to install anything locally? Codespaces runs this course in
a browser-based environment instead of on your own machine — nothing
to install, but it needs a stable internet connection for every
session, and GitHub's free tier has monthly usage limits.

- **Create it from your own fork**, not the original course repository.
  You need write access for later labs that have you commit and push.
  Creating a Codespace on the original repository instead of your fork
  is the single most common setup mistake; double-check the repository
  name in the URL before continuing.
- **Open the terminal** with **Terminal → New Terminal** once the
  Codespace finishes initializing.
- **The toolchain is already installed** — Python, Go, and the JDK all
  come preconfigured. Running `./scripts/check-environment.sh` is
  optional, useful only if you want to confirm versions match the table
  above; it's not required to start Lab 01.
- **Stop Codespaces you're not using** from
  [github.com/codespaces](https://github.com/codespaces) (or let them
  auto-suspend). Codespaces has monthly usage limits; stopping one
  doesn't delete your work.

1. Fork this repository (**Fork** button, top right of the GitHub page).
2. On **your fork**, open **Code → Codespaces → Create codespace on
   main**.
3. Open the integrated terminal (**Terminal → New Terminal**).
4. Open [`labs/01-workstation/README.md`](labs/01-workstation/README.md)
   and begin.

## Languages and tools

| Ecosystem | Toolchain              | Tests                    |
|-----------|-------------------------|---------------------------|
| Python    | `uv`                    | `pytest`                  |
| Go        | standard Go tooling      | `go test`                 |
| Java      | JDK 21 + Gradle Wrapper  | JUnit, via `./gradlew test` |

Labs 01-04 are one shared path, language-agnostic. From Lab 05 on,
you pick one of three equal, **fully supported** language tracks —
Python, Go, or Java, not one primary language with the other two as
examples — and use it consistently from there through the Act VI
capstone: same learning outcomes, real working starters, and the same
run/test commands pattern (just the language-specific tool) in all
three. Lab 14 is a deliberate pause to compare how the same idea looks
across all three — you read all three there, but still only implement
it in the one you picked, not a switch of track. In all three, the
language is the medium — the subject is software engineering. You
only need **one toolchain** for the whole course: whichever language
you choose at Lab 05, not all three up front.

## How the labs work

Every lab shares the same backbone: **Story → Learning objectives →
Before you start → Your task → Acceptance criteria → Verification →
Think about it → If you get stuck → What's next.** Some labs add a
section where the material actually calls for one — a timing note on
the heavier sessions, an "All tracks" note, or (Lab 26) a short
architecture-decision record — rather than forcing every lab into an
identical length. That backbone is deliberate — these materials are
designed for self-study, whether you're working through them solo or
as part of a classroom.

## Course map

| Lab | Title | Lab | Title |
|-----|-------|-----|-------|
| [01](labs/01-workstation/README.md) | Welcome to your workstation | [16](labs/16-parallel-branches/README.md) | Branches exist because work happens in parallel |
| [02](labs/02-terminal/README.md) | The terminal is a development tool | [17](labs/17-merge-conflict/README.md) | The merge conflict |
| [03](labs/03-inherited-repository/README.md) | You inherited a repository | [18](labs/18-pull-requests-and-review/README.md) | Pull requests and code review |
| [04](labs/04-local-vs-remote/README.md) | Local is not remote | [19](labs/19-repository-checks-itself/README.md) | The repository should check itself |
| [05](labs/05-works-on-my-machine/README.md) | "It works on my machine" | [20](labs/20-definition-of-done/README.md) | What does "done" mean? |
| [06](labs/06-from-script-to-project/README.md) | From script to project | [21](labs/21-api-is-a-contract/README.md) | An API is a contract |
| [07](labs/07-automated-tests/README.md) | How do we know it works? | [22](labs/22-data-outlives-code/README.md) | Code changed, old data remained |
| [08](labs/08-bug-report/README.md) | A bug report arrives | [23](labs/23-outside-world-fails/README.md) | The outside world fails |
| [09](labs/09-automated-checks/README.md) | Machines can check boring things | [24](labs/24-production-says-it-doesnt-work/README.md) | Production says "it does not work" |
| [10](labs/10-one-way-to-check/README.md) | One obvious way to check the project | [25](labs/25-release-and-compatibility/README.md) | Release and compatibility |
| [11](labs/11-changed-requirements/README.md) | The client changed their mind | [26](labs/26-project-kickoff/README.md) | Project kickoff |
| [12](labs/12-change-surface/README.md) | Where should this change go? | [27](labs/27-development-iteration/README.md) | Development iteration |
| [13](labs/13-refactoring-safety-net/README.md) | Refactoring with a safety net | [28](labs/28-change-request/README.md) | Change request |
| [14](labs/14-one-contract-three-languages/README.md) | One contract, three languages | [29](labs/29-production-incident/README.md) | Production incident |
| [15](labs/15-patterns-without-worship/README.md) | Patterns without pattern worship | [30](labs/30-handover/README.md) | Handover |

## Repository health

Run `./scripts/check-course.sh` to run the same checks this
repository's own CI runs on every push and pull request: repository
structure, EN/PL parity, and every example project's tests, syntax, and
lockfiles. This repository holds itself to the same practices it
teaches.

## Contributing / reporting problems

Found a bug, unclear instruction, or something that does not work in
your environment? Please open an issue.

## Licensing

This repository is dual-licensed:

- **Code** — source code, tests, scripts, configuration, CI/CD
  workflows, starter projects, and code snippets embedded in lab
  Markdown files — is licensed under the [MIT License](LICENSE).
- **Instructional content** — lab READMEs, task descriptions,
  narrative, questions, hints, and diagrams — is licensed under
  [Creative Commons Attribution 4.0 International](LICENSE-CONTENT.md)
  (CC BY 4.0).

Third-party materials included in this repository, if any, keep their
own original copyright and licensing terms.

## Instructor / author

Created and maintained by Michał Maj.
