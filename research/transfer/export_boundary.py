"""Bind all 72 finite boundary words to untrusted Lean data with proof goals.

Reads only committed signed-machine.json. The exporter reconstructs fronts
after visits but does not prove choices or endpoints; Lean must prove both
for every sufficiently large power-of-seven scale using SignedCertificate.
No src/ or checker imports. Default mode checks binding without writing.
"""

import argparse
import hashlib
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SOURCE = REPO / "certificates/signed-machine.json"
TARGET = REPO / "formal/Heraclitus/SignedBoundaryData.lean"


def integer(x):
    if type(x) is not int:
        raise ValueError("Not an integer")
    return str(x) if x >= 0 else f"({x})"


def sequence(xs):
    return "[" + ", ".join(integer(x) for x in xs) + "]"


def boolean(sign):
    if sign not in (-1, 1):
        raise ValueError("Invalid side")
    return "true" if sign == 1 else "false"


def record(current, sides):
    rays = [f"⟨{integer(sides[s][0])}, {sequence(sorted(sides[s][1]))}⟩" for s in (1, -1)]
    return f"⟨{boolean(current[0])}, {integer(current[1])}, {rays[0]}, {rays[1]}⟩"


def moves(sides, word):
    state = {s: [f, set(points)] for s, (f, points) in sides.items()}
    rows = []
    for side, value in word:
        f, points = state[side]
        if value < f or value in points:
            raise ValueError("Repeated destination in source boundary word")
        points.add(value)
        while f in points:
            points.remove(f)
            f += 1
        state[side][0] = f
        rows.append(f"⟨{boolean(side)}, {integer(value)}, {integer(f)}⟩")
    return "[\n  " + ",\n  ".join(rows) + "\n]"


def render():
    raw = SOURCE.read_bytes()
    data = json.loads(raw)
    if data["base"] != 7 or [row["k"] for row in data["transitions"]] != list(range(40, 76)):
        raise ValueError("Incomplete base-seven phase catalogue")
    chunks = ["import Heraclitus.SignedCertificate\n",
              "set_option autoImplicit false\nset_option maxRecDepth 20000\nset_option maxHeartbeats 40000000\n",
              "/- Generated data and kernel proof goals; use research/transfer/export_boundary.py.\n",
              "Source SHA-256: " + hashlib.sha256(raw).hexdigest() + "\n-/\n",
              "namespace Heraclitus.SignedBoundaryData\nopen SignedCertificate\n"]
    names, summary = [], []
    for row in data["transitions"]:
        first, approach = row["first_exit"], row["approach"]
        s, F1, F2, A = first["sign"], first["front"], approach["front"], first["entry"]
        outer_sides = {
            s: [F1, {F1 + x for x in first["state"][1]}],
            -s: [F2, {F2 + x for x in approach["state"][1]} | {A}],
        }
        for ray in outer_sides.values():
            while ray[0] in ray[1]:
                ray[1].remove(ray[0])
                ray[0] += 1
        stages = [
            ("inner", row["initial"][0], {s: [f, points] for s, f, points in row["initial"][1]},
             row["inner"]["current"], {int(s): value for s, value in row["inner"]["sides"].items()},
             row["inner"]["word"]),
            ("outer", [-s, F2 + approach["state"][0]], outer_sides,
             row["output"][0], {s: [f, points] for s, f, points in row["output"][1]},
             row["outer"]["word"]),
        ]
        for stage, cur, sides, final_cur, final_sides, word in stages:
            name = f"row{row['k']}_{stage}"
            names.append(name)
            chunks += [f"\ndef {name}_initial : Record := {record(cur, sides)}\n",
                       f"def {name}_final : Record := {record(final_cur, final_sides)}\n",
                       f"def {name}_moves : List Move := {moves(sides, word)}\n",
                       f"theorem {name}_valid : wordCheck {name}_initial {name}_moves = true := by decide +kernel\n",
                       f"theorem {name}_closes : ({name}_initial.run {name}_moves).equalityCheck {name}_final = true := by decide +kernel\n",
                       f"def {name} : CheckedBoundary :=\n",
                       f"  ⟨{row['k']}, {'true' if stage == 'outer' else 'false'}, {name}_initial, {name}_final, {name}_moves, {name}_valid, {name}_closes⟩\n"]
            summary.append(dict(label=row["k"], stage=stage, choices=len(word)))
    chunks += ["\ndef catalogue : List CheckedBoundary := [\n  " + ",\n  ".join(names) + "\n]\n",
               "theorem labels_complete : catalogue.map (fun b => (b.label, b.outer)) =\n  [" +
               ", ".join(f"({k}, {b})" for k in range(40, 76) for b in ("false", "true")) + "] := by decide +kernel\n",
               "\nend Heraclitus.SignedBoundaryData\n"]
    return "".join(chunks), summary


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    content, summary = render()
    if args.write:
        TARGET.write_text(content)
    elif not TARGET.is_file() or TARGET.read_text() != content:
        raise SystemExit("Signed boundary source binding failed")
    print(json.dumps(dict(status="written" if args.write else "matches", words=len(summary),
                          choices=sum(row["choices"] for row in summary),
                          source_sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest())))
