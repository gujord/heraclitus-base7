# Reproduce the distributed package

No private repository, account, API key or AI tool is needed. Extract the
source ZIP and run commands from its root. Python 3.9 or newer is sufficient
for all certificate checks and regeneration; these use only the standard
library and can run offline. Do not use `-O`, `-OO` or `PYTHONOPTIMIZE`.

```sh
python3 scripts/check_release.py
python3 scripts/verify.py
python3 src/generate_certificate.py
```

`check_release.py` checks the inventory and all bytes. The certificate
checker then independently recomputes local moves, closure, the 117650-term
base case and supplementary exact inequalities, and runs all 14 negative/
premise tests. Reports are written to `build/verification/`. Regeneration
writes only to `build/generated-certificates/`, compares all three JSON
objects with the supplied certificates and checks the regenerated files.

## Complete Lean build

Install [elan](https://github.com/leanprover/elan), Lean's toolchain manager,
and make `lake` available on PATH. The first invocation may download the
pinned toolchain `leanprover/lean4:v4.35.0`; network access is not needed once
it is installed. No Mathlib or other project dependency is needed.

```sh
python3 scripts/verify_lean.py --isolated --clean --jobs 2
python3 research/scale_schedule/verify_coverage.py \
  --shared build/lean-verification --output build/final-checks
```

The first command checks 21 certificate/source bindings, then compiles the
complete 244-module import closure from source, with warnings treated as
errors. It writes fresh objects under `build/lean-verification/compiled/`
and audits 4,998 declarations. Only `propext`, `Classical.choice` and
`Quot.sound` are allowed. `run.json` is written only after success and a
second source-identity check. A previous two-worker run took about 90
minutes; worker count and hardware affect the duration.

The second command validates that receipt and the compiled object hashes,
compiles two fresh fixtures, prints the literal rule and final theorem
types, and runs 24 axiom audits, 14 mathematical rejection cases and five
receipt rejection cases. It reuses the first command's compiled objects;
it is not another complete build. Both commands accept `--lake /path/to/lake`.
Keep `ELAN_HOME` set if using an installation outside its default location.

All 20 subsidiary exporters under `research/` are required by the binding
checks and are included. Running `lake build` in `formal/` is an alternative
kernel compilation route, but it does not replace the Python source-binding
and axiom-audit procedure above.

## Manuscript PDF

The canonical editable source is `paper/base-seven-heraclitus.tex`.
`paper/tables.tex` is regenerated from the two main certificates. With
pdfLaTeX (including Latin Modern, microtype, listings, xurl and the usual
AMS/table packages) and Poppler's `pdftotext` installed:

```sh
python3 scripts/build_paper.py
```

Pass `--engine /path/to/pdflatex` to select an installation. The builder
performs two passes and rejects overfull boxes, missing glyphs and undefined
references. It also derives the text search index from the PDF. PDF bytes
can differ with TeX version and metadata; verify equations, tables and
rendered pages when rebuilding. A rebuilt PDF changes the distribution
inventory; preserve the original archive when checking its recorded hashes.

## Evidence and reproducibility limits

The fresh public-package receipt is `evidence/public-package/formal/run.json`.
Its `source_sha256` entries identify every build input. The final public
export is required to match all of these hashes. Presentation files can be
finished while the isolated build runs; they do not alter that proof input.
The package's fresh Python reports and dependent final checks are stored
alongside that receipt. Objects are not shipped: reproduction builds them.

Old reports under `evidence/coverage-2026-11-03/` are preserved unchanged.
They are additional historical evidence, not a claim that a second person
performed the reproduction. See [provenance](provenance.md).

The GitHub workflow checks distribution integrity, Python certificates and regeneration on Python
3.9 and 3.12. It does not run Lean and does not deploy or publish anything.
