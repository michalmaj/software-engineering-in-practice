# Lab 11 — The client changed their mind

## Story

The restaurant owner says: "We want servers to be able to type in a
discount code at checkout." That's the whole request. No mention of
which codes, how much they're worth, whether they stack with the
existing loyalty discount, or what happens if someone mistypes one.

## Learning objectives

After this lab you should be able to:

- Turn a vague request into a list of concrete clarifying questions.
- Turn a resolved requirement into specific input/output examples.
- Explain why "what happens on invalid input" is itself a requirement,
  not an implementation detail.

## Before you start

- Labs 06-10 complete.
- No code for this lab — it's requirements analysis only.

## Your task

1. Before reading any further, write down at least five questions you
   would ask the restaurant owner about "discount codes at checkout."
   Put them in `labs/11-changed-requirements/my-clarifying-questions.md`.
   Think about: which codes exist, what each is worth, whether they
   combine with the existing loyalty discount, what happens with an
   unrecognized code, and whether more than one code can be used per
   order.
2. Now read the resolved specification below — this is what the owner
   actually meant, once someone asked:

   - There are exactly two discount codes: `SAVE10` and `SAVE5`.
   - `SAVE10` takes 10% off the amount that remains *after* the
     existing loyalty discount has already been applied.
   - `SAVE5` takes a flat $5 off that same remaining amount.
   - At most one discount code may be used per order.
   - An unrecognized code is an error — the system must refuse the
     order rather than silently charging full price.
3. In the same notes file, add a table with at least four concrete
   examples covering: an order using `SAVE10`, an order using `SAVE5`,
   an order using no code at all, and an order using a code that
   doesn't exist. For each, state what should happen (a total, or an
   error).

## Acceptance criteria

- `my-clarifying-questions.md` contains at least five distinct
  clarifying questions written *before* you read the resolved spec.
- The same file contains an examples table with at least four rows
  covering the scenarios listed in step 3.

## Verification

```bash
test -f labs/11-changed-requirements/my-clarifying-questions.md && echo "notes exist"
grep -c '^[0-9]\.' labs/11-changed-requirements/my-clarifying-questions.md
```

There's no automated check for the *content* of a requirements
analysis — this lab is verified by re-reading your own notes and
confirming each example resolves unambiguously.

## Think about it

- Of the five questions you wrote, how many were already answered by
  the resolved spec? How many weren't — and what would you do about
  those in a real project?
- "An unrecognized code is an error" is itself a design decision, not
  an obvious default. What would change about the system's behavior if
  the owner had instead said "just ignore codes we don't recognize"?

## If you get stuck

- **Hint 1:** Good clarifying questions are answerable with a specific
  fact, not "it depends." "Do discount codes expire?" is better than
  "how should discount codes work?"
- **Hint 2:** For the examples table, pick concrete numbers — an actual
  order total, an actual code, an actual expected outcome — not
  descriptions like "some order."
- **Hint 3:** If you're unsure whether `SAVE10` applies before or after
  the loyalty discount, re-read the resolved spec — it says explicitly.

## What's next

You know exactly what needs to be built. Now: where in the code should
this change actually go?

Continue to [Lab 12 — Where should this change go?](../12-change-surface/README.md).
