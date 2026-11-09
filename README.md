# The base-seven Heraclitus transform

**Version 1.1.0 — 9 November 2026.**

Set `a(0)=0`. From `a(n)`, choose an unused integer at distance `7^j`,
`j>=0`, of least absolute value; prefer positive values in ties.

This package contains the proposed computer-assisted coverage proof and the
completed exact rational-epsilon **3/8 equality contract** for this rule.
Independent human review of the manuscript, universal reduction and formal
statement fidelity remains outstanding. No novelty claim is made here.

With `E(n)=||a(n)|-n/2|`, the added proof establishes
`8E(n)-3n <= 32771+6*(k-4)` for every `k>=6` and
`7^k<=n<=7^(k+1)`. It combines eventual upper bounds with arbitrarily late
lower witnesses. `Heraclitus.UpperScaleAssembly.original_rule_three_eighths`
inhabits `Heraclitus.UpperMachineAudit.OriginalRuleThreeEighths` from the
literal original rule, with no additional transition, time, radius or tail
hypothesis. This is the exact rational-epsilon formulation of limsup 3/8;
no real-analysis library limsup API conversion is claimed.

## Reproduce

Python >=3.9, standard library only:

```sh
python3 scripts/check_release.py
python3 scripts/verify.py
python3 src/generate_certificate.py
```

With the pinned Lean 4.35.0 toolchain installed:

```sh
python3 scripts/rebuild_release.py --jobs 4
```

This builds all **351 project modules** from source: 244 coverage modules
and 107 research modules. It audits 4,998 coverage declarations and 1,595
research theorem statements/axiom lists, checks 21 coverage source bindings,
and runs the Python and Lean rejection controls. It imports no prior project
objects. See [reproduction](docs/reproducibility.md),
[verification scope](docs/verification.md), and [release notes](docs/release-1.1.0.md).
The complete clean-build receipts are in `evidence/release-1.1.0/`.
Publication-only changes and their exact link to that build are recorded in
`evidence/publication-1.1.0/`. Earlier public evidence is preserved unchanged.

Read the [paper](paper/base-seven-heraclitus.pdf),
[authoritative LaTeX](paper/base-seven-heraclitus.tex),
[proof guide](research/README.md), and [provenance](docs/provenance.md).
The inventory `release-manifest.json` checks exact bytes, not truth.

Code: MIT. Prose/data: CC BY 4.0, by component in [LICENSE](LICENSE).
The historical DOI [10.5281/zenodo.23912682](https://doi.org/10.5281/zenodo.23912682)
identifies **1.0.0 only**. The version DOI for **1.1.0** is
[10.5281/zenodo.24086002](https://doi.org/10.5281/zenodo.24086002).
The public repository is [gujord/heraclitus-base7](https://github.com/gujord/heraclitus-base7).

The DOI metadata update preserves all proof inputs and earlier execution
receipts; its exact editorial changes are recorded in `evidence/doi-1.1.0/`.
