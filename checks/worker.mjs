// The worker of the check window. It starts Python (Pyodide, beside this file) and drives runner.py one step at a
// time, so that the page can say what is running. It reads nothing but Pyodide's own files: the files to run and
// the runner come from the page (the release's files as the bytes the page has compared, or the reader's changed
// copy of them, which the page then says). With `only`, that one step is run and no other; "file:<path>" is a
// step too, and runs that file of the copy. What a step writes
// is passed on line by line, with the step it came from.
//
// The second Python. Three of the release's tests start a second Python, and a browser has no processes. So before
// the step "tests" this worker starts two more interpreters, each a Pyodide of its own with its own memory,
// modules and files: one plain, one with -O. It is said to the page when they stand ready, and what each made of
// its flags. The runner then gives a test's command to the one with the flags the test asks for (runner.py says
// which commands), and for that one start the folders the two share (the working copy and the temporary folder)
// are carried over, the program is run, and the folders are carried back: one operation, so that the second
// sees what the test wrote and the test sees what the second wrote. If the two cannot be started, or the page
// asks for none (second: false), the tests run without, and those that start a second Python are named as not run.
const say = m => postMessage(m);
const PYODIDE = new URL("./pyodide/", import.meta.url).href;
let at = null;

function removeTree(FS, p) {
  if (FS.isDir(FS.stat(p).mode)) { for (const n of FS.readdir(p)) if (n !== "." && n !== "..") removeTree(FS, p + "/" + n); FS.rmdir(p); }
  else FS.unlink(p);
}
// After this, `to` has under dir exactly what `from` has there: its files with their bytes, and nothing else.
function carry(from, to, dir) {
  const FS = from.FS, TS = to.FS;
  if (!FS.analyzePath(dir).exists) { if (TS.analyzePath(dir).exists) removeTree(TS, dir); return; }
  if (TS.analyzePath(dir).exists && !TS.isDir(TS.stat(dir).mode)) TS.unlink(dir);
  TS.mkdirTree(dir);
  const names = FS.readdir(dir).filter(n => n !== "." && n !== "..");
  for (const n of TS.readdir(dir)) if (n !== "." && n !== ".." && !names.includes(n)) removeTree(TS, dir + "/" + n);
  for (const n of names) {
    const p = dir + "/" + n, mode = FS.stat(p).mode;
    if (FS.isDir(mode)) carry(from, to, p);
    else if (FS.isFile(mode)) {
      if (TS.analyzePath(p).exists && TS.isDir(TS.stat(p).mode)) removeTree(TS, p);
      TS.writeFile(p, FS.readFile(p));
    }
  }
}
// Two more interpreters for the tests, and the runner's way to them. Returns nothing; the page is told.
async function second(py, loadPyodide, runner, wanted) {
  if (!wanted) { say({ type: "second", state: "none", why: "" }); return; }
  say({ type: "second", state: "running" });
  const t0 = performance.now(), made = [];
  try {
    for (const flags of [[], ["-O"]]) {
      const c = await loadPyodide({ indexURL: PYODIDE, args: flags.slice(), stdout: () => {}, stderr: () => {} });
      c.FS.writeFile("/runner.py", new Uint8Array(runner));
      const is = JSON.parse(c.runPython('import sys, json\nsys.path.insert(0, "/")\nimport runner\njson.dumps({"optimize": sys.flags.optimize, "debug": __debug__})'));
      if (is.debug !== (flags.length === 0) || (is.optimize > 0) !== (flags.length > 0))
        throw new Error("an interpreter started with " + (flags.join(" ") || "no flags") + " has its assertions " + (is.debug ? "on" : "off"));
      made.push({ key: flags.join(" "), flags, c, optimize: is.optimize, debug: is.debug });
    }
  } catch (err) {
    say({ type: "second", state: "none", why: String(err && err.message || err).slice(0, 300) });
    return;
  }
  py.globals.set("SECOND", text => {
    const job = JSON.parse(text), one = made.find(x => x.key === job.flags.join(" "));
    if (!one) return '{"none": true}';
    for (const d of job.dirs) carry(py, one.c, d);
    one.c.globals.set("JOB", text);
    const answer = one.c.runPython("runner.child(JOB)");
    for (const d of job.dirs) carry(one.c, py, d);
    return answer;
  });
  py.runPython("R.second = SECOND");
  say({ type: "second", state: "done", seconds: (performance.now() - t0) / 1000, interpreters: made.map(x => ({ flags: x.flags, optimize: x.optimize, debug: x.debug })) });
}
onmessage = async e => {
  const m = e.data;
  if (m.type !== "run") return;
  try {
    const t0 = performance.now();
    say({ type: "python", state: "running" });
    const { loadPyodide } = await import("./pyodide/pyodide.mjs");
    const py = await loadPyodide({ indexURL: PYODIDE,
                                   stdout: t => say({ type: "said", step: at, text: t }), stderr: t => say({ type: "said", step: at, text: t }) });
    for (const f of m.files) {
      const at = "/repo/" + f.path;
      py.FS.mkdirTree(at.slice(0, at.lastIndexOf("/")));
      py.FS.writeFile(at, new Uint8Array(f.bytes));
    }
    py.FS.writeFile("/runner.py", new Uint8Array(m.runner));
    py.runPython('import sys\nsys.path.insert(0, "/")\nimport runner\nR = runner.Run("/repo", "/out", live=True)');
    const about = JSON.parse(py.runPython("R.about()"));
    say({ type: "python", state: "done", seconds: (performance.now() - t0) / 1000, about, pyodide: py.version });
    if (m.only && about.plan.indexOf(m.only) < 0 && !/^file:./.test(m.only)) throw new Error("no such step: " + m.only);
    for (const id of m.only ? [m.only] : about.plan) {
      if (id === "tests") await second(py, loadPyodide, m.runner, m.second !== false);
      at = id;
      say({ type: "step", id, state: "running" });
      const result = JSON.parse(py.runPython("R.step(" + JSON.stringify(id) + ")"));
      at = null;
      say({ type: "step", id, state: "done", result });
    }
    say({ type: "done", end: JSON.parse(py.runPython("R.end()")) });
  } catch (err) {
    say({ type: "failed", message: String(err && err.message || err).slice(0, 2000) });
  }
};
say({ type: "ready" });
