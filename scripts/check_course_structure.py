#!/usr/bin/env python3
"""Course-repository invariant checks that are naturally text/markdown
processing: lab structure, README pairs, broken relative links, the
decisions/ and CLAUDE.md exclusion, AI-attribution strings, and EN/PL
executable-code-block parity.

Run directly (`python3 scripts/check_course_structure.py`) or via
scripts/check-course.sh, which also runs the toolchain-based checks
(syntax, lockfiles, test suites) this script doesn't cover.

Exit code 0 means every check passed; 1 means at least one failed. Each
failure is printed with enough context (file, line, what's wrong) to
fix it without re-reading this script.
"""

import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LAB_COUNT = 30
# Fenced-block languages that must be byte-identical between a lab's
# README.md and README.pl.md: real executable/config snippets, not prose
# templates a student fills in (e.g. Lab 26's ADR template, which is
# deliberately written in whichever language the README is).
PARITY_LANGUAGES = {"bash", "sh", "shell", "python", "yaml", "yml"}
# This script's own path, and check-course.sh, legitimately mention the
# AI-attribution strings below as search patterns — exclude them from
# the scan of everything else.
SELF_EXCLUDED_PATHS = {"scripts/check_course_structure.py", "scripts/check-course.sh"}
AI_ATTRIBUTION_PATTERNS = [
    re.compile(r"co-authored-by:\s*claude", re.IGNORECASE),
    re.compile(r"generated with claude code", re.IGNORECASE),
    re.compile(r"\bclaude\b", re.IGNORECASE),
    re.compile(r"\banthropic\b", re.IGNORECASE),
]


def tracked_files() -> list[str]:
    result = subprocess.run(
        ["git", "ls-files"], cwd=REPO_ROOT, capture_output=True, text=True, check=True
    )
    return [line for line in result.stdout.splitlines() if line]


def lab_dirs() -> list[Path]:
    return sorted(p for p in (REPO_ROOT / "labs").iterdir() if p.is_dir())


def check_lab_structure() -> list[str]:
    errors = []
    dirs = lab_dirs()
    if len(dirs) != LAB_COUNT:
        errors.append(
            f"labs/ has {len(dirs)} directories, expected exactly {LAB_COUNT}"
        )

    seen_numbers = {}
    for d in dirs:
        m = re.match(r"^(\d{2})-[a-z0-9-]+$", d.name)
        if not m:
            errors.append(
                f"labs/{d.name}: doesn't match the expected 'NN-slug' naming "
                "pattern (two-digit number, dash, lowercase slug)"
            )
            continue
        number = int(m.group(1))
        seen_numbers.setdefault(number, []).append(d.name)

    for n in range(1, LAB_COUNT + 1):
        if n not in seen_numbers:
            errors.append(f"labs/: no directory found for lab {n:02d}")
    for n, names in seen_numbers.items():
        if len(names) > 1:
            errors.append(f"labs/: lab number {n:02d} used by more than one directory: {names}")
        if not (1 <= n <= LAB_COUNT):
            errors.append(f"labs/{names[0]}: lab number {n:02d} is outside 1-{LAB_COUNT}")

    return errors


def check_readme_pairs() -> list[str]:
    errors = []
    targets = [REPO_ROOT] + lab_dirs()
    for d in targets:
        rel = d.relative_to(REPO_ROOT) if d != REPO_ROOT else Path(".")
        en = d / "README.md"
        pl = d / "README.pl.md"
        if not en.is_file():
            errors.append(f"{rel}: missing README.md")
        if not pl.is_file():
            errors.append(f"{rel}: missing README.pl.md")
    return errors


LINK_RE = re.compile(r"\[[^\]]*\]\(([^)]+)\)")


def check_broken_links() -> list[str]:
    errors = []
    for rel_path in tracked_files():
        if not rel_path.endswith(".md"):
            continue
        if rel_path.startswith("decisions/"):
            continue
        path = REPO_ROOT / rel_path
        text = path.read_text(encoding="utf-8", errors="ignore")
        for lineno, line in enumerate(text.splitlines(), start=1):
            for match in LINK_RE.finditer(line):
                target = match.group(1).strip()
                if not target or target.startswith(("http://", "https://", "mailto:")):
                    continue
                if target.startswith("#"):
                    continue  # in-page anchor, not a file link
                target = target.split("#", 1)[0]
                if not target:
                    continue
                resolved = (path.parent / target).resolve()
                if not resolved.exists():
                    errors.append(
                        f"{rel_path}:{lineno}: broken relative link -> {target}"
                    )
    return errors


