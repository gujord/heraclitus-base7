"""The steps of scripts/verify.py, run in one process: for a browser, which cannot start a second one.

This file is the adapter of the check window. It is not a proof check and not part of the release. It changes
no checker logic: each file of the release is run unchanged, as `python3 <file> ...` would run it (as __main__,
with the arguments scripts/verify.py gives it, its own folder first on the path, a module table of its own), and
the tests are found the way `python3 -m unittest discover -s tests` finds them.

What it does differently from scripts/verify.py, and why the two must not be called the same run:

  * verify.py starts every step as a process of its own. Here the steps share one process.
  * Three tests start a second Python themselves (two run the checker as a command on altered or missing
    files, one runs Python with -O), seven times between them. A browser has no processes. Whoever drives this
    file may give it a second interpreter for them (Run.second, below). The test files are run unchanged; for the
    one kind of command they give (this Python, -O or not, a file, arguments, the output captured as text)
    subprocess.run is then answered by that interpreter, which runs the file as child() below does. Each such
    start is recorded with its test, its exit code and the flags, and the step's result says that the tests were
    served so. A second interpreter is not a process: it cannot be stopped from outside, so a test's timeout is
    not kept, and the folders it shares with the first are carried over and back by whoever drives it.
    Where there is no second interpreter those tests end in an error. They are then reported by name as not
    run, never as passed, and the test step has exit code 1.
  * verify.py writes run.json, with its status, only when every step has exit code 0. Nothing here writes one.

One step at a time, so that whoever drives it can say what is running (each call returns JSON text):

    r = Run(repo, out); r.about(); r.step("integrity"); ...; r.end()

With live=True what a step writes is also passed on at once, line by line, to this process's own standard
output (in the browser: to the page's output pane), besides being kept for the step's result.

A step named "file:<path>" is not one of verify.py's: it runs that file of the folder, which may be one the
reader made, as `python3 <path>` started in the folder would, with no arguments.

or all of it at once:  python3 checks_runner.py <repo> <out>
"""
import contextlib, hashlib, io, json, os, platform, runpy, subprocess, sys, tempfile, time, traceback, unittest
from pathlib import Path

SCRIPTS = {"integrity": ("scripts/check_integrity.py", lambda out: []),
           "check_certificate.py": ("checker/check_certificate.py", lambda out: ["--output", str(out)]),
           "check_crossing_corollary.py": ("checker/check_crossing_corollary.py", lambda out: ["--output", str(out)]),
           "check_reduction_obligations.py": ("checker/check_reduction_obligations.py",
                                              lambda out: ["--output", str(out / "reduction-obligations.json")])}
PLAN = list(SCRIPTS) + ["tests"]
REPORTS = ["certificate-verification.json", "direct-base-verification.json", "crossing-corollary-verification.json",
           "reduction-obligations.json"]
NO_PROCESS = "needs a second process"
TESTS_COMMAND = "python3 -m unittest discover -s tests -v"     # the release's command for the step "tests"
SECOND_FLAGS = ("-O", "-OO")                                   # the interpreter's flags a second Python may be asked for


def command(args, kw):
    """The one kind of command a second interpreter is given, or None: [this Python, flags, a file, arguments],
    its output captured as text. Anything else is left to the real subprocess.run."""
    if not isinstance(args, (list, tuple)) or len(args) < 2 or str(args[0]) != sys.executable:
        return None
    if set(kw) - {"capture_output", "text", "universal_newlines", "timeout", "check", "cwd"}:
        return None
    if not kw.get("capture_output") or not (kw.get("text") or kw.get("universal_newlines")):
        return None
    rest, flags = [str(a) for a in args[1:]], []
    while rest and rest[0] in SECOND_FLAGS:
        flags.append(rest.pop(0))
    if not rest or rest[0].startswith("-"):
        return None
    return {"flags": flags, "script": rest[0], "args": rest[1:], "cwd": str(kw.get("cwd") or os.getcwd())}


