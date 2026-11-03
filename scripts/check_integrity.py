"""Check the recorded bytes, not the mathematical claims."""

import hashlib
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
EXPECTED_CERTIFICATES = {
    "single-marker-7.json",
    "ladder-machine.json",
    "signed-machine.json",
}


def check(root=REPO):
    root = Path(root)
    manifest = json.loads((root / "certificates/manifest.json").read_text())
    if manifest.get("schema_version") != 1:
        raise ValueError("Unsupported manifest version")
    entries = manifest["files"]
    required = {"certificates/" + name for name in EXPECTED_CERTIFICATES}
    if not required.issubset(entries):
        raise ValueError("Manifest is missing a required certificate")
    for name, record in entries.items():
        path = (root / name).resolve()
        if root.resolve() not in path.parents:
            raise ValueError("Manifest path escapes the repository")
        payload = path.read_bytes()
        if (
            len(payload) != record["bytes"]
            or hashlib.sha256(payload).hexdigest() != record["sha256"]
        ):
            raise ValueError("Integrity mismatch: " + name)
    return len(entries)


if __name__ == "__main__":
    print(f"Integrity checks passed for {check()} recorded files (not a proof check).")
