/* The check window, opened by "Check it yourself" and named Virtual Python Studio in its title bar: the release's
   checker, run by the reader's own browser. (Virtual: the Python is CPython built for the browser's own virtual
   machine, WebAssembly, and the files it sees are a copy held in memory.)

   The window is the frame's, like the manuscript window: it pauses the scene, holds the keyboard, and gives the
   place back when it is closed. It is laid out the way a code editor is, because that is where its readers
   already know their way: the files at the left as a tree, the open files as tabs in the middle beside an
   overview, under them what the programs wrote, and a line of status at the foot.

   What it runs. The release's own files are laid out beside the page in checks/repo/. Before every run the page
   reads each file, works out its SHA-256 and sets it beside the value the release's own list gives; if one
   differs, nothing is run. Those bytes go to a worker (checks/worker.mjs), which starts Python and drives
   checks/runner.py one step at a time.

   The working copy. The reader may change the files, in this tab only: change a text file by hand, change a
   certificate by one of the prepared changes (each is a change that a test of the release makes; checks/files.js
   carries it as one splice of the file's text), delete a file, give it another name, make a new one. Every
   such file is marked wherever it is named (M changed, D deleted, U new), a run of a changed copy is told as
   that and never as a run of the release's files, and "Reset to the release" puts everything back. Nothing
   is stored: a reload is the release again.

   How a file is shown. In colours by what each part is, and a JSON file that is one long line laid out with
   indentation (checks/syntax.js; neither changes the text, and the window says when a file is shown laid out).

   What it does not pretend. A run here is not `python3 scripts/verify.py`: the steps share one process, and
   a browser has no processes for the tests that start a second Python. For those the worker starts two more
   interpreters (see checks/worker.mjs and checks/runner.py), and the terminal says so where it happens: that
   they were started, every start a test made with its exit code, and at the end of a run of all steps what
   that was instead of. Where they cannot be started those tests are named as not run, never as passed. A
   program of the reader's that tries to start a second Python is told that it gets none. The pane under the files looks like a terminal, so that a
   reader sees what is run: a prompt, the command each step stands for, the lines the program really wrote, and
   a block cursor. It is read-only and says so: nothing can be typed there, and nothing is shown that did not
   run. The Overview is
   kept to what is done there: the result of a finished run in one line (and every fault in it), the steps with
   what each came to under a head that holds Run all (in the colour of the way in on a scene, with its rings
   until something has been run), and the changes to try. While a run goes Run all is Stop, where it was
   pressed, and Stop is in the bar too, for when a file is open. Reset to the release stands under the
   Explorer's head, there only while the copy is changed; on a narrow window, where the Explorer lies far
   down, the bar's own is shown in its place. It has no paragraph of introduction; what a step or a change is
   stands in its title. A run of all steps on the release's files ends, in the terminal, with what it was not,
   in the words of the release's own verify.py (the player's checks hold every quotation against its source). */
