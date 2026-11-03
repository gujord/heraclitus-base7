"""Separate proof-certificate checker. No producer imports.

Greedy moves are checked by scanning candidates in increasing order and
recognizing powers by integer division. Universal spacing bounds are
checked separately from finite sample simulations.
"""

import argparse, json, math, hashlib, struct
from pathlib import Path

if not __debug__:
    raise SystemExit(
        "Checks require assertions: do not run with -O, -OO, or PYTHONOPTIMIZE."
    )
REPO = Path(__file__).resolve().parents[1]
ROOT = REPO / "certificates"
OUTPUT = REPO / "build/verification"
L = 19240
edges = {}
edge_checks = 0
literal_moves = 0


def power(d):
    if d <= 0:
        return False
    while d % 7 == 0:
        d //= 7
    return d == 1


def state(s):
    return (s[0], tuple(s[1]))


def triple(s):
    return (s[0], s[1], tuple(s[2]))


def canonical(sides, current):
    return [list(current), [[s, sides[s][0], sorted(sides[s][1])] for s in [1, -1]]]


def direct_edge(s):
    global edge_checks
    s = state(s)
    if s in edges:
        return edges[s]
    c, points = s
    used = set(points)
    assert 0 not in used and all(x > 0 for x in used)
    assert c < 0 or c in used
    v = 0
    while v in used or not power(abs(v - c)):
        v += 1
    used.add(v)
    shift = 0
    while shift in used:
        shift += 1
    nxt = (v - shift, tuple(sorted(x - shift for x in used if x >= shift)))
    result = (nxt, shift, v)
    edges[s] = result
    edge_checks += 1
    return result


def check_route(route, initial):
    cur = state(initial)
    shift = 0
    values = []
    previous = []
    fronts = []
    for s, nxt, d, v in route:
        assert state(s) == cur
        assert direct_edge(cur) == (state(nxt), d, v)
        assert abs(cur[0]) < 2000 and max(cur[1], default=0) < 2000
        fronts.append(shift)
        previous.append(shift + cur[0])
        values.append(shift + v)
        shift += d
        cur = state(nxt)
    return cur, shift, values, previous, fronts


def check_orbit(prefix, cycle, initial):
    start, D, V, _, _ = check_route(prefix, initial)
    last, P, W, previous, fronts = check_route(cycle, start)
    assert last == start and P == len(cycle) > 0
    assert len(set(w % P for w in W)) == P and L % P == 0
    return start, D, V, P, W, previous, fronts


def literal(initial, h, steps):
    global literal_moves
    f, c, B = triple(initial)
    cur = f + c
    occupied = {f + x for x in B} | {h}
    while f in occupied:
        occupied.remove(f)
        f += 1
    for _ in range(steps):
        v = f
        while v in occupied or not power(abs(v - cur)):
            v += 1
        occupied.add(v)
        cur = v
        while f in occupied:
            occupied.remove(f)
            f += 1
    literal_moves += steps
    return (f - h, cur - f, tuple(sorted(x - f for x in occupied)))


def check_marker(cert):
    f, c, B = triple(cert["initial"])
    assert f > 0
    cyc, D, V, P, W, prev, fronts = check_orbit(cert["prefix"], cert["cycle"], (c, B))
    assert P == cert["modulus"]
    i = cert["phase"]
    r = cert["residue"]
    fcycle = f + D
    assert (r - fcycle - W[i]) % P == 0
    # These explicit bounds imply validity for EVERY h>=2401 in this class.
    assert f + max(B, default=0) < 2000
    assert all(f + v < 2000 for v in V)
    assert fcycle + W[i] < 2000
    assert max(W) - min(W) < 2000
    phase_state = state(cert["cycle"][i][0])
    F = fronts[i] - W[i]
    used = set(phase_state[1])
    used.add(-F)
    assert -F not in phase_state[1]
    delta = 0
    while delta in used:
        delta += 1
    after = (
        phase_state[0] - delta,
        tuple(sorted(x - delta for x in used if x >= delta)),
    )
    F += delta
    assert F + max(after[1], default=0) < 2000
    last, D2, V2, _, _ = check_route(cert["repair"], after)
    assert all(F + v < 2000 for v in V2)
    # Repair must stop exactly when the marked endpoint has no older holes.
    running = F
    for edge in cert["repair"]:
        assert running <= 0
        running += edge[2]
    assert running > 0
    output = (F + D2, last[0], last[1])
    assert output == triple(cert["output"])
    assert output[0] + max(output[2], default=0) < 2000
    # Separate full greedy simulation, with the point marked FROM THE START.
    for offset in [0, 2 * P]:
        h = 2401 + (r - 2401) % P + offset
        q = (h - fcycle - W[i]) // P
        assert q >= 0
        steps = len(cert["prefix"]) + q * P + i + len(cert["repair"])
        assert literal(cert["initial"], h, steps) == output
    return P


