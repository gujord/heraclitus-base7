"""One offline command for integrity, certificate checks, and rejection tests."""

import argparse
import json
import platform
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from check_integrity import check

REPO = Path(__file__).resolve().parents[1]


def main():
    if not __debug__:
        raise SystemExit("Do not run verification with -O, -OO, or PYTHONOPTIMIZE.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=REPO / "build/verification")
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    for name in [
        "run.json",
        "certificate-verification.json",
        "direct-base-verification.json",
        "crossing-corollary-verification.json",
        "reduction-obligations.json",
    ]:
        (output / name).unlink(missing_ok=True)
    started = time.perf_counter()
    started_at = datetime.now(timezone.utc).isoformat()
    checked_files = check()
    commands = [
        [
            sys.executable,
            str(REPO / "checker/check_certificate.py"),
            "--output",
            str(output),
        ],
        [
            sys.executable,
            str(REPO / "checker/check_crossing_corollary.py"),
            "--output",
            str(output),
        ],
        [
            sys.executable,
            str(REPO / "checker/check_reduction_obligations.py"),
            "--output",
            str(output / "reduction-obligations.json"),
        ],
        [sys.executable, "-m", "unittest", "discover", "-s", str(REPO / "tests"), "-v"],
    ]
    steps = []
    for i, command in enumerate(commands, 1):
        before = time.perf_counter()
        result = subprocess.run(command, cwd=REPO, capture_output=True, text=True)
        (output / f"step-{i}.log").write_text(result.stdout + result.stderr)
        seconds = time.perf_counter() - before
        steps.append(
            {"step": i, "exit_code": result.returncode, "seconds": round(seconds, 3)}
        )
        if result.returncode:
            print(result.stdout + result.stderr, file=sys.stderr)
            raise SystemExit(
                f"FAILED at step {i}; no successful run.json was written. See {output}"
            )
        print(f"Step {i}/{len(commands)} passed ({seconds:.2f} s).", flush=True)
    report = {
        "status": "certificate checks passed",
        "version": (REPO / "VERSION").read_text().strip(),
        "started_utc": started_at,
        "python": platform.python_version(),
        "implementation": platform.python_implementation(),
        "platform": platform.system() + " " + platform.release(),
        "integrity_files": checked_files,
        "steps": steps,
        "seconds": round(time.perf_counter() - started, 3),
        "scope": "Finite certificate checks, direct base case, conditional corollary, supplementary reduction premises, and rejection tests. Not a formal proof or human review.",
    }
    (output / "run.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Certificate checks passed. Reports: {output}")
    print(
        "The infinite reduction remains a mathematical proof draft; see docs/verification.md."
    )


if __name__ == "__main__":
    main()
