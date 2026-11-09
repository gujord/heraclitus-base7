"""Bind the final editorial promotion to the unchanged clean-build inputs."""
import hashlib
import json

EDITORIAL_FILES = frozenset({
    'README.md', 'CITATION.cff', '.zenodo.json', 'docs/provenance.md',
    'docs/reproducibility.md', 'docs/release-1.1.0.md',
    'paper/base-seven-heraclitus.tex', 'paper/base-seven-heraclitus.pdf',
    'paper/base-seven-heraclitus.txt', 'scripts/check_release.py',
})
PAPER_REPLACEMENTS = (
    ('1.1.0-rc.1', '1.1.0'),
    ('Local revision 1.1.0', 'Version 1.1.0'),
    ('local release candidate 1.1.0', 'release 1.1.0'),
    ('this candidate', 'version 1.1.0'),
    ('The candidate is self-contained', 'The package is self-contained'),
    ('extracted candidate root', 'extracted package root'),
    ('The final candidate records its fresh execution under\n'
     '\\path{evidence/release-1.1.0/}; a preliminary export has no completed receipt.\n'
     'Source and object identities are rechecked at completion.',
     'The clean candidate build is recorded under\n'
     '\\path{evidence/release-1.1.0/}. Final version labels and publication metadata\n'
     'were updated afterwards; the unchanged proof inputs and the exact editorial\n'
     'changes are bound in \\path{evidence/publication-1.1.0/}.\n'
     'Source and object identities are rechecked at build completion.'),
)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def check_promotion(root, entries):
    directory = root/'evidence/publication-1.1.0'
    if not directory.exists():
        return {}
    promotion = json.loads((directory/'promotion.json').read_text())
    if promotion['version'] != '1.1.0' or promotion['full_lean_build_repeated'] is not False:
        raise ValueError('Invalid publication scope')
    baseline_data = (directory/'candidate-manifest.json').read_bytes()
    if sha(baseline_data) != promotion['candidate_manifest_sha256']:
        raise ValueError('Candidate manifest changed')
    baseline = json.loads(baseline_data)['files']
    changes = promotion['editorial_changes']
    if not set(changes) <= EDITORIAL_FILES:
        raise ValueError('Noneditorial change in promotion')
    observed = {n for n, item in baseline.items()
                if n != 'EXPORT_PROVENANCE.json' and entries.get(n) != item}
    if observed != set(changes):
        raise ValueError('Unrecorded change from checked candidate')
    for name, item in changes.items():
        old = (directory/'original-inputs'/name).read_bytes()
        if sha(old) != baseline[name]['sha256'] or sha(old) != item['before_sha256']:
            raise ValueError('Original editorial input changed: '+name)
        if entries[name]['sha256'] != item['after_sha256']:
            raise ValueError('Final editorial input changed: '+name)
    old_tex = (directory/'original-inputs/paper/base-seven-heraclitus.tex').read_text()
    for old, new in PAPER_REPLACEMENTS:
        if old not in old_tex:
            raise ValueError('Missing expected manuscript phrase')
        old_tex = old_tex.replace(old, new)
    if old_tex != (root/'paper/base-seven-heraclitus.tex').read_text():
        raise ValueError('Manuscript changes exceed publication wording')
    history_data = (directory/'historical-manifest.json').read_bytes()
    if sha(history_data) != promotion['historical_manifest_sha256']:
        raise ValueError('Historical manifest changed')
    history = json.loads(history_data)['files']
    retained = {n: item for n, item in history.items() if n.startswith('evidence/')}
    if len(retained) != promotion['historical_evidence_files_preserved']:
        raise ValueError('Historical evidence count differs')
    for name, item in retained.items():
        if entries.get(name) != item:
            raise ValueError('Historical evidence removed or changed: '+name)
    return changes