def check_core(case, core, initial):
    global literal_moves
    A = case["offset"]
    J = core["J"]
    end = A + 7**J
    assert end == core["end"] and J == 4 and -100 <= A < 100 and A in case["core"]
    occupied = set(case["core"]) | {end}
    f = -100
    cur = end
    while f in occupied:
        f += 1
    maximum = end
    for v in core["word"]:
        candidate = f
        while candidate in occupied or not power(abs(candidate - cur)):
            candidate += 1
        assert candidate == v
        occupied.add(v)
        cur = v
        maximum = max(maximum, v)
        while f in occupied:
            f += 1
    literal_moves += len(core["word"])
    assert f > end and maximum == core["max_coordinate"] < end + 2000
    assert (
        f - end,
        cur - f,
        tuple(sorted(x - f for x in occupied if x >= f)),
    ) == triple(initial)
    assert max(case["core"]) < 100 and all(
        x in case["core"] for x in range(-100, min(case["core"]) + 1)
    )


def check_ladder(case, certs):
    check_core(case["case"], case["core"], case["initial"])
    rows = case["rows"]
    assert triple(rows[0]["state"]) == triple(case["initial"])
    assert case["J"] == 4 and case["repeat_period"] in [2, 36]
    M = case["modulus"]
    assert L % M == 0
    for i, row in enumerate(rows):
        assert row["level"] == 4 + i and row["h"] == 7 ** (4 + i)
        cur = triple(row["state"])
        assert len(row["transfers"]) == 6
        for key in row["transfers"]:
            cert = certs[key]
            assert cur == triple(cert["initial"])
            assert (
                row["h"] % cert["modulus"] == cert["residue"]
                and M % cert["modulus"] == 0
            )
            cur = triple(cert["output"])
        assert cur == triple(row["output"])
        if i + 1 < len(rows):
            assert cur == triple(rows[i + 1]["state"])
    a = case["repeat_start"]
    z = a + case["repeat_period"]
    assert z < len(rows) and triple(rows[a]["state"]) == triple(rows[z]["state"])
    assert rows[a]["h"] % M == rows[z]["h"] % M
    assert 0 <= a <= 1


def boundary(sides, current, word):
    global literal_moves
    sides = {s: [f, set(B)] for s, (f, B) in sides.items()}
    s, x = current

    def used(t, y):
        return y < sides[t][0] or y in sides[t][1]

    assert used(s, x)
    for f, B in sides.values():
        assert all(v > f for v in B)
    bound = max([abs(x)] + [abs(v) for f, B in sides.values() for v in [f, *B]])
    for wanted in word:
        y = min(v[0] for v in sides.values())
        while True:
            found = None
            for t in [1, -1]:
                if not used(t, y) and (
                    (t == s and power(abs(y - x))) or (t == -s and y == 1 - x)
                ):
                    found = (t, y)
                    break
            if found is not None:
                break
            y += 1
        assert list(found) == list(wanted)
        s, x = found
        sides[s][1].add(x)
        while sides[s][0] in sides[s][1]:
            sides[s][1].remove(sides[s][0])
            sides[s][0] += 1
        bound = max(bound, abs(x), *[abs(v[0]) for v in sides.values()])
    literal_moves += len(word)
    assert bound < 512
    return sides, (s, x)


def decode_initial(data):
    current = tuple(data[0])
    sides = {s: (f, B) for s, f, B in data[1]}
    return sides, current