def child(text):
    """In the second interpreter: one command, as `python <flags> <file> <arguments>` started in the given folder
    would run it. The file is run unchanged as __main__, its own folder first on the path; what it writes to
    standard output and to standard error is kept apart; the exit code is the one Python would give. The flags
    are the interpreter's own, set when it was started; what they made of it is said in the answer."""
    job = json.loads(text)
    out, err, code, script = io.StringIO(), io.StringIO(), 0, job["script"]
    argv0, path0, modules0, here = sys.argv, list(sys.path), set(sys.modules), os.getcwd()
    try:
        os.chdir(job["cwd"])
        if not os.path.isfile(script):
            err.write(f"python3: can't open file {script!r}: [Errno 2] No such file or directory\n")
            code = 2
        else:
            sys.argv = [script] + job["args"]
            sys.path.insert(0, os.path.dirname(os.path.abspath(script)))
            with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
                try:
                    runpy.run_path(script, run_name="__main__")
                except SystemExit as e:
                    code = e.code if isinstance(e.code, int) else (0 if e.code is None else 1)
                    if isinstance(e.code, str):
                        err.write(e.code + "\n")
                except BaseException:
                    code = 1
                    err.write(traceback.format_exc())
    finally:
        sys.argv, sys.path[:] = argv0, path0
        os.chdir(here)
        for m in set(sys.modules) - modules0:   # the next start finds the interpreter as a new process would
            del sys.modules[m]
    return json.dumps({"code": code, "out": out.getvalue(), "err": err.getvalue(), "optimize": sys.flags.optimize, "debug": __debug__})


class Kept(io.StringIO):
    """What a step writes: kept, and with `live` also passed on at once to the standard output it replaced."""

    def __init__(self, live):
        super().__init__()
        self.live = live

    def write(self, s):
        if self.live is not None:
            self.live.write(s)
        return super().write(s)

    def flush(self):
        if self.live is not None:
            self.live.flush()


class Outcomes(unittest.TextTestResult):
    """What became of each test, by its id. An error that comes from having no processes is named as that."""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.outcomes = []

    def addSuccess(self, test):
        super().addSuccess(test)
        self.outcomes.append([test.id(), "passed", ""])

    def addFailure(self, test, err):
        super().addFailure(test, err)
        self.outcomes.append([test.id(), "failed", f"{err[0].__name__}: {err[1]}"[:300]])

    def addError(self, test, err):
        super().addError(test, err)
        none = sys.platform == "emscripten" and isinstance(err[1], OSError) and "does not support processes" in str(err[1])
        self.outcomes.append([test.id(), NO_PROCESS if none else "error", f"{err[0].__name__}: {err[1]}"[:300]])

    def addSkip(self, test, reason):
        super().addSkip(test, reason)
        self.outcomes.append([test.id(), "skipped", str(reason)[:300]])

    def addExpectedFailure(self, test, err):
        super().addExpectedFailure(test, err)
        self.outcomes.append([test.id(), "failed as the test expects", ""])

    def addUnexpectedSuccess(self, test):
        super().addUnexpectedSuccess(test)
        self.outcomes.append([test.id(), "failed", "passed where the test expects a failure"])


