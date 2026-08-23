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
   `git tag -a order-api-v1.0.0 -m "order-api v1.0.0"`.
3. Now make one real, additive change: add an optional `priority` field
   to `POST /orders`, defaulting to `"normal"` when the caller omits
   it. Add two new tests: one asserting a request that *does* send
   `priority` gets that exact value back, one asserting a request that
   *omits* it gets `"normal"`. Run the full existing test suite too, to
   confirm none of those tests needed to change for this to be true.
4. Update `CONTRACT.md` from Lab 21: document the new optional
   `priority` field on `POST /orders`'s request body and its presence
   in the response.
5. Add a `## [1.1.0]` entry to `CHANGELOG.md` describing the new field,
   commit, and tag: `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`.
6. Push both tags — a release that only exists on your machine isn't a
   release: `git push origin order-api-v1.0.0 order-api-v1.1.0` (or
   `git push --tags` to push every tag at once).
7. In a new section at the bottom of `CHANGELOG.md`, `## Compatibility
   notes`, describe (without implementing it) what a *breaking* version
   of this same idea would have looked like instead — for example,
   renaming `items` to `line_items` in the request/response — and state
   which SemVer position (major/minor/patch) each of the two changes
   (the real additive one, and the hypothetical breaking one) would
   bump, and why.

## Acceptance criteria

- `CHANGELOG.md` has both a `[1.0.0]` and a `[1.1.0]` entry, plus a
  `## Compatibility notes` section reasoning about major vs. minor.
- `CONTRACT.md` documents the new `priority` field.
- Both `order-api-v1.0.0` and `order-api-v1.1.0` exist as annotated Git
  tags, pushed to your remote.
- The `priority` field is implemented, defaults correctly, has its own
  passing tests (explicit value and default omission), and every test
  written before this lab still passes unmodified.

## Verification

```bash
cd examples/order-api
uv run pytest -v
cat CHANGELOG.md
git tag
git ls-remote --tags origin
cd -
```

Expected: all tests pass, `CHANGELOG.md` shows both entries plus the
compatibility notes, `git tag` lists both `order-api-v1.0.0` and
`order-api-v1.1.0`, and `git ls-remote --tags origin` shows they made it
to the remote too.

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

Continue to [Lab 26 — Project kickoff](../26-project-kickoff/README.md).
