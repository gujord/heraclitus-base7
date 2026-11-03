# Certificate format (version 1.0.0)

All numbers in the certificates are exact JSON integers. Paths and command-line wrappers are not part of the mathematical transition logic. The three files retain their original producer format; `schema_version: 1` applies to the new integrity manifest, not retrospectively to the mathematical JSON.

## Shared records

- Half-line state `[c, B]`: all coordinates below 0 used/forbidden; 0 unused; B is the sorted finite list of positive used coordinates; current c is used.
- Local edge `[state, next_state, shift, value]`: complete before/after states, advance of the least hole, chosen value in the old normalization.
- Endpoint state `[f, c, B]`: relative to the preceding endpoint 0, least hole f>0, current f+c, finite used points f+B.
- Transfer: `initial`, `prefix`, `cycle`, `modulus`, `residue`, `phase`, `repair`, `output`. The producer's `threshold` is metadata; the checker derives its own conservative bounds below 2000 for every h>=2401.
- Transfer dictionary keys are JSON-encoded endpoint-state/modulus/residue triples. The checker follows references and checks each actual state and residue; key spelling is an identifier, not mathematical evidence.

## single-marker-7.json

The auxiliary one-marker graph has `base`, `incoming_bound`, `states`, `edges`, `cycles`, `root_cycles` and `cases`. Edges here are compact `[next_state_index, shift, chosen_value]`. There is one incoming case for each distance 1..7, plus one marker insertion per reachable unmarked state (22). The checker follows their deterministic paths to the listed cycles. This auxiliary result explains local cycles but is not a replacement for the signed proof.

## ladder-machine.json

`certificates` is a dictionary of endpoint transfers. `cases` contains old-region configurations, a direct bottom word at offset A+2401, an initial endpoint state, a modulus, and layer `rows`. Each row specifies its level, exact spacing h, input state, six transfer references and output. `repeat_start` and `repeat_period` identify a repeated **state and spacing residue**. The last repeated row is retained, although the closing equality suffices for the induction.

## signed-machine.json

`transitions` contains labels 40..75, covering 36 residue classes of exponents. `scale_start: 40` is a discovery label; the mathematical uniform lower bound is k>=6. A signed boundary is stored as `[current, [[+1, f_plus, B_plus], [-1, f_minus, B_minus]]]`, with current `[side, offset]`. Unlike half-line B, signed B is measured from the central coordinate C, not from its front.

Each row includes the entire initial state, inner boundary word, first exit, old core, applicable ladder/transfer references, approach record, outer boundary word and entire output. `marker_certificates` and `new_ladders` supplement the ladder file. Combined records must be consistent; consecutive outputs equal the next inputs, including the final-to-first wrap.

## Inputs versus evidence

`src/inputs/ladder-cores.json` and the two `*-states.jsonl` files are discovery inputs to producers. The checker reads only the three certificate files; it starts from its own direct small base case. Prior huge state traces are not trusted axioms.

`evidence/public-package/` contains outputs of executed checks and tests. `certificates/manifest.json` identifies expected bytes. Neither JSON output nor a digest is an independent proof of its own truth.
