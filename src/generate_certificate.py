"""Regenerate the finite certificates, compare them, then run the separate checker."""

import argparse
import contextlib
import hashlib
import json
import subprocess
import sys
import time
from pathlib import Path
import single_marker
import marker_machine
import signed_machine

REPO = Path(__file__).resolve().parents[1]
NAMES = ("single-marker-7.json", "ladder-machine.json", "signed-machine.json")


def main():
    if not __debug__:
        raise SystemExit(
            "The generator also requires assertions; do not use -O or PYTHONOPTIMIZE."
        )
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path, default=REPO / "build/generated-certificates"
    )
    args = parser.parse_args()
    output = args.output.resolve()
    if output == (REPO / "certificates").resolve():
        raise SystemExit(
            "Use a separate output directory; committed certificates are not overwritten."
        )
    output.mkdir(parents=True, exist_ok=True)
    (output / "generation-report.json").unlink(missing_ok=True)
    start = time.perf_counter()
    with (output / "generation.log").open("w") as log, contextlib.redirect_stdout(log):
        single_marker.build(output)
        marker_machine.build(REPO / "src/inputs", output)
        signed_machine.build(REPO / "src/inputs", output)
    comparison = {}
    for name in NAMES:
        generated = (output / name).read_bytes()
        original = (REPO / "certificates" / name).read_bytes()
        if json.loads(generated) != json.loads(original):
            raise SystemExit(
                "Regeneration differs from the committed certificate: " + name
            )
        comparison[name] = {
            "json_equal": True,
            "bytes_equal": generated == original,
            "sha256": hashlib.sha256(generated).hexdigest(),
        }
    # No generator mathematical functions are imported by either checker.
    for name in ["check_certificate.py", "check_crossing_corollary.py"]:
        command = [
            sys.executable,
            str(REPO / "checker" / name),
            "--certificates",
            str(output),
            "--output",
            str(output / "verification"),
        ]
        result = subprocess.run(command, capture_output=True, text=True, cwd=REPO)
        (output / (name + ".log")).write_text(result.stdout + result.stderr)
        if result.returncode:
            print(result.stdout + result.stderr, file=sys.stderr)
            raise SystemExit("Generated certificate failed the separate checker")
    report = {
        "status": "PASS",
        "seconds": round(time.perf_counter() - start, 3),
        "comparison": comparison,
        "scope": "Reproduces proposed certificates from the bundled discovery inputs; not an independent rediscovery or formal proof.",
    }
    (output / "generation-report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(
        f"Regenerated all three certificates; JSON matched and separate checks passed. Reports: {output}"
    )


if __name__ == "__main__":
    main()
