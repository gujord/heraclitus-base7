# Verification scope

The Python checker checks exact finite certificates, the 117650-term direct
base case, phase completeness, closure, reduction premises and the conditional
crossing corollary. Generation and checking use separate mathematical logic;
the checker does not import `src/`. These checks alone do not prove an
infinite theorem.

The coverage Lean closure supplies the literal rule, canonical sequence,
complete base, every successive scale transition, full used-set endpoints,
exact counts and coverage. The 107-module research extension supplies the
actual crossing lower witnesses and the all-index scale upper bound, including
all outgoing, crossing, return, approach and boundary phases and endpoints.
The final exact rational-epsilon contract has no extra transition or envelope
hypothesis. See `research/README.md` for entry points.

The full fresh build is described in `reproducibility.md`. The inventory is
351 project modules (244 + 107), 4,998 coverage axiom audits and 1,595 research
theorem statement/axiom audits. Coverage's own runner retains its narrower
historical scope text; the enclosing 1.1.0 report separately records completion
of the equality target. Python reports retain their finite-check scope.

Read the new run's report and logs under `evidence/release-1.1.0/`; a
preliminary export has no completed receipt. Prior development checks reused
objects in stages. This release's runner rebuilds the entire project closure
and does not require those old receipts or private build directories.

Trust remains in the compiler/kernel, bundled standard library, permitted
axioms, computer execution, and fidelity of the formal statement. The
manuscript remains a proposed computer-assisted proof pending independent
human review, especially its universal reduction in Sections 3–7. A second
AI implementation or same-project rebuild is not independent human review.
Neither an ordinary limit, a library real-limsup theorem, minimality of the
36-period, other-base coverage nor novelty is established by this package.
