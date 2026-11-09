#!/usr/bin/env python3
"""Fresh, offline build of the complete 1.1.0 proof chain from an export.

Only the installed pinned Lean standard library is reused. No project object
or development receipt is an input. Requires Python >=3.9 and Lean 4.35.0.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time
from check_release import check
from research_inventory import declarations, strip_comments, parse_axioms

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lake', help='Pinned toolchain Lake executable; default: PATH')
    parser.add_argument('--jobs', type=int, default=4)
    parser.add_argument('--output', type=Path, default=ROOT / 'build/release-rebuild')
    args = parser.parse_args()
    require(__debug__ and not os.environ.get('PYTHONOPTIMIZE'), 'Optimized Python prohibited')
    require(1 <= args.jobs <= 8, 'Use 1 to 8 jobs')
    out = args.output.resolve()
    require(ROOT / 'build' in out.parents and not out.exists(), 'Use a NEW directory under build/')
    check(ROOT)
    out.mkdir(parents=True)
    logs = out / 'logs'; logs.mkdir()
    started = time.monotonic()
    report = {'status': 'RUNNING', 'started_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'scope': 'Fresh coverage and research compilation from the exported sources; same-project machine check, not independent human review or a real-limsup API theorem.',
              'stages': [], 'research_modules': [], 'negative_tests': {}, 'final_target_proved': False,
              'fresh_project_modules': 0, 'reused_prior_project_objects': 0}
    source_manifest = json.loads((ROOT / 'release-manifest.json').read_text())['files']
    # Bind every input, including this runner and the expected audit inventory.
    report['input_sha256'] = {n: r['sha256'] for n, r in source_manifest.items()}
    env = {k: v for k, v in os.environ.items() if k not in ('LEAN_PATH', 'LEAN_SRC_PATH')}

    def stage(name, command, cwd=ROOT):
        print('START', name, flush=True)
        began = time.monotonic()
        path = logs / (name + '.txt')
        with path.open('wb') as log:
            code = subprocess.run(command, cwd=cwd, env=env, stdout=log, stderr=subprocess.STDOUT).returncode
        report['stages'].append({'name': name, 'exit_code': code,
                                 'seconds': round(time.monotonic()-began, 3), 'log_sha256': sha(path)})
        require(code == 0, 'Failed stage ' + name + '; see ' + str(path))
        print('PASS', name, flush=True)

    try:
        lake = args.lake or shutil.which('lake')
        require(lake, 'Install the pinned Lean toolchain; see docs/reproducibility.md')
        lake = str(Path(lake).absolute())
        prefix = subprocess.check_output([lake, 'env', 'lean', '--print-prefix'], cwd=ROOT/'formal', env=env, text=True).strip()
        lean = str(Path(prefix) / 'bin/lean')
        version = subprocess.check_output([lean, '--version'], env=env, text=True).strip()
        require('version 4.35.0,' in version, 'Wrong Lean version')
        report.update(lean_version=version, compiler_sha256=sha(Path(lean)))
        inventory = json.loads((ROOT / 'proof-inventory.json').read_text())
        modules = {e['module']: e for e in inventory['research_modules']}
        require(len(modules) == len(inventory['research_modules']) == 107, 'Incomplete research inventory')
        names, deps = [], {}
        for module, entry in modules.items():
            path = ROOT / entry['source']
            require(sha(path) == entry['source_sha256'], 'Changed proof input: ' + entry['source'])
            code = strip_comments(path.read_text())
            require(not re.search(r'\b(?:sorry|native_decide|axiom)\b', code), 'Forbidden shortcut: ' + module)
            names.extend(declarations(path))
            deps[module] = [word for line in code.splitlines() if line.startswith('import ')
                            for word in line.split()[1:] if word in modules]
        require(len(names) == len(set(names)) == 1595 and sorted(names) == inventory['research_theorems'],
                'Research theorem inventory mismatch')
        stage('python', [sys.executable, 'scripts/verify.py', '--output', str(out/'python')])
        stage('regeneration', [sys.executable, 'src/generate_certificate.py', '--output', str(out/'regeneration')])
        coverage = out / 'coverage'
        stage('coverage', [sys.executable, 'scripts/verify_lean.py', '--isolated', '--clean', '--jobs', str(args.jobs),
                           '--lake', lake, '--output', str(coverage)])
        receipt = json.loads((coverage/'run.json').read_text())
        require(receipt['status'] == 'PASS' and len(receipt['audited_modules']) == 244 and
                receipt['theorem_count'] == 4998 and receipt['binding_count'] == 21 and
                receipt['fresh_complete_import_closure'] and receipt['clean_build'], 'Incomplete coverage build')
        stage('coverage-final', [sys.executable, 'research/scale_schedule/verify_coverage.py', '--shared', str(coverage),
                                 '--output', str(out/'coverage-final'), '--lake', lake])
        compiled = out / 'research-compiled'
        compiled.mkdir()
        # Coverage and research each have their own Audit module. Keep those
        # roots separate, but keep ALL research modules in one root so their
        # research/ prefix cannot shadow another partial research tree.
        require(not any(m.startswith('Heraclitus.') for m in modules),
                'Research would shadow the coverage Heraclitus prefix')
        env['LEAN_PATH'] = os.pathsep.join(map(str, [compiled, coverage/'compiled']))

        def run_lean(label, source, output=None):
            command = [lean, '-DwarningAsError=true']
            if output:
                output.parent.mkdir(parents=True, exist_ok=True)
                command += ['-o', str(output)]
            command.append(str(source))
            result = subprocess.run(command, cwd=ROOT, env=env, text=True, capture_output=True)
            text = result.stdout + result.stderr
            (logs/(label+'.txt')).write_text(text)
            return result.returncode, text

        def compile_one(module):
            entry = modules[module]
            target = compiled / (module.replace('.', '/') + '.olean')
            require(not target.exists(), 'Unexpected existing research object: ' + module)
            code, text = run_lean('build-'+module, ROOT/entry['source'], target)
            require(code == 0, 'Research build failed: ' + module + '\n' + text[-5000:])
            print('BUILD', module, flush=True)
            return {**entry, 'object_sha256': sha(target)}

        pending, completed = set(modules), set()
        with ThreadPoolExecutor(max_workers=args.jobs) as pool:
            while pending:
                ready = sorted(m for m in pending if set(deps[m]) <= completed)
                require(ready, 'Cyclic research imports')
                report['research_modules'].extend(pool.map(compile_one, ready))
                completed.update(ready); pending.difference_update(ready)
        audit = out / 'CompleteAudit.lean'
        audit.write_text('\n'.join('import '+m for m in sorted(modules)) +
            '\nset_option pp.fullNames true\nset_option pp.maxSteps 1000000\n' +
            '\n'.join('#eval IO.println "BEGIN '+n+'"\n#check @'+n+'\n#print axioms '+n+'\n#eval IO.println "END"'
                      for n in sorted(names)) +
            '\nexample : Heraclitus.UpperMachineAudit.OriginalRuleThreeEighths := '+inventory['target']+'\n' +
            '\n'.join('#print Heraclitus.UpperMachineAudit.'+n for n in
                      ['defect', 'EventualUpperBound', 'FrequentLowerBound', 'OriginalRuleThreeEighths'])+'\n')
        code, text = run_lean('research-audit', audit)
        require(code == 0, 'Research audit failed: '+text[-5000:])
        sections = re.findall(r'BEGIN ([^\n]+)\n(.*?)\nEND', text, re.S)
        require(len(sections) == len(names), 'Incomplete statement audit')
        theorems = {}
        for name, body in sections:
            axioms = parse_axioms(body)
            require(name in axioms and set(axioms[name]) <= ALLOWED, 'Forbidden/missing axioms: '+name)
            theorems[name] = {'statement_and_axioms': body, 'axioms': axioms[name]}
        require(set(theorems) == set(names), 'Incomplete axiom inventory')
        save(out/'research-theorems.json', theorems)
        for name, diagnostic in [('sorry','sorry'), ('false_arithmetic','omega'),
                                  ('wrong_crossing_index','decide'), ('false_actual_crossing_defect','omega')]:
            if name != 'sorry':
                code, text = run_lean(name+'-negation', ROOT/'tests/release-probes'/(name+'_negation.lean'))
                require(code == 0, 'Could not prove negation: '+name)
            code, text = run_lean(name, ROOT/'tests/release-probes'/(name+'.lean'))
            require(code != 0 and diagnostic in text and not re.search(
                r'(unknown (?:module|identifier|tactic)|file not found|object file|maximum recursion|heartbeat|out of memory|failed to synthesize|timeout)', text),
                'Did not reach intended mathematical rejection: '+name)
            report['negative_tests'][name] = 'PASS'
        code, text = run_lean('injected_axiom', ROOT/'tests/release-probes/injected_axiom.lean')
        require(code == 0 and parse_axioms(text).get('tainted') == ['injectedFalse'] and
                not set(parse_axioms(text)['tainted']) <= ALLOWED, 'Axiom injection was not detected')
        report['negative_tests']['injected_axiom'] = 'PASS'
        objects = {'coverage/'+n: h for n, h in receipt['artifact_sha256'].items()}
        for entry in report['research_modules']:
            objects['research/'+entry['module'].replace('.', '/')+'.olean'] = entry['object_sha256']
        roots = {'coverage': coverage/'compiled', 'research': compiled}
        observed = {prefix+'/'+str(p.relative_to(directory)) for prefix, directory in roots.items()
                    for p in directory.rglob('*') if p.is_file()}
        require(len(objects) == 351 and observed == set(objects),
                'Unexpected or missing compiled object')
        for name, digest in objects.items():
            prefix, relative = name.split('/', 1)
            require(sha(roots[prefix]/relative) == digest, 'Object changed during audit: '+name)
        check(ROOT)
        for name, digest in report['input_sha256'].items():
            require(sha(ROOT/name) == digest, 'Input changed during build: '+name)
        report.update(status='PASS', fresh_project_modules=351, coverage_theorems=4998,
                      research_theorems=1595, coverage_bindings=21, final_target_proved=True,
                      target_statement=theorems[inventory['target']]['statement_and_axioms'],
                      artifact_sha256=objects, coverage_receipt_sha256=sha(coverage/'run.json'))
    except BaseException as exc:
        report.update(status='FAIL', error=str(exc))
        raise
    finally:
        report['seconds'] = round(time.monotonic()-started, 3)
        save(out/'report.json', report)
        print(report['status'], out/'report.json', flush=True)


if __name__ == '__main__':
    main()
