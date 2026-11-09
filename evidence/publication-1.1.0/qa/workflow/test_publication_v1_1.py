"""Negative controls for the final publication boundary, not theorem tests."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--package', type=Path, required=True)
    args = parser.parse_args()
    source = args.package.resolve()
    tests = ['unchanged', 'proof-with-edited-manifest', 'forged-proof-promotion',
             'historical-evidence', 'manuscript-math', 'original-input',
             'missing-old-evidence', 'private-path', 'current-coverage-guide',
             'historical-coverage-guide-binding']
    for test in tests:
        with tempfile.TemporaryDirectory(prefix='heraclitus-publication-') as tmp:
            root = Path(tmp)/'package'
            shutil.copytree(source, root, ignore=shutil.ignore_patterns('build', '__pycache__'))
            meta = root/'evidence/publication-1.1.0/promotion.json'
            promotion = json.loads(meta.read_text())
            if test in {'proof-with-edited-manifest', 'forged-proof-promotion'}:
                name = 'research/upper_scale_assembly/Theorem.lean'
                path = root/name
                old = path.read_bytes()
                path.write_bytes(old+b'\n-- unexpected proof edit\n')
                if test == 'forged-proof-promotion':
                    copy = root/'evidence/publication-1.1.0/original-inputs'/name
                    copy.parent.mkdir(parents=True); copy.write_bytes(old)
                    promotion['editorial_changes'][name] = {
                        'before_sha256': hashlib.sha256(old).hexdigest(),
                        'after_sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
            elif test == 'historical-evidence':
                path = root/'evidence/public-package/formal/run.json'
                path.write_bytes(path.read_bytes()+b'\n')
            elif test == 'manuscript-math':
                name = 'paper/base-seven-heraclitus.tex'
                path = root/name
                old = path.read_text()
                assert '32771' in old
                path.write_text(old.replace('32771', '32772', 1))
                promotion['editorial_changes'][name]['after_sha256'] = hashlib.sha256(path.read_bytes()).hexdigest()
            elif test == 'original-input':
                path = root/'evidence/publication-1.1.0/original-inputs/README.md'
                path.write_bytes(path.read_bytes()+b'\n')
            elif test == 'missing-old-evidence':
                (root/'evidence/public-package/formal/run.json').unlink()
            elif test == 'private-path':
                path = root/'presentation/private.txt'; path.parent.mkdir();path.write_text('private')
            elif test == 'current-coverage-guide':
                path = root/'formal/README.md';path.write_bytes(path.read_bytes()+b'\n')
            elif test == 'historical-coverage-guide-binding':
                path = root/'evidence/publication-1.1.0/historical-manifest.json'
                history = json.loads(path.read_text())
                history['files']['formal/README.md']['sha256'] = '0'*64
                path.write_text(json.dumps(history))
                promotion['historical_manifest_sha256'] = hashlib.sha256(path.read_bytes()).hexdigest()
            meta.write_text(json.dumps(promotion))
            manifest = root/'release-manifest.json'
            data = json.loads(manifest.read_text())
            data['files'] = {
                p.relative_to(root).as_posix(): {'bytes': p.stat().st_size,
                    'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                for p in root.rglob('*') if p.is_file() and p != manifest}
            manifest.write_text(json.dumps(data))
            result = subprocess.run([sys.executable, str(root/'scripts/check_release.py')],
                                    capture_output=True, text=True)
            passed = result.returncode == 0 if test == 'unchanged' else result.returncode != 0
            if not passed:
                raise RuntimeError(test+' unexpectedly accepted/rejected: '+result.stdout+result.stderr)
            if test != 'unchanged' and 'ValueError:' not in result.stderr:
                raise RuntimeError('Incidental failure: '+result.stderr)
            print('PASS '+test, flush=True)
    print('All 10 publication controls passed.')


if __name__ == '__main__':
    main()