(function () {
  "use strict";
  var P = window.PROOF, C = P.checks = { data: null }, S = P.syntax;
  var ui, D, box, link, from = null, worker = null, busy = null, can = null, why = "";
  var bytes = {}, sums = {}, sizes = {};          // the release's files as they were read from the site
  var edits = {};                                 // the working copy where it is not the release: path -> { bytes (null: deleted), how, sum }
  var rows = {}, tabs = [], doc = null, log = [], runs = 0, shut = {}, drawn = { tree: null, tabs: null }, naming = null, menu = null, lastOut = {};
  var run = fresh();
  var MONO_CUT = 1200, LINE_CUT = 3000, EDIT_BYTES = 120000, EDIT_LINE = 5000, LOG_CUT = 4000, WIDTH = 100, NEW_FILES = 40;
  var NAME = "Virtual Python Studio";       // the window's name; the ways in keep the invitation, "Check it yourself"
  // The window's own mark: "Py" on a tile in blue and yellow, drawn here. It is not the Python Software Foundation's logo.
  var MARK = '<svg class="checks-mark" viewBox="0 0 24 24" aria-hidden="true"><rect x="1" y="1" width="22" height="22" rx="5" fill="#306998"/>' +
             '<path d="M1 17h22v1a5 5 0 0 1-5 5H6a5 5 0 0 1-5-5z" fill="#ffd43b"/>' +
             '<text x="12" y="13.600" text-anchor="middle" font-family="-apple-system, Segoe UI, Helvetica, Arial, sans-serif" font-size="11.500" font-weight="800" fill="#fff">Py</text></svg>';
  var ICON = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3.5 5h17v14h-17z"/><path d="M7.5 10l3 2.5-3 2.5M12.5 15h4"/></svg>';
  var X = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18"/></svg>';
  var NEW = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M13.5 3.5h-7v17h11v-13z"/><path d="M13.5 3.5v4h4M12 11v6M9 14h6"/></svg>';
  var HALT = '<svg class="checks-play" viewBox="0 0 24 24" aria-hidden="true"><path d="M7 7h10v10H7z"/></svg>';
  var BACK = '<svg class="checks-back" viewBox="0 0 24 24" aria-hidden="true"><path d="M4.500 12a7.500 7.500 0 1 0 2.400-5.500"/><path d="M4.500 4.500v4.500h4.500"/></svg>';
  var RUN_ALL = "Run every step (Ctrl+Enter, or ⌘ Enter, when no program is open)", RESET = "Every file as in the release, and no run";
  var PLAY = '<svg class="checks-play" viewBox="0 0 24 24" aria-hidden="true"><path d="M8 5.500v13l10.500-6.500z"/></svg>';
  var BIN = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 7h14M10 7V4.500h4V7M7 7l.8 12.500h8.400L17 7M10.500 10.500v6M13.500 10.500v6"/></svg>';
  var DOTS = '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="6" cy="12" r="1.3"/><circle cx="12" cy="12" r="1.3"/><circle cx="18" cy="12" r="1.3"/></svg>';

  function fresh() { return { state: "idle", steps: {}, python: null, second: null, why: "", reports: null, message: "", seconds: 0, at: "", only: null, changed: [], n: 0 }; }
  function $(id) { return document.getElementById(id); }
  function el(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text !== undefined) e.textContent = text; return e; }
  function button(cls, text) { var b = el("button", cls, text); b.type = "button"; return b; }
  function count(n) { return String(n).replace(/\B(?=(\d{3})+$)/g, " "); }
  function secs(s) { return (s < 10 ? s.toFixed(1) : String(Math.round(s))) + " s"; }
  function hex(buf) { return Array.prototype.map.call(new Uint8Array(buf), function (b) { return (b < 16 ? "0" : "") + b.toString(16); }).join(""); }
  function all() { return D.files.concat([D.runner]); }
  function where(f) { return f.own ? f.path : "checks/repo/" + f.path; }
  function known(path) { return all().filter(function (f) { return f.path === path; })[0]; }
  function released(path) { return D.files.filter(function (f) { return f.path === path; })[0]; }
  function same(f) { return sums[f.path] === f.sha256 && sizes[f.path] === f.bytes; }
  function base(path) { return path.slice(path.lastIndexOf("/") + 1); }
  function folder(path) { return path.indexOf("/") < 0 ? "" : path.slice(0, path.lastIndexOf("/") + 1); }
  function change(id) { return D.alterations.filter(function (c) { return c.id === id; })[0]; }
  function going() { return run.state === "reading" || run.state === "running"; }
  function equal(a, b) {
    if (a.byteLength !== b.byteLength) return false;
    var x = new Uint8Array(a), y = new Uint8Array(b);
    for (var i = 0; i < x.length; i++) if (x[i] !== y[i]) return false;
    return true;
  }
  function text(buf) { try { return new TextDecoder("utf-8", { fatal: true }).decode(buf); } catch (e) { return null; } }
  function encode(t) { return new TextEncoder().encode(t).buffer; }

  // ---------------------------------------------------------------- the working copy
  // What it holds: the release's files that are not deleted, as changed or as released, and the files made here.
  function changed() { return Object.keys(edits).sort(); }
  function made(path) { return !!edits[path] && !released(path); }
  function deleted(path) { return !!edits[path] && edits[path].bytes === null; }
  function there(path) { return path === D.runner.path ? false : deleted(path) ? false : !!(released(path) || edits[path]); }
  function listed() {                       // every path the tree names: the release's, also where deleted, and the new ones
    var seen = {}, out = [];
    D.files.forEach(function (f) { seen[f.path] = 1; out.push(f.path); });
    Object.keys(edits).forEach(function (p) { if (!seen[p]) out.push(p); });
    return out;
  }
  function status(path) {
    var e = edits[path], f = known(path);
    if (e) return e.bytes === null ? "deleted" : released(path) ? "changed" : "new";
    return f && sums[path] ? (same(f) ? "ok" : "fail") : "waiting";
  }
  function how(path) {
    var e = edits[path];
    return !e ? "" : e.how === "by hand" || /^(deleted|new file|renamed )/.test(e.how) ? e.how : "the prepared change “" + change(e.how).title + "”";
  }
  function tally() {                        // what the bar says of the copy
    var c = 0, d = 0, n = 0;
    changed().forEach(function (p) { var s = status(p); if (s === "deleted") d++; else if (s === "new") n++; else c++; });
    if (!c && !d && !n) return "";
    if (!d && !n) return c + (c === 1 ? " file changed" : " files changed") + " by you · not the release’s files";
    return [c ? c + " changed" : "", d ? d + " deleted" : "", n ? n + " new" : ""].filter(Boolean).join(", ") + " by you · not the release’s files";
  }
  function note(path) {                     // the SHA-256 of a changed or new file, worked out when it is first wanted
    var e = edits[path];
    if (!e || e.sum || e.bytes === null || !(window.crypto && crypto.subtle)) return;
    var data = e.bytes;
    crypto.subtle.digest("SHA-256", data).then(function (d) { if (edits[path] && edits[path].bytes === data) { edits[path].sum = hex(d); paint(); } });
  }
  function put(path, data, by) {            // one file of the working copy
    if (released(path) && bytes[path] && equal(data, bytes[path])) delete edits[path];
    else { edits[path] = { bytes: data, how: by || (edits[path] ? edits[path].how : "new file"), sum: null }; note(path); }
  }
  function refuse(path, but) {              // why a name cannot be given, or ""
    var p = path, taken = listed().filter(function (q) { return q !== but && there(q); });
    if (!p) return "A name is needed.";
    if (p.length > 100) return "That name is too long.";
    if (!/^(?:[A-Za-z0-9._-]+\/)*[A-Za-z0-9._-]+$/.test(p) || p.split("/").some(function (s) { return s === "." || s === ".."; }))
      return "Letters, digits, . _ - and / for folders; no spaces, and no way out of the package.";
    if (p === D.runner.path || taken.indexOf(p) >= 0) return "There is a file of that name.";
    if (taken.some(function (q) { return q.indexOf(p + "/") === 0 || p.indexOf(q + "/") === 0; })) return "A file and a folder cannot have the same name.";
    return "";
  }
  function typed() {
    if (!doc || doc.kind !== "file" || !doc.editable) return;
    var v = $("checks-edit").value;
    put(doc.key, encode(v), released(doc.key) ? "by hand" : null);
    var n = v.split("\n"); doc.lines = n.length - (n.length > 1 && n[n.length - 1] === "" ? 1 : 0);
    numbers(n.length); colour(v);
    paint();
  }
  function restore(path) {                  // a file of the release, as released
    if (!released(path)) return;
    delete edits[path];
    refill(path); paint();
  }
  function remove(path) {
    if (!there(path)) return;
    if (released(path)) edits[path] = { bytes: null, how: "deleted", sum: null };
    else { delete edits[path]; shutTab("file", path); }
    refill(path); paint();
  }
  function create(path) {
    if (refuse(path) || changed().filter(made).length >= NEW_FILES) return false;
    put(path, new ArrayBuffer(0), "new file");
    paint(); openFile(path, null);
    return true;
  }
  function rename(path, to) {               // the same bytes under another name: the old name is gone, the new one is new
    if (!there(path) || refuse(to, path)) return Promise.resolve(false);
    var f = released(path);
    return (f ? read(f) : Promise.resolve()).then(function () {
      var data = edits[path] ? edits[path].bytes : bytes[path], was = tabs.filter(function (t) { return t.kind === "file" && t.key === path; })[0];
      if (f) edits[path] = { bytes: null, how: "renamed to " + to, sum: null }; else delete edits[path];
      put(to, data, "renamed from " + path);
      if (was && !tabs.some(function (t) { return t.kind === "file" && t.key === to; })) { was.key = to; drawn.tabs = null; }
      refill(path); refill(to); paint();
      return true;
    });
  }
  function alter(c, by) {
    var f = known(c.path);
    if (edits[c.path] && edits[c.path].how === c.id) { restore(c.path); return; }
    if (!can) return;
    read(f).then(function () {
      var t = text(bytes[c.path]);
      if (t === null || t.substr(c.at, c.delete.length) !== c.delete) { tell("note", "The change “" + c.title + "” does not fit " + c.path + " as it was read from this site; nothing was changed."); return; }
      put(c.path, encode(t.slice(0, c.at) + c.insert + t.slice(c.at + c.delete.length)), c.id);
      refill(c.path); paint(); if (by) by.focus();
    }).catch(function (e) { tell("note", c.path + " could not be read: " + String(e && e.message || e)); });
  }
  function reset() {
    if (going()) { if (busy) busy.terminate(); busy = null; }
    edits = {}; run = fresh(); log = []; lastOut = {}; clearLog(); naming = null;
    tabs = tabs.filter(function (t) { return t.kind === "file" && known(t.key); });
    if (doc && tabs.indexOf(doc) < 0) doc = null;
    drawn.tabs = null;
    if (doc) fill(doc.key); else showOver();
    paint();
  }

  // ---------------------------------------------------------------- the words
  function steps() {
    var q = D.quotes.steps, t = D.tests;
    return [
      { id: "files", name: "The release’s files are read",
        what: D.files.length + " files. For each, the SHA-256 worked out here is set beside the one release " + D.version + " lists in its release-manifest.json. " +
              "SHA-256 is a fingerprint of a file’s bytes: change one bit, and the fingerprint is another." },
      { id: "python", name: "Python starts in this browser",
        what: "Pyodide " + D.python.pyodide + ": the ordinary Python (CPython), built to run in a browser. About " + Math.round(D.python.bytes / 1e6) + " MB, fetched from this site the first time." },
      { id: "integrity", one: true, file: q.integrity.file, what: "In its own words: “" + q.integrity.text + "”" },
      { id: "check_certificate.py", one: true, file: "checker/check_certificate.py",
        what: "The checker. It goes through every choice in the certificates, and the first 117 649 steps of the walk itself." },
      { id: "check_crossing_corollary.py", one: true, file: q["check_crossing_corollary.py"].file, what: "In its own words: “" + q["check_crossing_corollary.py"].text + "”" },
      { id: "check_reduction_obligations.py", one: true, file: q["check_reduction_obligations.py"].file, what: "In its own words: “" + q["check_reduction_obligations.py"].text + "”" },
      { id: "tests", one: true, name: "tests/",
        what: "The rejection tests: " + t.count + " cases the checker must refuse, such as a certificate with one entry altered. " +
              t.need_process.length + " of them start a second Python. A browser has no processes, so this page starts a second Python interpreter for them." }
    ];
  }
  function step(id) { return rows[id] && rows[id].step; }
  function stepOf(path) { return steps().filter(function (s) { return s.one && s.file === path; })[0]; }
  function called(id) { var s = step(id); return s ? s.file || s.name : /^file:/.test(id) ? id.slice(5) : id; }
  var NO_SECOND = "This program tried to start a second Python. A browser has no processes, and this page starts a second interpreter only for the release’s tests, run as the step tests/. With the package it runs on plain Python.";
  var second = true;        // whether the tests are given a second interpreter (C.second; the player's checks run them without, too)
  function served(r) {      // of a tests' result: the starts a second interpreter ran, and how many tests made them
    var starts = r && r.second ? r.second.starts : [], tests = {};
    starts.forEach(function (s) { tests[s.test] = true; });
    return { starts: starts, tests: Object.keys(tests).length };
  }
  function limit(kind) { return D.quotes.limits.filter(function (q) { return !!q[kind]; })[0]; }      // what a run does not show: of a scene, of a file
  var FOLDER = location.protocol === "file:";      // why nothing can be run, when it cannot: such a page starts no worker; elsewhere the worker did not load
  var CANNOT = FOLDER ? "This page was opened from a folder on a disk. A browser does not let such a page start the program that runs Python, or read the files beside it, so nothing can be run or shown here. From a web address it can. Without a browser: <code>python3 scripts/verify.py</code> in the public package, with plain Python and no internet."
    : "The program that runs Python did not load, so nothing can be run or shown here. Without a network it loads only if this device has kept its files: Save for offline use, under App &amp; offline in the menu, keeps them. Reload the page to try again. Without a browser: <code>python3 scripts/verify.py</code> in the public package, with plain Python and no internet.";
  var NO_SUMS = "This browser works out SHA-256 for a page only over https or on your own machine. Without it the files cannot be compared with the release’s list, so the page does not run them.";
  var LANGUAGE = { json: "JSON", jsonl: "JSON Lines", python: "Python", "": "Plain text" };

  // ---------------------------------------------------------------- the window
  function build() {
    box = el("div", "paper checks"); box.id = "checks"; box.hidden = true;
    box.setAttribute("role", "dialog"); box.setAttribute("aria-modal", "true"); box.setAttribute("aria-labelledby", "checks-title");
    box.innerHTML =
      '<div class="paper-box checks-box">' +
        '<div class="paper-head">' +
          MARK + '<div class="paper-what"><b id="checks-title"><span id="checks-app"></span><span id="checks-release" class="checks-release"></span></b><small id="checks-sub"></small></div>' +
          '<button id="checks-close" class="window-close" type="button" aria-label="Close" title="Close (Esc)">' + X + '</button>' +
        '</div>' +
        '<div class="checks-bar">' +
          '<button id="checks-stop" class="pill" type="button" hidden>Stop</button>' +
          '<span id="checks-status" role="status" aria-live="polite"></span>' +
          '<span id="checks-changed" class="checks-changed" hidden></span>' +
          '<button id="checks-reset-bar" class="checks-reset checks-reset-bar" type="button" hidden disabled title="' + RESET + '">' + BACK + '<span>Reset to the release</span></button>' +
        '</div>' +
        '<p id="checks-cannot" class="checks-cannot" hidden></p>' +
        '<div class="checks-work">' +
          '<aside class="checks-side" aria-label="The files">' +
            '<div class="checks-side-head"><h3>Explorer</h3>' +
              '<button id="checks-new" class="checks-icon" type="button" aria-label="New file" title="New file…">' + NEW + '</button>' +
              '<button id="checks-more" class="checks-icon" type="button" aria-label="More actions" title="More actions" aria-haspopup="menu">' + DOTS + '</button></div>' +
            '<button id="checks-reset" class="checks-reset" type="button" hidden disabled title="' + RESET + '">' + BACK + '<span>Reset to the release</span></button>' +
            '<details class="checks-section" open><summary><span>Checks of the release</span>' +
              '<button id="checks-side-run" class="checks-icon" type="button" aria-label="Run all" title="Run all">' + PLAY + '</button></summary><ul id="checks-side-steps" class="checks-files checks-runs"></ul></details>' +
            '<details class="checks-section" open><summary><span>Release <span class="checks-version"></span> · working copy</span></summary><div id="checks-files" class="checks-tree"></div></details>' +
            '<details id="checks-reports" class="checks-section" open hidden><summary><span>Reports of this run</span></summary><ul id="checks-report-list" class="checks-files"></ul></details>' +
            '<details class="checks-section" open><summary><span>This page’s own</span></summary><ul id="checks-own" class="checks-files"></ul></details>' +
            '<p class="checks-legend"><span><i data-state="ok"></i> read: SHA-256 as the release lists</span><span><b data-state="changed">M</b> changed</span><span><b data-state="deleted">D</b> deleted</span>' +
              '<span><b data-state="new">U</b> new</span><span>by you, in this tab only. A file’s actions: its ⋯, or a right click.</span></p>' +
          '</aside>' +
          '<div class="checks-centre">' +
            '<div id="checks-tabs" class="checks-tabs" role="tablist"><button id="checks-tab-over" class="checks-tab" type="button" role="tab" aria-controls="checks-over">Overview</button></div>' +
            '<section id="checks-over" class="checks-over" role="tabpanel" aria-labelledby="checks-tab-over">' +
              '<div id="checks-result" class="checks-result" hidden></div>' +
              '<div class="checks-go"><b>All steps</b>' +
                '<button id="checks-run" class="pill checks-all" type="button" title="' + RUN_ALL + '"><span id="checks-run-mark">' + PLAY + '</span><span id="checks-run-label">Run all</span></button></div>' +
              '<ol id="checks-steps" class="checks-steps"></ol>' +
              '<div class="checks-try">' +
                '<h3>Try to break it</h3>' +
                '<ul id="checks-alter" class="checks-alter"></ul>' +
              '</div>' +
            '</section>' +
            '<section id="checks-doc" class="checks-doc" role="tabpanel" hidden>' +
              '<div class="checks-doc-head"><div class="checks-doc-what"><b id="checks-doc-title"></b><small id="checks-doc-meta"></small><small id="checks-doc-note"></small></div>' +
                '<span id="checks-doc-as" class="checks-seg" role="group" aria-label="How the file is shown" hidden>' +
                  '<button id="checks-doc-formatted" type="button" title="The file’s own parts, with spaces and line breaks added between them">Indented</button>' +
                  '<button id="checks-doc-raw" type="button" title="The file’s lines as they are">As in the file</button></span>' +
                '<button id="checks-doc-run" class="pill dark" type="button" title="Run this file (Ctrl+Enter, or ⌘ Enter)" hidden>' + PLAY + '<span>Run this file</span></button>' +
                '<button id="checks-doc-restore" class="pill" type="button" hidden>Restore this file</button></div>' +
              '<div id="checks-doc-body" class="checks-doc-body"><pre id="checks-ln" class="checks-ln" aria-hidden="true"></pre>' +
                '<div id="checks-edit-wrap" class="checks-edit-wrap" hidden>' +
                  '<textarea id="checks-edit" class="checks-edit" spellcheck="false" autocapitalize="off" autocomplete="off" wrap="off" aria-labelledby="checks-doc-title"></textarea>' +
                  '<pre id="checks-paint" class="checks-paint" aria-hidden="true"></pre></div>' +
                '<div id="checks-read" class="checks-read" hidden><pre id="checks-src" class="checks-src" tabindex="0"></pre>' +
                  '<button id="checks-doc-more" class="pill" type="button" hidden></button></div></div>' +
            '</section>' +
          '</div>' +
          '<section class="checks-out" aria-label="Terminal, read-only">' +
            '<div id="checks-split" class="checks-split" role="separator" aria-orientation="horizontal" aria-label="The terminal’s height" tabindex="0" title="Drag to make the terminal taller or lower"></div>' +
            '<div class="checks-out-head"><h3>Terminal</h3><small id="checks-out-note"><b>Read-only.</b> Each command is the one its step stands for; under it, the lines the program wrote here.</small>' +
              '<button id="checks-clear" class="checks-icon" type="button" aria-label="Clear the terminal" title="Clear the terminal">' + BIN + '</button></div>' +
            '<div id="checks-log" class="checks-log" role="log" tabindex="0" aria-label="The commands, and what the programs wrote"></div>' +
          '</section>' +
        '</div>' +
        '<div class="checks-foot"><span id="checks-foot-copy"></span><span id="checks-foot-run"></span><span class="checks-foot-gap"></span>' +
          '<span id="checks-foot-place"></span><span id="checks-foot-lines"></span><span id="checks-foot-kind"></span><span id="checks-foot-python"></span></div>' +
      '</div>';
    document.body.appendChild(box);
    Array.prototype.forEach.call(box.querySelectorAll(".checks-version"), function (e) { e.textContent = D.version; });
    $("checks-app").textContent = NAME; $("checks-release").textContent = "release " + D.version;
    $("checks-sub").textContent = "Check it yourself: the release’s checker, run by Python in your browser, on your machine";
    $("checks-close").onclick = close; clearLog();
    box.addEventListener("pointerdown", function (ev) { if (menu && !menu.contains(ev.target)) shutMenu(); if (ev.target === box) close(); });
    box.addEventListener("keydown", function (ev) {     // Escape leaves a menu, then a name being given, then a file, then the window (the page's own handler)
      if (ev.key === "Enter" && (ev.ctrlKey || ev.metaKey) && !naming && !menu) {      // run: the open program, or else every step
        ev.preventDefault();
        if (doc && doc.kind === "file" && there(doc.key) && S.kind(doc.key) === "python") runFile(doc.key); else start(null);
        return;
      }
      if (ev.key !== "Escape") return;
      if (menu) { ev.preventDefault(); ev.stopPropagation(); shutMenu(true); }
      else if (naming) { ev.preventDefault(); ev.stopPropagation(); endNaming(true); }
      else if (doc) { ev.preventDefault(); ev.stopPropagation(); closeDoc(); }
    });
    // Run all is Stop while a run goes; the second click of a double click must not stop what the first one started
    $("checks-run").onclick = function (ev) { if (!going()) start(null); else if (!(ev.detail > 1)) stop(); };
    $("checks-run").onkeydown = function (ev) { if (ev.repeat && ev.key === "Enter") ev.preventDefault(); };      // nor must a held Enter
    $("checks-stop").onclick = stop; $("checks-reset").onclick = $("checks-reset-bar").onclick = reset;
    $("checks-side-run").onclick = function (ev) { ev.preventDefault(); start(null); };
    $("checks-clear").onclick = function () { if (!going()) { log = []; lastOut = {}; clearLog(); paint(); } };
    split();
    $("checks-tab-over").onclick = function () { showOver(); paint(); $("checks-tab-over").focus(); };
    $("checks-doc-restore").onclick = function () { if (doc && doc.kind === "file") restore(doc.key); };
    $("checks-doc-run").onclick = function () { if (doc) runFile(doc.key); };
    $("checks-doc-formatted").onclick = function () { view("formatted"); }; $("checks-doc-raw").onclick = function () { view("raw"); };
    $("checks-doc-more").onclick = function () { if (doc) { doc.limit += LINE_CUT; render(); paint(); } };
    $("checks-new").onclick = function () { name("new", ""); };
    $("checks-more").onclick = function () { var r = $("checks-more").getBoundingClientRect(); openMenu(sideMenu(), r.left, r.bottom + 2, $("checks-more")); };
    var edit = $("checks-edit");
    edit.addEventListener("input", typed);
    edit.addEventListener("scroll", function () { $("checks-ln").scrollTop = edit.scrollTop; $("checks-paint").scrollTop = edit.scrollTop; $("checks-paint").scrollLeft = edit.scrollLeft; });
    ["keyup", "click", "input", "focus"].forEach(function (n) { edit.addEventListener(n, place); });
    edit.addEventListener("keydown", function (ev) {       // Tab writes four spaces, as in the release's programs; Escape first leaves the field
      if (ev.key !== "Tab" || ev.shiftKey || ev.altKey || ev.ctrlKey || ev.metaKey) return;
      ev.preventDefault(); edit.setRangeText("    ", edit.selectionStart, edit.selectionEnd, "end"); typed();
    });

    steps().forEach(function (s) {
      var li = el("li", "checks-step"), mid = el("div", "checks-step-what"), name, said = button("checks-said", "waiting"), one = null;
      li.dataset.step = s.id; li.dataset.state = "waiting";
      if (s.file) { name = button("checks-name", s.file); name.onclick = function () { openFile(s.file, name); }; }
      else name = el("b", "checks-name", s.name);
      mid.appendChild(name); mid.title = s.what;
      said.disabled = true; said.onclick = function () { showStep(s.id); };
      li.appendChild(el("span", "checks-dot")); li.appendChild(mid); li.appendChild(said);
      if (s.one) {
        one = button("pill checks-one", "Run"); one.setAttribute("aria-label", "Run only " + (s.file || s.name)); one.title = "Run only this step";
        one.onclick = function () { start(s.id); }; li.appendChild(one);
      }
      $("checks-steps").appendChild(li); rows[s.id] = { li: li, said: said, one: one, step: s };
      if (s.one) {                         // and at the side, where it is in reach whatever is open
        var sl = el("li"), sn = s.file ? button("checks-file") : el("span", "checks-file"), sr = button("checks-row-run");
        sl.dataset.runStep = s.id; sl.dataset.state = "waiting";
        sn.appendChild(el("span", "checks-st")); sn.appendChild(el("span", "checks-fn", s.file ? base(s.file) : "tests/"));
        if (s.file) { sn.title = "Open " + s.file; sn.onclick = function () { openFile(s.file, sn); }; }
        sr.innerHTML = PLAY; sr.setAttribute("aria-label", "Run only " + (s.file || s.name)); sr.title = "Run only this step";
        sr.onclick = function () { start(s.id); };
        sl.appendChild(sn); sl.appendChild(sr); sl.appendChild(el("span", "checks-badge"));
        $("checks-side-steps").appendChild(sl); rows[s.id].side = sl; rows[s.id].sideRun = sr;
      }
    });
    $("checks-own").appendChild(row(D.runner.path, D.runner.path));

    // the prepared changes
    D.alterations.forEach(function (c) {
      var li = el("li"), mid = el("div", "checks-alter-what"), b = button("pill checks-alter-do", "Make this change");
      li.dataset.alter = c.id; li.dataset.on = "false";
      mid.appendChild(el("b", "", c.title)); mid.appendChild(el("small", "", c.path));
      mid.title = c.what + " As in " + c.test + ".";
      b.onclick = function () { alter(c, b); };
      li.appendChild(mid); li.appendChild(b); $("checks-alter").appendChild(li);
    });
  }

  function open(by) {
    if (!box.hidden) return;
    from = by || null;
    ui.clear(); ui.pause();
    box.hidden = false; document.body.classList.add("checks-open"); ui.behind(); ui.address();
    if (can === null) worker = make();
    paint(); $("checks-close").focus();
  }
  function close() {
    if (box.hidden) return;
    shutMenu(); endNaming(false, true);
    box.hidden = true; document.body.classList.remove("checks-open"); ui.behind(); ui.address();
    var to = from && document.contains(from) && from.offsetParent ? from : null; from = null;
    if (to) to.focus();
  }

  // ---------------------------------------------------------------- the files, as a tree
  var KIND_MARK = { json: "{}", jsonl: "{}", python: "py", "": "≡" };
  function row(path, label) {
    var li = el("li"), b = button("checks-file"), more = button("checks-row-more"), k = S.kind(path);
    var mark = el("span", "checks-ft", KIND_MARK[k]); mark.dataset.kind = k; mark.setAttribute("aria-hidden", "true");
    b.appendChild(mark); b.appendChild(el("span", "checks-fn", label));
    b.onclick = function () { openFile(path, b); };
    b.addEventListener("keydown", function (ev) {
      if (ev.key === "F2" && there(path)) { ev.preventDefault(); name("rename", path); }
      else if ((ev.key === "Delete" || (ev.key === "Backspace" && ev.metaKey)) && there(path)) { ev.preventDefault(); remove(path); focusRow(path); }
    });
    more.innerHTML = DOTS; more.setAttribute("aria-label", "Actions for " + path); more.title = "Actions"; more.setAttribute("aria-haspopup", "menu");
    more.onclick = function () { var r = more.getBoundingClientRect(); openMenu(fileMenu(path), r.left, r.bottom + 2, more); };
    li.addEventListener("contextmenu", function (ev) { ev.preventDefault(); openMenu(fileMenu(path), ev.clientX, ev.clientY, b); });
    li.dataset.path = path; li.setAttribute("role", "treeitem");
    li.appendChild(b);
    if (k === "python" && path !== D.runner.path) {
      var go = button("checks-row-run"); go.innerHTML = PLAY; go.setAttribute("aria-label", "Run " + path); go.title = "Run this file";
      go.onclick = function () { if (can && !going() && there(path)) runFile(path); };
      li.appendChild(go);
    }
    if (path !== D.runner.path) li.appendChild(more); li.appendChild(el("span", "checks-badge"));
    return li;
  }
  function focusRow(path) { var li = box.querySelector('li[data-path="' + path + '"]'); if (li) li.querySelector("button").focus(); }
  function tree() {                         // made again only when the names in it change, so that the keyboard keeps its place
    var paths = listed(), key = paths.join("\n") + "\n" + (naming ? naming.mode + ":" + naming.path : "");
    if (drawn.tree === key) return;
    drawn.tree = key;
    var host = $("checks-files"), folders = [], top = el("ul", "checks-files checks-top");
    host.innerHTML = "";
    paths.forEach(function (p) { var d = folder(p); if (d && folders.indexOf(d) < 0) folders.push(d); });
    folders.sort();
    function entry(p) { return naming && naming.mode === "rename" && naming.path === p ? namer() : row(p, base(p)); }
    if (naming && naming.mode === "new") host.appendChild(el("ul", "checks-files checks-top")).appendChild(namer());
    folders.forEach(function (d) {
      var det = el("details", "checks-folder"), sum = el("summary"), ul = el("ul", "checks-files");
      det.open = !shut[d]; det.dataset.folder = d;
      det.addEventListener("toggle", function () { shut[d] = !det.open; });
      sum.appendChild(el("b", "", d));
      sum.addEventListener("contextmenu", function (ev) { ev.preventDefault(); openMenu([{ text: "New file here…", go: function () { name("new", d); } }], ev.clientX, ev.clientY, sum); });
      paths.filter(function (p) { return folder(p) === d; }).sort().forEach(function (p) { ul.appendChild(entry(p)); });
      det.appendChild(sum); det.appendChild(ul); host.appendChild(det);
    });
    paths.filter(function (p) { return !folder(p); }).sort().forEach(function (p) { top.appendChild(entry(p)); });
    host.appendChild(top);
    if (naming) { var input = $("checks-name-input"); input.focus(); input.setSelectionRange(naming.mode === "new" ? input.value.length : folder(naming.path).length, input.value.length); }
  }
  // a name being given, to a new file or to one that has another
  function namer() {
    var li = el("li", "checks-naming"), input = el("input"), say = el("small");
    input.id = "checks-name-input"; input.type = "text"; input.spellcheck = false; input.autocomplete = "off"; input.setAttribute("autocapitalize", "off");
    input.setAttribute("aria-label", naming.mode === "new" ? "The new file’s name, with its folder" : "The new name of " + naming.path);
    input.value = naming.mode === "new" ? naming.path : naming.path; say.id = "checks-name-why"; say.setAttribute("role", "status");
    say.textContent = naming.mode === "new" ? "Enter makes the file · Esc leaves" : "Enter gives the name · Esc leaves";
    input.addEventListener("keydown", function (ev) {
      if (ev.key !== "Enter") return;
      ev.preventDefault();
      var to = input.value.trim(), why = naming.mode === "rename" && to === naming.path ? "" : refuse(to, naming.mode === "rename" ? naming.path : null);
      if (naming.mode === "new" && !why && changed().filter(made).length >= NEW_FILES) why = "No more than " + NEW_FILES + " new files.";
      if (why) { say.textContent = why; say.className = "warn"; return; }
      var n = naming; naming = null; drawn.tree = null;
      if (n.mode === "new") create(to);
      else if (to === n.path) { paint(); focusRow(to); }
      else rename(n.path, to).then(function () { focusRow(to); });
    });
    input.addEventListener("blur", function () { setTimeout(function () { if (naming && document.activeElement !== input) endNaming(false, true); }, 0); });
    li.appendChild(input); li.appendChild(say);
    return li;
  }
  function name(mode, path) {
    if (!can) return;
    shutMenu(); naming = { mode: mode, path: path }; drawn.tree = null; paint();
  }
  function endNaming(focus, quiet) {
    if (!naming) return;
    var n = naming; naming = null; drawn.tree = null;
    if (quiet !== true || !box.hidden) paint();
    if (focus) { if (n.mode === "rename") focusRow(n.path); else $("checks-new").focus(); }
  }

  // The terminal's height, by a handle on its upper edge: dragged, or moved with the arrow keys.
  function split() {
    var h = $("checks-split"), work = box.querySelector(".checks-work"), out = box.querySelector(".checks-out");
    function to(px) {
      var all = work.getBoundingClientRect().height, v = Math.max(90, Math.min(px, all - 140));
      work.style.gridTemplateRows = "minmax(0, 1fr) " + Math.round(v) + "px"; h.setAttribute("aria-valuenow", String(Math.round(v)));
    }
    h.addEventListener("pointerdown", function (ev) {
      ev.preventDefault(); h.setPointerCapture(ev.pointerId); h.dataset.drag = "true";
      function move(e) { to(work.getBoundingClientRect().bottom - e.clientY); }
      function up() { h.removeEventListener("pointermove", move); h.removeEventListener("pointerup", up); h.removeEventListener("pointercancel", up); delete h.dataset.drag; }
      h.addEventListener("pointermove", move); h.addEventListener("pointerup", up); h.addEventListener("pointercancel", up);
    });
    h.addEventListener("keydown", function (ev) {
      if (ev.key !== "ArrowUp" && ev.key !== "ArrowDown") return;
      ev.preventDefault(); to(out.getBoundingClientRect().height + (ev.key === "ArrowUp" ? 24 : -24));
    });
  }

  // ---------------------------------------------------------------- a menu of actions
  function fileMenu(path) {
    var items = [{ text: "Open", go: function () { openFile(path, null); } }], f = released(path), e = edits[path];
    if (path === D.runner.path || !can) return items;
    if (there(path) && S.kind(path) === "python") items.push({ text: "Run this file", off: going(), go: function () { runFile(path); } });
    if (there(path)) items.push({ text: "Rename…", key: "F2", go: function () { name("rename", path); } });
    if (there(path)) items.push({ text: "Delete", key: "Del", go: function () { remove(path); } });
    if (f && e) items.push({ text: "Restore from the release", go: function () { restore(path); focusRow(path); } });
    items.push({ text: "New file in this folder…", go: function () { name("new", folder(path)); } });
    return items;
  }
  function sideMenu() {
    var folders = box.querySelectorAll("details.checks-folder"), anyOpen = Array.prototype.some.call(folders, function (d) { return d.open; });
    return [{ text: "New file…", off: !can, go: function () { name("new", ""); } },
            { text: anyOpen ? "Collapse folders" : "Expand folders", go: function () { Array.prototype.forEach.call(folders, function (d) { d.open = !anyOpen; shut[d.dataset.folder] = anyOpen; }); } },
            { text: "Reset to the release", off: $("checks-reset").disabled, go: reset }];
  }
  function openMenu(items, x, y, by) {
    shutMenu();
    var m = el("div", "checks-menu"); m.setAttribute("role", "menu"); m.id = "checks-menu";
    items.forEach(function (it) {
      var b = button("checks-menu-item"); b.setAttribute("role", "menuitem"); b.disabled = !!it.off;
      b.appendChild(el("span", "", it.text)); if (it.key) b.appendChild(el("kbd", "", it.key));
      b.onclick = function () { shutMenu(); it.go(); };
      m.appendChild(b);
    });
    m.addEventListener("keydown", function (ev) {
      var list = Array.prototype.filter.call(m.children, function (b) { return !b.disabled; }), i = list.indexOf(document.activeElement);
      if (ev.key === "ArrowDown" || ev.key === "ArrowUp") { ev.preventDefault(); list[(i + (ev.key === "ArrowDown" ? 1 : list.length - 1)) % list.length].focus(); }
      else if (ev.key === "Tab") { ev.preventDefault(); shutMenu(true); }
    });
    box.appendChild(m); menu = m; m.by = by || null;
    var w = m.offsetWidth, h = m.offsetHeight;
    m.style.left = Math.max(4, Math.min(x, window.innerWidth - w - 4)) + "px"; m.style.top = Math.max(4, Math.min(y, window.innerHeight - h - 4)) + "px";
    var first = m.querySelector("button:not(:disabled)"); if (first) first.focus();
  }
  function shutMenu(focus) {
    if (!menu) return;
    var by = menu.by; menu.remove(); menu = null;
    if (focus && by && document.contains(by)) by.focus();
  }

  // ---------------------------------------------------------------- a run
  function make() {
    try {
      var w = new Worker("checks/worker.mjs", { type: "module" });
      w.onmessage = function (ev) { heard(w, ev.data); };
      w.onerror = function (ev) { if (ev.preventDefault) ev.preventDefault(); broke(w, ev.message || "it did not load"); };
      can = true; return w;
    } catch (e) { can = false; why = String(e && e.message || e); return null; }
  }
  function read(f) {                       // a file's bytes and their SHA-256, read once
    if (bytes[f.path]) return Promise.resolve(f);
    return fetch(where(f)).then(function (r) { if (!r.ok) throw new Error(f.path + " could not be read (" + r.status + ")"); return r.arrayBuffer(); })
      .then(function (buf) { return crypto.subtle.digest("SHA-256", buf).then(function (d) { bytes[f.path] = buf; sizes[f.path] = buf.byteLength; sums[f.path] = hex(d); return f; }); });
  }
  function set(id, state, text, more) { run.steps[id] = { state: state, text: text, more: more || null }; }
  // The pane as a terminal. What stands in it: a prompt and the command a step stands for; the lines the program
  // wrote, coloured by what they are and otherwise as written; and, as a shell's comments, what the page itself
  // says of the run. The last line is the cursor: after a prompt when nothing runs, alone while a program runs.
  function prompt(changedCopy) {
    return '<span class="term-prompt" aria-hidden="true"><span class="term-who">reader@browser</span>:<span class="term-dir">~/heraclitus-base7-' + S.esc(D.version) + '</span>' +
           (changedCopy ? ' <span class="term-changed">(changed copy)</span>' : "") + '$ </span>';
  }
  function cursor() {                      // the last line of the pane
    var pane = $("checks-log"), c = $("checks-cursor");
    if (!c) { c = el("div", "checks-line term-last"); c.id = "checks-cursor"; pane.appendChild(c); }
    var busyNow = going(), key = busyNow + ":" + changed().length;
    if (c.dataset.key !== key) { c.dataset.key = key; c.innerHTML = (busyNow ? "" : prompt(changed().length > 0)) + '<span class="term-cursor" aria-hidden="true"> </span>'; }
    return c;
  }
  function clearLog() {
    var pane = $("checks-log"); pane.innerHTML = "";
    var first = el("div", "checks-line note", "# Nothing has run yet. Run all, or Run at a step, and the commands and what they write come here."); first.id = "checks-log-first";
    pane.appendChild(first); cursor();
  }
  function tell(cls, line, id) {           // one line of the pane
    var at = log.length, e = { cls: cls, text: line, step: id || "", run: run.n };
    log.push(e);
    if (at > LOG_CUT) return;
    var pane = $("checks-log"), near = pane.scrollHeight - pane.scrollTop - pane.clientHeight < 40, row = el("div", "checks-line " + cls);
    if (at === LOG_CUT) row.textContent = "# … more was written than is shown here";
    else if (cls === "out") {              // a program's own line: coloured by what it is, and otherwise as written
      var before = lastOut[e.step] || "";
      row.innerHTML = line.split("\n").map(function (l) { var h = S.out(l, before); before = l; return h; }).join("\n");
      lastOut[e.step] = before;
    } else if (cls === "cmd") row.innerHTML = prompt(run.changed.length > 0) + '<span class="term-cmd">' + S.esc(line) + "</span>";
    else row.textContent = "# " + line;    // the page's own words, as a shell's comment
    if (e.step) row.dataset.step = e.step; row.dataset.run = String(e.run);
    if ($("checks-log-first")) $("checks-log-first").remove();
    pane.insertBefore(row, cursor());
    if (near) pane.scrollTop = pane.scrollHeight;
  }
  function runFile(path) {                 // a step of the release as that step; any other program as `python3 <its name>`
    var s = stepOf(path);
    start(s ? s.id : "file:" + path);
  }
  function start(only) {
    if (!can || going()) return;
    if (!(window.crypto && crypto.subtle)) { run = fresh(); run.state = "failed"; run.message = NO_SUMS; paint(); return; }
    var mine = run = fresh(), w = worker || make(); worker = null;
    if (!w) { paint(); return; }
    tabs = tabs.filter(function (t) { return t.kind !== "report"; }); if (doc && doc.kind === "report") { doc = null; showOver(); } drawn.tabs = null;
    run.n = ++runs; run.only = only || null; run.changed = changed().map(function (p) { return { path: p, how: how(p) }; }); lastOut = {};
    busy = w; run.state = "reading"; run.at = "files"; set("files", "running", "reading"); paint();
    tell("run", "Run " + run.n + " · " + (only ? "only " + called(only) : "all steps") + " · " +
         (run.changed.length ? "a changed copy, not the release’s files: " + run.changed.map(function (c) { return c.path; }).join(", ") : "the release’s files, unchanged"));
    var copy = {}; changed().forEach(function (p) { copy[p] = edits[p].bytes; });      // the copy as it is now
    Promise.all(all().map(read)).then(function () {
      if (mine !== run || run.state !== "reading") return;      // another run since, or this one stopped while the files were read
      var wrong = all().filter(function (f) { return !same(f); });
      if (wrong.length) {
        set("files", "fail", wrong.length + " differ");
        run.state = "failed"; run.message = "Not the listed bytes: " + wrong.map(function (f) { return f.path; }).join(", ") + ". Nothing was run.";
        wrong.forEach(function (f) { delete bytes[f.path]; });      // what was read stays shown; the next look reads the file anew
        tell("end fail", run.message);
        busy.terminate(); busy = null; paint(); return;
      }
      var n = run.changed.length;
      set("files", n ? "part" : "ok", D.files.length + " read, each as listed" + (n ? " · " + n + " then changed by you" : ""));
      tell("note", "Read " + D.files.length + " files from this site. Each has the SHA-256 that release " + D.version + " lists." +
           (n ? " In their place for this run, your working copy: " + run.changed.map(function (c) { return c.path + " (" + c.how + ")"; }).join(", ") + "." : ""));
      run.state = "running"; run.at = "python"; paint();
      var files = [], runner = bytes[D.runner.path].slice(0);
      D.files.forEach(function (f) { if (!(f.path in copy)) files.push({ path: f.path, bytes: bytes[f.path].slice(0) }); });
      Object.keys(copy).forEach(function (p) { if (copy[p] !== null) files.push({ path: p, bytes: copy[p].slice(0) }); });
      w.postMessage({ type: "run", files: files, runner: runner, only: run.only, second: second }, files.map(function (f) { return f.bytes; }).concat([runner]));
    }).catch(function (e) {
      if (mine !== run || !going()) return;
      set("files", "fail", "not read"); run.state = "failed"; run.message = String(e && e.message || e);
      tell("end fail", run.message);
      if (busy) busy.terminate(); busy = null; paint();
    });
  }
  function stop() {
    if (!going()) return;
    if (busy) busy.terminate(); busy = null;
    if (run.steps[run.at]) run.steps[run.at] = { state: "off", text: "stopped" };
    run.state = "stopped"; tell("end", "Stopped by you. Nothing is concluded from a stopped run."); paint();
    if (doc && tabOf(doc)) tabOf(doc).querySelector(".checks-tab").focus(); else $("checks-run").focus();      // Stop is gone: the keyboard goes to what is shown
  }
  function broke(w, message) {
    if (w === busy) { busy = null; run.state = "failed"; run.message = "The program that runs Python broke off: " + message; tell("end fail", run.message); }
    else if (w === worker) { worker = null; can = false; why = message; }
    paint();
  }
  function heard(w, m) {
    if (w !== busy || m.type === "ready") return;
    if (m.type === "said") { tell("out", m.text, m.step || ""); return; }
    if (m.type === "python") {
      if (m.state === "running") set("python", "running", "starting");
      else {
        run.python = { about: m.about, pyodide: m.pyodide }; set("python", "ok", "Python " + m.about.python + " · " + secs(m.seconds));
        tell("note", "Python " + m.about.python + " (Pyodide " + m.pyodide + ") started in " + secs(m.seconds) + ".");
      }
    } else if (m.type === "second") {
      if (m.state === "running") { run.at = "tests"; set("tests", "running", "two more Pythons starting"); }
      else if (m.state === "done") {
        run.second = { seconds: m.seconds, interpreters: m.interpreters };
        tell("note", "Two more Python interpreters started in " + secs(m.seconds) + ", one plain and one with -O. A browser has no processes: a test that starts a second Python gets one of these.", "tests");
      } else { run.second = null; run.why = m.why || ""; }
    } else if (m.type === "step") {
      run.at = m.id;
      if (m.state === "running") { set(m.id, "running", "running"); tell("cmd", run.python.about.commands[m.id] || "python3 " + m.id.replace(/^file:/, ""), m.id); }
      else {
        var r = m.result;
        if (m.id !== "tests") {
          set(m.id, r.exit_code === 0 ? "ok" : "fail", "exit code " + r.exit_code + " · " + secs(r.seconds), r);
          tell("end" + (r.exit_code ? " fail" : ""), "exit code " + r.exit_code + " · " + secs(r.seconds), m.id);
          if (/does not support processes/.test(r.output || "")) tell("note", NO_SECOND, m.id);
        } else {
          var other = r.tests.filter(function (t) { return t[1] !== "passed" && t[1] !== D.no_process; }).length, by = served(r);
          var word = r.passed + " of " + r.run + " passed" + (by.tests ? " · " + by.tests + " by a second interpreter" : "") +
                     (r.no_process.length ? " · " + r.no_process.length + " not run here" : "") + (other ? " · " + other + " FAILED" : "");
          set("tests", other ? "fail" : r.no_process.length ? "part" : "ok", word, r);
          tell("note", "What became of each test:", "tests");
          r.tests.forEach(function (t) { tell("out", (t[1] + "                        ").slice(0, 24) + t[0].split(".").pop() + (t[2] && t[1] !== "passed" ? "\n" + "                        " + t[2] : ""), "tests"); });
          tell("end" + (other ? " fail" : ""), word + " · " + secs(r.seconds), "tests");
          if (by.starts.length) {
            tell("note", by.tests + " of the " + r.run + " tests start a second Python, " + by.starts.length + " times in all. Each start ran in a second Python interpreter of this page, not in a process of the operating system:", "tests");
            by.starts.forEach(function (s) { tell("note", "  python3 " + s.flags.concat([s.file]).join(" ") + (s.args ? " …" : "") + " → exit code " + s.exit_code + " · " + s.test, "tests"); });
          }
          if (r.no_process.length) tell("note", r.no_process.length + " of the " + r.run + " tests start a second Python. " +
                                        (run.second ? "No interpreter stood ready with the flags they ask for" : "No second Python was started for this run" + (run.why ? " (" + run.why + ")" : "")) +
                                        ", so they were not run here, and they are not counted as passed. With the package all " + D.tests.count + " run: python3 scripts/verify.py", "tests");
        }
      }
    } else if (m.type === "done") {
      run.reports = m.end.reports; run.seconds = m.end.seconds; run.state = "done"; busy.terminate(); busy = null;
      tell("end", "Finished: " + secs(run.seconds) + " of computing.");
      if (!run.only) {
        var q = limit("file");
        var ran = run.steps.tests && run.steps.tests.more, with2 = ran && served(ran).starts.length && !ran.no_process.length;
        tell("note", with2 ? "This was not the package’s own command. python3 scripts/verify.py starts each step, and each Python a test starts, as a process of its own. Here the steps share one process, and a test’s second Python is a second interpreter in this page. The package needs plain Python and no internet."
                           : "This was not the package’s own command. python3 scripts/verify.py starts each step as a process of its own and runs all " + D.tests.count + " tests; it needs plain Python and no internet.");
        tell("note", q.file + ", on what these steps are: “" + q.text + "”");
      }
    } else if (m.type === "failed") {
      var lines = String(m.message).trim().split("\n");      // the bar gets the last line; the terminal all of it
      run.state = "failed"; run.message = "The run broke off: " + lines[lines.length - 1].slice(0, 240); busy.terminate(); busy = null;
      if (run.steps[run.at] && run.steps[run.at].state === "running") run.steps[run.at] = { state: "fail", text: "broke off" };
      if (lines.length > 1) tell("out", lines.join("\n"), run.at);
      tell("end fail", run.message);
    }
    paint();
  }
  // What a finished run was, in one line, and every fault in it. Nothing here is a verdict on the proof. A run
  // of a changed copy is told as that, and never as a run of the release's files. What each step came to stands
  // beside the step; what the programs wrote, in the terminal.
  function told() {
    var faults = [], T = run.steps, t = T.tests && T.tests.more, names = Object.keys(D.ordinary.reports), got = run.reports || {};
    if (run.changed.length) return { state: "changed", head: "This was a run of a changed copy, not of the release’s files", faults: faults };
    if (run.only) {
      Object.keys(got).forEach(function (n) {
        if (!D.ordinary.reports[n] || got[n].sha256 !== D.ordinary.reports[n].sha256) faults.push("The report " + n + " does not have the bytes of the ordinary run’s.");
      });
      if (T[run.only].state === "fail") faults.push(called(run.only) + " did not end without an error.");
      return { state: faults.length ? "fail" : "one", head: "Only " + called(run.only) + " was run, on the release’s files", faults: faults };
    }
    steps().filter(function (s) { return s.file && (!T[s.id] || T[s.id].state !== "ok"); }).forEach(function (s) { faults.push(s.file + " did not end with exit code 0. Its output is in the pane below."); });
    names.filter(function (n) { return !got[n] || got[n].sha256 !== D.ordinary.reports[n].sha256; })
         .forEach(function (n) { faults.push((got[n] ? "The report " + n + " does not have the bytes of the ordinary run’s." : "The report " + n + " was not written.")); });
    if (t) t.tests.filter(function (x) { return x[1] !== "passed" && x[1] !== D.no_process; }).forEach(function (x) { faults.push("The test " + x[0].split(".").pop() + " " + x[1] + "."); });
    else faults.push("The tests did not run.");
    return { state: faults.length ? "fail" : "ok", head: faults.length ? "This run found a fault" : "This run found no fault in what it checked", faults: faults };
  }

  // ---------------------------------------------------------------- what is shown
  var BADGE = { changed: "M", deleted: "D", "new": "U", fail: "!" };
  var SAID = { ok: "read: SHA-256 as listed", fail: "read: NOT the listed SHA-256", waiting: "not read yet", changed: "changed by you: not the release’s bytes",
               deleted: "deleted by you from the working copy", "new": "made by you: not a file of the release" };
  function paint() {
    var busyNow = going(), list = changed(), n = list.length;
    $("checks-stop").hidden = !busyNow;      // Stop is in the bar, where it can be reached with a file open too
    var all = $("checks-run");      // and Run all turns into Stop where it was pressed, as wide as it was
    if (!busyNow) all.style.minWidth = ""; else if (!all.style.minWidth) all.style.minWidth = all.offsetWidth + "px";
    if (all.classList.contains("stop") !== busyNow) { all.classList.toggle("stop", busyNow); all.title = busyNow ? "Stop the run" : RUN_ALL; $("checks-run-mark").innerHTML = busyNow ? HALT : PLAY; }
    all.disabled = !can; $("checks-run-label").textContent = busyNow ? "Stop" : runs ? "Run all again" : "Run all";
    all.classList.toggle("arrive", can === true && !runs);      // its rings, until something has been run
    $("checks-new").disabled = !can;
    $("checks-cannot").hidden = can !== false; if (can === false) $("checks-cannot").innerHTML = CANNOT;
    box.dataset.can = String(can); box.dataset.state = run.state; box.dataset.changed = String(n);
    var saying = can === false ? "" :
      run.state === "idle" ? "Not run yet. A run takes some seconds of computing on your machine." :
      run.state === "reading" ? "Reading the files …" :
      run.state === "running" ? "Running: " + called(run.at) + " …" :
      run.state === "stopped" ? "Stopped by you. Nothing is concluded from a stopped run." :
      run.state === "failed" ? run.message : "Finished: " + secs(run.seconds) + " of computing.";
    $("checks-status").textContent = saying;
    $("checks-status").classList.toggle("warn", run.state === "failed");
    var badge = $("checks-changed"); badge.hidden = !n; badge.textContent = tally(); badge.title = list.join(", ");
    $("checks-reset").hidden = $("checks-reset-bar").hidden = !n; $("checks-reset").disabled = $("checks-reset-bar").disabled = !n;      // there only while the copy is changed; on a narrow window the bar's own is the one shown
    Object.keys(rows).forEach(function (id) {
      var r = rows[id], s = run.steps[id] || { state: "waiting", text: run.only && run.state !== "idle" && id !== "files" && id !== "python" ? "not run" : "waiting" };
      r.li.dataset.state = s.state; r.said.textContent = s.text; r.said.disabled = !s.more;
      r.said.title = s.more ? "show what it wrote, in the pane below" : "";
      if (r.one) r.one.disabled = !can || busyNow;
      if (r.side) { r.side.dataset.state = s.state; r.side.title = (r.step.file || r.step.name) + " · " + s.text; r.sideRun.disabled = !can || busyNow; }
    });
    $("checks-side-run").disabled = !can || busyNow; $("checks-clear").disabled = busyNow || !log.length;
    tree();
    listed().concat([D.runner.path]).forEach(function (p) {
      var li = box.querySelector('li[data-path="' + p + '"]'), e = edits[p], f = known(p), st = status(p);
      if (!li) return;
      li.dataset.state = st;
      li.dataset.open = String(!!doc && doc.kind === "file" && doc.key === p);
      li.title = p + " · " + (e && e.bytes === null ? "" : count(e ? e.bytes.byteLength : f.bytes) + " bytes · ") + SAID[st] + (e && e.how !== "by hand" && !/^(deleted|new file)$/.test(e.how) ? " (" + how(p) + ")" : "") +
                 (f && f.own && st === "ok" ? " (this page’s build lists it)" : "");
      li.querySelector(".checks-badge").textContent = BADGE[st] || "";
      li.querySelector(".checks-file").setAttribute("aria-label", li.title);
    });
    Array.prototype.forEach.call($("checks-alter").children, function (li) {
      var c = change(li.dataset.alter), on = !!(edits[c.path] && edits[c.path].how === c.id), b = li.querySelector("button");
      li.dataset.on = String(on); b.textContent = on ? "Undo this change" : "Make this change"; b.disabled = !can;
    });
    var res = $("checks-result"); res.hidden = run.state !== "done"; res.innerHTML = "";
    if (run.state === "done") {
      var t = told();
      res.dataset.state = t.state;
      res.appendChild(el("h3", "", t.head));
      var ul = el("ul");
      t.faults.forEach(function (x) { var li = el("li", "warn"); li.textContent = x; ul.appendChild(li); });
      if (t.faults.length) res.appendChild(ul);
    }
    var reps = $("checks-reports"), ol = $("checks-report-list"), names = run.state === "done" && run.reports ? Object.keys(run.reports) : [];
    reps.hidden = !names.length; ol.innerHTML = "";
    names.forEach(function (name) {
      var r = run.reports[name], o = D.ordinary.reports[name], li = el("li"), b = button("checks-file"), ok = o && o.sha256 === r.sha256, mark = el("span", "checks-ft", "{}");
      mark.dataset.kind = "json"; b.appendChild(mark); b.appendChild(el("span", "checks-fn", name));
      b.onclick = function () { openReport(name, b); };
      li.dataset.state = ok ? "ok" : run.changed.length ? "changed" : "fail"; li.dataset.report = name; li.appendChild(b); li.appendChild(el("span", "checks-badge", ok ? "" : run.changed.length ? "≠" : "!"));
      li.dataset.open = String(!!doc && doc.kind === "report" && doc.key === name);
      li.title = name + " · " + count(r.bytes) + " bytes · " + (ok ? "the same bytes as an ordinary run’s" : run.changed.length ? "other bytes than an ordinary run’s: the copy was changed" : "NOT the bytes of an ordinary run’s");
      b.setAttribute("aria-label", li.title);
      ol.appendChild(li);
    });
    strip(); cursor();
    if (doc && doc.kind === "file") head(doc.key);
    foot(saying);
  }
  function foot(saying) {                  // the line at the foot: whose files these are, the run, and the open file
    var copy = $("checks-foot-copy"), n = changed().length;
    copy.textContent = n ? tally() : "Release " + D.version + " · the files as released"; copy.dataset.state = n ? "changed" : "ok";
    $("checks-foot-run").textContent = run.state === "idle" ? "" : run.state === "done" ? "Run " + run.n + " finished" : run.state === "failed" ? "Run " + run.n + " broke off" : run.state === "stopped" ? "Run " + run.n + " stopped" : "Run " + run.n + " …";
    $("checks-foot-kind").textContent = doc ? LANGUAGE[S.kind(doc.key)] + (doc.shown === "formatted" ? " · shown indented" : "") : "";
    $("checks-foot-lines").textContent = doc && doc.lines ? count(doc.lines) + (doc.lines === 1 ? " line" : " lines") : "";
    if (!doc || !doc.editable) $("checks-foot-place").textContent = "";
    $("checks-foot-python").textContent = run.python ? "Python " + run.python.about.python + " · Pyodide " + run.python.pyodide : "Pyodide " + D.python.pyodide;
  }
  function place() {                       // where the cursor is, as an editor says it
    if (!doc || !doc.editable) return;
    var e = $("checks-edit"), before = e.value.slice(0, e.selectionStart), ln = before.split("\n").length;
    $("checks-foot-place").textContent = "Ln " + ln + ", Col " + (before.length - before.lastIndexOf("\n"));
  }

  // ---------------------------------------------------------------- the tabs, and one open file or report
  function strip() {                       // Overview, and a tab for each open file
    var key = tabs.map(function (t) { return t.kind + ":" + t.key; }).join("\n"), host = $("checks-tabs");
    if (drawn.tabs !== key) {
      drawn.tabs = key;
      while (host.children.length > 1) host.removeChild(host.lastChild);
      tabs.forEach(function (t) {
        var wrap = el("span", "checks-tab-doc"), b = button("checks-tab"), x = button("checks-tab-x", "×");
        wrap.dataset.kind = t.kind; wrap.dataset.key = t.key;
        b.setAttribute("role", "tab"); b.setAttribute("aria-controls", "checks-doc"); b.appendChild(el("span", "checks-tab-name", base(t.key))); b.appendChild(el("i", "checks-tab-mark"));
        b.title = t.key; b.onclick = function () { if (t.kind === "file" && known(t.key) && !bytes[t.key] && !edits[t.key]) openFile(t.key, null); else { activate(t); paint(); b.focus(); } };
        x.setAttribute("aria-label", "Close " + base(t.key)); x.title = "Close (Esc)"; x.onclick = function () { shutTab(t.kind, t.key, true); };
        wrap.addEventListener("auxclick", function (ev) { if (ev.button === 1) { ev.preventDefault(); shutTab(t.kind, t.key, true); } });
        wrap.appendChild(b); wrap.appendChild(x); host.appendChild(wrap);
      });
    }
    $("checks-tab-over").setAttribute("aria-selected", String(!doc));
    tabs.forEach(function (t, i) {
      var wrap = host.children[i + 1], st = t.kind === "file" ? status(t.key) : "";
      wrap.dataset.active = String(t === doc); wrap.dataset.state = st;
      wrap.querySelector(".checks-tab").setAttribute("aria-selected", String(t === doc));
      wrap.querySelector(".checks-tab-mark").textContent = BADGE[st] || "";
    });
  }
  function tabOf(t) { return Array.prototype.filter.call($("checks-tabs").children, function (w) { return w.dataset.kind === t.kind && w.dataset.key === t.key; })[0]; }
  function keep() {                        // where the reader was in the tab being left
    if (!doc) return;
    var s = doc.editable ? $("checks-edit") : $("checks-doc-body");
    doc.top = s.scrollTop; doc.left = s.scrollLeft;
  }
  function showOver() { keep(); doc = null; $("checks-doc").hidden = true; $("checks-over").hidden = false; }
  function activate(t) {
    keep(); doc = t;
    $("checks-over").hidden = true; $("checks-doc").hidden = false;
    if (t.kind === "file") fill(t.key); else fillReport(t.key);
    if (doc !== t) return;
    var s = doc.editable ? $("checks-edit") : $("checks-doc-body");
    if (t.top !== undefined && !t.find) { s.scrollTop = t.top; s.scrollLeft = t.left; $("checks-ln").scrollTop = t.top; }
    t.find = null;
  }
  function show(kind, key, by, find) {     // the tab of this file, made if it is not open
    var t = tabs.filter(function (x) { return x.kind === kind && x.key === key; })[0];
    if (!t) { t = { kind: kind, key: key, limit: LINE_CUT, shown: null }; tabs.push(t); }
    t.by = by || t.by || null; t.find = find || null;
    activate(t);
    return t;
  }
  function shutTab(kind, key, focus) {
    var t = tabs.filter(function (x) { return x.kind === kind && x.key === key; })[0], i = tabs.indexOf(t);
    if (!t) return;
    var by = t.by, was = t === doc;
    tabs.splice(i, 1);
    if (was) { doc = null; if (tabs.length) activate(tabs[Math.min(i, tabs.length - 1)]); else showOver(); }
    paint();
    if (focus === true) {
      if (by && document.contains(by) && by.getClientRects().length) by.focus();
      else if (doc) tabOf(doc).querySelector(".checks-tab").focus(); else $("checks-tab-over").focus();
    }
  }
  function closeDoc() { if (doc) shutTab(doc.kind, doc.key, true); }
  function refill(path) { if (doc && doc.kind === "file" && doc.key === path) fill(path); }

  function numbers(n) { var s = "", i; for (i = 1; i <= n; i++) s += (i > 1 ? "\n" : "") + i; $("checks-ln").textContent = s; }
  function colour(v) { $("checks-paint").innerHTML = S.lines(v, S.kind(doc.key)).join("\n") + "\n"; }
  function view(as) { if (doc && doc.laid && doc.shown !== as) { doc.shown = as; doc.limit = LINE_CUT; render(); paint(); $(as === "raw" ? "checks-doc-raw" : "checks-doc-formatted").focus(); } }
  // The text of the open tab as it is shown: to change, or to read. To read, a JSON text with a long line is laid
  // out with indentation unless the reader asks for it as in the file; the note says which, and what is left out.
  function render() {
    var t = doc.text, k = S.kind(doc.key), editable = !!doc.editable, pane = $("checks-doc-body"), edit = $("checks-edit"), src = $("checks-src"), more = [], cut = false, html, lines, total;
    $("checks-edit-wrap").hidden = !editable; $("checks-read").hidden = editable;
    pane.dataset.mode = editable ? "edit" : "read";
    pane.scrollTop = 0; pane.scrollLeft = 0;
    if (editable) {
      edit.value = t; edit.setSelectionRange(0, 0); lines = t.split("\n"); numbers(lines.length); colour(t);
      doc.lines = lines.length - (lines.length > 1 && lines[lines.length - 1] === "" ? 1 : 0); doc.shown = "raw"; doc.cut = "";
      $("checks-doc-as").hidden = true; $("checks-doc-more").hidden = true; pane.dataset.view = "raw";
      return lines;
    }
    lines = t.split("\n"); if (lines.length > 1 && lines[lines.length - 1] === "") lines.pop();
    doc.lines = lines.length;
    var long = 0; lines.forEach(function (l) { if (l.length > long) long = l.length; });
    if (doc.laid === undefined) { doc.laid = k === "json" && long > MONO_CUT ? S.pretty(t, WIDTH) : null; if (doc.shown === null) doc.shown = doc.laid ? "formatted" : "raw"; }
    if (!doc.laid) doc.shown = "raw";
    var formatted = doc.shown === "formatted", from = formatted ? doc.laid : lines;
    total = from.length;
    if (formatted) {
      html = S.lines(from.slice(0, doc.limit).join("\n"), "json");
      more.push("Shown indented, for reading: the file’s own parts in the file’s own order, with only spaces and line breaks added. " +
                "The file itself is " + (lines.length === 1 ? "one line" : count(lines.length) + " lines") + ".");
    } else if (k === "python") html = S.lines(t, k).slice(0, doc.limit);       // a text over several lines needs the whole text
    else html = S.lines(from.slice(0, doc.limit).map(function (l) { if (l.length <= MONO_CUT) return l; cut = true; return l.slice(0, MONO_CUT) + " …"; }).join("\n"), k);
    if (total > doc.limit) more.push("Here the first " + count(doc.limit) + " of " + count(total) + " lines are shown" + (formatted ? "." : "; the whole file is in the release."));
    if (cut) more.push("Here a line longer than " + count(MONO_CUT) + " characters is shown to there; the whole file is in the release.");
    src.innerHTML = html.slice(0, doc.limit).join("\n");
    numbers(Math.min(total, doc.limit));
    pane.dataset.view = formatted ? "formatted" : "raw";
    $("checks-doc-as").hidden = !doc.laid;
    $("checks-doc-formatted").setAttribute("aria-pressed", String(formatted)); $("checks-doc-raw").setAttribute("aria-pressed", String(!formatted));
    var rest = total - doc.limit, btn = $("checks-doc-more");
    btn.hidden = rest <= 0; if (rest > 0) btn.textContent = "Show " + count(Math.min(rest, LINE_CUT)) + " more lines (" + count(rest) + " are not shown)";
    doc.cut = more.join(" ");
    return from.slice(0, doc.limit);
  }
  function seek(shown, find) {             // to the line that holds the words looked for
    var k = -1, editable = doc.editable, scroller = editable ? $("checks-edit") : $("checks-doc-body");
    if (find) shown.some(function (l, i) { if (l.indexOf(find.slice(0, 40)) >= 0) { k = i; return true; } return false; });
    scroller.scrollTop = k > 2 ? (k - 2) * parseFloat(getComputedStyle(editable ? $("checks-edit") : $("checks-src")).lineHeight) : 0; scroller.scrollLeft = 0;
    $("checks-ln").scrollTop = scroller.scrollTop; $("checks-paint").scrollTop = scroller.scrollTop; $("checks-paint").scrollLeft = 0;
    doc.line = k + 1;
  }
  function head(path) {                    // what is said over an open file: its bytes, its fingerprint, whose it is
    var f = known(path), e = edits[path], st = status(path), meta, say;
    if (st === "deleted") { meta = "not in the working copy"; say = "Deleted by you" + (e.how === "deleted" ? "" : " (" + how(path) + ")") + ". The release lists it with SHA-256 " + f.sha256 + "."; }
    else if (st === "new") { meta = count(e.bytes.byteLength) + " bytes · SHA-256 " + (e.sum || "…"); say = "Made by you" + (e.how === "new file" ? "" : " (" + how(path) + ")") + ": not a file of the release."; }
    else if (e) {
      meta = count(e.bytes.byteLength) + " bytes · SHA-256 " + (e.sum || "…");
      say = "Changed by you (" + how(path) + "): not the release’s bytes. The release lists SHA-256 " + f.sha256 + ".";
    } else if (sums[path] === undefined) {      // not read: where nothing can be run, the files are not read either
      meta = "not read";
      say = (f.own ? "This page’s build recorded " : "Release " + D.version + " lists ") + count(f.bytes) + " bytes and SHA-256 " + f.sha256 + " for it.";
    } else {
      meta = count(sizes[path]) + " bytes · SHA-256 " + sums[path];
      say = same(f) ? (f.own ? "The bytes this page’s build recorded. This file is the page’s own and not part of the release." : "The SHA-256 that release " + D.version + " lists for this file.")
                    : "NOT the SHA-256 listed (" + f.sha256 + ").";
    }
    $("checks-doc-title").textContent = path;
    $("checks-doc-meta").textContent = meta;
    $("checks-doc-note").textContent = [say, doc.cut, doc.editable ? "You can change it here." : doc.fixed].filter(Boolean).join(" ");
    $("checks-doc-restore").hidden = !(f && !f.own && e);
    $("checks-doc-run").hidden = !(can && there(path) && S.kind(path) === "python"); $("checks-doc-run").disabled = going();
  }
  function fill(path, find) {              // the open file's text as the working copy has it now
    var f = known(path), e = edits[path], gone = deleted(path), data = gone ? null : e ? e.bytes : bytes[path], t = data ? text(data) : null, long = 0;
    if (!f && !e) { shutTab("file", path); return; }      // a file made here and since deleted, or put back by Reset
    if (t !== null) t.split("\n").forEach(function (l) { if (l.length > long) long = l.length; });
    doc.editable = !gone && !(f && f.own) && t !== null && data.byteLength <= EDIT_BYTES && long <= EDIT_LINE && (!f || !bytes[path] || same(f));
    doc.fixed = gone ? "Restore this file puts it back." : f && f.own ? "" : doc.editable ? "" :
      t !== null && long > EDIT_LINE ? "It is not changed by hand here: its longest line has " + count(long) + " characters. Overview has prepared changes for the certificates." : "It is not changed by hand here.";
    doc.text = gone ? "" : t === null ? "(not text)" : t; doc.laid = undefined;
    seek(render(), find || doc.find);
    head(path); place();
  }
  function openFile(path, by, find) {
    var f = known(path);
    if (!can) {
      show("file", path, by); doc.editable = false; doc.text = FOLDER ? "A page opened from a folder cannot read the files beside it." : "Not shown: the program that runs Python did not load."; doc.laid = null; render();
      $("checks-doc-title").textContent = path; $("checks-doc-meta").textContent = f ? count(f.bytes) + " bytes" : ""; $("checks-doc-note").textContent = "";
      $("checks-doc-restore").hidden = true; $("checks-doc-run").hidden = true; paint(); tabOf(doc).querySelector(".checks-tab").focus(); return;
    }
    (f ? read(f) : Promise.resolve()).then(function () {
      var t = tabs.filter(function (x) { return x.kind === "file" && x.key === path; })[0];
      if (t) { t.by = by || t.by; t.find = find || null; keep(); doc = t; $("checks-over").hidden = true; $("checks-doc").hidden = false; fill(path, find); t.find = null; }
      else { t = { kind: "file", key: path, limit: LINE_CUT, shown: null, by: by || null }; tabs.push(t); keep(); doc = t; $("checks-over").hidden = true; $("checks-doc").hidden = false; fill(path, find); }
      paint();
      if (doc === t) (doc.editable ? $("checks-edit") : $("checks-src")).focus({ preventScroll: true });
    }).catch(function (e) {
      show("file", path, by); doc.editable = false; doc.text = "The file could not be read: " + String(e && e.message || e); doc.laid = null; render();
      $("checks-doc-title").textContent = path; $("checks-doc-meta").textContent = ""; $("checks-doc-note").textContent = "";
      $("checks-doc-restore").hidden = true; $("checks-doc-run").hidden = true; paint();
    });
  }
  function fillReport(n) {
    var r = run.reports && run.reports[n], o = D.ordinary.reports[n];
    if (!r) { shutTab("report", n); return; }
    doc.editable = false; doc.text = r.text; doc.laid = undefined; doc.fixed = "";
    seek(render(), null);
    $("checks-doc-title").textContent = n;
    $("checks-doc-meta").textContent = count(r.bytes) + " bytes · SHA-256 " + r.sha256;
    $("checks-doc-note").textContent = ["Written by this run.", o && o.sha256 === r.sha256 ? "The same bytes as the report of an ordinary run when this page was built." :
      run.changed.length ? "Other bytes than the ordinary run’s report: the copy was changed." : "NOT the bytes of the ordinary run’s report.", doc.cut].filter(Boolean).join(" ");
    $("checks-doc-restore").hidden = true; $("checks-doc-run").hidden = true;
  }
  function openReport(n, by) { show("report", n, by); paint(); $("checks-src").focus({ preventScroll: true }); }
  function showStep(id) {                  // to what the step wrote in the latest run, in the pane below
    var pane = $("checks-log"), lines = pane.querySelectorAll('.checks-line[data-step="' + id + '"][data-run="' + run.n + '"]');
    if (lines.length) pane.scrollTop = lines[0].offsetTop - pane.offsetTop - 4;
    pane.focus({ preventScroll: true });
  }

  // ---------------------------------------------------------------- the ways in
  C.init = function (u) {
    ui = u; D = C.data;
    if (!D) return;
    build();
    ui.over({ box: box, name: "checks", open: function () { open(null); }, close: close });
    // on a scene that is about the checker: an action of the scene, beside Share
    link = button("pill share-button checks-link"); link.id = "checks-link"; link.hidden = true;
    link.innerHTML = ICON + "<span>Check it yourself</span>"; link.onclick = function () { open(link); };
    $("share").insertAdjacentElement("beforebegin", link);
    var top = button("pill", "Check it yourself"); top.id = "channel-checks"; top.onclick = function () { open(top); };
    $("channel-manuscript").insertAdjacentElement("afterend", top);
    var item = button("guide-item"); item.id = "guide-checks";
    item.innerHTML = '<span class="guide-ic">' + ICON + "</span><span>Check it yourself</span>"; item.onclick = function () { open(item); };
    $("guide-manuscript").insertAdjacentElement("afterend", item);
  };
  C.fill = function (s) {                  // the way in comes with a scene about the checker, and shows that it came
    if (!link) return;
    var was = link.hidden; link.hidden = !D.map[s.id];
    if (was && !link.hidden) { link.classList.remove("arrive"); void link.offsetWidth; link.classList.add("arrive"); }
  };
  // for the player's checks: what the window holds now, and its working copy's own actions
  C.second = function (on) { if (arguments.length) second = !!on; return second; };      // the tests with a second interpreter, or without
  C.state = function () {
    var e = {}; Object.keys(edits).forEach(function (p) { e[p] = { how: edits[p].how, sum: edits[p].sum, bytes: edits[p].bytes === null ? null : edits[p].bytes.byteLength }; });
    var d = doc && { kind: doc.kind, key: doc.key, editable: !!doc.editable, shown: doc.shown, lines: doc.lines, line: doc.line, limit: doc.limit };
    return { open: !box.hidden, can: can, why: why, run: run, sums: sums, doc: d, edits: e, log: log, tabs: tabs.map(function (t) { return t.kind + ":" + t.key; }) };
  };
})();
