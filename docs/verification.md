# Verification scope

The mathematical definition is `a(0)=0`, unused integer destinations at a
distance `7^j` for `j>=0`, least absolute value, and positive preference in
ties. The manuscript presents a proposed computer-assisted coverage proof;
independent human review remains outstanding.

| Layer | What is checked | What it does not establish |
|---|---|---|
| Distribution hashes | Exact bytes in the supplied inventory | Mathematical truth or authorship |
| Python certificates | 119 endpoint transfers, 18 ladder entrances, 36 signed transitions, 2573 direct local transitions and 640839 literal local/boundary choices | By themselves, the infinite reduction |
| Direct finite base | All 117650 signed terms from index 0 through 117649 | Behavior at every later index |
| Regeneration | All three certificates regenerated and compared, then checked | An independently reviewed implementation |
| Lean | Literal rule, canonical existence, finite base, every scale transition, checkpoint interval and coverage | Human review or the complete deviation/limsup argument (7)–(9) |
| Rejection tests | Specific damaged inputs and invalid premises are rejected | Exhaustive detection of every possible implementation defect |

The infinite reduction in manuscript Sections 3–7 proceeds through exact
translation cycles, uniform marked-endpoint transfers, arbitrarily many
ladder layers, exhaustive signed candidate rules, and a closed 36-phase
scale schedule. The exact base at `7^6` connects the schedule to the walk
from zero. The least filled-front offset is -36, giving the margin 37.
The table labels 40 through 75 are phase representatives, not a cutoff.
Their periods divide 19240 and `7^36 = 1 (mod 19240)`.

The Lean source `formal/Heraclitus/OriginalProblem.lean` exposes the final
contract directly. `FollowsRule` has no coverage, period or transition
assumption. `canonical_follows_rule` proves existence of an instance;
`coverage` proves exactly one occurrence of each integer for any instance;
`checkpoint` gives the filled interval at every exponent at least six.
Reviewers should compare this definition with the intended mathematical
rule, and inspect the universal reduction as well as the final theorem type.

The following entry points connect the numbered manuscript claims to their
formal components. They are a reading guide, not a claim that each prose
statement is a literal transcription of a single Lean theorem.

| Manuscript claim | Formal entry point under `formal/Heraclitus/` |
|---|---|
| Theorem 1: coverage and filled interval | `OriginalProblem.lean`: `coverage`, `checkpoint`, and `canonical_follows_rule` |
| Lemma 2: translation cycle | `Translation.lean`: `normalized_cycle_repeats` |
| Lemma 3: marked-endpoint transfer | `Markers.lean`: `residue_marker_transfer`; concrete transfers in `TransferCatalogue.lean` |
| Proposition 4: ladder closure | `LadderLayersData.lean`: `all_heights`; signed composition in `SignedLadderData.lean` |
| Lemma 5: signed boundary rule | `Refinement.lean`: `boundary_rule_sound`; concrete words in `SignedBoundaryData.lean` |
| Proposition 6: scale transition and phase assembly | `OuterBoundaryData.lean`: `all_transitions`; `ScaleSchedule.lean` and `Coverage.lean` |
| Corollary 7: deviation lower bound | No complete Lean theorem for (7)–(9); `FirstCrossing.lean` and `Outgoing.lean` supply components only |

The clean procedure compiles 244 project modules and audits 4,998 declarations
after 21 source bindings. Only the standard axioms `propext`,
`Classical.choice` and `Quot.sound` are allowed. The trust boundary includes
the pinned compiler/kernel, standard library, allowed axioms and statement
fidelity. Data exporters are unverified deterministic programs, not verified
parsers; Lean checks claims about their literal outputs. Python PASS and
file hashes are not Lean axioms. The checker imports no `src/` code.

The transition and its first-crossing components are formalized. Connecting
them to the canonical subsequence and deriving (7)–(9), including the limit
and limsup conclusion, remains a manuscript argument. The exact rational
corollary checker derives all 36 offset pairs; its PASS is not a Lean proof
of that argument. The 3/8 claim is a lower bound conditional on the uniform
transition, not equality.

Equality at 3/8, minimality of the 36-phase period and general odd-base
coverage remain unproved; independent human review is outstanding.
No matching prior base-seven coverage result was found in the sources
searched; possible overlap with unpublished work remains unresolved.
Longer numerical prefixes alone would not settle these questions.

The historical prefix hash is
`3a9478e37859b92ba9e2a5d3a3cd1576cbba5071ceed829baae5d32b777d0c2c`,
encoding the signed base terms as little-endian signed 64-bit integers,
including `a(0)`. [Reproduction](reproducibility.md) gives the exact commands
and distinguishes fresh builds from checked object reuse.
