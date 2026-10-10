# Lab 26 — Project kickoff

## Story

You're not fixing someone else's project anymore. A restaurant owner
has a real problem and no software to solve it: "Reservations are
tracked on paper. During busy evenings it's slow to check which tables
are free, confirm what's already booked, or handle a cancellation
before the next call comes in." That's the whole brief. Everything
else — scope, design, language, plan — is yours to decide as a team.

## Learning objectives

After this lab you should be able to:

- Turn an open-ended problem into a written scope, a set of
  assumptions, and concrete MVP acceptance criteria.
- Write a lightweight Architecture Decision Record (ADR) justifying a
  real technical choice for your specific team and problem.
- Produce a milestone plan and a risk list for a multi-session project.

## Before you start

- Labs 01-25 complete, in your chosen track (Python, Go, or Java).
- If you're in a classroom: your instructor has assigned you to a team
  of 3-4. If you're working solo: you *are* the team — do every step
  below, including the role-assignment ones, deciding for yourself.
- Almost no code yet: the only code you touch is the starter you copy
  in the last step below, after your team has decided on a language.
  Everything else in this lab is planning and setting up a repository.

## Your task

**The problem (give this to your team as-is):**

> The restaurant needs a small internal tool called **TableTime** for
> managing table reservations. Today, reservations are tracked on
> paper.
>
> Minimum viable capabilities:
> 1. Create a reservation: a customer name, a party size, a day, and a
>    time slot.
> 2. List all reservations for a given day.
> 3. Cancel a reservation.
>
> The restaurant has a fixed, small number of tables, each with a
> maximum seating capacity — you decide the exact numbers as part of
> your design. A reservation must be assigned a table that can seat the
> party.
>
> There is no requirement (yet) about what happens if two reservations
> end up assigned to the same table at overlapping times. This is a
> real, deliberate gap in the brief, not an oversight you're meant to
> paper over — decide for yourselves whether it matters for this MVP,
> and if you decide it does, nothing stops you from handling it now
> instead of later.

### Step 1 — set up your team's actual repository

This is a different repository from the one you're reading this lab
in. Your personal fork of this course repository is where you did
Labs 01-25; TableTime lives somewhere new, created fresh, that your
whole team can push to. Don't create it by forking this course
repository, and don't build TableTime inside your existing fork
anywhere — a fresh, empty repository, owned by your team, is step
one.

