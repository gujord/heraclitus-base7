"""Optional Lean build and axiom audit; the Python certificate check stays separate."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
import os
import platform
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
FORMAL = REPO / "formal"
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
REQUIRED_THEOREMS = {
    "Heraclitus.normalized_cycle_repeats",
    "Heraclitus.residue_marker_transfer",
    "Heraclitus.clean_cycle_repeats",
    "Heraclitus.Certificate74.cycle_repeats",
    "Heraclitus.Certificate74.complete_transfer",
    "Heraclitus.TransferCatalogue.catalogue_uniform",
    "Heraclitus.signed_history_accounting",
    "Heraclitus.boundary_rule_sound",
    "Heraclitus.two_scale_rule_sound",
    "Heraclitus.SignedCertificate.CheckedBoundary.atScale",
    "Heraclitus.SignedBoundaryData.labels_complete",
    "Heraclitus.FirstCrossing.Row.all_exponents",
    "Heraclitus.Outgoing.before_first_choice",
    "Heraclitus.Outgoing.at_first_crossing",
    "Heraclitus.OutgoingWord.CertifiedRow.all_exponents",
    "Heraclitus.ReturnBridge.return_word",
    "Heraclitus.ReturnBridgeData.labels_complete",
    "Heraclitus.LadderLayersData.all_heights",
    "Heraclitus.LadderLayersData.all_periods",
    "Heraclitus.LadderDescentData.all_heights",
    "Heraclitus.LadderBottomData.all_bottoms",
    "Heraclitus.LadderBottomData.all_bottoms_with_later",
    "Heraclitus.LadderBottomData.all_heights",
    "Heraclitus.LadderEnvelopeData.all_bounds",
    "Heraclitus.LadderEnvelopeData.all_signed_heights",
    "Heraclitus.LadderEnvelopeData.catalogue_agrees",
    "Heraclitus.SignedBottom.CheckedCase.all_exponents",
    "Heraclitus.SignedBottomData.entrances_agree",
    "Heraclitus.SignedBottomData.phase43_all_exponents",
    "Heraclitus.SignedLadderData.all_exponents",
    "Heraclitus.SignedLadderData.entrances_agree",
    "Heraclitus.SignedLadderData.branches_complete",
    "Heraclitus.SignedTransferData.catalogue_agrees",
    "Heraclitus.SignedTransferData.all_bounds",
    "Heraclitus.SignedTransferData.all_signed",
    "Heraclitus.SignedTransfer.Checked.after_ladder",
    "Heraclitus.PostLadderData.all_inputs",
    "Heraclitus.PostLadderData.all_exponents",
    "Heraclitus.ShortReturnData.all_exponents",
    "Heraclitus.ApproachWordData.all_exponents",
    "Heraclitus.ApproachWordData.all_bounds",
    "Heraclitus.ApproachWordData.all_floor_laws",
    "Heraclitus.GlobalWalk.sequence_isWalk",
    "Heraclitus.GlobalWalk.walk_unique",
    "Heraclitus.GlobalWalk.valid_word_endpoint",
    "Heraclitus.ScaleInduction.Plan.reaches",
    "Heraclitus.ScaleInduction.Plan.canonical_coverage",
    "Heraclitus.SignedApproach.all_exponents",
    "Heraclitus.SignedApproachData.all_exponents",
    "Heraclitus.SignedApproachData.labels_complete",
    "Heraclitus.BoundaryCounting.scale_block_length",
    "Heraclitus.OuterBoundary.Transition.exact",
    "Heraclitus.OuterBoundaryData.labels_complete",
    "Heraclitus.OuterBoundaryData.exponents_complete",
    "Heraclitus.OuterBoundaryData.all_inputs",
    "Heraclitus.OuterBoundaryData.all_closures",
    "Heraclitus.OuterBoundaryData.all_transitions",
    "Heraclitus.OuterBoundaryData.all_filled",
}
REQUIRED_THEOREMS.update({f"Heraclitus.SignedApproachData.phase{k}" for k in range(40, 76)})

REQUIRED_THEOREMS.update({f"Heraclitus.OuterBoundaryData.phase{k}" for k in range(40, 76)})

REQUIRED_THEOREMS.update({f"Heraclitus.FiniteBaseData.Case{i:03}.checked" for i in range(115)})
REQUIRED_THEOREMS.update({
    "Heraclitus.FiniteBaseData.base_valid",
    "Heraclitus.FiniteBaseData.base_endpoint",
    "Heraclitus.FiniteBaseData.base_length",
    "Heraclitus.ScaleSchedule.Schedule.step",
    "Heraclitus.ScaleScheduleData.follows",
    "Heraclitus.ScaleScheduleData.initial_boundary",
    "Heraclitus.Coverage.canonical_coverage",
    "Heraclitus.Coverage.all_walks",
    "Heraclitus.OriginalProblem.rule_iff_walk",
    "Heraclitus.OriginalProblem.canonical_follows_rule",
    "Heraclitus.OriginalProblem.coverage",
    "Heraclitus.OriginalProblem.checkpoint",
})

def audit_dependencies(output, expected):
    found = {}
    for name, axioms in re.findall(
        r"'([^']+)' depends on axioms: \[([^\]]*)\]", output
    ):
        found[name] = [a.strip() for a in axioms.split(",") if a.strip()]
    for name in re.findall(r"'([^']+)' does not depend on any axioms", output):
        found[name] = []
    if set(found) != set(expected):
        raise ValueError("Missing or unexpected theorem in Lean axiom output")
    for name, axioms in found.items():
        bad = set(axioms) - ALLOWED_AXIOMS
        if bad:
            raise ValueError(f"Unapproved axiom dependency in {name}: {sorted(bad)}")
    return found


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lake", help="Path to Lake; otherwise use PATH or the local toolchain")
    parser.add_argument("--clean", action="store_true", help="Rebuild the local Lean package from scratch")
    parser.add_argument("--isolated", action="store_true", help="Compile only the audited import closure into the output directory, without touching .lake")
    parser.add_argument("--jobs", type=int, default=2, help="Independent module workers for an isolated build (default: 2)")
    parser.add_argument("--output", type=Path, default=REPO / "build/lean-verification")
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    (output / "run.json").unlink(missing_ok=True)
    env = os.environ.copy()
    env["LEAN_SRC_PATH"] = str(FORMAL) + os.pathsep + env.get("LEAN_SRC_PATH", "")
    local_elan = REPO / "build/lean-tools/elan"
    lake = args.lake or shutil.which("lake")
    if lake is None and (local_elan / "bin/lake").is_file():
        lake = str(local_elan / "bin/lake")
        env["ELAN_HOME"] = str(local_elan)
    if lake is None:
        raise SystemExit("Pinned Lean toolchain not found. See formal/README.md; Python verification remains available.")
    # Preserve the executable name: an elan-managed lake can be a symlink
    # whose dispatch behavior depends on argv[0].
    lake = str(Path(lake).absolute())
    if Path(lake).parent == local_elan / "bin":
        env["ELAN_HOME"] = str(local_elan)
    started = time.perf_counter()
    started_at = datetime.now(timezone.utc).isoformat()

    def run(label, command):
        result = subprocess.run(command, cwd=FORMAL, env=env, capture_output=True, text=True)
        log = result.stdout + result.stderr
        (output / (label + ".txt")).write_text(log)
        if result.returncode:
            print(log, file=sys.stderr)
            raise SystemExit(f"Lean check failed at {label}; no successful run.json written")
        return log

    version = run("lean-version", [lake, "env", "lean", "--version"]).strip()
    pin = (FORMAL / "lean-toolchain").read_text().strip()
    expected_version = pin.rsplit(":v", 1)[-1]
    if f"version {expected_version}," not in version:
        raise SystemExit("Lean version does not match formal/lean-toolchain")
    run("certificate-binding", [sys.executable, str(REPO / "scripts/export_lean_certificate.py"), "--check"])
    exporters = [
        ("catalogue", "research/lean_catalogue/export_data.py", ["--check"]),
        ("boundary", "research/transfer/export_boundary.py", []),
        ("first-crossing", "research/first_crossing/export_data.py", []),
        ("outgoing", "research/outgoing/export_data.py", []),
        ("outgoing-word", "research/outgoing_word/export_data.py", []),
        ("return-bridge", "research/return_bridge/export_data.py", []),
        ("ladder-layers", "research/ladder_layers/export_data.py", ["--check"]),
        ("ladder-descent", "research/ladder_descent/export_data.py", ["--check"]),
        ("ladder-bottom", "research/ladder_bottom/export_data.py", ["--check"]),
        ("ladder-envelope", "research/ladder_envelope/export_data.py", []),
        ("signed-bottom", "research/signed_bottom/export_data.py", []),
        ("signed-ladder", "research/signed_ladder/export_data.py", []),
        ("signed-transfer", "research/signed_transfer/export_data.py", []),
        ("post-ladder", "research/post_ladder/export_data.py", []),
        ("short-return", "research/short_return/export_data.py", []),
        ("approach-word", "research/approach_word/export_data.py", []),
        ("signed-approach", "research/signed_approach/export_data.py", []),
        ("outer-boundary", "research/outer_boundary/export_data.py", []),
        ("finite-base", "research/finite_base/export_data.py", []),
        ("scale-schedule", "research/scale_schedule/export_data.py", []),
    ]
    for label, script, options in exporters:
        run(label + "-binding", [sys.executable, str(REPO / script), *options])
    # Ask Lean's own header parser for direct source dependencies. Unimported
    # modules being edited by another session are outside this audit.
    modules = []
    seen = set()
    direct = {}

    def source_dependencies(path):
        path = path.resolve()
        if path in seen:
            return
        seen.add(path)
        label = "deps-" + "-".join(path.relative_to(FORMAL).with_suffix("").parts)
        deps = run(label, [lake, "env", "lean", "--src-deps", str(path)])
        direct[path] = []
        for line in deps.splitlines():
            candidate = Path(line).resolve()
            if FORMAL in candidate.parents and candidate.suffix == ".lean":
                direct[path].append(candidate)
                source_dependencies(candidate)
        modules.append(path)

    source_dependencies(FORMAL / "Audit.lean")
    sources = modules + [FORMAL / name for name in ["README.md", "lakefile.toml", "lake-manifest.json", "lean-toolchain"]]
    sources += [REPO / name for name in ["scripts/verify_lean.py", "scripts/export_lean_certificate.py", "certificates/ladder-machine.json", "certificates/signed-machine.json"]]
    sources += [REPO / script for _, script, _ in exporters]

    def fingerprints():
        return {str(p.relative_to(REPO)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(sources)}

    before = fingerprints()
    if args.isolated:
        prefix = run("lean-prefix", [lake, "env", "lean", "--print-prefix"]).strip()
        lean = str(Path(prefix) / "bin/lean")
        lib = output / "compiled"
        if args.clean and lib.exists():
            shutil.rmtree(lib)
        lib.mkdir(parents=True, exist_ok=True)
        env["LEAN_PATH"] = str(lib)
        def compile_one(source):
            relative = source.relative_to(FORMAL)
            destination = (lib / relative).with_suffix(".olean")
            destination.parent.mkdir(parents=True, exist_ok=True)
            label = "axioms" if relative == Path("Audit.lean") else "build-" + "-".join(relative.with_suffix("").parts)
            log = run(label, [lean, "-R", str(FORMAL), "-DwarningAsError=true", str(source), "-o", str(destination)])
            print("Compiled " + str(relative), flush=True)
            return log

        remaining, completed = set(modules), set()
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            while remaining:
                ready = [p for p in modules if p in remaining and set(direct[p]) <= completed]
                if not ready:
                    raise SystemExit("Cyclic or unresolved local source dependency")
                logs = list(pool.map(compile_one, ready))
                for source, log in zip(ready, logs):
                    if source == FORMAL / "Audit.lean":
                        axiom_log = log
                completed.update(ready)
                remaining.difference_update(ready)
        (output / "build.txt").write_text("All audited local modules compiled in isolation:\n" + "\n".join(str(p.relative_to(FORMAL)) for p in modules) + "\n")
    else:
        if args.clean:
            run("clean", [lake, "clean"])
        run("build", [lake, "build"])
        axiom_log = run("axioms", [lake, "env", "lean", "-DwarningAsError=true", "Audit.lean"])
    expected = re.findall(r"^#print axioms (\S+)$", (FORMAL / "Audit.lean").read_text(), re.M)
    if len(expected) != len(set(expected)) or not REQUIRED_THEOREMS.issubset(expected):
        raise SystemExit("Axiom audit must include the required main theorems exactly once")
    dependencies = audit_dependencies(axiom_log, expected)
    after = fingerprints()
    if before != after:
        raise SystemExit("An audited source changed during verification; no successful report written")
    report = {
        "status": "PASS",
        "started_utc": started_at,
        "seconds": round(time.perf_counter() - started, 3),
        "python": platform.python_version(),
        "platform": platform.system() + " " + platform.release(),
        "lean_version": version,
        "toolchain": pin,
        "clean_build": args.clean,
        "isolated_build": args.isolated,
        "audited_modules": [str(p.relative_to(FORMAL)) for p in modules],
        "fresh_complete_import_closure": args.isolated,
        "binding_count": 1 + len(exporters),
        "artifact_sha256": {
            str(p.relative_to(FORMAL).with_suffix(".olean")):
                hashlib.sha256((lib / p.relative_to(FORMAL).with_suffix(".olean")).read_bytes()).hexdigest()
            for p in modules
        } if args.isolated else {},
        "warnings_as_errors": True,
        "theorem_count": len(dependencies),
        "axioms": dependencies,
        "source_sha256": after,
        "scope": "Complete exact signed base from zero, every successive scale transition, whole-state endpoints, exact counts and unconditional coverage of the original-rule sequence, including the checkpoint interval at every k>=6. No human review, global 3/8 upper bound, equality, or novelty claim. The manuscript remains a proposed computer-assisted proof pending independent review; the separate 3/8 lower-bound argument retains its stated conditional scope.",
    }
    (output / "run.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Lean lemmas and axiom audit passed ({len(dependencies)} declarations). Reports: {output}")
    print(report["scope"])


if __name__ == "__main__":
    main()
