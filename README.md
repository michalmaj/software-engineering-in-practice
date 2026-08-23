# Software Engineering in Practice

A hands-on laboratory course in software engineering, told as one continuous
story instead of a list of unrelated topics.

## Who this is for

University students taking a Software Engineering lab course. No prior
professional development experience is assumed. You should be comfortable
writing basic Python.

## The idea behind this course

> Programming is about making a program work.
> Software engineering is about making software safe to change, understand,
> review, reproduce, operate, and hand over to other people.

Each lab exists because the previous state of the project created a problem
worth solving. You will meet a problem before you meet its name.

## How the course is organized

30 lab sessions, 90 minutes each, grouped into six acts:

| Act | Labs  | Theme                                   |
|-----|-------|------------------------------------------|
| I   | 01-05 | I am a developer                         |
| II  | 06-10 | Code is not yet a project                |
| III | 11-15 | Software must survive change             |
| IV  | 16-20 | You do not work alone                    |
| V   | 21-25 | The system lives in a larger world        |
| VI  | 26-30 | You are the engineering team              |

Python is the shared language through most of the course. Go and Java appear
from Lab 14 onward for explicit cross-language comparisons, and become
implementation choices for your team project in Act VI.

## Where to start

Open [`labs/01-workstation/README.md`](labs/01-workstation/README.md) (or
[`README.pl.md`](labs/01-workstation/README.pl.md) for Polish) and follow the
labs in numeric order. Each lab ends with a "What's next" section that tells
you where to go.

## Getting an environment: GitHub Codespaces (recommended)

1. You need a GitHub account.
2. Open this repository on GitHub and click **Fork** (top right). This
   creates your own copy — you need your own fork because later labs
   have you commit and push, and you don't have write access to the
   original course repository.
3. On **your fork**, click **Code → Codespaces → Create codespace on
   main**. (Creating a Codespace on the original course repository
   instead of your fork is the most common setup mistake — double-check
   the repository name in the URL before continuing.)
4. Wait for the codespace to finish initializing (this can take a few
   minutes the first time).
5. Open the integrated terminal: **Terminal → New Terminal**.
6. Verify your toolchain (see below).
7. The repository is already checked out at `/workspaces/<repo-name>`
   inside the codespace, with `origin` already pointing at your fork.
8. When you are done for the day, stop the codespace from
   **github.com/codespaces** (or let it auto-suspend) — this does not
   delete your work.
9. Codespaces has monthly usage limits. Stop codespaces you are not
   actively using; delete ones you no longer need.
10. To pull in course updates later, add the original repository as a
    second remote: `git remote add upstream <original-repo-url>`, then
    `git fetch upstream` and `git merge upstream/main` when needed.

## Getting an environment: local Unix-like machine (supported fallback)

Works on Linux and macOS. Getting the repository itself needs only
Git — no Docker Desktop, no WSL. Individual labs will later have you
install a language toolchain (Python, `uv`, Go, a JDK) as you actually
need it; the install methods in the table below (`curl`-based scripts,
your OS's package manager) don't need admin rights on most systems, but
that depends on how your machine is already set up — if your package
manager is configured to require `sudo`, that's a property of your
machine, not something this course adds on top of it.

1. Fork this repository on GitHub (same reason as above: you need write
   access for later labs).
2. Clone **your fork**, not the original repository:
   ```bash
   git clone <your-fork-url>
   cd software-engineering-in-practice
   ```
3. Add the original repository as a second remote, so you can pull
   course updates later:
   ```bash
   git remote add upstream <original-repository-url>
   ```

Individual labs will tell you which additional tool (like `uv`) to install
and how, the first time you actually need it. See "Verifying your
toolchain" below for what each lab actually needs and when.

## Verifying your toolchain

Once your environment is up (Codespaces or local), check what is available:

```bash
git --version
python3 --version
go version
java -version
```

Lab 01 walks you through reading and interpreting this kind of output if any
of it is unfamiliar.

Not every lab needs every tool. Here's when each one actually matters:

| Tool | First needed in | Install if missing |
|------|-----------------|---------------------|
| Git | Lab 01 | Already on Codespaces; on macOS/Linux, usually pre-installed or via your package manager |
| Python 3.13 | Lab 01 | Codespaces has it; locally, use your OS's Python or [pyenv](https://github.com/pyenv/pyenv) if you need a specific version |
| `uv` 0.11.21 | Lab 05 | `curl -LsSf https://astral.sh/uv/0.11.21/install.sh \| sh` |
| Go 1.25 | Lab 14 | Codespaces has it; locally, see [go.dev/doc/install](https://go.dev/doc/install) |
| JDK 21 | Lab 14 | Codespaces has it; locally, see your OS's package manager (e.g. `brew install openjdk@21`) |

Run `scripts/check-environment.sh` at any point to see which of these
your current environment actually has.

## Language of this repository

This repository is bilingual. Every lab has two versions:

```text
labs/0N-topic/README.md      # English
labs/0N-topic/README.pl.md   # Polish
```

Both versions are pedagogically equivalent — pick whichever you read more
comfortably. Code, commands, filenames, and identifiers are always in
English regardless of which README you follow.

## Working through the labs

- Follow labs in order — each one assumes the previous one is done.
- Do the task described in the lab, not just the reading.
- Use each lab's "Verification" section to confirm you're actually finished
  before moving on.
- If you get stuck, use the lab's progressive hints before asking for the
  answer outright.

## What's next

Start with [`labs/01-workstation/README.md`](labs/01-workstation/README.md).
