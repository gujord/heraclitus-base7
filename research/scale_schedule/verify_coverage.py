"""Recheck the final clean-build receipt, original-rule contract and negatives.

This command requires a successful complete fresh shared build. It reuses
its source/object-checked artifacts; only the two fixture modules are fresh.
"""
import argparse
import ast
from copy import deepcopy
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
FORMAL = ROOT / 'formal'
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_report(report, directory):
    require(report['status'] == 'PASS' and report['clean_build'] and
            report['isolated_build'] and report['fresh_complete_import_closure'],
            'A successful fresh isolated clean build is required')
    require(report['binding_count'] == 21 and report['warnings_as_errors'], 'Missing binding/warning gates')
    expected = set(re.findall(r'^#print axioms (\S+)$', (FORMAL / 'Audit.lean').read_text(), re.M))
    require(len(expected) == 4998 and set(report['axioms']) == expected and
            report['theorem_count'] == len(expected), 'Incomplete final theorem audit')
    require(all(not (set(a)-ALLOWED) for a in report['axioms'].values()), 'Unapproved axiom')
    modules = report['audited_modules']
    require(len(modules) == len(set(modules)) == 244, 'Incomplete final import closure')
    objects = {str(Path(p).with_suffix('.olean')) for p in modules}
    require(set(report['artifact_sha256']) == objects, 'Incomplete artifact receipt')
    require(all('formal/'+p in report['source_sha256'] for p in modules), 'Missing module source receipt')
    for key, digest in report['source_sha256'].items():
        require(not Path(key).is_absolute() and '..' not in Path(key).parts, 'Nonlocal source path')
        require(sha(ROOT / key) == digest, 'Changed source: '+key)
    for key, digest in report['artifact_sha256'].items():
        require(sha(directory / 'compiled' / key) == digest, 'Changed object: '+key)
    pin = (FORMAL / 'lean-toolchain').read_text().strip()
    require(report['toolchain'] == pin, 'Wrong toolchain pin')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--shared', type=Path, default=ROOT / 'build/coverage-2026-11-03/formal')
    parser.add_argument('--output', type=Path, default=ROOT / 'build/coverage-2026-11-03/final-checks')
    parser.add_argument('--lake', help='Lake executable; otherwise use PATH or the project-local installation')
    args = parser.parse_args()
    shared, out = args.shared.resolve(), args.output.resolve()
    require(ROOT / 'build' in out.parents and out != shared and shared not in out.parents,
            'Use a separate child of build for final checks')
    out.mkdir(parents=True, exist_ok=True)
    (out / 'run.json').unlink(missing_ok=True)
    started, tick = datetime.now(timezone.utc).isoformat(), time.monotonic()
    report_path = shared / 'run.json'
    receipt_hash = sha(report_path)
    report = json.loads(report_path.read_text())
    validate_report(report, shared)
    lib = out / 'lib'
    if lib.exists():
        shutil.rmtree(lib)
    shutil.copytree(shared / 'compiled', lib)
    for key, digest in report['artifact_sha256'].items():
        require(sha(lib / key) == digest, 'Copied object changed: '+key)
    env = dict(os.environ, LEAN_PATH=str(lib), LEAN_SRC_PATH=str(FORMAL)+os.pathsep+str(ROOT))
    local_elan = ROOT / 'build/lean-tools/elan'
    lake = args.lake or shutil.which('lake')
    if lake is None and (local_elan / 'bin/lake').is_file():
        lake = str(local_elan / 'bin/lake')
    require(lake is not None, 'Pinned toolchain not found; see formal/README.md')
    lake = str(Path(lake).absolute())
    if Path(lake).parent == local_elan / 'bin':
        env['ELAN_HOME'] = str(local_elan)
    prefix_command = [lake, 'env', 'lean', '--print-prefix']
    prefix = subprocess.run(prefix_command, cwd=FORMAL, env=env, capture_output=True, text=True, timeout=60)
    (out / 'toolchain-prefix.txt').write_text(prefix.stdout+prefix.stderr)
    require(prefix.returncode == 0, 'Unable to resolve the pinned toolchain')
    lean = Path(prefix.stdout.strip()) / 'bin/lean'

    def run(label, arguments, reject=False):
        command = [str(lean), '-DwarningAsError=true', *map(str, arguments)]
        result = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True, timeout=1800)
        log = result.stdout+result.stderr
        (out / (label+'.txt')).write_text(log)
        if reject:
            require(result.returncode != 0 and 'Tactic `decide` proved that the proposition' in log and
                    'is false' in log, 'Expected mathematical rejection missing: '+label)
        else:
            require(result.returncode == 0, label+' failed\n'+log)
        return {'command': command, 'exit_code': result.returncode, 'diagnostic': log}

    require(run('version', ['--version'])['diagnostic'].strip() == report['lean_version'], 'Compiler version changed')
    tracked = [Path(__file__).resolve()]
    for group in ['finite_base', 'scale_schedule']:
        tracked += [ROOT / 'research' / group / name for name in ['Fixtures.lean', 'verify.py']]
    before = {str(p.relative_to(ROOT)): sha(p) for p in tracked}
    compiled, negatives, names = [], [], []
    for group, opening, count in [('finite_base', 'FiniteBase SignedCertificate', 8),
                                   ('scale_schedule', 'ScaleSchedule', 6)]:
        fixture = ROOT / 'research' / group / 'Fixtures.lean'
        target = lib / fixture.relative_to(ROOT).with_suffix('.olean')
        target.parent.mkdir(parents=True, exist_ok=True)
        run('fixtures-'+group, ['-R', ROOT, fixture, '-o', target])
        compiled.append({'source': str(fixture.relative_to(ROOT)), 'object': str(target.relative_to(lib)),
                         'object_sha256': sha(target)})
        tree = ast.parse((fixture.parent / 'verify.py').read_text())
        assignments = [n for n in ast.walk(tree) if isinstance(n, ast.Assign) and
                       any(isinstance(t, ast.Name) and t.id == 'negatives' for t in n.targets)]
        require(len(assignments) == 1, 'Expected one explicit negative table')
        cases = ast.literal_eval(assignments[0].value)
        require(len(cases) == count, 'Missing negative case')
        for label, body in cases.items():
            source = out / ('Reject_'+group+'_'+label+'.lean')
            source.write_text(f'import research.{group}.Fixtures\nopen Heraclitus {opening}\n'+body+'\n')
            negatives.append({'name': group+'/'+label, **run('reject-'+group+'-'+label, [source], reject=True)})
        namespace = re.search(r'^namespace (\S+)', fixture.read_text(), re.M).group(1)
        names += [namespace+'.'+n for n in re.findall(r'^theorem ([A-Za-z0-9_.]+)', fixture.read_text(), re.M)]
    for module in ['Coverage', 'OriginalProblem']:
        source = FORMAL / 'Heraclitus' / (module+'.lean')
        names += ['Heraclitus.'+module+'.'+n for n in re.findall(r'^theorem ([A-Za-z0-9_.]+)', source.read_text(), re.M)]
    audit = out / 'Audit.lean'
    audit.write_text('import Heraclitus.OriginalProblem\nimport research.finite_base.Fixtures\n'
                     'import research.scale_schedule.Fixtures\n'+''.join('#print axioms '+n+'\n' for n in names))
    log = run('axioms', [audit])['diagnostic']
    axioms = {n: [a.strip() for a in raw.split(',') if a.strip()]
              for n, raw in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", log)}
    axioms.update({n: [] for n in re.findall(r"'([^']+)' does not depend on any axioms", log)})
    require(len(names) == len(set(names)) == 24 and set(axioms) == set(names) and
            all(not (set(a)-ALLOWED) for a in axioms.values()), 'Incomplete final contract/fixture audit')
    contract = out / 'Contract.lean'
    contract.write_text('import Heraclitus.OriginalProblem\nset_option pp.proofs false\n'
                        '#print Heraclitus.OriginalProblem.FollowsRule\n'
                        '#check Heraclitus.OriginalProblem.rule_iff_walk\n'
                        '#check Heraclitus.OriginalProblem.canonical_follows_rule\n'
                        '#check Heraclitus.OriginalProblem.coverage\n'
                        '#check Heraclitus.OriginalProblem.checkpoint\n')
    run('original-contract', [contract])
    mutations = []
    for label in ['missing-coverage', 'missing-base-object', 'changed-source', 'unexpected-axiom', 'not-clean']:
        bad = deepcopy(report)
        if label == 'missing-coverage':
            del bad['axioms']['Heraclitus.OriginalProblem.coverage']
        elif label == 'missing-base-object':
            del bad['artifact_sha256']['Heraclitus/FiniteBaseData/Case114.olean']
        elif label == 'changed-source':
            bad['source_sha256']['formal/Heraclitus/OriginalProblem.lean'] = '0'*64
        elif label == 'unexpected-axiom':
            bad['axioms']['Heraclitus.OriginalProblem.coverage'] = ['sorryAx']
        else:
            bad['clean_build'] = False
        try:
            validate_report(bad, shared)
        except RuntimeError as error:
            mutations.append({'name': label, 'rejected': str(error)})
        else:
            raise RuntimeError('Damaged receipt accepted: '+label)
    validate_report(report, shared)
    require(sha(report_path) == receipt_hash, 'Shared report changed')
    require(before == {key: sha(ROOT/key) for key in before}, 'Final-check source changed')
    for key, digest in report['artifact_sha256'].items():
        require(sha(lib/key) == digest, 'Copied dependency changed after use')
    for item in compiled:
        require(sha(lib/item['object']) == item['object_sha256'], 'Fixture object changed')
    (out / 'rejections.json').write_text(json.dumps(negatives, indent=2)+'\n')
    (out / 'receipt-rejections.json').write_text(json.dumps(mutations, indent=2)+'\n')
    result = {'status': 'PASS', 'started_utc': started, 'seconds': round(time.monotonic()-tick, 3),
              'shared_report': str(report_path), 'shared_report_sha256': receipt_hash,
              'toolchain_prefix_command': prefix_command, 'lean_executable': str(lean),
              'fresh_complete_import_closure': False, 'reused_objects': len(report['artifact_sha256']),
              'compiled': compiled, 'source_sha256': before, 'axioms': axioms,
              'mathematical_rejections': len(negatives), 'receipt_rejections': len(mutations),
              'scope': 'Final shared receipt and copied artifacts rechecked; two fresh fixtures, '
                       '14 mathematical rejections, 24 contract/fixture audits and five receipt rejections. '
                       'Literal original-rule contract printed. This is not a second full build or human review.'}
    (out / 'run.json').write_text(json.dumps(result, indent=2)+'\n')
    print('PASS: final shared receipt, 24 audits, 14 mathematical and five receipt rejections', flush=True)


if __name__ == '__main__':
    main()
