"""Adversarial examples: these tests do not use the generator's transition logic."""

import copy
import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "certificate_checker", REPO / "checker/check_certificate.py"
)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


def read(name):
    return json.loads((REPO / "certificates" / name).read_text())


class CertificateRejectionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ladder = read("ladder-machine.json")
        cls.signed = read("signed-machine.json")
        cls.marker = next(iter(cls.ladder["certificates"].values()))

    def check_single_document(self, doc):
        with tempfile.TemporaryDirectory() as directory:
            old = checker.ROOT
            try:
                checker.ROOT = Path(directory)
                (checker.ROOT / "single-marker-7.json").write_text(json.dumps(doc))
                return checker.check_single_marker()
            finally:
                checker.ROOT = old

    def test_missing_auxiliary_edge_is_rejected(self):
        doc = read("single-marker-7.json")
        doc["edges"].pop()
        with self.assertRaises(AssertionError):
            self.check_single_document(doc)

    def test_missing_incoming_case_is_rejected(self):
        doc = read("single-marker-7.json")
        doc["cases"] = [
            c
            for c in doc["cases"]
            if not (c["kind"] == "incoming" and c["source"] == 7)
        ]
        with self.assertRaises(AssertionError):
            self.check_single_document(doc)

    def test_wrong_greedy_choice_is_rejected(self):
        cert = copy.deepcopy(self.marker)
        cert["cycle"][0][3] += 1
        with self.assertRaises(AssertionError):
            checker.check_marker(cert)

    def test_wrong_translation_shift_is_rejected(self):
        cert = copy.deepcopy(self.marker)
        cert["cycle"][0][2] += 1
        with self.assertRaises(AssertionError):
            checker.check_marker(cert)

    def test_wrong_marker_output_is_rejected(self):
        cert = copy.deepcopy(self.marker)
        cert["output"][0] += 1
        with self.assertRaises(AssertionError):
            checker.check_marker(cert)

    def test_wrong_marker_residue_is_rejected(self):
        cert = copy.deepcopy(
            next(c for c in self.ladder["certificates"].values() if c["modulus"] > 1)
        )
        cert["residue"] = (cert["residue"] + 1) % cert["modulus"]
        with self.assertRaises(AssertionError):
            checker.check_marker(cert)

    def test_missing_referenced_transfer_is_rejected(self):
        case = self.ladder["cases"][0]
        certs = dict(self.ladder["certificates"])
        del certs[case["rows"][0]["transfers"][0]]
        with self.assertRaises(KeyError):
            checker.check_ladder(case, certs)

    def test_broken_ladder_closure_is_rejected(self):
        case = copy.deepcopy(self.ladder["cases"][0])
        case["rows"][-1]["state"][0] += 1
        with self.assertRaises(AssertionError):
            checker.check_ladder(case, self.ladder["certificates"])

    def test_reversed_sign_tie_is_rejected(self):
        # At current offset -3 on the negative side, both a same-side
        # step 7 and the reflected candidate reach offset 4. Positive wins.
        sides = {1: [4, set()], -1: [4, set()]}
        _, current = checker.boundary(sides, (-1, -3), [[1, 4]])
        self.assertEqual(current, (1, 4))
        with self.assertRaises(AssertionError):
            checker.boundary(sides, (-1, -3), [[-1, 4]])

    def test_missing_scale_row_is_rejected_by_real_main(self):
        # No integrity-hash shortcut: the mathematical checker sees the edited JSON.
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            for name in [
                "single-marker-7.json",
                "ladder-machine.json",
                "signed-machine.json",
            ]:
                doc = read(name)
                if name == "signed-machine.json":
                    doc["transitions"].pop()
                (directory / name).write_text(json.dumps(doc))
            result = subprocess.run(
                [
                    sys.executable,
                    str(REPO / "checker/check_certificate.py"),
                    "--certificates",
                    str(directory),
                    "--output",
                    str(directory / "out"),
                ],
                capture_output=True,
                text=True,
                timeout=120,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("AssertionError", result.stderr)
            self.assertFalse((directory / "out/certificate-verification.json").exists())

    def test_missing_file_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            result = subprocess.run(
                [
                    sys.executable,
                    str(REPO / "checker/check_certificate.py"),
                    "--certificates",
                    directory,
                    "--output",
                    str(Path(directory) / "out"),
                ],
                capture_output=True,
                text=True,
                timeout=30,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("FileNotFoundError", result.stderr)

    def test_optimized_python_is_refused(self):
        for name in [
            "checker/check_certificate.py",
            "checker/check_crossing_corollary.py",
            "checker/check_reduction_obligations.py",
            "scripts/verify.py",
            "src/generate_certificate.py",
        ]:
            result = subprocess.run(
                [sys.executable, "-O", str(REPO / name)],
                capture_output=True,
                text=True,
                timeout=30,
            )
            self.assertNotEqual(result.returncode, 0, name)
            self.assertIn("-O", result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
