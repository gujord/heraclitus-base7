"""Verify the precise DOI editorial update without changing proof receipts."""
import hashlib
import json

DOI = '10.5281/zenodo.24086002'
DOI_FILES = frozenset({
    'README.md', 'CITATION.cff', '.zenodo.json', 'docs/provenance.md',
    'docs/release-1.1.0.md', 'paper/base-seven-heraclitus.tex',
    'paper/base-seven-heraclitus.pdf', 'paper/base-seven-heraclitus.txt',
    'paper/references.bib', 'scripts/check_release.py',
    'scripts/check_publication.py',
})
TEX_REPLACEMENTS = (
    (r'\date{9 November 2026\\\small Version 1.1.0}',
     r'\date{9 November 2026\\\small Version 1.1.0\\\small\url{https://doi.org/'+DOI+'}}'),
    ('The published source package \\cite{package}, version 1.0.0, contains the\n'
     'manuscript of 3 November 2026,',
     'The accompanying source package \\cite{package}, version 1.1.0, contains the\n'
     'manuscript of 9 November 2026,'),
    ('identifies 1.0.0 only; no DOI is assigned to version 1.1.0. The project\n'
     'repository is \\url{https://github.com/gujord/heraclitus-base7}.',
     'identifies 1.0.0 only. The version DOI for the present 1.1.0 package is\n'
     '\\begin{quote}\\small\n\\mbox{\\url{https://doi.org/'+DOI+'}}\n'
     '\\end{quote}\nThe project repository is \\url{https://github.com/gujord/heraclitus-base7}.'),
    ('changes are bound in \\path{evidence/publication-1.1.0/}.',
     'changes are bound in \\path{evidence/publication-1.1.0/}. The subsequent\n'
     'DOI metadata update is recorded separately in \\path{evidence/doi-1.1.0/};\n'
     'it changes no mathematical source or build receipt.'),
    ('manuscript and reproducible proof package, version 1.0.0, 2026.\n'
     '\\par\\mbox{\\small\\url{https://doi.org/10.5281/zenodo.23912682}}',
     'manuscript and reproducible proof package, version 1.1.0, 2026.\n'
     '\\par\\mbox{\\small\\url{https://doi.org/'+DOI+'}}'),
)
BIB_REPLACEMENTS = (('version = {1.0.0}', 'version = {1.1.0}'),
                    ('doi = {10.5281/zenodo.23912682}', 'doi = {'+DOI+'}'))


def sha(data):
    return hashlib.sha256(data).hexdigest()


def substitute(text, replacements):
    for old, new in replacements:
        if text.count(old) != 1:
            raise ValueError('DOI update requires exactly one expected phrase')
        text = text.replace(old, new)
    return text


def check_doi_update(root, entries):
    directory = root/'evidence/doi-1.1.0'
    if not directory.exists():
        return entries, None, None
    report = json.loads((directory/'update.json').read_text())
    if (report['version'] != '1.1.0' or report['doi'] != DOI or
            report['full_lean_build_repeated'] is not False):
        raise ValueError('Incorrect DOI update scope')
    data = (directory/'previous-release-manifest.json').read_bytes()
    if sha(data) != report['previous_manifest_sha256']:
        raise ValueError('Previous release manifest changed')
    previous = json.loads(data)['files']
    changes = report['editorial_changes']
    if set(changes) != DOI_FILES:
        raise ValueError('Unexpected DOI update inputs')
    observed = {name for name, item in previous.items()
                if name != 'EXPORT_PROVENANCE.json' and entries.get(name) != item}
    if observed != set(changes):
        raise ValueError('Noneditorial or unrecorded DOI change')
    for name, item in changes.items():
        original = (directory/'original-inputs'/name).read_bytes()
        if sha(original) != previous[name]['sha256'] or sha(original) != item['before_sha256']:
            raise ValueError('Original DOI input changed: '+name)
        if entries[name]['sha256'] != item['after_sha256']:
            raise ValueError('Current DOI input changed: '+name)
    old_tex = (directory/'original-inputs/paper/base-seven-heraclitus.tex').read_text()
    if substitute(old_tex, TEX_REPLACEMENTS) != (root/'paper/base-seven-heraclitus.tex').read_text():
        raise ValueError('DOI manuscript changes exceed permitted wording')
    old_bib = (directory/'original-inputs/paper/references.bib').read_text()
    if substitute(old_bib, BIB_REPLACEMENTS) != (root/'paper/references.bib').read_text():
        raise ValueError('DOI bibliography changes exceed permitted replacements')
    if '\ndoi: "'+DOI+'"\n' not in (root/'CITATION.cff').read_text():
        raise ValueError('Citation DOI mismatch')
    if json.loads((root/'.zenodo.json').read_text()).get('doi') != DOI:
        raise ValueError('Zenodo DOI mismatch')
    return previous, old_tex, DOI
