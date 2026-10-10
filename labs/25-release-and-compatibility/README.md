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
  21-24, `CHANGELOG.md` has a `[1.0.0]` entry, and `order-api-v1.0.0`
  exists as an annotated tag on `main`, pushed to your remote.
- Current directory: `examples/order-api/python/`.

### Go

- Lab 24 complete: `go test ./...` passes with all tests from Labs
  21-24, `CHANGELOG.md` has a `[1.0.0]` entry, and `order-api-v1.0.0`
  exists as an annotated tag on `main`, pushed to your remote.
- Current directory: `examples/order-api/go/`.

### Java

- Lab 24 complete: `./gradlew test` passes with all tests from Labs
  21-24, `CHANGELOG.md` has a `[1.0.0]` entry, and `order-api-v1.0.0`
  exists as an annotated tag on `main`, pushed to your remote.
- Current directory: `examples/order-api/java/`.

A reminder before you tag anything in this lab: you're working in
your own fork of this course's repository, not a separate repository
for `order-api` alone. `examples/order-api/<language>/` is a folder,
not a Git repository of its own — there's exactly one `.git`
directory, at the root of your fork, and every tag you create points
at a commit of the *whole course repo*, of which your `order-api`
work is one part. Never run `git init` inside
`examples/order-api/<language>/`. And double-check that `origin`
points at your own fork before you push anything (`git remote -v`) —
not at the original course repository, which you don't have push
access to anyway.

### If your `v1.0.0` state doesn't match the above

Check which of these you're actually in before writing any code —
each has a specific, non-destructive fix:

- **`order-api-v1.0.0` exists, points at a commit on `main`, and your
  tests pass**: you're ready, including if you reached this state
  through an earlier version of Lab 24 or Lab 25 that asked you to
  create the tag yourself — the tag itself is what matters, not which
  lab's instructions produced it. Continue to "Your task" below.
- **The tag doesn't exist because Lab 24 isn't finished**: go back
  and finish it, including its own PR merge and the tag — this lab
  assumes that state exists, not that you can skip ahead and tag it
  as an afterthought here.
- **The tag exists but `git merge-base --is-ancestor
  order-api-v1.0.0^{commit} main` prints nothing**: it's pointing at
  a commit `main` doesn't actually contain — almost always because it
  was created on a feature branch before merging. Don't delete or
  force-move it yet. Find out what it actually points at
  (`git show order-api-v1.0.0`) and whether that work ever
  merged. If the underlying change is already on `main` under a
  different commit (a squash merge, for example), delete the stale
  tag and recreate it on the correct `main` commit. If the change
  never merged, go finish that PR first.
- **Lab 24's PR is open but not yet merged**: finish that first — this
  lab's starting point is a merged, tagged `v1.0.0`, not an
  in-progress one. Don't create `v1.1.0` work on top of an unmerged
  base; you'd be building on a branch that might still change.
- **You have local uncommitted changes left over from Lab 24**: commit
  or stash them (`git stash -u` if any are untracked) before doing
  anything else in this lab — don't discard them, and don't let them
  ride along uncommitted into a new branch where they're easy to lose
  track of.

Never use `git tag -f`, `git push --force`, or `git reset --hard` to
get out of any of these — every one of them has a slower, safe fix
above.

## Your task

1. Create branch `feature/priority-field` from `main`.
2. Make one real, additive change: add an optional `priority` field
   to `POST /orders`, defaulting to `"normal"` when the caller omits
   it. This has to be a real, persisted field, not just a value
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
  column the same way Lab 22's `migrateAddNotesColumn` already does —
  copy that same `PRAGMA table_info` scanning shape into the new
  function; a second copy of a six-line loop is a perfectly fine way
  to stay inside this lab's 90 minutes, and nothing here grades you on
  having only one copy. Call `migrateAddPriorityColumn()` in `main()`,
  right after `migrateAddNotesColumn()`.
  **Optional, outside the core path:** if you finish with real time to
  spare, extracting the shared scanning logic into
  `hasColumn(name string) (bool, error)` and having both migration
  functions call it is a reasonable refactor — Lab 22's existing tests
  for `migrateAddNotesColumn` keep passing either way, since its
  behavior doesn't change — but treat it as a stretch goal, not part
  of this lab's required path.
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
  `migrateAddNotesColumn` already does — copy that same
  `PRAGMA table_info` scanning shape into the new method; a second
  copy of a short loop is a perfectly fine way to stay inside this
  lab's 90 minutes, and nothing here grades you on having only one
  copy. Call `migrateAddPriorityColumn()` in `Main`, right after
  `migrateAddNotesColumn()`.
  **Optional, outside the core path:** if you finish with real time to
  spare, extracting the shared scanning logic into a private
  `hasColumn(String name) throws SQLException` helper and having both
  migration methods call it is a reasonable refactor — Lab 22's
  existing tests for `migrateAddNotesColumn` keep passing either
  way — but treat it as a stretch goal, not part of this lab's
  required path.
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
not just echoed in the creation response.

