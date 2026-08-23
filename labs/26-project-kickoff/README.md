# Lab 26 — Project kickoff

## Story

You're not fixing someone else's project anymore. A restaurant owner
has a real problem and no software to solve it: "Servers are tracking
table reservations on paper. It's slow, and we keep double-booking
tables during busy nights." That's the whole brief. Everything else —
scope, design, language, plan — is yours to decide as a team.

## Learning objectives

After this lab you should be able to:

- Turn an open-ended problem into a written scope, a set of
  assumptions, and concrete MVP acceptance criteria.
- Write a lightweight Architecture Decision Record (ADR) justifying a
  real technical choice for your specific team and problem.
- Produce a milestone plan and a risk list for a multi-session project.

## Before you start

- Labs 01-25 complete.
- If you're in a classroom: your instructor has assigned you to a team
  of 3-4. If you're working solo: you *are* the team — do every step
  below, including the role-assignment ones, deciding for yourself.
- No code yet — this lab is planning only.

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
> end up assigned to the same table at overlapping times. Decide for
> yourselves whether that matters for this MVP.

1. Set up your team's actual repository now (new, separate from this
   course repository), with a root `README.md` explaining what
   TableTime is and how to run it once it exists. Everything from here
   on lives in that repository, not this one.
2. Copy the matching language starter from
   `examples/capstone-starters/<python|go|java>/` (in this course
   repository) into your new repository's root, once you've made the
   language decision in step 4 below — commit it as your first real
   commit.
3. As a team, write `PROJECT_PLAN.md` (in your new repository) covering:
   - **Scope**: what's in the MVP, what's explicitly out.
   - **Assumptions**: anything the brief didn't specify that you
     decided for yourselves (how many tables, their capacities, what a
     "time slot" is — an hour? a specific reservation window?).
   - **Acceptance criteria**: how you'll know the MVP is done —
     specific, checkable statements, in the style of Lab 20's
     Definition of Done.
   - **Responsibilities**: who owns what, if you're a team; if solo,
     which concerns you'll tackle in which order.
   - **Milestone plan**: a rough mapping of what happens in Labs 27
     (iteration), 28 (change request), 29 (incident), and 30 (handover).
   - **Top risks**: 2-3 specific things that could derail this project,
     and what you'd do about each.
4. Write `docs/adr/adr-001-language-choice.md` (in your new repository)
   using this template:
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

## Acceptance criteria

- `PROJECT_PLAN.md` exists and answers all six points in step 1 with
  specifics, not placeholders.
- `docs/adr/adr-001-language-choice.md` exists and states a real
  decision with real reasoning, not "we chose Python because it's
  popular."
- A new team repository exists, separate from the course repository,
  with at least a root `README.md`.

## Verification

There's no automated check for a plan — verify it the way a reviewer
would: read `PROJECT_PLAN.md` cold. Could someone who wasn't in your
kickoff conversation tell, from the document alone, what you're
building and why you made the choices you made?

## Think about it

- The brief deliberately doesn't say what happens with overlapping
  reservations for the same table. Did your team notice that gap while
  writing acceptance criteria, or only when re-reading this question?
- Your ADR should be revisitable. What specific new information, if it
  showed up in Lab 28 or Lab 29, would make you want to revisit
  ADR-001?

## If you get stuck

- **Hint 1:** A good acceptance criterion reads like a test name:
  "creating a reservation for a party larger than any table raises an
  error," not "reservations work correctly."
- **Hint 2:** Keep your table model small — 4-6 tables with 2-3
  different capacities is enough to make later labs interesting without
  overengineering the kickoff.
- **Hint 3:** If your team can't agree on a language, revisit Lab 14's
  comparison (Python Protocol vs. Go interface vs. Java `implements`)
  and let *that* discussion, not familiarity alone, inform ADR-001.

## What's next

You have a plan and a decision record. Now you actually build the
thing — using every workflow habit from Act IV, for real, continuously.

Continue to [Lab 27 — Development iteration](../27-development-iteration/README.md).
