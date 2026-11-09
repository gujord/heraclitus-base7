"""Prepare the DOI-corrected 1.1.0 package without any remote mutation."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import zipfile

from export_v1_1 import allowed, encode, record
from finalize_v1_1 import checked_files

ROOT = Path(__file__).resolve().parents[1]
PROFILE = ROOT/'release/v1.1.0/public'
sys.path.insert(0, str(PROFILE/'scripts'))
from check_doi_update import DOI, DOI_FILES


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--qa', type=Path)
    args = parser.parse_args()
    out = args.output.resolve()
    archive = Path(str(out)+'.zip')
    if ROOT/'build' not in out.parents or out.exists() or archive.exists():
        raise ValueError('Use a new directory under build/')
    source = args.source.resolve()
    subprocess.run([sys.executable, str(source/'scripts/check_release.py')], check=True)
    files, previous_manifest = checked_files(source)
    if json.loads(previous_manifest)['version'] != '1.1.0' or 'evidence/doi-1.1.0/update.json' in files:
        raise ValueError('Expected the original public 1.1.0 package')
    prefix = 'evidence/doi-1.1.0/'
    changes = {}
    for name in sorted(DOI_FILES):
        path = ROOT/name if name.startswith('paper/') else PROFILE/name
        new = path.read_bytes()
        if new == files[name]:
            raise ValueError('Expected DOI editorial update missing: '+name)
        changes[name] = {'before_sha256': record(files[name])['sha256'],
                         'after_sha256': record(new)['sha256']}
        files[prefix+'original-inputs/'+name] = files[name]
        files[name] = new
    files['scripts/check_doi_update.py'] = (PROFILE/'scripts/check_doi_update.py').read_bytes()
    files[prefix+'previous-release-manifest.json'] = previous_manifest
    files[prefix+'previous-EXPORT_PROVENANCE.json'] = files['EXPORT_PROVENANCE.json']
    files[prefix+'update.json'] = encode({
        'version': '1.1.0', 'doi': DOI, 'date': '2026-11-09',
        'doi_source': 'Supplied by Roger for the new Zenodo version.',
        'zenodo_published_by_this_workflow': False,
        'scope': 'DOI editorial update; all prior evidence and mathematical inputs unchanged.',
        'full_lean_build_repeated': False,
        'previous_manifest_sha256': record(previous_manifest)['sha256'],
        'editorial_changes': changes,
    })
    if args.qa:
        for path in sorted(args.qa.rglob('*')):
            if not path.is_file():
                continue
            if path.is_symlink():
                raise ValueError('Symlink in QA')
            name = prefix+'qa/'+path.relative_to(args.qa).as_posix()
            if name.endswith('.log'):
                name += '.txt'
            files[name] = path.read_bytes()
    provenance = json.loads(files['EXPORT_PROVENANCE.json'])
    provenance['version_doi'] = DOI
    provenance['publication_status_at_export'] = 'DOI-corrected 1.1.0 package prepared locally for Zenodo upload'
    provenance['doi_update'] = prefix+'update.json'
    provenance['doi_preparer_sha256'] = record(Path(__file__).read_bytes())['sha256']
    for name in [*changes, 'scripts/check_doi_update.py']:
        provenance['inputs'][name] = {
            'source': name if name.startswith('paper/') else 'release/v1.1.0/public/'+name,
            **record(files[name])}
    files['EXPORT_PROVENANCE.json'] = encode(provenance)
    for name in files:
        if not allowed(name):
            raise ValueError('Disallowed distribution path: '+name)
    files['release-manifest.json'] = encode({
        'schema_version': 1, 'version': '1.1.0',
        'scope': 'Exact distribution inventory except this manifest; byte identity is not mathematical truth.',
        'files': {n: record(d) for n, d in sorted(files.items())}})
    out.mkdir(parents=True)
    for name, data in files.items():
        path = out/name; path.parent.mkdir(parents=True, exist_ok=True); path.write_bytes(data)
    subprocess.run([sys.executable, str(out/'scripts/check_release.py')], check=True)
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for name, data in sorted(files.items()):
            entry = zipfile.ZipInfo('heraclitus-base7-1.1.0/'+name, (2026,11,9,0,0,0))
            entry.compress_type = zipfile.ZIP_DEFLATED; entry.external_attr = 0o100644 << 16
            z.writestr(entry, data)
    print(json.dumps({'directory': str(out), 'archive': str(archive),
                      'files': len(files), 'archive_sha256': record(archive.read_bytes())['sha256'],
                      'doi': DOI, 'mathematical_inputs_unchanged': True}, indent=2))


if __name__ == '__main__':
    main()
