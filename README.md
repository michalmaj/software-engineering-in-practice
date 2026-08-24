# Software Engineering in Practice

[Czytaj po polsku →](README.pl.md)

> From terminal to team — learning to build software that survives change.

## What this course is

30 lab sessions, 90 minutes each: a hands-on Software Engineering lab
course told as one continuous, progressive story, not a catalogue of
technologies. It's built for university students taking a Software
Engineering lab course — no prior professional development experience
assumed, just basic Python.

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

The preferred path is: **fork → Codespace → terminal → Lab 01.** This
course doesn't assume GitHub Classroom — just a regular GitHub account.

1. Fork this repository (**Fork** button, top right of the GitHub page).
2. On **your fork**, open **Code → Codespaces → Create codespace on
   main**.
3. Open the integrated terminal (**Terminal → New Terminal**).
4. Open [`labs/01-workstation/README.md`](labs/01-workstation/README.md)
   and begin.

## GitHub Codespaces

Codespaces is the recommended way to run this course: everyone gets the
same environment, with nothing to install on your own machine first.

- **Why we use it:** no local setup, no "works on my machine" before
  Lab 1 even starts, and it works from any machine that can run a
  browser.
- **The environment is Linux-based** (Ubuntu), regardless of what your
  own laptop runs. Every command and path in this course assumes a
  Unix-like shell.
- **Create it from your own fork**, not the original course repository
  — you need write access for later labs that have you commit and push.
  Creating a Codespace on the original repository instead of your fork
  is the single most common setup mistake; double-check the repository
  name in the URL before continuing.
- **Open the terminal** with **Terminal → New Terminal** once the
  Codespace finishes initializing.
- **Verify your toolchain** by running `./scripts/check-environment.sh`
  — it checks the versions this course actually needs and tells you
  exactly what's missing or mismatched.
- **Stop Codespaces you're not using** from
  [github.com/codespaces](https://github.com/codespaces) (or let them
  auto-suspend). Codespaces has monthly usage limits; stopping one
  doesn't delete your work.

## Local Unix-like setup

Linux and macOS are a supported fallback. Getting the repository itself
needs only Git and a fork — no Docker Desktop, no WSL. The labs
themselves, though, do need a real toolchain, and we won't pretend
otherwise:

```bash
git clone <your-fork-url>
cd software-engineering-in-practice
./scripts/check-environment.sh
```

| Tool   | Required version |
|--------|-------------------|
| Python | 3.13.x             |
| `uv`   | 0.11.21 exactly    |
| Go     | 1.25.x             |
| JDK    | 21                 |

Gradle is **not** a global requirement: the Java capstone starter ships
its own committed Gradle Wrapper (`./gradlew`), so all you need locally
is a JDK.

## Languages and tools

| Ecosystem | Toolchain              | Tests                    |
|-----------|-------------------------|---------------------------|
| Python    | `uv`                    | `pytest`                  |
| Go        | standard Go tooling      | `go test`                 |
| Java      | JDK 21 + Gradle Wrapper  | JUnit, via `./gradlew test` |

Python carries most of the course; Go and Java appear from Lab 14
onward for explicit cross-language comparisons. In all three, the
language is the medium — the subject is software engineering.

## How the labs work

Every lab follows the same shape: **Story → Learning objectives →
Before you start → Your task → Acceptance criteria → Verification →
Think about it → If you get stuck → What's next.** That consistency is
deliberate — these materials are designed for self-study, whether
you're working through them solo or as part of a classroom.

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
