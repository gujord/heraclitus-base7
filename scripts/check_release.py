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
        if (any(p in {"archive", ".git", "AGENTS.md", "COORDINATION.md", ".lake"} or
                "presentation" in p.lower() for p in path.parts) or
                path.suffix.lower() in {".olean", ".ilean", ".eml", ".mbox", ".msg"}):
            raise ValueError("Private/compiled file in distribution: " + name)
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
    from check_publication import check_promotion
    from check_doi_update import check_doi_update
    built_entries, previous_tex, version_doi = check_doi_update(root, entries)
    editorial_changes = check_promotion(root, built_entries, previous_tex)
    receipt_path = root / "evidence/public-package/formal/run.json"
    if receipt_path.is_file():
        receipt = json.loads(receipt_path.read_text())
        for name, expected in receipt["source_sha256"].items():
            if name == 'formal/README.md' and editorial_changes:
                # This old receipt binds the 1.0.0 guide. The 1.1.0 guide is
                # separately bound by the complete 351-module receipt below.
                history = json.loads((root/'evidence/publication-1.1.0/historical-manifest.json').read_text())
                if history['files'][name]['sha256'] != expected:
                    raise ValueError('Historical coverage guide binding changed')
                continue
            if built_entries[name]["sha256"] != expected:
                raise ValueError("Distribution differs from the clean Lean receipt: " + name)
    if manifest.get("version") == "1.1.0":
        required = {"proof-inventory.json", "scripts/rebuild_release.py",
                    "research/upper_scale_assembly/Theorem.lean",
                    "research/upper_machine_audit/TargetContract.lean"}
        if not required.issubset(entries) or (root/"VERSION").read_text().strip() != "1.1.0":
            raise ValueError("Missing 1.1.0 proof or wrong version")
        provenance = json.loads((root/"EXPORT_PROVENANCE.json").read_text())
        if provenance.get("version_doi") != version_doi:
            raise ValueError("Version DOI differs from verified metadata update")
        receipt_path = root/"evidence/release-1.1.0/report.json"
        if provenance.get("verification_evidence_included") and not receipt_path.is_file():
            raise ValueError("Promised proof evidence is missing")
        if receipt_path.is_file():
            receipt = json.loads(receipt_path.read_text())
            if not (receipt.get("status") == "PASS" and receipt.get("fresh_project_modules") == 351 and
                    receipt.get("reused_prior_project_objects") == 0 and receipt.get("final_target_proved") is True):
                raise ValueError("Incomplete fresh 1.1.0 receipt")
            for name, expected in receipt["input_sha256"].items():
                if name != "EXPORT_PROVENANCE.json" and built_entries[name]["sha256"] != expected:
                    if editorial_changes.get(name, {}).get('before_sha256') != expected:
                        raise ValueError("Distribution differs from the complete build: " + name)
    return len(entries)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    args = parser.parse_args()
    print(f"Distribution integrity passed: {check(args.root)} files (not a proof check).")
