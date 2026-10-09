#!/usr/bin/env python3
"""Black-box HTTP contract checks for the order-api starter — the
public, pre-Lab-21 state shared by the Python, Go, and Java tracks.

This is maintainer tooling, not student work: it talks to each
server over real HTTP, the same way a client in any language would,
and never imports any of the three servers' own code. A student
working through Lab 21 in Go or Java never needs Python installed to
finish that lab — this script is only for check-course.sh and anyone
auditing the course.

This baseline deliberately stops at what the starter already does
before Lab 21. It must never test the per-item string validation rule
Lab 21 has the student add — doing that would make the public starter
need a solution it isn't supposed to ship.

Usage:
    python3 check_contract.py [--track python] [--track go] [--track java]

With no --track, all three run. Exits non-zero if any check fails.
"""

from __future__ import annotations

import argparse
import http.client
import json
import os
import shutil
import signal
import socket
import subprocess
import sys
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[4]

TRACKS = {
    "python": {
        "dir": REPO_ROOT / "examples/order-api/python",
        "cmd": ["uv", "run", "python", "api.py"],
        "cleanup_dirs": [],
    },
    "go": {
        "dir": REPO_ROOT / "examples/order-api/go",
        "cmd": ["go", "run", "."],
        "cleanup_dirs": [],
    },
    "java": {
        "dir": REPO_ROOT / "examples/order-api/java",
        "cmd": ["./gradlew", "run", "--console=plain"],
        # Gradle's daemon deliberately detaches from the process that
        # launched it, so it can survive and be reused by the next
        # build — which also means killing the run command's process
        # group does not stop the daemon, and the daemon can still be
        # writing to .gradle/ afterward. --stop shuts it down first;
        # only then is it safe to remove build/.gradle without racing
        # the daemon's own writes. Verified: without the --stop step,
        # .gradle/ reappeared after cleanup here.
        "stop_cmd": ["./gradlew", "--stop"],
        "cleanup_dirs": ["build", ".gradle"],
    },
}

# Generous: a cold Java run downloads the Gradle distribution and
# dependencies the first time, the same as every other Gradle Wrapper
# project in this course.
READY_TIMEOUT_SECONDS = 90


class ContractError(AssertionError):
    pass


def find_free_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(("localhost", 0))
        return s.getsockname()[1]


def wait_for_server(port: int, process: subprocess.Popen) -> None:
    deadline = time.monotonic() + READY_TIMEOUT_SECONDS
    while time.monotonic() < deadline:
        if process.poll() is not None:
            raise ContractError(
                f"server process exited early (code {process.returncode}) before it ever accepted a connection"
            )
        try:
            with socket.create_connection(("localhost", port), timeout=1):
                return
        except OSError:
            time.sleep(0.3)
    raise ContractError(f"server did not start listening on port {port} within {READY_TIMEOUT_SECONDS}s")


def request(port: int, method: str, path: str, body: str | None = None) -> tuple[int, str, str]:
    conn = http.client.HTTPConnection("localhost", port, timeout=10)
    try:
        headers = {"Content-Type": "application/json"} if body is not None else {}
        conn.request(method, path, body=body, headers=headers)
        response = conn.getresponse()
        raw = response.read().decode("utf-8")
        # HTTP header names are case-insensitive (RFC 9110 §5.1) — the
        # three servers don't all spell it the same way ("Content-Type"
        # vs "Content-type"), so this must look it up case-insensitively
        # rather than via a plain dict, which would silently miss one
        # track's spelling.
        content_type = response.headers.get("Content-Type", "")
        return response.status, content_type, raw
    finally:
        conn.close()


def expect_status(label: str, got: int, want: int) -> None:
    if got != want:
        raise ContractError(f"{label}: expected HTTP {want}, got {got}")


def expect_json_content_type(label: str, content_type: str) -> None:
    if "application/json" not in content_type:
        raise ContractError(f"{label}: expected a JSON Content-Type, got {content_type!r}")


def parse_json(label: str, raw: str) -> dict:
    try:
        return json.loads(raw)
    except json.JSONDecodeError as e:
        raise ContractError(f"{label}: response body was not valid JSON: {raw!r} ({e})")


