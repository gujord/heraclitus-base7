"""Symbolic-in-spacing transfer past an isolated preused endpoint.

Input (f,c,B) is relative to a completed endpoint at 0: the least hole
is f>0, all values below f are used, current=f+c, and used values above
the front are f+B. The next endpoint is at h. A transfer is valid for
every sufficiently large h in a certified residue class modulo P.
"""

import json, sys, math
from pathlib import Path
from local_closure import normalize, next_state


def core_checkpoint(case, J=4):
    end = case["offset"] + 7**J
    used = set(case["core"]) | {end}
    current = end
    f = -100
    while f in used:
        f += 1
    c = current - f
    B = tuple(sorted(x - f for x in used if x >= f))
    word = []
    maximum = end
    while f <= end:
        nxt, shift, v = next_state(7, (c, B))
        word.append(f + v)
        maximum = max(maximum, f + v)
        f += shift
        c, B = nxt
        assert len(word) < 1000000
    assert maximum < end + 7**J
    return (f - end, c, B), dict(J=J, end=end, word=word, max_coordinate=maximum)


def transfer(b, initial, h, certificates):
    f, c, B = initial
    start = (c, B)
    route = []
    lookup = {}
    cur = start
    while cur not in lookup:
        assert len(route) < 100000
        lookup[cur] = len(route)
        nxt, shift, v = next_state(b, cur)
        route.append((cur, nxt, shift, v))
        cur = nxt
    cut = lookup[cur]
    prefix = route[:cut]
    cycle = route[cut:]
    P = len(cycle)
    H = max(0, f + max(B, default=0))
    for st, nxt, shift, v in prefix:
        H = max(H, f + v)
        f += shift
    W = []
    shifts = []
    d = 0
    for st, nxt, shift, v in cycle:
        shifts.append(d)
        W.append(d + v)
        d += shift
    assert d == P and len({v % P for v in W}) == P
    phase = next(i for i, v in enumerate(W) if (h - f - v) % P == 0)
    q = (h - f - W[phase]) // P
    H = max(H, f + W[phase] - 1, max(W) - min(W) + P)
    assert q >= 0
    newf = shifts[phase] - W[phase]
    state = cycle[phase][0]
    oldc, oldB = state
    assert -newf == cycle[phase][3]
    state, shift = normalize(oldc, set(oldB) | {-newf})
    newf += shift
    repair = []
    while newf <= 0:
        nxt, shift, v = next_state(b, state)
        H = max(H, newf + v)
        repair.append((state, nxt, shift, v))
        newf += shift
        state = nxt
        assert len(repair) < 100000
    H = max(H, newf + max(state[1], default=0))
    assert h > H, (h, H)
    output = (newf, state[0], state[1])
    key = (initial, h % P)
    item = dict(
        initial=initial,
        modulus=P,
        residue=h % P,
        threshold=H,
        prefix=prefix,
        cycle=cycle,
        phase=phase,
        repair=repair,
        output=output,
    )
    encoded = json.dumps(item, separators=(",", ":"))
    key = json.dumps([initial, P, h % P], separators=(",", ":"))
    if key in certificates:
        assert certificates[key] == item
    else:
        certificates[key] = item
    return output, P, H, key


def run_case(case, J, certs):
    initial, core = core_checkpoint(case, J)
    state = initial
    h = 7**J
    seen = {}
    rows = []
    L = 1
    for level in range(J, J + 200):
        # Record the exact finite local state and the residue of this power.
        # Later, recompute all keys after the final lcm has been determined.
        row = dict(level=level, state=state, h=h, transfers=[])
        for _ in range(6):
            state, P, H, key = transfer(7, state, h, certs)
            L = math.lcm(L, P)
            row["transfers"].append(key)
        row["output"] = state
        rows.append(row)
        h *= 7
        normalized = {}
        for i, r in enumerate(rows):
            key = (r["state"], r["h"] % L)
            if key in normalized:
                # A repeated state at the BEGINNING of a level is enough. The final
                # row is redundant and retained as a check, but not needed for induction.
                begin = normalized[key]
                period = i - begin
                return dict(
                    case=case,
                    J=J,
                    core=core,
                    initial=initial,
                    modulus=L,
                    repeat_start=begin,
                    repeat_period=period,
                    rows=rows,
                )
            normalized[key] = i
    raise RuntimeError("No closure within 200 levels")


def build(input_dir, output_dir):
    raw = json.loads((input_dir / "ladder-cores.json").read_text())
    chosen = []
    seen = set()
    for case in raw:
        if not case["anchor_used"] or not case.get("only_entry_above_core", False):
            continue
        key = (case["offset"], tuple(case["core"]))
        if key in seen:
            continue
        seen.add(key)
        chosen.append({k: case[k] for k in ["k", "offset", "core"]})
    certs = {}
    results = []
    for case in chosen:
        result = run_case(case, 4, certs)
        results.append(result)
        print(
            "case",
            case["k"],
            case["offset"],
            "modulus",
            result["modulus"],
            "transient",
            result["repeat_start"],
            "period",
            result["repeat_period"],
            "certificates",
            len(certs),
            flush=True,
        )
    out = dict(base=7, certificates=certs, cases=results)
    (output_dir / "ladder-machine.json").write_text(
        json.dumps(out, separators=(",", ":")) + "\n"
    )
    print("DONE", len(results), "cases", len(certs), "certificates", flush=True)
