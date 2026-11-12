"""Generator-only half-line neighbor enumeration; never imported by the checker.
A state (c,B) has all coordinates <0 used/forbidden, 0 unused, B finite
used coordinates above 0, and current c used (possibly negative).
"""


def normalize(c, B):
    front = 0
    while front in B:
        front += 1
    return (c - front, tuple(sorted(x - front for x in B if x >= front))), front


def next_state(b, state):
    c, points = state
    B = set(points)
    p = 1
    while c + p < 0 or c + p in B:
        p *= b
    v = c + p
    p = 1
    while p <= max(c, v - c):
        for x in (c - p, c + p):
            if 0 <= x < v and x not in B:
                v = x
        p *= b
    B.add(v)
    s, shift = normalize(v, B)
    return s, shift, v
