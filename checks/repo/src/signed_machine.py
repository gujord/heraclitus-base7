"""Finite reduction of the signed scale transition.

Large spacings are handled by explicit cycle formulas and the certified
ladder machine. The proof obligations for arbitrary larger powers are
recorded separately, not inferred from numerical boundary repetition.
"""

import json, math
from pathlib import Path
from local_closure import next_state, normalize
from marker_machine import transfer, core_checkpoint, run_case


def frozen(s):
    return (s[0], s[1], tuple(s[2]))


def orbit(state):
    route = []
    seen = {}
    cur = state
    while cur not in seen:
        assert len(route) < 100000
        seen[cur] = len(route)
        nxt, d, v = next_state(7, cur)
        route.append((cur, nxt, d, v))
        cur = nxt
    cut = seen[cur]
    pre, cyc = route[:cut], route[cut:]
    P = len(cyc)
    shift = 0
    W = []
    prev = []
    shifts = []
    for st, nxt, d, v in cyc:
        shifts.append(shift)
        prev.append(shift + st[0])
        W.append(shift + v)
        shift += d
    assert shift == P and len({v % P for v in W}) == P
    return pre, cyc, P, W, prev, shifts


class Boundary:
    def __init__(self, sides, current):
        self.sides = {s: [v[0], set(v[1])] for s, v in sides.items()}
        self.current = current
        self.words = []

    def used(self, s, x):
        f, B = self.sides[s]
        return x < f or x in B

    def add(self, s, x):
        f, B = self.sides[s]
        assert not self.used(s, x)
        B.add(x)
        while f in B:
            B.remove(f)
            f += 1
        self.sides[s][0] = f

    def one(self):
        s, x = self.current
        p = 1
        while self.used(s, x + p):
            p *= 7
        options = [(s, x + p)]
        p = 1
        # Only neighbors better than the available forward bound are needed.
        while p <= max(x - self.sides[s][0], options[0][1] - x):
            for z in [x - p, x + p]:
                if not self.used(s, z):
                    options.append((s, z))
            p *= 7
        if not self.used(-s, 1 - x):
            options.append((-s, 1 - x))
        nxt = min(options, key=lambda z: (z[1], -z[0]))
        self.add(*nxt)
        self.current = nxt
        self.words.append(nxt)

    def weight(self):
        return sum(f + len(B) for f, B in self.sides.values())

    def serialize(self):
        return dict(
            sides={str(s): [f, sorted(B)] for s, (f, B) in self.sides.items()},
            current=self.current,
            word=self.words,
        )


def parse_snapshot(row):
    C = (row["n"] - 1) // 2
    sides = {}
    for s, name in [(1, "positive"), (-1, "negative")]:
        iv = row[name]
        f = iv[0][1] + 1 - C
        B = []
        for l, r in iv[1:]:
            B.extend(range(l - C, r - C + 1))
        sides[s] = (f, B)
    return sides, (1 if row["current"] > 0 else -1, abs(row["current"]) - C)


def canonical(sides, current):
    return [list(current), [[s, sides[s][0], sorted(sides[s][1])] for s in [1, -1]]]