None of those three tests touches the one case that actually matters
most for a migration: a row that was already in the database *before*
`migrate_add_priority_column()` ever ran, whose `priority` column is
genuinely `NULL` — not defaulted, not omitted from a request, really
`NULL` at the SQL level. Every one of the three tests above only ever
creates *new* rows, through `create_order`/`createOrder`, which always
writes a real value. Add a fourth test that proves the historical
case directly:

```text
Old database row without priority
→ upgrade schema
→ GET historical order
→ priority == "normal"
```

Write it by inserting a row with a raw `INSERT` statement that doesn't
mention `priority` at all — bypassing `create_order`/`createOrder`
entirely — *before* calling `migrate_add_priority_column()` in that
test, so the column is genuinely absent (and then genuinely `NULL`
once the migration adds it) for that one row, the same way a real
pre-Lab-25 row would be. Then run the migration, then fetch that row
through your normal `get_order`/`getOrder` path, and assert its
`priority` comes back as `"normal"` — not `null`, not missing. This is
a different, stronger test than the three above: it would have caught
a real bug this course's own authors found while verifying this
lab — a GET endpoint that maps a SQL `NULL` straight into the JSON
response as `null`, which every one of the first three tests still
passes, because none of them ever reads back a row whose `priority`
column is actually `NULL`.

Then run the full existing test suite too, to confirm none of the
four new tests needed any earlier test to change for this to be true.

3. Update `CONTRACT.md` from Lab 21: document the new optional
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
4. Add a `## [1.1.0]` entry to `CHANGELOG.md` describing the new
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
5. Commit, push the branch, open a pull request, and merge once CI is
   green.
6. Switch back to `main` and pull the merge, confirm the suite still
   passes, then tag:
   `git tag -a order-api-v1.1.0 -m "order-api v1.1.0"`, and push it:
   `git push origin order-api-v1.1.0`.

## A realistic 90 minutes

This lab is now one release cycle, not two — `v1.0.0` was tagged at
the end of Lab 24, so everything here builds on an already-merged,
already-tagged starting point. The work that's left: a real schema
migration, three straightforward tests plus the subtler
historical-`NULL` one, a `CONTRACT.md` update, a `CHANGELOG.md` entry
reasoning about SemVer, and one full PR/CI/merge/tag loop. That's a
real session's worth of work, not a short one, but it no longer
competes with a second release cycle for the same 90 minutes.

The fourth test — the historical row with a genuinely `NULL`
`priority` column — is the one most likely to eat unplanned time,
precisely because it's the one this lab's own authors got wrong on a
first pass (see the note above about the bug it would have caught).
Give it the time it needs rather than rushing it to match the other
three, which are mechanically similar to tests you've already written
in Labs 21-23.

If this still doesn't fit in one sitting for your pace, that's a
realistic outcome, not a sign you're doing it wrong — stop at a point
where the suite is green and nothing is half-finished (for example,
right after the four tests pass, before touching `CONTRACT.md` or
`CHANGELOG.md`), and pick the rest up next session. There's no tag to
split at mid-lab this time — `v1.1.0` only exists once everything here
is merged — so the natural stopping point is "tests green, nothing
half-finished," the same as any other lab.

## Acceptance criteria

- `CHANGELOG.md` has a `[1.1.0]` entry (on top of the `[1.0.0]` entry
  Lab 24 already added), plus a `## Compatibility notes` section
  reasoning about major vs. minor.
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
  has its own passing tests (explicit value, default omission, the
  POST-then-GET round trip, and a historical row whose `priority`
  column is genuinely `NULL` mapping to `"normal"`, not `null`), and
  every test written before this lab still passes unmodified.
- This lab's change was merged through a pull request with a green CI
  check, not committed directly to `main`.

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
- **Hint 4:** For the historical-row test, open a raw
  `sqlite3.connect(db.DB_PATH)` connection in the test itself and
  `INSERT INTO orders (items, status, notes) VALUES (...)` directly —
  no `priority` column mentioned at all — *before* calling
  `db.migrate_add_priority_column()`. That's what makes the row
  genuinely pre-migration, not just missing a value you could have
  passed.

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
- **Hint 4:** For the historical-row test, open your own `sql.Open` +
  `Exec` directly in the test, inserting straight into `orders` with
  only `items` and `status` set — no `priority` — *before* calling
  `migrateAddPriorityColumn()`. That's what makes the row genuinely
  pre-migration, not just missing a value you could have passed to
  `createOrder`.

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
- **Hint 4:** For the historical-row test, open your own
  `DriverManager.getConnection(...)` directly in the test and insert
  straight into `orders` with only `items` and `status` set — no
  `priority` — *before* calling `OrderDb.migrateAddPriorityColumn()`.
  That's what makes the row genuinely pre-migration, not just missing
  a value you could have passed to `createOrder`.

## What's next

Act V is done, in whichever track you followed — your system persists
data, survives schema change, tolerates external failure, explains
itself through logs, and ships versioned releases with a real
compatibility story. Next, you join (or lead) a team building
something from scratch — this is where the whole course comes
together.

Continue to [Lab 26 — Project kickoff](../26-project-kickoff/README.md).
