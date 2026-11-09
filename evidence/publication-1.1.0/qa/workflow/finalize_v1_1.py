"""Promote a checked 1.1.0 candidate locally; preserve published evidence.

No network operations. The candidate and its full-build receipts are immutable.
Only explicitly listed editorial inputs may change; no proof/checker/generator
mathematics or full-build runner change is permitted.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import zipfile

from export_v1_1 import allowed, encode, record

ROOT = Path(__file__).resolve().parents[1]
PROFILE = ROOT/'release/v1.1.0/public'
sys.path.insert(0, str(PROFILE/'scripts'))
from check_publication import EDITORIAL_FILES


def checked_files(directory):
    manifest_data = (directory/'release-manifest.json').read_bytes()
    manifest = json.loads(manifest_data)
    result = {}
    for name, expected in manifest['files'].items():
        if not allowed(name) or (directory/name).is_symlink():
            raise ValueError('Unsafe source: '+name)
        data = (directory/name).read_bytes()
        if record(data) != expected:
            raise ValueError('Source manifest mismatch: '+name)
        result[name] = data
    return result, manifest_data


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate', type=Path, required=True)
    parser.add_argument('--historical', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--publication-evidence', type=Path,
                        help='Post-promotion QA files; these do not replace the clean-build receipt')
    args = parser.parse_args()
    out = args.output.resolve()
    archive = Path(str(out)+'.zip')
    if ROOT/'build' not in out.parents or out.exists() or archive.exists():
        raise ValueError('Use a new output under build/')
    subprocess.run([sys.executable, str(args.candidate/'scripts/check_release.py')], check=True)
    files, candidate_manifest = checked_files(args.candidate)
    historical, historical_manifest = checked_files(args.historical)
    receipt = json.loads(files['evidence/release-1.1.0/report.json'])
    if receipt['status'] != 'PASS' or receipt['fresh_project_modules'] != 351 or not receipt['final_target_proved']:
        raise ValueError('Missing completed full proof build')
    evidence_prefix = 'evidence/publication-1.1.0/'
    changes = {}
    for name in sorted(EDITORIAL_FILES):
        source = ROOT/name if name.startswith('paper/') else PROFILE/name
        new = source.read_bytes()
        if new != files[name]:
            changes[name] = {'before_sha256': record(files[name])['sha256'],
                             'after_sha256': record(new)['sha256']}
            files[evidence_prefix+'original-inputs/'+name] = files[name]
            files[name] = new
    files['scripts/check_publication.py'] = (PROFILE/'scripts/check_publication.py').read_bytes()
    files[evidence_prefix+'candidate-manifest.json'] = candidate_manifest
    files[evidence_prefix+'candidate-EXPORT_PROVENANCE.json'] = files['EXPORT_PROVENANCE.json']
    files[evidence_prefix+'historical-manifest.json'] = historical_manifest
    history = {n: d for n, d in historical.items() if n.startswith('evidence/')}
    for name, data in history.items():
        if name in files and files[name] != data:
            raise ValueError('Conflicting historical evidence: '+name)
        files[name] = data
    promotion = {
        'version': '1.1.0', 'date': '2026-11-09',
        'scope': 'Editorial promotion of the fully built candidate; proof inputs unchanged.',
        'full_lean_build_repeated': False,
        'candidate_manifest_sha256': record(candidate_manifest)['sha256'],
        'historical_manifest_sha256': record(historical_manifest)['sha256'],
        'historical_evidence_files_preserved': len(history),
        'editorial_changes': changes,
        'fresh_build_report_sha256': record(files['evidence/release-1.1.0/report.json'])['sha256'],
    }
    files[evidence_prefix+'promotion.json'] = encode(promotion)
    if args.publication_evidence:
        for path in sorted(args.publication_evidence.rglob('*')):
            if not path.is_file():
                continue
            if path.is_symlink():
                raise ValueError('Symlink in publication QA')
            name = evidence_prefix+'qa/'+path.relative_to(args.publication_evidence).as_posix()
            if not allowed(name):
                raise ValueError('Unsafe publication QA path')
            files[name] = path.read_bytes()
    provenance = json.loads(files['EXPORT_PROVENANCE.json'])
    provenance['publication_status_at_export'] = 'final 1.1.0 package prepared for authorized GitHub publication'
    provenance['editorial_promotion'] = evidence_prefix+'promotion.json'
    provenance['historical_evidence_files_preserved'] = len(history)
    for name in changes:
        provenance['inputs'][name] = {'source': name if name.startswith('paper/') else 'release/v1.1.0/public/'+name,
                                      **record(files[name])}
    provenance['inputs']['scripts/check_publication.py'] = {
        'source': 'release/v1.1.0/public/scripts/check_publication.py',
        **record(files['scripts/check_publication.py'])}
    provenance['finalizer_sha256'] = record(Path(__file__).read_bytes())['sha256']
    files['EXPORT_PROVENANCE.json'] = encode(provenance)
    for name in files:
        if not allowed(name):
            raise ValueError('Disallowed publication path: '+name)
    files['release-manifest.json'] = encode({'schema_version': 1, 'version': '1.1.0',
        'scope': 'Exact distribution inventory except this manifest; byte identity is not mathematical truth.',
        'files': {n: record(d) for n, d in sorted(files.items())}})
    out.mkdir(parents=True)
    for name, data in files.items():
        path = out/name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    subprocess.run([sys.executable, str(out/'scripts/check_release.py')], check=True)
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for name, data in sorted(files.items()):
            entry = zipfile.ZipInfo('heraclitus-base7-1.1.0/'+name, (2026,11,9,0,0,0))
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.external_attr = 0o100644 << 16
            z.writestr(entry, data)
    print(json.dumps({'directory': str(out), 'archive': str(archive), 'files': len(files),
                      'archive_sha256': record(archive.read_bytes())['sha256'],
                      'editorial_changes': sorted(changes),
                      'historical_evidence_preserved': len(history)}, indent=2))


if __name__ == '__main__':
    main()
