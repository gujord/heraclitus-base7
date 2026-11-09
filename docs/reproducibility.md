# Reproduce version 1.1.0

Extract the ZIP and work from its root. No private repository or AI service
is required. Python >=3.9 uses only its standard library. Do not use `-O`,
`-OO` or `PYTHONOPTIMIZE`. The source archive contains no compiled project
objects. The optional full proof build needs Lean 4.35.0, pinned in
`formal/lean-toolchain`; install the matching toolchain with elan and put
`lake` on PATH. Once installed, all commands below work offline. Mathlib
is not required.

```sh
python3 scripts/check_release.py
python3 scripts/rebuild_release.py --jobs 4
```

Alternatively supply `--lake /path/to/pinned/toolchain/bin/lake`. Preserve
`ELAN_HOME` if using a custom elan installation. The runner checks the
compiler version and records its hash. It requires a NEW output directory
(default `build/release-rebuild`); use `--output build/another-run` to repeat.
It does not delete or reuse an earlier run. Full builds can take hours,
depending on hardware and worker count; `--jobs` accepts 1 through 8.

The runner checks distribution integrity, runs the separate certificate
checker and its 14 rejection/premise tests, regenerates all three certificates
and compares them, checks 21 coverage source bindings, freshly builds the
244-module coverage closure, audits 4,998 declarations, runs 14 mathematical
and five receipt rejection controls, and then freshly builds all 107 added
research modules. It imports the research modules together and checks all
1,595 public theorem statements and their transitive axioms, plus an actual
inhabitant of the final target. Five additional controls reject a proof
placeholder, false arithmetic, a wrong crossing index, a false actual
crossing defect and an injected axiom. The false mathematical propositions
also have their negations proved, excluding incidental import/resource failures.
Only `propext`, `Classical.choice`, and `Quot.sound` are allowed.

All project imports resolve to objects created in this run. Only the pinned
compiler's standard library is prebuilt. Sources and objects are rehashed
at completion. `report.json` records PASS only after all checks succeed;
a failed run records FAIL. A successful old report is never reused.
The exact definition and target are printed in the logs. Check
`evidence/release-1.1.0/report.json` for the clean candidate build's execution,
not just the expected inventory in `proof-inventory.json`. The final release
changes only publication wording, the rebuilt manuscript, metadata and the
distribution integrity check. `evidence/publication-1.1.0/promotion.json`
records every changed original input and preserves its pre-edit bytes.
The integrity check rejects any change to the proof sources or mathematical
checks. The complete Lean build was not repeated after these editorial edits.

For Python-only verification:

```sh
python3 scripts/verify.py
python3 src/generate_certificate.py
```

These commands do not compile Lean. GitHub's bundled workflow runs these
Python checks; it does not establish that the complete Lean build passed.

The optional manuscript build requires LaTeX and Poppler:

```sh
python3 scripts/build_paper.py
```

That command updates the supplied PDF, generated text index and tables;
working on a copy is convenient because modified bytes no longer match the
release inventory. Mathematical verification does not require these tools.
