# The base-seven Heraclitus transform

**Version 1.0.0 — manuscript and reproducible proof package.**

A proposed computer-assisted proof that the greedy walk with jumps
`1, 7, 49, ...` visits every integer exactly once. The package contains the
manuscript, exact certificates, a separate Python checker and generators,
and a Lean formalization of the literal rule, finite base and complete
coverage theorem. It was developed using OpenAI Codex under Roger Gujord's
direction and has not received independent human mathematical review.

Read the [manuscript](paper/base-seven-heraclitus.pdf), then the
[verification scope](docs/verification.md) and [reproduction instructions](docs/reproducibility.md).
The complete deviation derivation (7)–(9) is not formalized in Lean.
Equality at 3/8 and general odd-base coverage remain unproved. No matching
prior base-seven coverage result was found in the sources searched;
possible overlap with unpublished work remains unresolved.

## Exact rule

Start at `a(0)=0`. From `a(n)`, choose an unused integer `v` with
`|v-a(n)|=7^j`, `j>=0`, minimizing `|v|`; prefer the positive integer in a
tie. The coverage theorem applies to this literal rule. For every `k>=6`,
the used set through index `7^k` contains `[-C_k+37, C_k-37]`, where
`C_k=(7^k-1)/2`. See `formal/Heraclitus/OriginalProblem.lean`.

## Run

Python 3.9 or newer; only the standard library is required for these checks:

```sh
python3 scripts/check_release.py
python3 scripts/verify.py
python3 src/generate_certificate.py
```

The first checks distribution integrity. The second checks certificates,
the direct finite base, exact corollary calculations and rejection tests.
The third regenerates the certificates into `build/` and compares them to
the supplied originals. These commands do not compile the Lean proof.

With the pinned Lean toolchain installed, run separately:

```sh
python3 scripts/verify_lean.py --isolated --clean
```

This performs 21 source bindings, a fresh 244-module build and 4,998 axiom
audits. The [Lean guide](formal/README.md) describes the trust boundary.
The bundled CI workflow runs **distribution integrity, Python certificate checks and regeneration**;
its green status does not represent a Lean build.

## Package layout

| Directory | Purpose |
|---|---|
| `paper/` | PDF, editable LaTeX, generated search text and bibliography |
| `formal/` | Complete Lean proof sources and pinned toolchain |
| `certificates/` | Three unchanged mathematical certificates and scoped integrity manifest |
| `checker/`, `src/`, `tests/` | Separate checker, generators, generation inputs and rejection tests |
| `research/` | Required data exporters and final contract/rejection fixtures |
| `docs/` | Reproduction, statement review, provenance and bounded prior-work search |
| `evidence/public-package/` | Clean package build/check records; later editorial review in `editorial-update/` |
| `evidence/coverage-2026-11-03/` | Unmodified historical coverage build and final-check records |

The three earlier gap/base-3/base-5 drafts are not included or assumed.
The package does not require access to the private development repository.
Historical reports may contain private commit IDs and machine paths;
[provenance](docs/provenance.md) explains their scope.
The [reference review](docs/reference-review-2026-11-03.md) records the
September 2026 seminar citation and the remaining publication-access checks.

## Citation and licenses

Roger Gujord, *The base-seven Heraclitus transform: manuscript and
reproducible proof package*, version 1.0.0. Version DOI:
[10.5281/zenodo.23912682](https://doi.org/10.5281/zenodo.23912682).
Project repository: [gujord/heraclitus-base7](https://github.com/gujord/heraclitus-base7).
The source archive is self-contained and requires no repository access.

**MIT for code; CC BY 4.0 for prose and data**, by component.
See [LICENSE](LICENSE) and [CITATION.cff](CITATION.cff).
`release-manifest.json` inventories all distributed bytes except itself;
`EXPORT_PROVENANCE.json` records the actual source mapping.
