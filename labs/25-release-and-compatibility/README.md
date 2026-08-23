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
   it. This has to be a real, persisted field, not just a value echoed
   back in the POST response:
   - In `db.py`, add `migrate_add_priority_column()` (same shape as
     Lab 22's `migrate_add_notes_column()`: check `PRAGMA
     table_info(orders)`, `ALTER TABLE orders ADD COLUMN priority TEXT`
     if it's missing) and call it in `run()`, right after
     `migrate_add_notes_column()`. Update your test fixture the same
     way you did in Lab 22.
   - Update `create_order` to accept and store an optional
     `priority: str = "normal"` parameter. Update `get_order` to
     include `priority` in its result, defaulting to `"normal"` if the
     stored value is `NULL`.
   - Update `do_POST` in `api.py` to read an optional `priority` field
     from the request body (defaulting to `"normal"`) and pass it into
     `db.create_order` — don't just attach it to the response dict
     after the fact.
   - Add three tests: one asserting a `POST` that *does* send
     `priority` gets that exact value back; one asserting a `POST` that
     *omits* it gets `"normal"`; and one that `POST`s an order with an
     explicit `priority`, then `GET`s that same order by id and asserts
     the fetched order's `priority` matches — proving it's actually
     persisted, not just echoed in the creation response.
   - Run the full existing test suite too, to confirm none of those
     tests needed to change for this to be true.
4. Update `CONTRACT.md` from Lab 21: document the new optional
   `priority` field on `POST /orders`'s request body and its presence
   in every response that returns an order, including `GET`.
5. Add a `## [1.1.0]` entry to `CHANGELOG.md` describing the new field,
   and a `## Compatibility notes` section at the bottom of the file
   describing (without implementing it) what a *breaking* version of
   this same idea would have looked like instead — for example,
   renaming `items` to `line_items` in the request/response — stating
   which SemVer position (major/minor/patch) each of the two changes
   (the real additive one, and the hypothetical breaking one) would
   bump, and why. Write both of these before you commit and tag, so the
   tagged commit's changelog is complete, not finished after the fact.
6. Commit, then tag: `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`.
7. Push both tags — a release that only exists on your machine isn't a
   release: `git push origin order-api-v1.0.0 order-api-v1.1.0` (or
   `git push --tags` to push every tag at once).

## Acceptance criteria

- `CHANGELOG.md` has both a `[1.0.0]` and a `[1.1.0]` entry, plus a
  `## Compatibility notes` section reasoning about major vs. minor —
  and both were part of the same commit that got tagged
  `order-api-v1.1.0`.
- `CONTRACT.md` documents the new `priority` field, including on `GET`
  responses.
- Both `order-api-v1.0.0` and `order-api-v1.1.0` exist as annotated Git
  tags, pushed to your remote.
- The `priority` field is implemented and genuinely persisted in
  SQLite (a `GET` after a `POST` returns it, not just the `POST`
  response itself), defaults correctly, has its own passing tests
  (explicit value, default omission, and the POST-then-GET round trip),
  and every test written before this lab still passes unmodified.

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

- **Hint 1:** `data.get("priority", "normal")` is the read side of
  backward compatibility — a caller who never heard of `priority`
  sends a request that looks exactly like before. The write side is
  passing that value into `db.create_order` so it becomes a real
  column: a caller who fetches the order later with `GET` needs to see
  `priority` too, not just the caller who made the original `POST`.
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
