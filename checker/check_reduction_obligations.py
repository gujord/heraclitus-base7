"""Supplementary exact finite premises for the 2026-11-02 reduction audit.

Run the main checker first. This script checks additional bounds used in
docs/reduction-audit-2026-11-02.md; the universal implications remain prose.
No producer imports, sampling of higher exponents, or floating arithmetic.
"""

import argparse
import hashlib
import json
from pathlib import Path

import check_certificate as checker

if not __debug__:
    raise SystemExit("Checks require assertions; do not use -O or -OO.")

REPO = Path(__file__).resolve().parents[1]


def first_at(cert, m):
    """Solve every phase threshold, including the sign-dependent equality."""
    _, shift, _, period, values, currents, fronts = checker.check_orbit(
        cert["prefix"], cert["cycle"], cert["initial_state"]
    )
    front = cert["initial_front"] + shift
    assert m % period == cert["residue"]
    thresholds = []
    for i, (u, w) in enumerate(zip(currents, values)):
        rhs = 6 * m + 1 - 2 * front - u - w
        q = rhs // (2 * period) + 1 if cert["sign"] > 0 else -((-rhs) // (2 * period))
        assert q > 0
        thresholds.append((q, i))
    q, phase = min(thresholds)
    f = front + q * period + fronts[phase] - 3 * m
    st = checker.state(cert["cycle"][phase][0])
    a = 1 - f - st[0]
    assert (phase, f, st, a) == (
        cert["phase"], cert["front"], checker.state(cert["state"]), cert["entry"]
    )
    # This whole final cycle bounds every earlier cycle from above.
    upper = front + q * period + max(values + currents) - 3 * m
    assert upper < 2000
    assert -3 <= a <= 3
    return min(x[0] for x in thresholds), upper


def approach_at(cert, m):
    _, shift, values0, period, values, currents, _ = checker.check_orbit(
        cert["prefix"], cert["cycle"], cert["initial_state"]
    )
    front = cert["initial_front"] + shift
    a = cert["offset"]
    q, rem = divmod(m - a - 256 - front, period)
    assert q >= 0
    assert -256 - rem == cert["front"]
    # Both old currents and new choices, not only the final normalized state.
    upper = max(values + currents) - period
    assert upper < 200
    assert a > -50
    _, _, _, currents0, _ = checker.check_route(cert["prefix"], cert["initial_state"])
    initial_current = cert["initial_state"][0]
    transient = a + cert["initial_front"] + max([initial_current, 0] + values0 + currents0)
    assert transient < 4096 and 4096 < m - 56
    lower = a + cert["initial_front"] + min([initial_current] + currents0 + [shift + min(currents)])
    assert lower >= -100
    return q, upper, transient, lower


def main(certificate_dir, output):
    output.parent.mkdir(parents=True, exist_ok=True)
    output.unlink(missing_ok=True)
    ladder = json.loads((certificate_dir / "ladder-machine.json").read_text())
    signed = json.loads((certificate_dir / "signed-machine.json").read_text())
    certs = {**ladder["certificates"], **signed["marker_certificates"]}
    ranges = {}

    def record(name, value):
        ranges.setdefault(name, []).append(value)

    for cert in certs.values():
        f, c, points = cert["initial"]
        _, d, _, p, w, u, fronts = checker.check_orbit(cert["prefix"], cert["cycle"], (c, points))
        _, _, _, prefix_currents, _ = checker.check_route(cert["prefix"], (c, points))
        assert min([f + c] + [f + x for x in prefix_currents] + [f + d + min(u)]) >= -100
        assert max([f + c] + [f + x for x in prefix_currents]) < 2000
        i = cert["phase"]
        # The paper bounds chosen points; signed comparison needs currents too.
        assert max(u) - w[i] < 2000
        relative_front = fronts[i] - w[i]
        assert relative_front + cert["cycle"][i][0][0] >= -2000
        record("marker_cycle_current_above_target", max(u) - w[i])
        if cert["repair"]:
            # Derive the post-insertion normalization, including an empty repair.
            before = checker.state(cert["cycle"][i][0])
            used = set(before[1]) | {-relative_front}
            shift = 0
            while shift in used:
                shift += 1
            after = (before[0] - shift, tuple(sorted(x - shift for x in used if x >= shift)))
            _, _, _, repair_currents, _ = checker.check_route(cert["repair"], after)
            assert min(relative_front + shift + x for x in repair_currents) >= -2000
            assert max(relative_front + shift + x for x in repair_currents) < 2000
        f1, c1, _ = cert["output"]
        assert -2000 <= f1 + c1 < 2000

    rows = signed["transitions"]
    phases = []
    for row in rows:
        k0 = 6 + (row["k"] - 6) % 36
        m = 7**k0
        first = row["first_exit"]
        qmin, first_upper = first_at(first, m)
        record("first_phase_threshold_minimum", qmin)
        record("first_last_cycle_upper_relative_D", first_upper)
        # No competing 7m crossing during the initial transient.
        _, _, v0, u0, _ = checker.check_route(first["prefix"], first["initial_state"])
        x0 = first["initial_front"] + max([first["initial_state"][0], 0] + u0 + v0)
        assert x0 < 2000 and 6 * m + 1 - x0 > 2000
        approach = approach_at(row["approach"], m)
        for name, value in zip(
            ["approach_cycle_count", "approach_cycle_upper_minus_period", "approach_transient_upper_relative_2m", "approach_current_lower_relative_2m"],
            approach,
        ):
            record(name, value)
        record("crossing_anchor", first["entry"])
        # Signed old-region representation really includes all offsets < -100.
        s = first["sign"]
        f0, b0 = row["inner"]["sides"][str(-s)]
        assert -100 <= f0 < 100 and all(f0 < x < 100 for x in b0)
        if not row["anchor_used"]:
            # The sole direct-return case must not meet the next remote marker.
            assert row["k"] == 43 and first["entry"] == 2 and row["bottom"] == [1]
        assert sum(f + len(b) for _, f, b in row["initial"][1]) == 3
        assert sum(f + len(b) for _, f, b in row["output"][1]) == 3
        phases.append({"label": row["k"], "least_k": k0, "first_q_min": qmin, "approach_q": approach[0]})

    # Exact margins at the common lower bound; all are increasing thereafter.
    m = 7**6
    assert (m - 1) // 2 - 512 > m // 7
    assert 7 * m > 2 * ((m - 1) // 2 + 512)
    assert 2 * m + 1 - 2 * 4096 > 0
    assert 3 * m - 200 > 101
    assert m + 1 - 2 * 3 > 0
    assert 49 * m > 2 * ((m - 1) // 2 + 3 * m + 4096)
    assert pow(7, 36, checker.L) == 1
    assert sorted(x["least_k"] for x in phases) == list(range(6, 42))

    report = {
        "status": "PASS",
        "scope": "Additional finite premises of the dated prose audit; requires the main certificate check. Not a formal universal proof or independent human review.",
        "certificate_sha256": {name: hashlib.sha256((certificate_dir / name).read_bytes()).hexdigest() for name in ["ladder-machine.json", "signed-machine.json"]},
        "marker_transfers": len(certs),
        "phase_count": len(phases),
        "ranges": {key: [min(values), max(values)] for key, values in ranges.items()},
        "phases": phases,
    }
    output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({key: value for key, value in report.items() if key != "phases"}, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificates", type=Path, default=REPO / "certificates")
    parser.add_argument("--output", type=Path, default=REPO / "build/verification/reduction-obligations.json")
    args = parser.parse_args()
    main(args.certificates, args.output)
