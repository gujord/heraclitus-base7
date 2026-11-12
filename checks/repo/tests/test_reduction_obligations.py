"""Reject missing hypotheses of the universal approach argument."""

import copy
import importlib.util
import json
from pathlib import Path
import sys
import unittest

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "checker"))
spec = importlib.util.spec_from_file_location(
    "reduction_audit", REPO / "checker/check_reduction_obligations.py"
)
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class ReductionPremiseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        doc = json.loads((REPO / "certificates/signed-machine.json").read_text())
        cls.row = doc["transitions"][0]

    def test_modular_front_does_not_prove_nonnegative_cycle_count(self):
        cert = self.row["approach"]
        # m=1 has the same residue as 7**40 modulo 8. The old modular
        # identity passes although the prescribed cycle count is negative.
        audit.checker.check_approach(cert, 1)
        with self.assertRaises(AssertionError):
            audit.approach_at(cert, 1)

    def test_modular_front_does_not_prove_marker_separation(self):
        cert = copy.deepcopy(self.row["approach"])
        # Preserve every modular front equation while moving the marker
        # below the cutoff used in the prose. This is a local-contract
        # counterexample, not a reachable signed state or theorem disproof.
        cert["offset"] -= 13 * cert["modulus"]
        audit.checker.check_approach(cert, 7**40)
        with self.assertRaises(AssertionError):
            audit.approach_at(cert, 7**40)


if __name__ == "__main__":
    unittest.main()