class Run:
    def __init__(self, repo, out, live=False):
        if not __debug__:
            raise SystemExit("assertions are off (-O); nothing would be checked")
        self.repo, self.out, self.live = Path(repo), Path(out), live
        self.second = None                         # second(text) -> text: one command, run by child() in another interpreter
        self.out.mkdir(parents=True, exist_ok=True)
        for name in REPORTS:                       # no report of an earlier run may stand
            (self.out / name).unlink(missing_ok=True)
        self.began = time.perf_counter()

    def about(self):
        version = self.repo / "VERSION"            # a reader's copy may be without it
        return json.dumps({"python": platform.python_version(), "implementation": platform.python_implementation(),
                           "platform": sys.platform, "version": version.read_text().strip() if version.is_file() else None, "plan": PLAN,
                           "commands": dict({name: " ".join(["python3", file] + arguments(self.out)) for name, (file, arguments) in SCRIPTS.items()},
                                            tests=TESTS_COMMAND)})

    def _kept(self):
        return Kept(sys.stdout if self.live else None)

    def step(self, name):
        began = time.perf_counter()
        if name == "tests":
            said = self._tests()
        elif name.startswith("file:"):
            said = self._file(name[5:])
        else:
            said = self._script(*SCRIPTS[name])
        said.update(id=name, seconds=round(time.perf_counter() - began, 3))
        return json.dumps(said)

    def _script(self, file, arguments):
        script = self.repo / file
        argv0, path0, modules0 = sys.argv, list(sys.path), set(sys.modules)
        sys.argv, text, code = [str(script)] + arguments(self.out), self._kept(), 0
        sys.path.insert(0, str(script.parent))
        try:
            with contextlib.redirect_stdout(text), contextlib.redirect_stderr(text):
                runpy.run_path(str(script), run_name="__main__")
        except SystemExit as e:
            code = e.code if isinstance(e.code, int) else (0 if e.code is None else 1)
            if isinstance(e.code, str):
                text.write(e.code + "\n")
        except BaseException:
            code = 1
            text.write(traceback.format_exc())
        finally:
            sys.argv, sys.path[:] = argv0, path0
            for m in set(sys.modules) - modules0:   # the next step starts as a new process would
                del sys.modules[m]
        return {"file": file, "exit_code": code, "output": text.getvalue()[-6000:]}

    def _file(self, file):
        """A file of the folder that is not a step of verify.py, as `python3 <file>` started in the folder."""
        root, script = self.repo.resolve(), (self.repo / file).resolve()
        if root not in script.parents or not script.is_file():
            raise ValueError(f"no such file in the working copy: {file}")
        here = os.getcwd()
        os.chdir(root)
        try:
            return self._script(file, lambda out: [])
        finally:
            os.chdir(here)

    def _served(self, real, starts, now):
        """subprocess.run for the tests where a second interpreter is given: the commands of command() go to it."""
        root = os.path.realpath(self.repo)

        def run(args, **kw):
            job = command(args, kw)
            if job is None:
                return real(args, **kw)
            job["dirs"] = sorted({root, os.path.realpath(tempfile.gettempdir())})   # carried over and back
            r = json.loads(self.second(json.dumps(job)))
            if r.get("none"):                      # no interpreter with these flags stood ready: as with none at all
                return real(args, **kw)
            if bool(job["flags"]) == bool(r["debug"]):
                raise RuntimeError("the second interpreter does not have the assertions the flags ask for")
            file = os.path.realpath(job["script"])
            starts.append({"test": now[0], "flags": job["flags"], "file": os.path.relpath(file, root) if file.startswith(root + os.sep) else job["script"],
                           "args": len(job["args"]), "exit_code": r["code"]})
            done = subprocess.CompletedProcess(list(args), r["code"], r["out"], r["err"])
            if kw.get("check"):
                done.check_returncode()
            return done
        return run

    def _tests(self):
        text = self._kept()
        path0, modules0, real, starts, now = list(sys.path), set(sys.modules), subprocess.run, [], [None]

        class Named(Outcomes):                     # which test is running, for the record of a start
            def startTest(self, test):
                now[0] = test.id().split(".")[-1]
                super().startTest(test)

        try:
            if self.second:
                subprocess.run = self._served(real, starts, now)
            suite = unittest.TestLoader().discover(str(self.repo / "tests"))
            with contextlib.redirect_stdout(text), contextlib.redirect_stderr(text):
                r = unittest.TextTestRunner(stream=text, verbosity=2, resultclass=Named).run(suite)
        finally:
            subprocess.run = real
            sys.path[:] = path0
            for m in set(sys.modules) - modules0:
                del sys.modules[m]
        said = {"file": "tests", "exit_code": 0 if r.wasSuccessful() else 1, "run": r.testsRun, "tests": r.outcomes,
                "passed": sum(1 for t in r.outcomes if t[1] == "passed"),
                "no_process": [t[0] for t in r.outcomes if t[1] == NO_PROCESS], "output": text.getvalue()[-6000:]}
        if self.second:
            said["second"] = {"starts": starts}    # the Pythons the tests started, each run by a second interpreter
        return said

    def end(self):
        reports = {}
        for name in REPORTS:
            p = self.out / name
            if p.is_file():
                data = p.read_bytes()
                reports[name] = {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest(), "text": data.decode("utf-8")}
        return json.dumps({"seconds": round(time.perf_counter() - self.began, 3), "reports": reports})


if __name__ == "__main__":
    run = Run(sys.argv[1], sys.argv[2])
    print(json.dumps({"about": json.loads(run.about()), "steps": [json.loads(run.step(s)) for s in PLAN], "end": json.loads(run.end())}))
