"""Rejection controls for DOI metadata and the immutable proof/evidence chain."""
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
    tests = ['unchanged', 'changed-proof', 'forged-proof-exception', 'old-evidence',
             'manuscript-math', 'bibliography', 'citation-doi', 'zenodo-doi',
             'original-input', 'missing-old-evidence', 'private-path', 'provenance-doi']
    for test in tests:
        with tempfile.TemporaryDirectory(prefix='heraclitus-doi-') as tmp:
            root = Path(tmp)/'package'
            shutil.copytree(args.package, root, ignore=shutil.ignore_patterns('build', '__pycache__'))
            path = root/'evidence/doi-1.1.0/update.json'
            report = json.loads(path.read_text())
            changed = None
            if test in {'changed-proof', 'forged-proof-exception'}:
                name = 'research/upper_scale_assembly/Theorem.lean'
                target = root/name; old = target.read_bytes(); target.write_bytes(old+b'\n-- changed\n')
                if test == 'forged-proof-exception':
                    report['editorial_changes'][name] = {'before_sha256': hashlib.sha256(old).hexdigest(),
                        'after_sha256': hashlib.sha256(target.read_bytes()).hexdigest()}
            elif test == 'old-evidence':
                target = root/'evidence/release-1.1.0/report.json';target.write_bytes(target.read_bytes()+b'\n')
            elif test == 'manuscript-math':
                changed = 'paper/base-seven-heraclitus.tex'
                target = root/changed;old = target.read_text();assert '32771' in old
                target.write_text(old.replace('32771', '32772', 1))
            elif test == 'bibliography':
                changed = 'paper/references.bib'
                target = root/changed;target.write_text(target.read_text().replace('Sloane', 'Different', 1))
            elif test == 'citation-doi':
                changed = 'CITATION.cff'
                target = root/changed;target.write_text(target.read_text().replace('24086002', '23912682'))
            elif test == 'zenodo-doi':
                changed = '.zenodo.json'
                target = root/changed;target.write_text(target.read_text().replace('24086002', '23912682'))
            elif test == 'original-input':
                target = root/'evidence/doi-1.1.0/original-inputs/CITATION.cff';target.write_bytes(target.read_bytes()+b'\n')
            elif test == 'missing-old-evidence':
                (root/'evidence/public-package/formal/run.json').unlink()
            elif test == 'private-path':
                target = root/'presentation/private.txt';target.parent.mkdir();target.write_text('private')
            elif test == 'provenance-doi':
                target = root/'EXPORT_PROVENANCE.json'
                provenance = json.loads(target.read_text());provenance['version_doi'] = '10.5281/zenodo.23912682'
                target.write_text(json.dumps(provenance))
            if changed:
                report['editorial_changes'][changed]['after_sha256'] = hashlib.sha256((root/changed).read_bytes()).hexdigest()
            path.write_text(json.dumps(report))
            manifest = root/'release-manifest.json';data = json.loads(manifest.read_text())
            data['files'] = {p.relative_to(root).as_posix(): {'bytes': p.stat().st_size,
                'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                for p in root.rglob('*') if p.is_file() and p != manifest}
            manifest.write_text(json.dumps(data))
            result = subprocess.run([sys.executable, str(root/'scripts/check_release.py')], capture_output=True, text=True)
            if (result.returncode == 0) != (test == 'unchanged'):
                raise RuntimeError(test+': '+result.stdout+result.stderr)
            if test != 'unchanged' and 'ValueError:' not in result.stderr:
                raise RuntimeError('Incidental failure: '+result.stderr)
            print('PASS '+test, flush=True)
    print('All 12 DOI/publication controls passed.')


if __name__ == '__main__':
    main()
