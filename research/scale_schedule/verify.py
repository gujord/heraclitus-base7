"""Verify the complete 36-phase schedule and the induction assembly interface.

New modules are compiled fresh; dependencies require the recorded shared
source/object receipt. The concrete base and unconditional coverage module are audited separately.
"""
import argparse
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


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'build/scale_schedule/verification')
    args = parser.parse_args()
    out = args.output.resolve()
    if ROOT / 'build/scale_schedule' not in out.parents:
        raise SystemExit('Use a child of build/scale_schedule for output')
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

    def run(label, args, reject=False):
        command = [str(lean), '-DwarningAsError=true', *args]
        p = subprocess.run(command, cwd=FORMAL, env=env, capture_output=True, text=True, timeout=600)
        log = p.stdout+p.stderr
        (out / (label+'.txt')).write_text(log)
        if reject:
            if p.returncode == 0 or 'Tactic `decide` proved that the proposition' not in log or 'is false' not in log:
                raise RuntimeError('Expected mathematical rejection missing: '+label+'\n'+log)
        elif p.returncode:
            raise RuntimeError(label+' failed\n'+log)
        return {'command': command, 'exit_code': p.returncode, 'diagnostic': log}

    version = run('version', ['--version'])['diagnostic'].strip()
    if f"version {pin.rsplit(':v', 1)[-1]}," not in version:
        raise RuntimeError('Toolchain version mismatch')
    modules, seen = [], set()

    def visit(source):
        source = source.resolve()
        if source in seen:
            return
        seen.add(source)
        label = 'deps-'+source.stem
        log = run(label, ['--src-deps', str(source)])['diagnostic']
        for line in log.splitlines():
            dep = Path(line).resolve()
            if ROOT in dep.parents and (FORMAL in dep.parents or HERE in dep.parents):
                visit(dep)
        modules.append(source)

    visit(HERE / 'Fixtures.lean')
    base = ROOT / 'build/outer_boundary/integration'
    prior_path = base / 'run.json'
    prior = json.loads(prior_path.read_text())
    if prior['status'] != 'PASS' or prior['lean_version'] != version or prior['toolchain'] != pin:
        raise RuntimeError('Successful matching shared dependency report required')
    for name in ['lean-toolchain', 'lakefile.toml', 'lake-manifest.json']:
        if sha(FORMAL / name) != prior['source_sha256']['formal/'+name]:
            raise RuntimeError('Dependency compilation configuration changed')
    receipt_hash = sha(prior_path)
    fresh = {FORMAL / 'Heraclitus/ScaleSchedule.lean', FORMAL / 'Heraclitus/ScaleScheduleData.lean', HERE / 'Fixtures.lean'}
    bindings = ['lean_catalogue/export_data.py', 'transfer/export_boundary.py',
                'first_crossing/export_data.py', 'outgoing/export_data.py',
                'outgoing_word/export_data.py', 'return_bridge/export_data.py',
                'ladder_layers/export_data.py', 'ladder_descent/export_data.py',
                'ladder_bottom/export_data.py', 'ladder_envelope/export_data.py',
                'signed_bottom/export_data.py', 'signed_ladder/export_data.py',
                'signed_transfer/export_data.py', 'post_ladder/export_data.py',
                'short_return/export_data.py', 'approach_word/export_data.py',
                'signed_approach/export_data.py', 'outer_boundary/export_data.py', 'scale_schedule/export_data.py']
    for name in bindings:
        script = ROOT / 'research' / name
        result = subprocess.run([os.sys.executable, str(script)], cwd=ROOT, capture_output=True, text=True)
        log = result.stdout+result.stderr
        (out / (name.split('/')[0]+'-binding.txt')).write_text(log)
        if result.returncode:
            raise RuntimeError('Source binding failed: '+name+'\n'+log)
    tracked = modules+[Path(__file__).resolve(), FORMAL / 'lean-toolchain']
    tracked += [ROOT / 'research' / p for p in bindings]
    tracked += [ROOT / 'certificates/signed-machine.json', ROOT / 'certificates/ladder-machine.json']
    before = {str(p.relative_to(ROOT)): sha(p) for p in tracked}
    reused = []
    compiled = []
    for source in modules:
        package_root = FORMAL if FORMAL in source.parents else ROOT
        relative = source.relative_to(package_root)
        target = lib / relative.with_suffix('.olean')
        target.parent.mkdir(parents=True, exist_ok=True)
        if source not in fresh:
            key = str(source.relative_to(ROOT))
            obj = str(relative.with_suffix('.olean'))
            origin = base / 'compiled' / obj
            if before[key] != prior['source_sha256'][key] or sha(origin) != prior['artifact_sha256'][obj]:
                raise RuntimeError('Dependency source/object mismatch: '+key)
            shutil.copy2(origin, target)
            if sha(target) != prior['artifact_sha256'][obj]:
                raise RuntimeError('Copied dependency changed: '+key)
            reused.append({'source': key, 'source_sha256': before[key], 'object': obj,
                           'object_sha256': sha(target), 'origin': str(origin)})
            continue
        result = run('build-'+source.stem, ['-R', str(package_root), str(source), '-o', str(target)])
        compiled.append({'source': str(source.relative_to(ROOT)),
                         'object': str(target.relative_to(lib)), 'object_sha256': sha(target),
                         'command': result['command']})
        print('Compiled '+str(source.relative_to(ROOT)), flush=True)

    names = []
    for source, namespace in [(FORMAL / 'Heraclitus/ScaleSchedule.lean', 'Heraclitus.ScaleSchedule'),
                              (FORMAL / 'Heraclitus/ScaleScheduleData.lean', 'Heraclitus.ScaleScheduleData'),
                              (HERE / 'Fixtures.lean', 'Heraclitus.ScaleScheduleFixtures')]:
        names += [namespace+'.'+n for n in re.findall(r'^theorem ([A-Za-z0-9_.]+)', source.read_text(), re.M)]
    required = {'Heraclitus.ScaleScheduleData.least', 'Heraclitus.ScaleScheduleData.follows',
                'Heraclitus.ScaleScheduleData.initial_boundary', 'Heraclitus.ScaleSchedule.Schedule.step',
                'Heraclitus.ScaleSchedule.Schedule.filled', 'Heraclitus.ScaleSchedule.Schedule.input_period'}
    if not required <= set(names):
        raise RuntimeError('Missing concrete phase composition')
    audit = out / 'Audit.lean'
    audit.write_text('import research.scale_schedule.Fixtures\n'+
                     ''.join('#print axioms '+n+'\n' for n in names))
    log = run('axioms', [str(audit)])['diagnostic']
    axioms = {n: [a.strip() for a in raw.split(',') if a.strip()]
              for n, raw in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", log)}
    axioms.update({n: [] for n in re.findall(r"'([^']+)' does not depend on any axioms", log)})
    if len(names) != len(set(names)) or set(axioms) != set(names) or any(set(a)-ALLOWED for a in axioms.values()):
        raise RuntimeError('Incomplete or unapproved axiom audit')

    negatives = {
        'wrong-first-exponent': 'example : (ScaleScheduleData.schedule.entry (index 0)).checked.link.approach.row.exponent 0=5 := by decide',
        'missing-cycle-increment': 'example : (ScaleScheduleData.schedule.entry (index 36)).checked.link.approach.row.exponent (35/36)=42 := by decide',
        'wrong-35-period': 'example : index 0=index 35 := by decide',
        'wrong-37-period': 'example : index 0=index 37 := by decide',
        'wrong-radius': 'example : ScaleInduction.radius 7=411772 := by decide',
        'wrong-next-radius': 'example : ScaleInduction.radius 7=ScaleInduction.radius 6+3*7^6+1 := by decide',
    }
    rejections = []
    for label, body in negatives.items():
        source = out / ('Reject_'+label+'.lean')
        source.write_text('import research.scale_schedule.Fixtures\nopen Heraclitus ScaleSchedule\n'+body+'\n')
        result = run('reject-'+label, [str(source)], reject=True)
        rejections.append({'name': label, **result})
    bad = out / 'changed-generated-source.lean'
    bad.write_text((FORMAL / 'Heraclitus/ScaleScheduleData.lean').read_text().replace('theorem follows ', 'theorem omittedFollows '))
    command = [os.sys.executable, str(HERE / 'export_data.py'), '--target', str(bad)]
    rejected = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    if rejected.returncode == 0 or 'Scale-schedule generated-source mismatch' not in rejected.stdout+rejected.stderr:
        raise RuntimeError('Generated source identity mutation not rejected')
    rejections.append({'name': 'changed-generated-source', 'command': command,
                       'exit_code': rejected.returncode, 'diagnostic': rejected.stdout+rejected.stderr,
                       'kind': 'Source identity, not a mathematical counterexample'})
    (out / 'rejections.json').write_text(json.dumps(rejections, indent=2)+'\n')
    after = {name: sha(ROOT / name) for name in before}
    if after != before:
        raise RuntimeError('Source changed during the build')
    for record in compiled:
        if sha(lib / record['object']) != record['object_sha256']:
            raise RuntimeError('Compiled object changed: '+record['object'])
    if sha(prior_path) != receipt_hash:
        raise RuntimeError('Dependency report changed during verification')
    for record in reused:
        for artifact in [Path(record['origin']), lib / record['object']]:
            if sha(artifact) != record['object_sha256']:
                raise RuntimeError('Dependency object changed during verification')
    receipt = {'report': str(prior_path), 'report_sha256': receipt_hash,
               'mode': 'Source/object-checked reuse; no fresh dependency rebuild', 'reused': reused}
    (out / 'dependency-receipt.json').write_text(json.dumps(receipt, indent=2)+'\n')
    report = {
        'status': 'PASS', 'started_utc': started, 'seconds': round(time.monotonic()-tick, 3),
        'lean_version': version, 'toolchain': pin, 'fresh_complete_import_closure': False,
        'reused_project_objects': len(reused), 'warnings_as_errors': True, 'compiled': compiled,
        'source_sha256': after, 'audited_declarations': len(names), 'axioms': axioms,
        'mathematical_rejections': list(negatives), 'binding_checks': len(bindings), 'identity_rejections': ['changed-generated-source'],
        'scope': 'All 36 transitions are ordered at every exponent n+6, with exact next-state coupling, 6*7^(n+6) lengths, periodic normalized inputs and filled intervals. A concrete Plan is constructed given the exact initial base block; this runner does not import the new finite base or unconditional Coverage module. No human review or novelty claim.'
    }
    (out / 'run.json').write_text(json.dumps(report, indent=2)+'\n')
    print(f'PASS: {len(compiled)} modules freshly compiled; {len(reused)} checked dependencies reused, {len(names)} axiom audits, {len(negatives)} mathematical rejections. '+str(out), flush=True)


if __name__ == '__main__':
    main()
