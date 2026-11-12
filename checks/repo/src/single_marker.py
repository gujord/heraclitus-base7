"""Exact finite state certificates for one additional preused point.

Normalized half-line states have a filled negative prefix, least hole 0,
current c and a finite tuple of used nonnegative coordinates. This module
uses neighbor enumeration; checker/check_certificate.py uses direct candidate
scanning and does not import this module.
"""

import json, sys, time
from pathlib import Path
from local_closure import normalize, next_state


def build(output_dir, b=7, incoming_bound=None):
    if incoming_bound is None:
        incoming_bound = b
    states = []
    state_id = {}
    edges = []
    cycles = []
    owner = {}
    results = []

    def get(s):
        if s not in state_id:
            state_id[s] = len(states)
            states.append(s)
            edges.append(None)
        return state_id[s]

    def follow(seed, kind, source):
        route = []
        local = {}
        cur = get(seed)
        while cur not in owner and cur not in local:
            assert len(states) < 1000000
            local[cur] = len(route)
            route.append(cur)
            nxt, shift, value = next_state(b, states[cur])
            j = get(nxt)
            edges[cur] = [j, shift, value]
            cur = j
        if cur in owner:
            cid = owner[cur]
        else:
            cid = len(cycles)
            cycles.append(route[local[cur] :])
        for i in route:
            owner[i] = cid
        results.append(dict(kind=kind, source=source, start=get(seed), cycle=cid))

    for d in range(1, incoming_bound + 1):
        follow((-d, ()), "incoming", d)
    root_cycles = list(range(len(cycles)))
    root_states = list(range(len(states)))
    for i in root_states:
        c, B = states[i]
        v = edges[i][2]
        seed, shift = normalize(c, set(B) | {v})
        follow(seed, "marker", [i, shift, v])
    out = dict(
        base=b,
        incoming_bound=incoming_bound,
        states=states,
        edges=edges,
        cycles=cycles,
        root_cycles=root_cycles,
        cases=results,
    )
    tag = f"{b}" if incoming_bound == b else f"{b}-d{incoming_bound}"
    target = output_dir / f"single-marker-{tag}.json"
    target.write_text(json.dumps(out, separators=(",", ":")) + "\n")
    summary = dict(
        base=b,
        incoming_cases=incoming_bound,
        marker_cases=len(root_states),
        states=len(states),
        root_periods=[len(cycles[i]) for i in root_cycles],
        resulting_periods=[len(c) for c in cycles],
        max_used_coordinate=max(max(s[1], default=-1) for s in states),
        min_current=min(s[0] for s in states),
        max_current=max(s[0] for s in states),
        max_candidate=max(e[2] for e in edges),
    )
    (output_dir / f"single-marker-{tag}-summary.json").write_text(
        json.dumps(summary, indent=2) + "\n"
    )
    print(json.dumps(summary, indent=2))
