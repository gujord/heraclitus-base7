"""Build the optional LaTeX PDF and derived plain-text search index.

Needs a TeX installation (pdflatex with the packages named in the manuscript)
and Poppler's pdftotext. Mathematical verification remains standard-library Python only.
All temporary TeX files stay under build/; certificates are read-only.
"""
import argparse
import json
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PAPER = ROOT / 'paper'
STEM = 'base-seven-heraclitus'
TEXT_NOTICE = (
    'GENERATED SEARCH TEXT - NOT THE MATHEMATICAL SOURCE\n'
    'PDF extraction can lose mathematical delimiters and two-dimensional layout.\n'
    'Use base-seven-heraclitus.pdf or the authoritative .tex source for formulas.\n'
    'Do not edit this generated file.\n\n'
)


def ranges(values):
    """Typeset inclusive integer ranges, keeping separated runs distinct."""
    if not values:
        return r'\varnothing'
    assert values == sorted(set(values))
    runs = []
    first = last = values[0]
    for value in values[1:] + [None]:
        if value is not None and value == last + 1:
            last = value
            continue
        runs.append(str(first) if first == last else
                    f'{first},{last}' if last == first + 1 else
                    str(first) + r',\ldots,' + str(last))
        first = last = value
    return r'\{'+r';\ '.join(runs)+r'\}'


def tables():
    signed = json.loads((ROOT / 'certificates/signed-machine.json').read_text())
    ladder = json.loads((ROOT / 'certificates/ladder-machine.json').read_text())
    phases = {row['k'] % 36: row['initial'] for row in signed['transitions']}
    assert len(signed['transitions']) == len(phases) == 36
    a = []
    for phase in range(36):
        (side, current), sides = phases[phase]
        by_side = {s: (f, b) for s, f, b in sides}
        fp, bp = by_side[1]
        fn, bn = by_side[-1]
        a.append(f'{phase} & {side} & {current} & {fp} & ${ranges(bp)}$ & {fn} & ${ranges(bn)}$' + r' \\')
    assert len(ladder['cases']) == 18
    b = []
    for i, case in enumerate(ladder['cases']):
        core = case['case']['core']
        front = -100
        while front in core:
            front += 1
        extra = [n for n in core if n > front]
        assert core == list(range(-100, front)) + extra
        b.append(f"{i} & {case['case']['offset']} & {front} & ${ranges(extra)}$ & {case['repeat_start']} & {case['repeat_period']}" + r' \\')
    return r'''% Generated from the committed certificates by scripts/build_paper.py; do not edit.
\section*{Appendix A. Signed scale states}
\label{app:signed}
The rows are indexed by $k$ modulo 36. Put $C=(7^k-1)/2$; the current
integer is $s(C+x)$. On each side all positive magnitudes below $C+f$ are
used, and the additional used magnitudes are $C+B$. Ellipses denote every
integer between the endpoints, inclusively; semicolons separate runs.

\begingroup\footnotesize
\setlength{\tabcolsep}{4pt}
\renewcommand{\arraystretch}{1.12}
\begin{longtable}{rrrrlrl}
\toprule
Phase & $s$ & $x$ & $f_+$ & $B_+$ & $f_-$ & $B_-$ \\
\midrule
\endfirsthead
\toprule
Phase & $s$ & $x$ & $f_+$ & $B_+$ & $f_-$ & $B_-$ \\
\midrule
\endhead
''' + '\n'.join(a) + r'''
\bottomrule
\end{longtable}
\endgroup

\clearpage
\section*{Appendix B. Old half-line regions and ladder closure}
\label{app:ladder}
All offsets below $f$ are used; $B$ lists the additional used offsets.
The offset $A$ is already used, and high power subtraction would return
there. The bottom anchor is $A+2401$. Transient and period count
six-marker layers. Ellipses and semicolons follow Appendix A.

\begingroup\small
\renewcommand{\arraystretch}{1.18}
\begin{longtable}{rrrlrr}
\toprule
Case & $A$ & $f$ & $B$ & Transient & Period \\
\midrule
\endfirsthead
\toprule
Case & $A$ & $f$ & $B$ & Transient & Period \\
\midrule
\endhead
''' + '\n'.join(b) + r'''
\bottomrule
\end{longtable}
\endgroup
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--engine', default='pdflatex', help='pdflatex executable or path')
    parser.add_argument('--pdftotext', default='pdftotext', help='Poppler pdftotext executable or path')
    parser.add_argument('--output', type=Path, default=ROOT / 'build/paper')
    args = parser.parse_args()
    out = args.output.resolve()
    if ROOT / 'build' not in out.parents:
        parser.error('Temporary output must be a child of build/')
    out.mkdir(parents=True, exist_ok=True)
    table_text = tables()
    (PAPER / 'tables.tex').write_text(table_text)
    for name in [STEM+'.tex', 'tables.tex']:
        shutil.copyfile(PAPER / name, out / name)
    engine = shutil.which(args.engine)
    pdftotext = shutil.which(args.pdftotext)
    if not engine or not pdftotext:
        parser.error('PDF rebuild requires pdflatex and pdftotext; see docs/reproducibility.md')
    for pass_number in [1, 2]:
        result = subprocess.run([engine, '-no-shell-escape', '-interaction=nonstopmode',
            '-halt-on-error', '-file-line-error', STEM+'.tex'], cwd=out,
            capture_output=True, text=True)
        (out / f'pass-{pass_number}.log').write_text(result.stdout+result.stderr)
        if result.returncode:
            raise SystemExit(f'LaTeX pass {pass_number} failed; see {out}/pass-{pass_number}.log')
    log = (out / (STEM+'.log')).read_text()
    problems = re.findall(r'(?:Overfull \\[hv]box[^\n]*|LaTeX Warning: (?:Citation|Reference)[^\n]*|LaTeX Warning: There were undefined[^\n]*|Missing character:[^\n]*)', log)
    if problems:
        raise SystemExit('PDF layout/reference errors:\n'+'\n'.join(problems))
    # Extract the actual rendered text: generic TeX-to-text conversion can
    # silently omit abstracts, citation numbers and leading interval brackets.
    result = subprocess.run([pdftotext, '-layout', STEM+'.pdf', STEM+'.txt'], cwd=out,
        capture_output=True, text=True)
    (out / 'text-export.log').write_text(result.stdout+result.stderr)
    if result.returncode:
        raise SystemExit(f'Text export failed; see {out}/text-export.log')
    text_path = out / (STEM+'.txt')
    text_path.write_text(TEXT_NOTICE + text_path.read_text())
    for suffix in ['pdf', 'txt']:
        shutil.copyfile(out / (STEM+'.'+suffix), PAPER / (STEM+'.'+suffix))
    print('Built PDF and derived text from '+str(PAPER / (STEM+'.tex')))
    print('Appendix data: 36 signed states and 18 ladder cases, directly from certificates.')
    print('No overfull boxes, missing glyphs or unresolved citations/references.')


if __name__ == '__main__':
    main()
