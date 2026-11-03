"""Derive the 3/8 subsequence limit from the existing signed certificate.

This is a conditional corollary of the uniform signed transition proof.
It does not prove an upper bound or re-audit that proof.
"""

import argparse, json
from fractions import Fraction
from pathlib import Path

if not __debug__:
    raise SystemExit(
        "Checks require assertions: do not run with -O, -OO, or PYTHONOPTIMIZE."
    )
REPO = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--certificates", type=Path, default=REPO / "certificates")
parser.add_argument("--output", type=Path, default=REPO / "build/verification")
args = parser.parse_args()
args.output.mkdir(parents=True, exist_ok=True)
(args.output / "crossing-corollary-verification.json").unlink(missing_ok=True)
data = json.loads((args.certificates / "signed-machine.json").read_text())
assert data["base"] == 7
assert [row["k"] for row in data["transitions"]] == list(range(40, 76))
results = {}
for row in data["transitions"]:
    e = row["first_exit"]
    s = e["sign"]
    F = e["front"]
    B = e["state"][1]
    f0, B0 = row["inner"]["sides"][str(-s)]
    delta = F + len(B) + f0 + len(B0) - 2
    A = e["entry"]
    phase = row["k"] % 36
    # Separate counting check: explicitly assemble the finite used set at
    # a modest symbolic m, including the newly chosen crossing endpoint.
    # This checks the cardinality identity, not a greedy walk at that m.
    for m in [101, 1001]:
        C = (m - 1) // 2
        D = (7 * m - 1) // 2
        used = {0}
        used.update(s * v for v in range(1, D + F))
        used.update(s * (D + F + v) for v in B)
        used.update(-s * v for v in range(1, C + f0))
        used.update(-s * (C + v) for v in B0)
        entry = -s * (D + A)
        assert entry not in used
        used.add(entry)
        n = len(used) - 1
        assert n == 4 * m + delta
        E = abs(Fraction(abs(entry)) - Fraction(n, 2))
        assert E / Fraction(n) == Fraction(3, 8) + Fraction(
            8 * A - 4 - 7 * delta, 8 * n
        )
    results[phase] = dict(
        phase=phase, A=A, delta=delta, correction_numerator=8 * A - 4 - 7 * delta
    )

out = dict(
    status="PASS",
    scope="conditional on the base-seven uniform transition proof",
    conclusion="limsup E(n)/n >= 3/8; no upper bound asserted",
    formula="E(n_k)/n_k = 3/8 + (8*A-4-7*delta)/(8*(4*7^k+delta))",
    A_range=[
        min(x["A"] for x in results.values()),
        max(x["A"] for x in results.values()),
    ],
    delta_range=[
        min(x["delta"] for x in results.values()),
        max(x["delta"] for x in results.values()),
    ],
    phases=[results[i] for i in range(36)],
)
(args.output / "crossing-corollary-verification.json").write_text(
    json.dumps(out, indent=2) + "\n"
)
print(json.dumps({k: v for k, v in out.items() if k != "phases"}, indent=2))