def check_no_tracked_decisions_or_claude() -> list[str]:
    errors = []
    for rel_path in tracked_files():
        if rel_path == "decisions" or rel_path.startswith("decisions/"):
            errors.append(f"{rel_path}: decisions/ must never be tracked in git")
        if rel_path == "CLAUDE.md":
            errors.append("CLAUDE.md: no root-level CLAUDE.md is allowed in this repo")
    return errors


def _looks_binary(data: bytes) -> bool:
    return b"\x00" in data


def check_ai_attribution() -> list[str]:
    errors = []
    for rel_path in tracked_files():
        if rel_path in SELF_EXCLUDED_PATHS:
            continue
        path = REPO_ROOT / rel_path
        try:
            data = path.read_bytes()
        except OSError:
            continue
        if _looks_binary(data):
            continue
        text = data.decode("utf-8", errors="ignore")
        for lineno, line in enumerate(text.splitlines(), start=1):
            for pattern in AI_ATTRIBUTION_PATTERNS:
                if pattern.search(line):
                    errors.append(
                        f"{rel_path}:{lineno}: possible AI-attribution string "
                        f"matching /{pattern.pattern}/"
                    )
    return errors


FENCE_RE = re.compile(r"^(\s*)```([a-zA-Z0-9_+-]*)\s*$")


def _extract_fenced_blocks(text: str, languages: set[str]) -> list[str]:
    """Return the raw content of every fenced block whose language tag is
    in `languages`, in document order, content only (no fence lines)."""
    lines = text.splitlines()
    blocks = []
    i = 0
    while i < len(lines):
        m = FENCE_RE.match(lines[i])
        if m and m.group(2).lower() in languages:
            indent = m.group(1)
            close_re = re.compile(rf"^{re.escape(indent)}```\s*$")
            j = i + 1
            body = []
            while j < len(lines) and not close_re.match(lines[j]):
                body.append(lines[j])
                j += 1
            blocks.append("\n".join(body))
            i = j + 1
        else:
            i += 1
    return blocks


def check_code_block_parity() -> list[str]:
    errors = []
    targets = [REPO_ROOT] + lab_dirs()
    for d in targets:
        rel = d.relative_to(REPO_ROOT) if d != REPO_ROOT else Path(".")
        en = d / "README.md"
        pl = d / "README.pl.md"
        if not (en.is_file() and pl.is_file()):
            continue  # already reported by check_readme_pairs
        en_blocks = _extract_fenced_blocks(
            en.read_text(encoding="utf-8"), PARITY_LANGUAGES
        )
        pl_blocks = _extract_fenced_blocks(
            pl.read_text(encoding="utf-8"), PARITY_LANGUAGES
        )
        if len(en_blocks) != len(pl_blocks):
            errors.append(
                f"{rel}: README.md has {len(en_blocks)} executable code "
                f"block(s), README.pl.md has {len(pl_blocks)} — they must "
                "match one-for-one"
            )
            continue
        for idx, (e, p) in enumerate(zip(en_blocks, pl_blocks), start=1):
            if e != p:
                errors.append(
                    f"{rel}: executable code block #{idx} differs between "
                    "README.md and README.pl.md — commands, comments, and "
                    "placeholders in code blocks must be byte-identical "
                    "across languages"
                )
    return errors


CHECKS = [
    ("Lab structure (30 labs, NN-slug naming)", check_lab_structure),
    ("README.md / README.pl.md pairs", check_readme_pairs),
    ("Broken relative links in Markdown", check_broken_links),
    ("No tracked decisions/ or root CLAUDE.md", check_no_tracked_decisions_or_claude),
    ("No AI-attribution strings", check_ai_attribution),
    ("EN/PL executable code-block parity", check_code_block_parity),
]


def main() -> int:
    any_failed = False
    for label, fn in CHECKS:
        errors = fn()
        if errors:
            any_failed = True
            print(f"FAIL  {label} ({len(errors)} issue(s))")
            for e in errors:
                print(f"      - {e}")
        else:
            print(f"OK    {label}")
    return 1 if any_failed else 0


if __name__ == "__main__":
    sys.exit(main())