def check_first(cert, other_front):
    f = cert["initial_front"]
    initial = cert["initial_state"]
    cyc, D, V, P, W, prev, fronts = check_orbit(cert["prefix"], cert["cycle"], initial)
    assert cert["modulus"] == P and max([f] + [f + v for v in V]) < 2000
    _, _, _, prefix_previous, _ = check_route(cert["prefix"], initial)
    assert all(1 - f - v < other_front for v in prefix_previous)
    assert all(1 - (f + D) - v < other_front for v in prev)
    f += D
    s = cert["sign"]
    r = cert["residue"]
    expected = None
    # This computes phase inequalities without using the producer's ceil.
    # The proof then uses q -> q+3*Delta/P for a change m -> m+Delta.
    for m in [1000000 + (r - 1000000) % P, 2000000 + (r - 2000000) % P]:
        opts = []
        for i in range(P):
            q = (6 * m + 1 - 2 * f - prev[i] - W[i]) // (2 * P)

            def wins(t):
                old = f + t * P + prev[i]
                nxt = f + t * P + W[i]
                other = 6 * m + 1 - old
                return other < nxt or (other == nxt and s < 0)

            while not wins(q):
                q += 1
            while q > 0 and wins(q - 1):
                q -= 1
            assert q > 0
            opts.append((q, i))
        q, i = min(opts)
        F = f + q * P + fronts[i] - 3 * m
        st = state(cert["cycle"][i][0])
        answer = (i, F, st, 1 - F - st[0])
        if expected is None:
            expected = answer
        else:
            assert answer == expected
    i, F, st, A = expected
    assert (
        i == cert["phase"]
        and F == cert["front"]
        and st == state(cert["state"])
        and A == cert["entry"]
    )
    assert abs(F) < 200 and abs(A) < 100 and F + max(st[1], default=0) < 200
    return F, st, A


def check_approach(cert, m):
    f = cert["initial_front"]
    st = cert["initial_state"]
    A = cert["offset"]
    cyc, D, V, P, W, prev, _ = check_orbit(cert["prefix"], cert["cycle"], st)
    assert P == cert["modulus"] and m % P == cert["residue"]
    assert max([f] + [f + v for v in V]) < 2000
    assert max(max(W), max(prev)) - P < 200
    F = -256 - ((m - A - 256 - f - D) % P)
    assert F == cert["front"] and cyc == state(cert["state"])
    assert F + max(cyc[0], max(cyc[1], default=0)) < -50
    return F, cyc


def check_single_marker():
    doc = json.loads((ROOT / "single-marker-7.json").read_text())
    states = [state(x) for x in doc["states"]]
    assert doc["base"] == 7 and doc["incoming_bound"] == 7
    assert len(states) == len(doc["edges"]) and len(set(states)) == len(states)
    assert all(case["kind"] in ["incoming", "marker"] for case in doc["cases"])
    incoming = [c["source"] for c in doc["cases"] if c["kind"] == "incoming"]
    assert sorted(incoming) == list(range(1, 8))
    assert all(0 <= j < len(states) for j, d, v in doc["edges"])
    for s, (j, d, v) in zip(states, doc["edges"]):
        assert direct_edge(s) == (states[j], d, v)
    for cycle in doc["cycles"]:
        shift = 0
        for i, j in zip(cycle, cycle[1:] + cycle[:1]):
            edge = doc["edges"][i]
            assert edge[0] == j
            shift += edge[1]
        assert shift == len(cycle) > 0
    roots = set()
    for case in doc["cases"]:
        if case["kind"] != "incoming":
            continue
        assert states[case["start"]] == (-case["source"], ())
        i = case["start"]
        while i not in roots:
            roots.add(i)
            i = doc["edges"][i][0]
    sources = {c["source"][0] for c in doc["cases"] if c["kind"] == "marker"}
    assert sources == roots and len(roots) == 22
    assert len([c for c in doc["cases"] if c["kind"] == "marker"]) == len(roots)
    for case in doc["cases"]:
        if case["kind"] == "marker":
            i, shift, v = case["source"]
            c, B = states[i]
            assert v == doc["edges"][i][2]
            used = set(B) | {v}
            d = 0
            while d in used:
                d += 1
            assert d == shift and states[case["start"]] == (
                c - d,
                tuple(sorted(x - d for x in used if x >= d)),
            )
        i = case["start"]
        seen = set()
        while i not in seen:
            seen.add(i)
            i = doc["edges"][i][0]
        assert i in doc["cycles"][case["cycle"]]
    return dict(states=len(states), marker_cases=len(roots), status="PASS")


