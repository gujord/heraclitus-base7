"""Verify the complete formal base: every signed choice, update and endpoint.

Core/data/assembly/fixtures are freshly compiled. Only seven previously
receipt-checked dependency objects are reused; this is not a full fresh build.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
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
HERE = Path(__file__).resolve().parent
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}


def require(value, message):
    if not value:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'build/finite_base/verification')
    parser.add_argument('--jobs', type=int, default=2)
    args = parser.parse_args()
    out = args.output.resolve()
    require(ROOT / 'build/finite_base' in out.parents, 'Use a child of build/finite_base')
    require(1 <= args.jobs <= 4, 'Use one to four module workers')
    out.mkdir(parents=True, exist_ok=True)
    (out / 'run.json').unlink(missing_ok=True)
    lib = out / 'lib'
    if lib.exists():
        shutil.rmtree(lib)
    lib.mkdir()
    started, tick = datetime.now(timezone.utc).isoformat(), time.monotonic()
    pin = (FORMAL / 'lean-toolchain').read_text().strip()
    lean = ROOT / 'build/lean-tools/elan/toolchains' / pin.replace('/', '--').replace(':', '---') / 'bin/lean'
    env = dict(os.environ, LEAN_PATH=str(lib), LEAN_SRC_PATH=str(FORMAL)+os.pathsep+str(ROOT))

    def run(label, command, reject=False):
        p = subprocess.run([str(x) for x in command], cwd=ROOT, env=env, capture_output=True, text=True, timeout=1800)
        log = p.stdout+p.stderr
        (out / (label+'.txt')).write_text(log)
        if reject:
            require(p.returncode != 0 and 'Tactic `decide` proved that the proposition' in log and 'is false' in log,
                    'Expected mathematical rejection missing: '+label+'\n'+log)
        else:
            require(p.returncode == 0, label+' failed\n'+log[:12000])
        return {'command': [str(x) for x in command], 'exit_code': p.returncode, 'diagnostic': log}

    version = run('version', [lean, '--version'])['diagnostic'].strip()
    require(f"version {pin.rsplit(':v', 1)[-1]}," in version, 'Toolchain version mismatch')
    bindings = [HERE / 'export_data.py', ROOT / 'research/transfer/export_boundary.py']
    for script in bindings:
        run(script.parent.name+'-binding', [os.sys.executable, script])
    modules, seen, deps = [], set(), {}

    def visit(source):
        source = source.resolve()
        if source in seen:
            return
        seen.add(source)
        deps[source] = []
        for line in run('deps-'+source.stem, [lean, '--src-deps', source])['diagnostic'].splitlines():
            path = Path(line).resolve()
            if ROOT in path.parents and (FORMAL in path.parents or HERE in path.parents):
                deps[source].append(path)
                visit(path)
        modules.append(source)

    visit(FORMAL / 'Heraclitus/FiniteBaseData.lean')
    visit(HERE / 'Fixtures.lean')
    base = ROOT / 'build/signed_approach/integration'
    prior_path = base / 'run.json'
    prior = json.loads(prior_path.read_text())
    require(prior['status']=='PASS' and prior['lean_version']==version and prior['toolchain']==pin,
            'Matching successful dependency build required')
    configs = [FORMAL / name for name in ['lean-toolchain', 'lakefile.toml', 'lake-manifest.json']]
    for path in configs:
        require(sha(path)==prior['source_sha256'][str(path.relative_to(ROOT))], 'Dependency configuration changed')
    receipt_hash = sha(prior_path)
    cases = sorted((FORMAL / 'Heraclitus/FiniteBaseData').glob('Case*.lean'))
    require(len(cases)==115, 'All 115 consecutive data chunks are required')
    fresh = {FORMAL / 'Heraclitus/FiniteBase.lean', FORMAL / 'Heraclitus/FiniteBaseData.lean', HERE / 'Fixtures.lean', *cases}
    require(fresh <= set(modules), 'Fresh sources missing from import closure')
    tracked = set(modules+configs+bindings+[Path(__file__).resolve(), ROOT / 'certificates/signed-machine.json'])
    before = {str(p.relative_to(ROOT)): sha(p) for p in sorted(tracked)}
    reused, compiled = [], []

    def compile_source(source):
        package = FORMAL if FORMAL in source.parents else ROOT
        target = lib / source.relative_to(package).with_suffix('.olean')
        target.parent.mkdir(parents=True, exist_ok=True)
        t = time.monotonic()
        result = run('build-'+source.stem, [lean, '-DwarningAsError=true', '-R', package, source, '-o', target])
        return {'source': str(source.relative_to(ROOT)), 'object': str(target.relative_to(lib)),
                'object_sha256': sha(target), 'command': result['command'], 'seconds': round(time.monotonic()-t, 3)}

    for source in modules:
        if source in fresh:
            continue
        key = str(source.relative_to(ROOT))
        obj = str(source.relative_to(FORMAL).with_suffix('.olean'))
        origin, target = base / 'compiled' / obj, lib / obj
        require(before[key]==prior['source_sha256'][key] and sha(origin)==prior['artifact_sha256'][obj],
                'Dependency source/object mismatch: '+key)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(origin, target)
        require(sha(target)==prior['artifact_sha256'][obj], 'Copied dependency changed')
        reused.append({'source': key, 'source_sha256': before[key], 'object': obj,
                       'object_sha256': sha(target), 'origin': str(origin)})
    require(len(reused)==7, 'Unexpected dependency closure')
    compiled.append(compile_source(FORMAL / 'Heraclitus/FiniteBase.lean'))
    compiled.append(compile_source(HERE / 'Fixtures.lean'))
    print('Compiled generic checker and positive fixtures; seven checked dependencies reused', flush=True)
    negatives = {
        'negative-tie': 'example : Claim initial (⟨false, 1, 2⟩ : Move) := by decide',
        'skipped-front': 'example : Claim initial (⟨true, 1, 3⟩ : Move) := by decide',
        'revisit-zero': 'example : Claim FiniteBaseFixtures.first (⟨true, 0, 2⟩ : Move) := by decide',
        'too-large': 'example : Claim initial (⟨true, 823543, 1⟩ : Move) := by decide',
        'changed-current-hint': 'example : traceCheck initial [{ FiniteBaseFixtures.first with current := 2 }]=true := by decide',
        'invented-opposite-point': 'example : traceCheck initial [{ FiniteBaseFixtures.first with neg := ⟨1, [3]⟩ }]=true := by decide',
        'dropped-opposite-point': 'example : traceCheck { initial with neg := ⟨1, [3]⟩ } [FiniteBaseFixtures.first]=true := by decide',
        'omitted-visit': 'example : traceCheck initial [FiniteBaseFixtures.second]=true := by decide',
    }
    rejects = []
    for name, body in negatives.items():
        source = out / ('Reject_'+name+'.lean')
        source.write_text('import research.finite_base.Fixtures\nopen Heraclitus FiniteBase SignedCertificate\n'+body+'\n')
        rejects.append({'name': name, **run('reject-'+name, [lean, '-DwarningAsError=true', source], reject=True)})
    (out / 'rejections.json').write_text(json.dumps(rejects, indent=2)+'\n')
    print('PASS: eight targeted mathematical rejections', flush=True)
    done = 0
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        pending = {pool.submit(compile_source, source): source for source in cases}
        for future in as_completed(pending):
            compiled.append(future.result())
            done += 1
            (out / 'partial-compilations.json').write_text(json.dumps(compiled, indent=2)+'\n')
            if done % 10 == 0 or done == len(cases):
                print(f'Compiled {done}/{len(cases)} complete trace chunks', flush=True)
    compiled.append(compile_source(FORMAL / 'Heraclitus/FiniteBaseData.lean'))
    names = []
    for source in sorted(fresh):
        namespace = re.search(r'^namespace (\S+)', source.read_text(), re.M).group(1)
        names += [namespace+'.'+name for name in re.findall(r'^theorem ([A-Za-z0-9_.]+)', source.read_text(), re.M)]
    required = {'Heraclitus.FiniteBaseData.'+n for n in ['base_length', 'base_valid', 'base_endpoint', 'final_exact', 'initial_exact']}
    required |= {'Heraclitus.FiniteBaseData.Case'+f'{i:03}'+'.checked' for i in range(115)}
    require(required <= set(names) and len(names)==len(set(names)), 'Missing or repeated base audit target')
    audit = out / 'Audit.lean'
    audit.write_text('import Heraclitus.FiniteBaseData\nimport research.finite_base.Fixtures\n'+''.join('#print axioms '+n+'\n' for n in names))
    log = run('axioms', [lean, '-DwarningAsError=true', audit])['diagnostic']
    axioms = {n:[a.strip() for a in raw.split(',') if a.strip()]
              for n,raw in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",log)}
    axioms.update({n:[] for n in re.findall(r"'([^']+)' does not depend on any axioms",log)})
    require(set(axioms)==set(names) and all(not(set(a)-ALLOWED) for a in axioms.values()), 'Incomplete or unapproved axiom audit')
    after = {name:sha(ROOT/name) for name in before}
    require(after==before and sha(prior_path)==receipt_hash, 'Source or input report changed during verification')
    for record in compiled:
        require(sha(lib/record['object'])==record['object_sha256'], 'Compiled object changed')
    for record in reused:
        require(sha(Path(record['origin']))==record['object_sha256'] and sha(lib/record['object'])==record['object_sha256'],
                'Dependency object changed')
    receipt = {'report':str(prior_path),'report_sha256':receipt_hash,'reused':reused,
               'mode':'Source/object-checked reuse; no fresh dependency rebuild'}
    (out/'dependency-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
    report = {'status':'PASS','started_utc':started,'seconds':round(time.monotonic()-tick,3),'jobs':args.jobs,
              'lean_version':version,'toolchain':pin,'fresh_complete_import_closure':False,'warnings_as_errors':True,
              'reused_project_objects':len(reused),'compiled':compiled,'source_sha256':after,
              'audited_declarations':len(names),'axioms':axioms,'mathematical_rejections':list(negatives),'binding_checks':len(bindings),
              'scope':'Complete kernel-checked signed base from zero through 117649 moves, exact full endpoint at the phase-42 inner boundary. Every state hint is checked. This does not itself assemble the infinite scale induction or constitute human review.'}
    (out/'run.json').write_text(json.dumps(report,indent=2)+'\n')
    print(f'PASS: {len(compiled)} fresh modules, {len(reused)} checked dependencies, {len(names)} audits, full 117649-move base',flush=True)


if __name__=='__main__':
    main()