def first_exit(s, f, state, m):
    pre, cyc, P, W, prev, shifts = orbit(state)
    startf = f
    prefix_points = []
    for st, nxt, d, v in pre:
        prefix_points.append(f + v)
        f += d
    # Candidate on the other ray wins ties exactly when it is positive.
    threshold = 6 * m + 1 - 2 * f
    options = []
    for i in range(P):
        need = threshold - prev[i] - W[i] + (1 if s > 0 else 0)
        q = max(0, -((-need) // (2 * P)))
        options.append((q, i))
    q, i = min(options)
    F = f + q * P + shifts[i] - 3 * m
    st = cyc[i][0]
    old = F + st[0]
    A = 1 - old
    certificate = dict(
        sign=s,
        initial_front=startf,
        initial_state=state,
        prefix=pre,
        cycle=cyc,
        modulus=P,
        residue=m % P,
        phase=i,
        front=F,
        state=st,
        entry=A,
        prefix_points=prefix_points,
    )
    return (F, st[0], st[1]), A, certificate


def approach_outer(f, state, m, A):
    # Here the preceding endpoint is at 2m+A, so f is relative to it.
    pre, cyc, P, W, prev, shifts = orbit(state)
    startf = f
    prefix_points = []
    for st, nxt, d, v in pre:
        prefix_points.append(f + v)
        f += d
    # Stop a full 256 positions short of the outer central coordinate 3m.
    q = (m - A - 256 - f) // P
    assert q >= 0
    F = 2 * m + A + f + q * P - 3 * m
    st = cyc[0][0]
    assert -256 - P < F <= -256
    assert max(W) - P < 200 and max(st[1], default=0) < 200
    certificate = dict(
        initial_front=startf,
        initial_state=state,
        prefix=pre,
        cycle=cyc,
        modulus=P,
        residue=m % P,
        offset=A,
        front=F,
        state=st,
        prefix_points=prefix_points,
    )
    return (F, st[0], st[1]), certificate


def initial_after_A(core, A):
    B = set(core) | {A}
    f = -100
    while f in B:
        f += 1
    state = (A - f, tuple(sorted(x - f for x in B if x >= f)))
    word = []
    while f <= A:
        nxt, d, v = next_state(7, state)
        word.append(f + v)
        f += d
        state = nxt
    return (f - A, state[0], state[1]), word


def build(input_dir, output_dir):
    rows = [
        json.loads(x)
        for x in (input_dir / "base7-prefix-states.jsonl").read_text().splitlines()
    ]
    rows += [
        json.loads(x)
        for x in (input_dir / "base7-cont-states.jsonl").read_text().splitlines()
    ]
    rows = {s["k"]: s for s in rows}
    ladder = json.loads((output_dir / "ladder-machine.json").read_text())
    ladders = {
        (r["case"]["offset"], tuple(r["case"]["core"])): r for r in ladder["cases"]
    }
    certs = {}
    results = []
    new_ladders = []
    for k in range(40, 76):
        m = 7**k
        sides, current = parse_snapshot(rows[k])
        initial = canonical(sides, current)
        inner = Boundary(sides, current)
        while inner.sides[inner.current[0]][0] <= 100:
            inner.one()
            assert len(inner.words) < 10000
        s = inner.current[0]
        f, B = inner.sides[s]
        c = inner.current[1] - f
        active, A, exitcert = first_exit(s, f, (c, tuple(sorted(x - f for x in B))), m)
        f0, B0 = inner.sides[-s]
        assert max(B0, default=f0 - 1) < 100
        core = list(range(-100, f0)) + sorted(B0)
        anchor_used = A < f0 or A in B0
        corecase = dict(k=k, offset=A, core=core)
        transferkeys = []
        if anchor_used:
            key = (A, tuple(core))
            if key not in ladders:
                r = run_case(corecase, 4, certs)
                ladders[key] = r
                new_ladders.append(r)
            r = ladders[key]
            j = k - 4
            if j >= r["repeat_start"]:
                j = r["repeat_start"] + (j - r["repeat_start"]) % r["repeat_period"]
            # Row state is the checkpoint at A+7^k, before the next six cells.
            check = frozen(r["rows"][j]["state"])
            bottom = None
            ladder_key = [A, core]
        else:
            check, bottom = initial_after_A(core, A)
            ladder_key = None
            check, P, H, key = transfer(7, check, m, certs)
            transferkeys.append(key)
        # In either case the checkpoint is now just beyond m+A.
        check, P, H, key = transfer(7, check, m, certs)
        transferkeys.append(key)
        final_side, approach = approach_outer(check[0], (check[1], check[2]), m, A)
        F, c, B = active
        out_sides = {s: (F, [F + x for x in B])}
        F, c, B = final_side
        out_sides[-s] = (F, [F + x for x in B] + [A])
        outer = Boundary(out_sides, (-s, F + c))
        # The last head endpoint was already used, not newly visited here.
        for ss in [s, -s]:
            ff, BB = outer.sides[ss]
            while ff in BB:
                BB.remove(ff)
                ff += 1
            outer.sides[ss][0] = ff
        assert outer.weight() <= 3
        while outer.weight() < 3:
            outer.one()
            assert len(outer.words) < 10000
        target = canonical(outer.sides, outer.current)
        expected = canonical(*parse_snapshot(rows[40 if k == 75 else k + 1]))
        assert target == expected, (k, target, expected)
        result = dict(
            k=k,
            initial=initial,
            inner=inner.serialize(),
            first_exit=exitcert,
            core=corecase,
            anchor_used=anchor_used,
            ladder_key=ladder_key,
            bottom=bottom,
            transfer_keys=transferkeys,
            approach=approach,
            outer=outer.serialize(),
            output=target,
        )
        results.append(result)
        print(
            k,
            "entry",
            A,
            "ladder",
            anchor_used,
            "periods",
            exitcert["modulus"],
            approach["modulus"],
            "inner/outer",
            len(inner.words),
            len(outer.words),
            "MATCH",
            flush=True,
        )
    out = dict(
        base=7,
        scale_start=40,
        scale_period=36,
        transitions=results,
        marker_certificates=certs,
        new_ladders=new_ladders,
    )
    (output_dir / "signed-machine.json").write_text(
        json.dumps(out, separators=(",", ":")) + "\n"
    )
    print(
        "DONE",
        len(results),
        "scale transitions",
        len(certs),
        "new marker certificates",
        len(new_ladders),
        "new ladders",
    )
