"""Check the exact public distribution inventory, separately from mathematics."""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]


def check(root):
    root = Path(root).resolve()
    manifest = json.loads((root / "release-manifest.json").read_text())
    if manifest.get("schema_version") != 1:
        raise ValueError("Unsupported release inventory")
    entries = manifest["files"]
    required = {"VERSION", "LICENSE", "LICENSES/MIT.txt", "LICENSES/CC-BY-4.0.txt",
                "CITATION.cff", "EXPORT_PROVENANCE.json", "certificates/manifest.json",
                "paper/base-seven-heraclitus.pdf", "formal/Heraclitus/OriginalProblem.lean"}
    if not required.issubset(entries):
        raise ValueError("Release inventory is missing required components")
    for name, expected in entries.items():
        path = PurePosixPath(name)
        if path.is_absolute() or ".." in path.parts or str(path) != name:
            raise ValueError("Unsafe inventory path: " + name)
        target = root / name
        if target.is_symlink() or root not in target.resolve().parents:
            raise ValueError("Nonlocal/symlink inventory entry: " + name)
        payload = target.read_bytes()
        if {"bytes": len(payload), "sha256": hashlib.sha256(payload).hexdigest()} != expected:
            raise ValueError("Changed distribution file: " + name)
    observed = set()
    for target in root.rglob("*"):
        relative = target.relative_to(root)
        if relative.parts[0] in {".git", "build"} or "__pycache__" in relative.parts or relative.parts[:2] == ("formal", ".lake"):
            continue
        if target.is_symlink():
            raise ValueError("Unexpected symlink: " + str(relative))
        if target.is_file() and target.name != ".DS_Store":
            observed.add(relative.as_posix())
    if observed != set(entries) | {"release-manifest.json"}:
        raise ValueError("Missing/unexpected files: " + repr(sorted(observed ^ (set(entries) | {"release-manifest.json"}))))
    receipt_path = root / "evidence/public-package/formal/run.json"
    if receipt_path.is_file():
        receipt = json.loads(receipt_path.read_text())
        for name, expected in receipt["source_sha256"].items():
            if entries[name]["sha256"] != expected:
                raise ValueError("Distribution differs from the clean Lean receipt: " + name)
    return len(entries)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    args = parser.parse_args()
    print(f"Distribution integrity passed: {check(args.root)} files (not a proof check).")
