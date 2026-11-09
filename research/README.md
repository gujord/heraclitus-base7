# Proof map for the 3/8 extension

Use `python3 scripts/rebuild_release.py --jobs 4` from the package root.
The public package includes exactly the research source closure listed in
`proof-inventory.json`; development-only stage runners and their old build
receipts are unnecessary for the portable complete build.

- `upper_machine_audit/TargetContract.lean`: exact defect and rational-epsilon
  eventual-upper/frequent-lower target, for every sequence following the rule.
- `actual_lower_bound/LowerBound.lean`: phase-42 arbitrarily late witnesses.
- `upper_outgoing_prefix/Actual.lean`: all actual outgoing prefixes.
- `upper_return_geometry/`: checkpoint radius, crossing time and entrance tail.
- `upper_return_tail/`: complete return, post-core, approach and boundary tails.
- `upper_scale_assembly/Frame.lean` and `Counting.lean`: actual interval
  decomposition, tail/count/radius coupling and shared endpoints.
- `upper_scale_assembly/Theorem.lean`: `original_rule_scale_bound`,
  `original_rule_eventual_upper`, `original_rule_three_eighths` and
  `canonical_three_eighths`.

All source files and their module names are listed explicitly; some historical
modules use short import names differing from their paths. The runner preserves
those names in a single fresh research object directory, separate from the
coverage objects. Both components have an `Audit` module; keeping their roots
separate prevents a filename collision while keeping the research prefix
complete in one place. The expected theorem inventory is
checked against the source declarations; Lean supplies the actual elaborated
statements and transitive axiom lists. An explicit `example` must inhabit the
final target: defining the target alone cannot pass.
