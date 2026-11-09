# Lean coverage proof

This directory formalizes the literal base-seven greedy rule, its canonical
sequence, the exact finite base, all successive scale transitions and coverage
of every integer. The manuscript remains a proposed computer-assisted proof
pending independent human mathematical review. The separate research extension now proves the exact original-rule
rational-epsilon 3/8 equality contract. For the entire 351-module chain run
`python3 scripts/rebuild_release.py --jobs 4` from the package root.
The commands below check only the 244-module coverage component.

## Reproduce

Install Lean's `elan` toolchain manager, then from the package root run:

```sh
python3 scripts/verify_lean.py --isolated --clean --jobs 2
```

The pin in `lean-toolchain` selects Lean 4.35.0. Only the bundled standard
library is needed; there is no Mathlib dependency. The command checks 21
source bindings (including the exporters under `research/`), freshly compiles
the entire 244-module import closure and audits 4,998 declarations. Its only
allowed axioms are `propext`, `Classical.choice` and `Quot.sound`. Budget about
90 minutes on the original two-worker machine; time varies by hardware.
Use `--lake /path/to/lake` if it is not on PATH. An installation using a custom
`ELAN_HOME` must retain that environment variable.

For the final contract and targeted mathematical/receipt rejection tests:

```sh
python3 research/scale_schedule/verify_coverage.py \
  --shared build/lean-verification --output build/final-checks
```

Use the output directory printed by `verify_lean.py` as `--shared` if different.
The second command checks and reuses the first command's objects; it is not a
second clean build. See [reproduction instructions](../docs/reproducibility.md)
and [verification scope](../docs/verification.md).

## Review the statement

Start with `Heraclitus/OriginalProblem.lean`: `FollowsRule` spells out the
mathematical rule, `canonical_follows_rule` establishes an instance, and
`coverage` applies to every sequence satisfying the rule without a transition
or periodicity premise. `checkpoint` gives the explicit filled interval.
Review statement fidelity as well as the manuscript's universal reduction.

The Python data exporters are not verified parsers. Lean checks propositions
about their emitted literal data, and the binding checks compare those data
to the supplied certificates. Python PASS and hash values are not Lean axioms.
The trust boundary includes the pinned compiler/kernel, standard library,
allowed axioms and fidelity of the formal statement to the intended problem.