def run_checks(port: int) -> None:
    # 1-2-9: POST /orders creates an order with the right shape.
    status, content_type, raw = request(port, "POST", "/orders", body=json.dumps({"items": ["Burger", "Fries"]}))
    expect_status("POST /orders (valid)", status, 201)
    expect_json_content_type("POST /orders (valid)", content_type)
    created = parse_json("POST /orders (valid)", raw)
    if not isinstance(created.get("order_id"), str):
        raise ContractError(f"POST /orders (valid): expected order_id to be a string, got {created.get('order_id')!r}")
    if created.get("items") != ["Burger", "Fries"]:
        raise ContractError(f"POST /orders (valid): expected items ['Burger', 'Fries'], got {created.get('items')!r}")
    if created.get("status") != "received":
        raise ContractError(f"POST /orders (valid): expected status 'received', got {created.get('status')!r}")
    order_id = created["order_id"]

    # 3: GET returns the order just created — never assume an ID.
    status, content_type, raw = request(port, "GET", f"/orders/{order_id}")
    expect_status("GET /orders/{id} (existing)", status, 200)
    expect_json_content_type("GET /orders/{id} (existing)", content_type)
    fetched = parse_json("GET /orders/{id} (existing)", raw)
    if fetched.get("order_id") != order_id or fetched.get("status") != "received":
        raise ContractError(f"GET /orders/{{id}} (existing): unexpected body {fetched!r}")

    # 4: GET missing ID returns 404 with the documented error body.
    status, content_type, raw = request(port, "GET", "/orders/this-id-does-not-exist")
    expect_status("GET /orders/{id} (missing)", status, 404)
    expect_json_content_type("GET /orders/{id} (missing)", content_type)
    body = parse_json("GET /orders/{id} (missing)", raw)
    if body.get("error") != "order not found":
        raise ContractError(f"GET /orders/{{id}} (missing): unexpected error body {body!r}")

    # 5: POST without items -> 400.
    status, content_type, raw = request(port, "POST", "/orders", body=json.dumps({}))
    expect_status("POST /orders (no items)", status, 400)
    expect_json_content_type("POST /orders (no items)", content_type)
    body = parse_json("POST /orders (no items)", raw)
    if body.get("error") != "items must be a non-empty list":
        raise ContractError(f"POST /orders (no items): unexpected error body {body!r}")

    # 6: POST with an empty list -> 400, same error body.
    status, content_type, raw = request(port, "POST", "/orders", body=json.dumps({"items": []}))
    expect_status("POST /orders (empty items)", status, 400)
    body = parse_json("POST /orders (empty items)", raw)
    if body.get("error") != "items must be a non-empty list":
        raise ContractError(f"POST /orders (empty items): unexpected error body {body!r}")

    # 7: malformed JSON -> 400.
    status, content_type, raw = request(port, "POST", "/orders", body="not json")
    expect_status("POST /orders (invalid JSON)", status, 400)
    expect_json_content_type("POST /orders (invalid JSON)", content_type)
    body = parse_json("POST /orders (invalid JSON)", raw)
    if body.get("error") != "invalid JSON":
        raise ContractError(f"POST /orders (invalid JSON): unexpected error body {body!r}")

    # 8: unknown path -> 404 with the generic error body.
    status, content_type, raw = request(port, "GET", "/completely/unknown/path")
    expect_status("GET /completely/unknown/path", status, 404)
    expect_json_content_type("GET /completely/unknown/path", content_type)
    body = parse_json("GET /completely/unknown/path", raw)
    if body.get("error") != "not found":
        raise ContractError(f"GET /completely/unknown/path: unexpected error body {body!r}")


def run_track(name: str) -> list[str]:
    spec = TRACKS[name]
    port = find_free_port()
    env = {**os.environ, "PORT": str(port)}
    errors: list[str] = []

    # start_new_session=True puts the launched command in its own
    # process group. This matters for Go specifically: `go run .`
    # compiles to a temporary binary and execs it as a *child*
    # process — terminating just the `go run` PID leaves that
    # compiled server running, orphaned, still holding the port.
    # Signaling the whole group (via os.killpg below) is what a real
    # terminal's Ctrl+C does automatically; a plain process.terminate()
    # does not. Verified: without this, a stray `order-api` process
    # survives every run of this script against the Go track.
    process = subprocess.Popen(
        spec["cmd"],
        cwd=spec["dir"],
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        start_new_session=True,
    )
    try:
        wait_for_server(port, process)
        run_checks(port)
    except ContractError as e:
        errors.append(str(e))
    finally:
        pgid = os.getpgid(process.pid)
        try:
            os.killpg(pgid, signal.SIGTERM)
            process.wait(timeout=15)
        except (subprocess.TimeoutExpired, ProcessLookupError):
            try:
                os.killpg(pgid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            process.wait(timeout=15)
        stop_cmd = spec.get("stop_cmd")
        if stop_cmd:
            subprocess.run(stop_cmd, cwd=spec["dir"], capture_output=True)
        for rel_dir in spec["cleanup_dirs"]:
            shutil.rmtree(spec["dir"] / rel_dir, ignore_errors=True)

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--track",
        action="append",
        choices=sorted(TRACKS),
        help="Run only this track (repeatable). Default: all three.",
    )
    args = parser.parse_args()
    tracks = args.track or sorted(TRACKS)

    overall_failed = False
    for track in tracks:
        print(f"== order-api starter contract: {track} ==")
        errors = run_track(track)
        if errors:
            overall_failed = True
            for error in errors:
                print(f"FAIL  [{track}] {error}")
        else:
            print(f"OK    [{track}] all baseline contract checks passed")
        print()

    if overall_failed:
        print("Contract check FAILED. See the FAIL lines above.")
        return 1
    print("Contract check passed for: " + ", ".join(tracks))
    return 0


if __name__ == "__main__":
    sys.exit(main())