def direct_signed_base(transitions):
    """Separate uncompressed signed walk, all arithmetic exact.

    Let R be the largest magnitude used and p the first power exceeding 2R.
    Then current+p is unused. Every larger power q>=7p has
    |current +/- q| >= q-R > p+R, so cannot improve that candidate.
    """
    used = {0}
    current = 0
    R = 0
    powers = [1]
    digest = hashlib.sha256(struct.pack("<q", 0))
    snapshots = {}
    for n in range(1, 7**6 + 1):
        while powers[-1] <= 2 * R:
            powers.append(7 * powers[-1])
        choices = [
            current + d * p
            for p in powers
            for d in [-1, 1]
            if current + d * p not in used
        ]
        current = min(choices, key=lambda x: (abs(x), -x))
        used.add(current)
        R = max(R, abs(current))
        digest.update(struct.pack("<q", current))
        if n in [7**4, 7**5, 7**6]:
            k = next(j for j in [4, 5, 6] if n == 7**j)
            C = (n - 1) // 2
            sides = {}
            for s in [1, -1]:
                f = 1
                while s * f in used:
                    f += 1
                sides[s] = (
                    f - C,
                    [abs(v) - C for v in used if v * s > 0 and abs(v) >= f],
                )
            value = canonical(sides, (1 if current > 0 else -1, abs(current) - C))
            expected = transitions[k + 36 - 40]["initial"]
            assert value == expected
            snapshots[k] = value
    return dict(
        index=7**6,
        terms=7**6 + 1,
        current=current,
        sha256=digest.hexdigest(),
        snapshots=snapshots,
        status="PASS",
    )


