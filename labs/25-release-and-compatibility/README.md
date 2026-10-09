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

### Python

- Lab 24 complete: `uv run pytest` passes with all tests from Labs
  21-24.
- Current directory: `examples/order-api/python/`.

### Go

- Lab 24 complete: `go test ./...` passes with all tests from Labs
  21-24.
- Current directory: `examples/order-api/go/`.

### Java

- Lab 24 complete: `./gradlew test` passes with all tests from Labs
  21-24.
- Current directory: `examples/order-api/java/`.

A reminder before you start tagging anything: you're working in your
own fork of this course's repository, not a separate repository for
`order-api` alone. `examples/order-api/<language>/` is a folder, not
a Git repository of its own — there's exactly one `.git` directory,
at the root of your fork, and every tag you create points at a commit
of the *whole course repo*, of which your `order-api` work is one
part. Never run `git init` inside `examples/order-api/<language>/`.
And double-check that `origin` points at your own fork before you
push anything (`git remote -v`) — not at the original course
repository, which you don't have push access to anyway.

## Your task

**Release 1.0.0 — baseline:**

1. Create branch `feature/changelog-baseline` from `main`.
2. Write `CHANGELOG.md` in `examples/order-api/<language>/`, following
   a simple "Keep a Changelog"-style format, with one `## [1.0.0]`
   entry listing everything the API does as of Lab 24, from a caller's
   point of view: the two endpoints, request validation, SQLite
   persistence, the `notes` migration, bounded retry around the
   kitchen notification, and operational logging. It doesn't need to
   mention implementation details specific to your language unless
   they matter operationally or for compatibility (for example: "data
   is stored in SQLite" is worth a line; "requests are handled by
   `com.sun.net.httpserver.HttpServer`" isn't).
3. Run your track's full test suite to confirm nothing is broken, then
   commit `CHANGELOG.md`, push the branch, open a pull request, and
   merge once CI is green — same loop as the rest of Act V.
4. Switch back to `main` and pull the merge:
   `git switch main` then `git pull --ff-only`. Confirm the suite
   still passes, then — only now, on this already-merged commit — tag
   the release:
   `git tag -a order-api-v1.0.0 -m "order-api v1.0.0"`, and push it:
   `git push origin order-api-v1.0.0`.

**Never tag a feature branch before it merges.** Squash and rebase
merges can both give the commit that lands on `main` a completely
different hash than the one on your branch — a tag created too early
ends up pointing at a commit `main` doesn't actually contain. Tagging
only after `git pull --ff-only` on `main` sidesteps that entirely.

This lab's "release" is a Git tag, nothing more — don't create a
GitHub Release, and don't build or publish any binary or package.

**Release 1.1.0 — compatible addition:**

5. Create a second branch, `feature/priority-field`, from the
   now-updated `main`.
6. Now make one real, additive change: add an optional `priority`
   field to `POST /orders`, defaulting to `"normal"` when the caller
   omits it. This has to be a real, persisted field, not just a value
   echoed back in the `POST` response — a `GET` later must see it too,
   and it must survive a restart.

#### Python

- In `db.py`, add `migrate_add_priority_column()` (same shape as
  Lab 22's `migrate_add_notes_column()`: check `PRAGMA
  table_info(orders)`, `ALTER TABLE orders ADD COLUMN priority TEXT`
  if it's missing) and call it in `run()`, right after
  `migrate_add_notes_column()`. Update your test fixture the same way
  you did in Lab 22.
- Update `create_order` to accept and store an optional
  `priority: str = "normal"` parameter. Update `get_order` to include
  `priority` in its result, defaulting to `"normal"` if the stored
  value is `NULL`.
- Update `do_POST` in `api.py` to read an optional `priority` field
  from the request body (defaulting to `"normal"`) and pass it into
  `db.create_order` — don't just attach it to the response dict after
  the fact; that would pass every test that only checks the `POST`
  response, while silently never touching SQLite at all.

#### Go

- In `db.go`, add `migrateAddPriorityColumn() error`, checking for the
  column the same way Lab 22's `migrateAddNotesColumn` already does.
  If you'd rather not duplicate that `PRAGMA table_info` scanning loop
  a third time, extract it once into a shared helper —
  `hasColumn(name string) (bool, error)` — and have both migration
  functions call it; Lab 22's existing tests for
  `migrateAddNotesColumn` keep passing either way, since its behavior
  doesn't change. Call `migrateAddPriorityColumn()` in `main()`, right
  after `migrateAddNotesColumn()`.
- Give `Order` a `Priority string` field (JSON tag `priority`). Update
  `createOrder` to take a `priority string` parameter, storing and
  returning it. Update `getOrder` to read the `priority` column with
  `sql.NullString`, defaulting to `"normal"` when it's `NULL` or empty
  (which it will be for every row created before this migration ran).
- Update `handleCreateOrder` to read an optional `priority` field from
  the decoded body (`body["priority"].(string)`, defaulting to
  `"normal"` if absent, not a string, or empty) and pass it into
  `createOrder` *before* the order is persisted — not attached to the
  `Order` value afterward. Update `newTestServer`'s callers (or
  wherever your tests build a server) to call
  `migrateAddPriorityColumn()` too, the same way they already call
  `migrateAddNotesColumn()`.

#### Java

- In `OrderDb.java`, add `migrateAddPriorityColumn() throws
  SQLException`, checking for the column the same way Lab 22's
  `migrateAddNotesColumn` already does. If you'd rather not duplicate
  that `PRAGMA table_info` scanning loop a third time, extract it once
  into a shared private helper — `hasColumn(String name) throws
  SQLException` — and have both migration methods call it; Lab 22's
  existing tests for `migrateAddNotesColumn` keep passing either way.
  Call `migrateAddPriorityColumn()` in `Main`, right after
  `migrateAddNotesColumn()`.
- Give `Order` a `final String priority` field and update its
  constructor to take it. Update `createOrder` to take a `String
  priority` parameter, storing and returning it. Update `getOrder` to
  read the `priority` column with `ResultSet.getString`, defaulting to
  `"normal"` when it's `null` or empty (which it will be for every row
  created before this migration ran).
- Update `handleCreateOrder` to read an optional `priority` field from
  the parsed body (`data.get("priority")`, defaulting to `"normal"` if
  absent, not a `String`, or empty) and pass it into
  `OrderDb.createOrder` *before* the order is persisted — not attached
  to the `Order` object afterward. Update `ApiServerTest`'s
  `@BeforeEach` to call `OrderDb.migrateAddPriorityColumn()` too, the
  same way it already calls `OrderDb.migrateAddNotesColumn()`.

Add three tests (any track): one asserting a `POST` that *does* send
`priority` gets that exact value back; one asserting a `POST` that
*omits* it gets `"normal"`; and one that `POST`s an order with an
explicit `priority`, then `GET`s that same order by id and asserts the
fetched order's `priority` matches — proving it's actually persisted,
not just echoed in the creation response. Then run the full existing
test suite too, to confirm none of those tests needed to change for
this to be true.

7. Update `CONTRACT.md` from Lab 21: document the new optional
   `priority` field on `POST /orders`'s request body and its presence
   in every response that returns an order, including `GET`. Also add
   a short `## Compatibility assumption` section stating that clients
   are expected to ignore response fields they don't recognize — and
   be precise about what that assumption actually covers: it's *not*
   a blanket rule that any JSON change is backward compatible. A
   client written with strict schema validation (rejecting unknown
   fields) would break on this change regardless, and nothing about
   SemVer or "additive fields are safe" protects against that — this
   assumption is a statement about what your API expects from its
   callers, not a guarantee that holds no matter how a caller is
   written.
8. Add a `## [1.1.0]` entry to `CHANGELOG.md` describing the new
   field, and a `## Compatibility notes` section at the bottom of the
   file describing (without implementing it) what a *breaking* version
   of this same idea would have looked like instead — for example,
   renaming `items` to `line_items` in the request/response — stating
   which SemVer position (major/minor/patch) each of the two changes
   (the real additive one, and the hypothetical breaking one) would
   bump, and why, referencing `CONTRACT.md`'s compatibility assumption
   as the actual reason the additive change qualifies as backward
   compatible. Write all of this before you commit, so the commit that
   eventually gets tagged has a complete changelog, not one finished
   after the fact.
9. Commit, push the branch, open a pull request, and merge once CI is
   green.
10. Switch back to `main` and pull the merge, confirm the suite still
    passes, then tag:
    `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`, and push it:
    `git push origin order-api-v1.1.0`.

## Acceptance criteria

- `CHANGELOG.md` has both a `[1.0.0]` and a `[1.1.0]` entry, plus a
  `## Compatibility notes` section reasoning about major vs. minor.
- `CONTRACT.md` documents the new `priority` field (including on `GET`
  responses) and states the compatibility assumption about ignoring
  unknown response fields — without overstating it as a universal
  guarantee.
- Both `order-api-v1.0.0` and `order-api-v1.1.0` exist as annotated Git
  tags, pushed to your remote — and each was created only *after* its
  corresponding change was merged into `main`, never on the feature
  branch beforehand: `git merge-base --is-ancestor <tag> main` succeeds
  for both.
- The `priority` field is implemented and genuinely persisted in
  SQLite (a `GET` after a `POST` returns it, not just the `POST`
  response itself, and it survives a server restart, since it's a real
  column, not an in-memory or echoed-only value), defaults correctly,
  has its own passing tests (explicit value, default omission, and the
  POST-then-GET round trip), and every test written before this lab
  still passes unmodified.
- Both of this lab's changes were merged through pull requests with a
  green CI check, not committed directly to `main`.

## Verification

### Python

```bash
cd examples/order-api/python
uv run pytest -v
cat CHANGELOG.md
git tag --list "order-api-v*"
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

### Go

```bash
cd examples/order-api/go
go test ./... -v
cat CHANGELOG.md
git tag --list "order-api-v*"
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

### Java

```bash
cd examples/order-api/java
./gradlew test
cat CHANGELOG.md
git tag --list "order-api-v*"
git ls-remote --tags origin
git merge-base --is-ancestor order-api-v1.0.0^{commit} main && echo "v1.0.0 is on main"
git merge-base --is-ancestor order-api-v1.1.0^{commit} main && echo "v1.1.0 is on main"
cd -
```

Expected: all tests pass, `CHANGELOG.md` shows both entries plus the
compatibility notes, `git tag --list "order-api-v*"` lists both
`order-api-v1.0.0` and `order-api-v1.1.0`, `git ls-remote --tags
origin` shows they made it to the remote too, and both
`merge-base --is-ancestor` checks print their confirmation line.

**If a `merge-base --is-ancestor` check prints nothing at all** (no
confirmation line, and the command just exits): that tag's commit
isn't actually on `main` yet. Don't force-fix this by re-tagging with
`git tag -f` or force-pushing — first find out *why*, with
`git show order-api-v1.0.0` (which commit does the tag actually point
at?) and `git log main` (is that commit in `main`'s history at all?).
The usual cause is tagging before the merge, or tagging a local branch
that was never actually pushed/merged. Fix the real problem — merge
first, then tag the resulting `main` commit — rather than overwriting
a tag you're unsure about.

## Think about it

- You didn't have to change a single existing test to add `priority`.
  What specifically about *how* you added it (as an optional field
  with a default) made that true?
- If you'd renamed `items` to `line_items` instead, every test that
  builds a request body would need to change. Is that itself a good
  signal for "this change is breaking," even before you think about
  SemVer rules?
- `CONTRACT.md`'s compatibility assumption says callers should ignore
  unknown fields — but that's a statement about what your API expects,
  not something you can enforce on every caller. What's one real kind
  of client that would break on this change anyway, despite it being
  "additive"?

## If you get stuck

### Python

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

### Go

- **Hint 1:** `body["priority"].(string)`'s two-value form (`priority,
  ok := body["priority"].(string)`) tells you both whether the field
  was present and a string, and, if so, gives you the value — treat
  `!ok` and an empty string the same way, both mean "fall back to
  `normal`."
- **Hint 2:** `sql.NullString`'s `.Valid` field is `false` for a `NULL`
  column value — exactly the case every row from before this
  migration will be in. Checking `!priority.Valid ||
  priority.String == ""` in one place, inside `getOrder`, keeps every
  caller of `getOrder` from needing to know SQLite represents "no
  priority yet" as `NULL`.
- **Hint 3:** `git tag --list "order-api-v*"` only lists tags matching
  that pattern — useful once you're also tagging things unrelated to
  `order-api` in the same repository.

### Java

- **Hint 1:** `data.get("priority")`'s result is `Object`, not
  `String` — a pattern-matching `instanceof` check (`if
  (priorityRaw instanceof String s && !s.isEmpty())`) both narrows the
  type and gives you a non-empty value to use, falling through to
  `"normal"` otherwise.
- **Hint 2:** `ResultSet.getString("priority")` returns Java `null`
  for a SQL `NULL` — exactly the case every row from before this
  migration will be in. Checking for `null` *and* an empty string in
  one place, inside `getOrder`, keeps every caller of `getOrder` from
  needing to know about SQLite's historical gap.
- **Hint 3:** `git tag --list "order-api-v*"` only lists tags matching
  that pattern — useful once you're also tagging things unrelated to
  `order-api` in the same repository.

## What's next

Act V is done, in whichever track you followed — your system persists
data, survives schema change, tolerates external failure, explains
itself through logs, and ships versioned releases with a real
compatibility story. Next, you join (or lead) a team building
something from scratch — this is where the whole course comes
together.

Continue to [Lab 26 — Project kickoff](../26-project-kickoff/README.md).
