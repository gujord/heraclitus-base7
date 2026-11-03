# Provenance and distribution scope

Roger Gujord directed this personal research project. OpenAI Codex was used
to develop the argument, manuscript, generator, separate checker and Lean
formalization. Their differing implementations are not independent human
review. OpenAI has not reviewed or endorsed the result.

Version 1.0.0 was prepared locally for a manual Zenodo deposit under
version DOI `10.5281/zenodo.23912682`, reserved before the export.
The export record describes the preparation state at that time; it is not
a claim of priority confirmation or independently performed reproduction.

## Deterministic export

The development tool `release/export_public.py` selects explicit source
paths and overlays public-facing documentation, without copying Git
history, build caches, agent instructions, coordination files or archives.
`EXPORT_PROVENANCE.json` records the private base commit, worktree status
and source-file hash map actually used. It separately records the one
derived integrity manifest and the version substitution. The public
`release-manifest.json` inventories every distributed file except itself.
ZIP entries are sorted and carry fixed timestamps and permissions.

The three earlier gap/base-3/base-5 notes are excluded because they are
separate unrevised drafts. The present manuscript neither cites nor assumes
them. All private archive bytes are preserved in the development repository.
Their absence from this package is not a claim about their results.

The public certificate manifest retains the six original entries for the
three mathematical certificates and three generation inputs, with exactly
their original sizes and hashes. Archive entries are omitted explicitly;
no mathematical certificate or verification logic is changed. The original
development manifest remains unchanged. Public documentation is an overlay;
in particular the shorter `formal/README.md` is a documented difference from
historical source receipts. All 244 Lean source files remain unchanged.

## Build records

The new build ran from a freshly extracted public ZIP, with no project
objects copied in. Only the installed pinned compiler/standard library
were reused. `evidence/public-package/formal/run.json` records the actual
inputs and compiled object hashes. The final export must match all its
source hashes even if manuscript and metadata work finished during the
build. Dependent final checks reuse only hash-validated objects from that
build, and are described separately in their receipt.

`evidence/coverage-2026-11-03/` contains unmodified historical build and
final-check reports from the private development tree. Absolute machine
paths and private Git commit IDs inside old reports identify that historical
execution, not public repository revisions or files required on a reader's
machine. They are retained byte for byte for traceability. No old report is
rewritten to appear to come from the public package.

Later citation and manuscript checks are stored in
`evidence/public-package/editorial-update/` when present. Their link record
identifies the original build reports by hash; the original reports remain
unchanged. The export still requires all 272 Lean build inputs and every
checked Python input to match. An editorial update is not a new Lean build.

## Manuscript changes and old references

The release presentation makes the base-seven argument self-contained,
numbers the key statements and reproduces the literal Lean contract.
The nine numbered mathematical equations and both certificate-derived
appendix tables are retained. The earlier comparison with the separate gap
note is removed with its references. Historical reports refer to the older
section numbering:

| Older manuscript | This edition |
|---|---|
| Sections 1–7 | Sections 1–7 |
| Section 7a | Section 8 (deviation lower bound) |
| Section 8 | Section 9 (Python checks) |
| Section 8a | Section 10 (package and formal contract) |
| Sections 9 and 10 | Sections 11 and 12 |
| Section 10a and references [7]–[9] | Removed; separate unrevised notes excluded |
| Reference [10] | Reference [7], the versioned package |

The old evidence speaks to the sources it identifies. It is not a review of
later prose changes. The new editorial checks are recorded separately.

## Licenses and metadata

Roger selected CC BY 4.0 for text and data and MIT for code. See `LICENSE`
for component boundaries. The CFF and `.zenodo.json` single software-license
field describes the code (MIT); their descriptions explicitly identify the
CC BY prose/data components. A CFF license array would mean alternative
licenses for the same work, so it is not used to express this split.
For the manual Zenodo record, add both licenses and preserve the component
description. The DOI is a reserved version DOI, not a concept DOI.

No independent human mathematical review or independently performed clean
reproduction has yet been obtained. Review statement fidelity and Sections
3–7; the complete first-crossing deviation derivation remains outside Lean.
