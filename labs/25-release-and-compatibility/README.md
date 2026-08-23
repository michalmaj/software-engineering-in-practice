# Lab 25 — Release and compatibility

## Story

Another team wants to start calling `order-api` from their own service.
They need to know: what version are they integrating against, what's
guaranteed to keep working, and how will they find out when something
changes.

## Learning objectives

After this lab you should be able to:

- Write a changelog entry that documents what changed and why it
  matters to a caller.
- Tag a specific commit as a release using Git.
- Distinguish an additive (backward-compatible) change from a breaking
  one, and explain which SemVer position each one bumps.

## Before you start

- Lab 24 complete: `uv run pytest` passes with all tests from Labs
  21-24.
- Current directory: `examples/order-api/`.

## Your task

1. Write `CHANGELOG.md` in `examples/order-api/`, following a simple
   "Keep a Changelog"-style format, with one `## [1.0.0]` entry listing
   everything the API does as of Lab 24: the two endpoints, SQLite
   persistence, the `notes` migration, the retry wrapper, and
   structured logging.
2. Commit `CHANGELOG.md`, then tag the current commit:
   `git tag -a v1.0.0 -m "order-api v1.0.0"`.
3. Now make one real, additive change: add an optional `priority` field
   to `POST /orders`, defaulting to `"normal"` when the caller omits
   it. Existing requests that don't send `priority` must keep working
   exactly as before — run the full test suite to confirm none of your
   existing tests needed to change for this to be true.
4. Add a `## [1.1.0]` entry to `CHANGELOG.md` describing the new field,
   commit, and tag: `git tag -a v1.1.0 -m "order-api v1.1.0"`.
5. In a new section at the bottom of `CHANGELOG.md`, `## Compatibility
   notes`, describe (without implementing it) what a *breaking* version
   of this same idea would have looked like instead — for example,
   renaming `items` to `line_items` in the request/response — and state
   which SemVer position (major/minor/patch) each of the two changes
   (the real additive one, and the hypothetical breaking one) would
   bump, and why.

## Acceptance criteria

- `CHANGELOG.md` has both a `[1.0.0]` and a `[1.1.0]` entry, plus a
  `## Compatibility notes` section reasoning about major vs. minor.
- Both `v1.0.0` and `v1.1.0` exist as annotated Git tags.
- The `priority` field is implemented, defaults correctly, and every
  test written before this lab still passes unmodified.

## Verification

```bash
cd examples/order-api
uv run pytest -v
cat CHANGELOG.md
git tag
cd -
```

Expected: all tests pass, `CHANGELOG.md` shows both entries plus the
compatibility notes, and `git tag` lists both `v1.0.0` and `v1.1.0`.

## Think about it

- You didn't have to change a single existing test to add `priority`.
  What specifically about *how* you added it (as an optional field with
  a default) made that true?
- If you'd renamed `items` to `line_items` instead, every test that
  builds a request body would need to change. Is that itself a good
  signal for "this change is breaking," even before you think about
  SemVer rules?

## If you get stuck

- **Hint 1:** `data.get("priority", "normal")` is the whole
  backward-compatibility trick — a caller who never heard of
  `priority` sends a request that looks exactly like before, and gets
  the same default behavior as before.
- **Hint 2:** An annotated tag (`git tag -a <name> -m "<message>"`)
  carries a message and author info, unlike a lightweight tag (`git tag
  <name>`) — prefer annotated tags for releases.
- **Hint 3:** MAJOR bumps mean "you might need to change your calling
  code"; MINOR bumps mean "new capability, nothing else changes for
  you"; PATCH bumps mean "same behavior, a bug got fixed."

## What's next

Act V is done — your system persists data, survives schema change,
tolerates external failure, explains itself through logs, and ships
versioned releases with a real compatibility story. Next, you join
(or lead) a team building something from scratch — this is where the
whole course comes together.

Act VI (Lab 26) continues in the next milestone.