1. **One person on the team creates it** (anyone — it doesn't have to
   be the same person every lab). On [github.com](https://github.com),
   click the **+** in the top-right corner, then **New repository**.
2. **Name it** something short and recognizable — `tabletime` is fine.
3. **Leave "Add a README file" unchecked.** You're about to write your
   own `README.md` locally and push it yourselves as your first real
   commit — letting GitHub auto-create one would just mean deleting it
   a few minutes later. Leave the `.gitignore` and license dropdowns on
   "None" too; you'll bring in whatever `.gitignore` your chosen
   starter ships with in the last step below.
4. Click **Create repository**. GitHub lands you on a page with
   "Quick setup" and a few command snippets — keep this page open, you
   need the URL from it next.
5. **Copy the HTTPS URL** (the box near the top, starting with
   `https://github.com/...`, with a copy icon next to it) — not the
   SSH one, to stay consistent with how you've cloned repositories all
   course.
6. **Clone it locally**, in a new terminal, in a location outside your
   existing course-repository clone — `git clone <the URL you just
   copied>`, then `cd` into the new folder.
7. **Open that folder in VS Code** — a fresh **File → Open Folder...**
   (or `code .` from the terminal), separate from whatever VS Code
   window has your course repository open.
8. **Confirm `origin` points at your new team repository**, not your
   course fork: `git remote -v` should show the URL you just cloned,
   for both `fetch` and `push`.
9. Write a root `README.md` right now, by hand, with one or two
   sentences on what TableTime is and a placeholder note that setup/run
   instructions will land here once the starter is copied in. Commit
   it (`git add README.md && git commit -m "docs: add initial
   README"`) and push (`git push`) — this is your team repository's
   first real commit.
10. **If you're a team**, one more step before anyone else touches
    code: on GitHub, go to your new repository's **Settings → Collaborators**,
    and add each teammate by their GitHub username or the email
    they used to sign up. GitHub emails them an invitation; each
    teammate accepts it from that email (or from the notification bell
    on GitHub) before they can push.
11. **Every teammate then clones the same URL** from step 5 onto their
    own machine, the same way you did in step 6 — everyone ends up
    with their own local copy of the one team repository, exactly like
    you've been doing with your personal course fork since Lab 03,
    just pointed at a different remote.
12. From here, `README.md` (just started), and soon `PROJECT_PLAN.md`
    and `docs/adr/adr-001-language-choice.md`, all live in *this*
    repository's root — not anywhere inside your course fork.

No `gh` CLI, no SSH keys, no WSL, no Docker needed for any of this —
everything above is either the GitHub web UI or plain `git`, the same
Git Bash-inside-VS-Code setup you've used all course on Windows.

### Step 2 — write `PROJECT_PLAN.md`

As a team, write `PROJECT_PLAN.md` (in your new repository) covering:

- **Scope**: what's in the MVP, what's explicitly out.
- **Assumptions**: anything the brief didn't specify that you decided
  for yourselves — how many tables, their capacities, and, in detail,
  your time model:
  - What values does a reservation's time slot actually hold — clock
    times (`"19:00"`), named slots (`"lunch"`, `"dinner"`), or
    something else?
  - What real-world interval does one reservation represent, and for
    roughly how long does a table stay occupied because of it?
  - What happens at the edges — does a reservation ending at the same
    moment another begins count as overlapping, or not?

  Write this precisely enough that *later*, anyone on the team could
  look at two reservations and say for certain whether they overlap in
  time — even though you aren't required to write any code that
  checks this yet (that's a separate decision, left to you, per the
  gap in the brief above). A model that only supports a handful of
  named, non-overlapping slots (`"lunch"`/`"dinner"`) is a perfectly
  valid choice *if you say so explicitly* — what's not acceptable here
  is leaving it vague enough that nobody could answer the question
  later without guessing what you meant now.
- **Acceptance criteria**: how you'll know the MVP is done — specific,
  checkable statements, in the style of Lab 20's Definition of Done.
- **Responsibilities**: who owns what, if you're a team; if solo,
  which concerns you'll tackle in which order.
- **Milestone plan**: a rough mapping of what happens in Labs 27
  (iteration), 28 (change request), 29 (incident), and 30 (handover).
- **Top risks**: 2-3 specific things that could derail this project,
  and what you'd do about each.

### Step 3 — write the ADR

Before you write the ADR: all three languages this course covers are
genuinely available for this capstone — Python, Go, and Java are
equally real choices, not a default plus two alternatives. By now your
team has spent all of Act V (Labs 21-25) building a real, tested,
persisted, observable HTTP API in whichever track you picked, so "we
don't know this language well enough" isn't automatically true for any
of the three the way it might have been back at Lab 14. Base the
decision on what actually matters for *this* team and *this* project:

- which language your team already knows best, from Act V and
  whichever earlier labs you did in it;
- which track you were already in, if switching has no real benefit;
- a genuine team preference, if more than one option is equally
  comfortable;
- which language keeps the MVP's actual logic simplest to express;
- any constraint your environment imposes (shared machines, an
  instructor's grading setup, and so on).

Neither "we picked the same language as our Act V track" nor "we
switched because we wanted to" needs a bigger justification than
that — just write down the real one, specific to your team, not a
general claim about which language is better. Then write
`docs/adr/adr-001-language-choice.md` (in your new repository) using
this template:

```markdown
# ADR-001: Choice of implementation language

## Status
Accepted

## Context
[What are you building, and what constraints matter — team
familiarity, deployment target, existing course experience with
Python/Go/Java from Labs 14-15?]

## Decision
[Which language: Python, Go, or Java, and why — for this team, this
problem, not "which language is best in general."]

## Consequences
[What does this choice make easier? What does it make harder? What
would make you revisit this decision later?]
```

### Step 4 — copy the matching starter

Now that Step 3 has settled on a language, copy the matching starter
from `examples/capstone-starters/<python|go|java>/` (in this course
repository) into your new repository's root. Work from a fresh clone
of the course repository if your working copy there has uncommitted
changes you don't want to drag along by accident.

- Copy the starter directory's **entire contents**, including dotfiles
  (`.gitignore`, and for Python, `.python-version`) — a plain Finder/
  Explorer copy or `cp -r`/`xcopy` can silently skip files whose name
  starts with a dot; double-check with `ls -a` (or ``Get-ChildItem
  -Force`` in PowerShell) in the destination afterward.
- Do **not** copy a `.git` folder if the starter happens to have one
  anywhere nested inside it — there shouldn't be one, but if `ls -a`
  shows one, delete it before committing; a nested `.git` directory
  would silently turn part of your repository into an unrelated,
  broken sub-repository.
- The starter's own `STARTER.md` will **not** overwrite the
  `README.md` you wrote in Step 1 — they're different files. Read
  `STARTER.md` once for the exact setup commands, then delete it; it's
  scaffolding, not part of your project.

Track-specific details:

#### Python

Nothing to rename — `examples/capstone-starters/python/pyproject.toml`
already has `name = "capstone-starter"`, which is cosmetic and doesn't
need to match your team's repository name for `uv sync`/`uv run
pytest` to work. Change it later if you want a tidier `pyproject.toml`,
but it's not required.

#### Go

The starter's `go.mod` declares `module capstonestarter`. That name is
only used for *internal* import paths within your own module — since
this starter is a single `package main` with no sub-packages importing
each other by path, nothing breaks if you leave it as `capstonestarter`
forever. If you'd still rather rename it to match your project (for
example `tabletime`), the safe procedure is one command, run once,
right after copying the starter in and before writing any of your own
code: `go mod edit -module tabletime`. Then confirm `go build ./...`
and `go test ./...` still succeed before your first commit — this
course verified that exact rename causes no breakage for this
starter's shape, but confirming it yourself takes seconds and costs
nothing.

#### Java

Keep the entire committed Gradle Wrapper (`gradlew`, `gradlew.bat`,
`gradle/wrapper/gradle-wrapper.jar`, `gradle/wrapper/gradle-wrapper.properties`)
exactly as copied — these are binary/pinned files, not something to
regenerate or edit. `settings.gradle`'s `rootProject.name =
'capstone-starter'` is cosmetic, the same way Go's module name is; if
you want it to read `tabletime` instead, edit that one line and
confirm `./gradlew test` still passes before your first commit. Do
**not** run `gradle init` or any Gradle wrapper-generation command
inside your new repository — that would create a second, different
wrapper and likely conflict with the one you just copied in.

Finish with the checkpoint every track shares:

```text
Team repository exists
→ correct starter copied
→ tests green
→ commit
→ push
→ teammates can clone and run tests
```

Commit the starter as your own first real project commit (for
example `feat: add <language> project starter`), push, and — if
you're a team — have every teammate `git pull` and run their track's
test command locally, confirming green, before anyone writes a line
of TableTime's actual logic.

### Step 5 — CI, now, if this session has room left (optional here)

Lab 27 opens with setting up CI for this repository — the exact same
mechanical recipe you already followed in Lab 19, just pointed at a
different test command. Nothing about it depends on any TableTime
code existing yet, since it only needs to run against the starter's
one existing test. If your team finished Steps 1-4 with meaningful
time still left in this session, set it up now: it's one `.github/
workflows/*.yml` file, one more small PR through your team's own
review process, and one thing Lab 27 won't have to spend time on.

This is genuinely optional here, not a hidden requirement: a 3-4
person team that's already spent most of this session on repository
setup, collaborator invites, and a real planning discussion should
not try to squeeze CI in on top — Lab 27's own step 1 covers it, and
starting Lab 27 with that step is exactly as valid as arriving with
it already done. Don't let this turn into a reason to rush
`PROJECT_PLAN.md` or the ADR; those two documents are this lab's
actual point.

## Acceptance criteria

- `PROJECT_PLAN.md` exists and answers all six points in Step 2 with
  specifics, not placeholders — including an unambiguous description
  of what a time slot means and how long a table is considered
  occupied.
- `docs/adr/adr-001-language-choice.md` exists and states a real
  decision with real reasoning specific to this team, not "we chose
  Python because it's popular" (or the equivalent for Go or Java).
- A new team repository exists, separate from the course repository,
  with a root `README.md`, the copied starter, and every teammate able
  to clone it and run its tests green.

## Verification

There's no automated check for a plan — verify it the way a reviewer
would: read `PROJECT_PLAN.md` cold. Could someone who wasn't in your
kickoff conversation tell, from the document alone, what you're
building, why you made the choices you made, and whether two given
reservations would count as overlapping under your stated time model?

## Think about it

- The brief deliberately doesn't say what happens with overlapping
  reservations for the same table. Did your team notice that gap while
  writing acceptance criteria, or only when re-reading this question?
- Your ADR should be revisitable. What specific new information, if it
  showed up in Lab 28 or Lab 29, would make you want to revisit
  ADR-001?
- You had to pin down your time model precisely enough to answer
  "do these two reservations overlap?" without yet deciding whether
  the system *prevents* overlaps. Why are those two different
  decisions, and which one actually matters for Lab 27's MVP?

## If you get stuck

- **Hint 1:** A good acceptance criterion reads like a test name:
  "creating a reservation for a party larger than any table raises an
  error," not "reservations work correctly."
- **Hint 2:** Keep your table model small — 4-6 tables with 2-3
  different capacities is enough to make later labs interesting without
  overengineering the kickoff.
- **Hint 3:** If your team can't agree on a language, revisit Lab 14's
  comparison (Python Protocol vs. Go interface vs. Java `implements`)
  and let *that* discussion, plus which track you're each strongest in
  after Act V, inform ADR-001 — not a guess about which language is
  "better."
- **Hint 4:** If `git remote -v` shows your course fork's URL instead
  of your new team repository's, you're about to commit TableTime into
  the wrong place — stop and re-clone from the correct URL (Step 1)
  rather than trying to repoint `origin` on a repository that already
  has unrelated history in it.

## What's next

You have a plan and a decision record. Now you build the thing, using
every workflow habit from Act IV, continuously.

Continue to [Lab 27 — Development iteration](../27-development-iteration/README.md).