def main(certificate_dir=None, output_dir=None):
    global ROOT, OUTPUT, edge_checks, literal_moves
    ROOT = (
        Path(certificate_dir) if certificate_dir is not None else REPO / "certificates"
    )
    OUTPUT = Path(output_dir) if output_dir is not None else REPO / "build/verification"
    OUTPUT.mkdir(parents=True, exist_ok=True)
    # A failed run must not leave an earlier PASS report at this destination.
    for name in ["certificate-verification.json", "direct-base-verification.json"]:
        (OUTPUT / name).unlink(missing_ok=True)
    edges.clear()
    edge_checks = 0
    literal_moves = 0
    single = check_single_marker()
    ladder = json.loads((ROOT / "ladder-machine.json").read_text())
    signed = json.loads((ROOT / "signed-machine.json").read_text())
    assert ladder["base"] == signed["base"] == 7
    assert signed["scale_start"] == 40 and signed["scale_period"] == 36
    for key in ladder["certificates"].keys() & signed["marker_certificates"].keys():
        assert ladder["certificates"][key] == signed["marker_certificates"][key]
    certs = {**ladder["certificates"], **signed["marker_certificates"]}
    for c in certs.values():
        check_marker(c)
    ladders = ladder["cases"] + signed["new_ladders"]
    for c in ladders:
        check_ladder(c, certs)
    lookup = {(r["case"]["offset"], tuple(r["case"]["core"])): r for r in ladders}
    assert len(lookup) == len(ladders)
    transitions = signed["transitions"]
    assert [r["k"] for r in transitions] == list(range(40, 76))
    for row in transitions:
        k = row["k"]
        m = 7**k
        sides, current = decode_initial(row["initial"])
        first_k = 6 + (k - 6) % 36
        first_m = 7**first_k
        assert first_m >= 7**6 and first_m % L == m % L
        sides, current = boundary(sides, current, row["inner"]["word"])
        inner = {int(s): [v[0], set(v[1])] for s, v in row["inner"]["sides"].items()}
        assert canonical(sides, current) == canonical(inner, row["inner"]["current"])
        s, x = current
        f, B = sides[s]
        assert f > 100
        cert = row["first_exit"]
        assert cert["sign"] == s and cert["residue"] == m % cert["modulus"]
        assert cert["initial_front"] == f and state(cert["initial_state"]) == (
            x - f,
            tuple(sorted(v - f for v in B)),
        )
        F, st, A = check_first(cert, sides[-s][0])
        active = (F, st)
        f0, B0 = sides[-s]
        assert max(B0, default=f0 - 1) < 100
        core = list(range(-100, f0)) + sorted(B0)
        assert row["core"]["core"] == core and row["core"]["offset"] == A
        used = A < f0 or A in B0
        assert used == row["anchor_used"]
        if used:
            r = lookup[A, tuple(core)]
            j = k - 4
            if j >= r["repeat_start"]:
                j = r["repeat_start"] + (j - r["repeat_start"]) % r["repeat_period"]
            check = triple(r["rows"][j]["state"])
            assert len(row["transfer_keys"]) == 1
            jfirst = first_k - 4
            assert jfirst >= r["repeat_start"]
            jfirst = (
                r["repeat_start"] + (jfirst - r["repeat_start"]) % r["repeat_period"]
            )
            assert check == triple(r["rows"][jfirst]["state"])
        else:
            occupied = set(core) | {A}
            f = -100
            while f in occupied:
                f += 1
            st = (A - f, tuple(sorted(v - f for v in occupied if v >= f)))
            for v in row["bottom"]:
                nxt, d, rel = direct_edge(st)
                assert f + rel == v
                f += d
                st = nxt
            assert f > A
            check = (f - A, st[0], st[1])
            assert len(row["transfer_keys"]) == 2
        for key in row["transfer_keys"]:
            c = certs[key]
            assert triple(c["initial"]) == check
            assert m % c["modulus"] == c["residue"]
            check = triple(c["output"])
        c = row["approach"]
        assert c["initial_front"] == check[0] and state(c["initial_state"]) == (
            check[1],
            check[2],
        )
        assert c["offset"] == A
        F2, st2 = check_approach(c, m)
        assert check_approach(c, first_m) == (F2, st2)
        F1, st1 = active
        outside = {
            s: [F1, {F1 + v for v in st1[1]}],
            -s: [F2, {F2 + v for v in st2[1]} | {A}],
        }
        assert A >= F2 and A not in {F2 + v for v in st2[1]}
        outcur = (-s, F2 + st2[0])
        for ss, (ff, BB) in outside.items():
            while ff in BB:
                BB.remove(ff)
                ff += 1
            outside[ss][0] = ff
        before = sum(f + len(B) for f, B in outside.values())
        assert before <= 3
        assert len(row["outer"]["word"]) == 3 - before
        final, cur = boundary(outside, outcur, row["outer"]["word"])
        assert canonical(final, cur) == row["output"]
        nextrow = transitions[(k - 40 + 1) % 36]
        assert row["output"] == nextrow["initial"]
    # Uniform separation uses only m>=7^6>100000, not the much larger
    # representative values used to discover the 36 transition records.
    assert 7**6 > 100000
    base = direct_signed_base(transitions)
    (OUTPUT / "direct-base-verification.json").write_text(
        json.dumps(base, indent=2) + "\n"
    )
    assert pow(7, 36, L) == 1
    minimum_front = min(f for row in transitions for s, f, B in row["initial"][1])
    assert minimum_front == -36
    summary = dict(
        status="PASS",
        single_marker=single,
        unique_marker_certificates=len(certs),
        ladder_cases=len(ladders),
        signed_scale_transitions=len(transitions),
        separate_direct_edge_checks=edge_checks,
        separate_literal_moves=literal_moves,
        uniform_spacing_minimum=2401,
        checked_locality_bound=2000,
        residue_modulus=L,
        exponent_period=36,
        scale_start=6,
        guaranteed_core_margin=37,
        base_terms=base["terms"],
        base_sha256=base["sha256"],
        scope="finite certificate audit plus the universal lemmas in the accompanying proof; no human or proof-assistant review",
    )
    (OUTPUT / "certificate-verification.json").write_text(
        json.dumps(summary, indent=2) + "\n"
    )
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificates", type=Path, default=REPO / "certificates")
    parser.add_argument("--output", type=Path, default=REPO / "build/verification")
    args = parser.parse_args()
    main(args.certificates, args.output)
