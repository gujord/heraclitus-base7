/* How the check window shows a file's text: in colours by what each part is, and, for a JSON file written as one
   long line, laid out with indentation for reading.

   Neither changes the text. The coloured lines are the file's lines with <span>s around their parts. The
   laid-out lines are the file's own parts in the file's own order, with spaces and line breaks added between
   them and nothing else: the text is cut into parts and put together again, never read as values, because a
   browser's own JSON reading would round whole numbers of more than sixteen digits, and the files here have
   numbers of fifty. test_checks_syntax.cjs holds both to that, for every file of the release.

   No component from outside: this is all of it. In a page it is PROOF.syntax; under Node it is the module. */
(function (root) {
  "use strict";

  function esc(s) { return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;"); }
  function span(cls, s) { return '<span class="' + cls + '">' + esc(s) + "</span>"; }
  function kind(path) { return /\.jsonl$/.test(path) ? "jsonl" : /\.json$/.test(path) ? "json" : /\.py$/.test(path) ? "python" : ""; }

  // ---------------------------------------------------------------- JSON, a line at a time
  // A string cannot run over a line's end in JSON, so each line can be coloured by itself. A string that a
  // colon follows is a key.
  var JSON_PART = /("(?:[^"\\]|\\.)*")(\s*:)?|-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?|\b(?:true|false|null)\b/g;
  function jsonLine(line) {
    var out = "", at = 0, m;
    JSON_PART.lastIndex = 0;
    while ((m = JSON_PART.exec(line))) {
      out += esc(line.slice(at, m.index));
      if (m[1]) out += span(m[2] ? "syn-key" : "syn-s", m[1]) + (m[2] ? esc(m[2]) : "");
      else out += span(/^[tfn]/.test(m[0]) ? "syn-l" : "syn-n", m[0]);
      at = m.index + m[0].length;
    }
    return out + esc(line.slice(at));
  }

  // ---------------------------------------------------------------- Python, the whole text at once
  // A text in three quotation marks runs over lines, so the whole text is cut into parts first and the parts
  // are then dealt out to the lines.
  var KEYWORDS = {}, CONSTANTS = { True: 1, False: 1, None: 1 };
  ("and as assert async await break class continue def del elif else except finally for from global if import in is " +
   "lambda nonlocal not or pass raise return try while with yield").split(" ").forEach(function (k) { KEYWORDS[k] = 1; });
  var PY_PART = new RegExp([
    "(#[^\\n]*)",                                                                               // 1 a comment
    "((?:\\b[rRbBuUfF]{1,2})?(?:\"\"\"[\\s\\S]*?(?:\"\"\"|$)|'''[\\s\\S]*?(?:'''|$)))",           // 2 a text in three marks
    "((?:\\b[rRbBuUfF]{1,2})?(?:\"(?:[^\"\\\\\\n]|\\\\[\\s\\S])*\"?|'(?:[^'\\\\\\n]|\\\\[\\s\\S])*'?))",   // 3 a text on one line
    "(\\b(?:0[xXoObB][\\da-fA-F_]+|\\d[\\d_]*(?:\\.[\\d_]+)?(?:[eE][+-]?\\d+)?j?)\\b)",          // 4 a number
    "(@[A-Za-z_][\\w.]*)",                                                                      // 5 a decorator
    "([A-Za-z_]\\w*)"                                                                           // 6 a name
  ].join("|"), "g");
  function pythonLines(text) {
    var lines = [""], m, at = 0, defining = false;
    function put(cls, s) {                  // a part may hold line ends: each line gets its piece
      s.split("\n").forEach(function (piece, i) {
        if (i) lines.push("");
        if (piece) lines[lines.length - 1] += cls ? span(cls, piece) : esc(piece);
      });
    }
    PY_PART.lastIndex = 0;
    while ((m = PY_PART.exec(text))) {
      if (m[0] === "") { PY_PART.lastIndex++; continue; }
      put("", text.slice(at, m.index));
      if (m[1]) put("syn-c", m[1]);
      else if (m[2] || m[3]) put("syn-s", m[0]);
      else if (m[4]) put("syn-n", m[4]);
      else if (m[5]) put(/^\s*$/.test(text.slice(text.lastIndexOf("\n", m.index - 1) + 1, m.index)) ? "syn-d" : "", m[5]);
      else if (defining) put("syn-f", m[6]);
      else put(KEYWORDS[m[6]] ? "syn-k" : CONSTANTS[m[6]] ? "syn-l" : "", m[6]);
      defining = !!m[6] && (m[6] === "def" || m[6] === "class") && !defining;
      at = m.index + m[0].length;
    }
    put("", text.slice(at));
    return lines;
  }

  // The lines of a text, coloured. One entry for each line of text.split("\n").
  function lines(text, k) {
    if (k === "python") return pythonLines(text);
    var raw = text.split("\n");
    return k === "json" || k === "jsonl" ? raw.map(jsonLine) : raw.map(esc);
  }

  // ---------------------------------------------------------------- a JSON text, laid out for reading
  // In the manner of jq, but a value that fits on the line stays on it, and a long list of numbers fills its
  // lines. Returns the lines, or null if the text is not one JSON value.
  var TOKEN = /\s*(?:("(?:[^"\\\u0000-\u001f]|\\.)*")|(-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?)|(true|false|null)|([{}\[\],:]))/y;
  function pretty(text, width) {
    var toks = [], types = [], m, at = 0, i;
    while (at < text.length) {
      TOKEN.lastIndex = at;
      m = TOKEN.exec(text);
      if (!m) { if (/^\s*$/.test(text.slice(at))) break; return null; }
      toks.push(m[1] || m[2] || m[3] || m[4]); types.push(m[1] ? "s" : m[2] || m[3] ? "v" : m[4]);
      at = TOKEN.lastIndex;
    }
    var n = toks.length, close = new Array(n), flat = new Array(n), sum = new Array(n + 1), stack = [];
    if (!n) return null;
    // where each list or object ends, whether it holds another, and how long each stretch is on one line
    sum[0] = 0;
    for (i = 0; i < n; i++) {
      sum[i + 1] = sum[i] + toks[i].length + (types[i] === "," || types[i] === ":" ? 1 : 0);
      if (types[i] === "{" || types[i] === "[") { flat[i] = true; if (stack.length) flat[stack[stack.length - 1]] = false; stack.push(i); }
      else if (types[i] === "}" || types[i] === "]") {
        if (!stack.length || types[stack[stack.length - 1]] !== (types[i] === "}" ? "{" : "[")) return null;
        close[stack.pop()] = i;
      }
    }
    if (stack.length) return null;
    function one(a, b) {                    // the parts a..b on one line
      var s = "", j;
      for (j = a; j <= b; j++) s += toks[j] + (types[j] === "," || types[j] === ":" ? " " : "");
      return s;
    }
    function end(a) { return types[a] === "{" || types[a] === "[" ? close[a] : a; }
    var out = [], bad = false;
    function pad(d) { var s = ""; while (d-- > 0) s += "  "; return s; }
    function value(a, depth, lead, tail) {  // the value that begins at part a; returns the part after it
      var t = types[a], b = end(a), j, next, first;
      if (t !== "s" && t !== "v" && t !== "{" && t !== "[") { bad = true; return b + 1; }
      if (!check(a, b)) { bad = true; return b + 1; }
      if (t === "s" || t === "v" || b === a + 1 || 2 * depth + lead.length + (sum[b + 1] - sum[a]) + tail.length <= width) {
        out.push(pad(depth) + lead + one(a, b) + tail); return b + 1;
      }
      out.push(pad(depth) + lead + toks[a]);
      if (t === "[" && flat[a]) {           // a list of plain values: lines filled to the width
        var line = pad(depth + 1);
        for (j = a + 1; j < b; j += 2) {
          var piece = toks[j] + (j + 1 < b ? "," : "");
          if (line.length > 2 * depth + 2 && line.length + 1 + piece.length > width) { out.push(line); line = pad(depth + 1); }
          line += (line.length > 2 * depth + 2 ? " " : "") + piece;
        }
        out.push(line);
      } else if (t === "[") {
        for (j = a + 1; j < b; j = next + 1) { next = end(j) + 1; value(j, depth + 1, "", next < b ? "," : ""); }
      } else {
        for (j = a + 1; j < b; j = next + 1) { first = j + 2; next = end(first) + 1; value(first, depth + 1, toks[j] + ": ", next < b ? "," : ""); }
      }
      out.push(pad(depth) + toks[b] + tail);
      return b + 1;
    }
    // the grammar, for one list or object: values with commas between, and in an object a string and a colon first
    function check(a, b) {
      if (a === b) return true;
      var j = a + 1, obj = types[a] === "{";
      if (j === b) return true;
      for (;;) {
        if (obj) { if (types[j] !== "s" || types[j + 1] !== ":") return false; j += 2; }
        if (j >= b || !/^[sv{[]$/.test(types[j])) return false;
        j = end(j) + 1;
        if (j === b) return true;
        if (types[j] !== ",") return false;
        j++;
      }
    }
    if (value(0, 0, "", "") !== n || bad) return null;
    return out;
  }

  // ---------------------------------------------------------------- a line a program wrote
  // Coloured by what it is: a line of JSON (the checkers print their reports), the lines of a Python traceback,
  // the outcome of a test. A line that is none of these is left as it is. `before` is the line written before it.
  var LOOKS_JSON = /^\s*(?:[{}\[\]],?$|"(?:[^"\\]|\\.)*"\s*:|"(?:[^"\\]|\\.)*",?$|-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?,?$|(?:true|false|null),?$)/;
  var FILE_LINE = /^(\s+File )("[^"]*")(, line )(\d+)(.*)$/;
  var RAISED = /^([A-Za-z_][\w.]*(?:Error|Exception|Exit|Interrupt|Warning))(:.*)?$/;
  var TEST_LINE = /^(.* \.\.\. )(ok|FAIL|ERROR|skipped.*|expected failure|unexpected success)$/;
  var OUTCOME = /^(passed|failed|error|skipped|needs a second process)(\s{2,}.*)$/;
  function out(line, before) {
    var m;
    if ((m = FILE_LINE.exec(line))) return esc(m[1]) + span("syn-s", m[2]) + esc(m[3]) + span("syn-n", m[4]) + esc(m[5]);
    if (/^\s+[~^]+\s*$/.test(line)) return esc(line.replace(/[~^]+\s*$/, "")) + span("syn-c", line.trim()) + esc(line.slice(line.replace(/\s+$/, "").length));
    if (before && FILE_LINE.test(before) && /^\s{4}/.test(line)) return pythonLines(line)[0];
    if ((m = RAISED.exec(line))) return span("syn-e", m[1]) + esc(m[2] || "");
    if ((m = TEST_LINE.exec(line))) return esc(m[1]) + span(m[2] === "ok" ? "syn-ok" : /^(skipped|expected)/.test(m[2]) ? "syn-w" : "syn-e", m[2]);
    if ((m = OUTCOME.exec(line))) return span(m[1] === "passed" ? "syn-ok" : m[1] === "failed" || m[1] === "error" ? "syn-e" : "syn-w", m[1]) + esc(m[2]);
    if (LOOKS_JSON.test(line)) return jsonLine(line);
    return esc(line);
  }

  var api = { kind: kind, lines: lines, pretty: pretty, out: out, esc: esc };
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  else root.PROOF.syntax = api;
})(typeof window !== "undefined" ? window : this);
