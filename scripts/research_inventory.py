"""Lexical inventory only; theorem types and axioms are queried from Lean.

Adapted without mathematical changes from the development audit.
"""
import re

def require(test, message):
    if not test:
        raise ValueError(message)


def strip_comments(s):
    """Enough lexical parsing for declarations; fail on strings at line start.
    Nested Lean block comments and line comments are removed, preserving lines.
    Type text is obtained from Lean, never from this parser.
    """
    out, i, depth = [], 0, 0
    while i < len(s):
        if s[i:i+2] == "/-":
            depth += 1; out.append("  "); i += 2
        elif depth and s[i:i+2] == "-/":
            depth -= 1; out.append("  "); i += 2
        elif depth:
            out.append("\n" if s[i] == "\n" else " "); i += 1
        elif s[i:i+2] == "--":
            end = s.find("\n", i)
            if end == -1:
                break
            out.append("\n"); i = end + 1
        else:
            out.append(s[i]); i += 1
    require(depth == 0, "Unclosed comment")
    return "".join(out)


def declarations(path):
    s = strip_comments(path.read_text())
    require(not re.search(r"^\s*(?:unsafe\s+)?axiom\s", s, re.M), "Research axiom declaration: " + str(path))
    namespaces, found = [], []
    for line in s.splitlines():
        if re.match(r"^namespace\s+", line):
            namespaces.append(line.split()[1])
        elif re.match(r"^end(?:\s|$)", line):
            require(namespaces, "Unsupported unmatched end in " + str(path))
            namespaces.pop()
        else:
            m = re.match(r"^(?:(private|protected)\s+)?theorem\s+([\w.']+)", line)
            if m and m[1] != "private":
                found.append(".".join(namespaces + [m[2]]))
    require(not namespaces, "Unclosed namespace in " + str(path))
    # Every public theorem token must be accounted for; new syntax requires an
    # explicit parser update rather than silent dropping from the audit.
    expected = len(re.findall(r"\btheorem\s+[\w.']+", s)) - len(re.findall(r"\bprivate\s+theorem\s", s))
    require(len(found) == expected, "Theorem extraction mismatch: " + str(path))
    return found


def parse_axioms(log):
    found = {}
    pattern = r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
    for m in re.finditer(pattern, log):
        found[m[1]] = [] if not m[2] else [x.strip() for x in m[2].split(",")]
    return found


