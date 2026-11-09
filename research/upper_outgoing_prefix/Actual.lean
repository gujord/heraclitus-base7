import research.upper_outgoing_prefix.Core
import research.upper_scale_assembly.Frame
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperOutgoingPrefix
open GlobalWalk UpperPhaseBridge UpperScaleAssembly UpperMachineAudit

/-- Original-rule bound at every actual index before the first crossing,
for every phase and every repetition of that phase. -/
theorem original_rule_before_crossing (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t q : Nat)
    (index : (phase i).CycleIndex t q) (n : Nat)
    (lower : 7^(exponent i t)≤n) (before : n<crossingIndex i t q) :
    defect a n≤16261 := by
  let k := exponent i t
  let c := (phase i).entrance.outgoing
  let C := ScaleInduction.radius k
  have walk := OriginalProblem.as_walk a rule
  have scale : 2*C+1=(7^k : Nat) := ScaleSchedule.radius_exact k
  have large : 100000≤(7^k : Nat) := scale_large i t
  have start : stateAt a (7^k)=c.inner.initial.toState C := phase_checkpoint a walk i t
  have data : RowBounds c := all_row_bounds i
  obtain ⟨d, hd, qeq, shift⟩ := index
  have shift' : (7^k : Nat)=c.row.scale+c.row.model.period*d := by
    simpa only [phase_exponent] using shift
  have qeq' : (q : Int)=c.row.winningCycle+3*d := qeq
  change 7^k≤n at lower
  have upper : n<7^k+(c.inner.moves.length+q*c.row.phases.size+c.row.selected.val+1) := before
  by_cases inside : n≤7^k+c.inner.moves.length
  · let j := n-7^k
    have indexEq : n=7^k+j := by dsimp only [j]; omega
    rw [indexEq]
    exact inner_defect c data a walk k C scale large start j (by dsimp only [j]; omega)
  · let P := c.row.phases.size
    change n<7^k+(c.inner.moves.length+q*P+c.row.selected.val+1) at upper
    have positive : 0<P := by
      have h := c.arithmetic.1
      change 0<(P : Int) at h
      omega
    let j := n-(7^k+c.inner.moves.length)
    let u := j/P
    let v : Fin P := ⟨j%P,Nat.mod_lt _ positive⟩
    have indexEq : n=7^k+c.inner.moves.length+j := by dsimp [j]; omega
    have decomposition : j=u*P+v.val := by
      have h := Nat.mod_add_div j P
      rw [Nat.mul_comm P] at h
      simpa only [u,v,Nat.add_comm] using h.symm
    have limited : j≤q*P+c.row.selected.val := by omega
    have uq : u≤q := by
      by_cases yes : u≤q
      · exact yes
      have order : q+1≤u := by omega
      have product := Nat.mul_le_mul_right P order
      rw [Nat.add_mul,Nat.one_mul] at product
      have phaseBound : c.row.selected.val<P := c.row.selected.isLt
      omega
    have last : u=q → v.val≤c.row.selected.val := by
      intro same
      rw [same] at decomposition
      omega
    have bound := cycle_defect c data a walk k C d scale large start shift' q u qeq' uq v last
    have exactIndex : n=7^k+c.inner.moves.length+u*c.row.phases.size+v.val := by
      change n=7^k+c.inner.moves.length+u*P+v.val
      omega
    rw [exactIndex]
    exact bound

end Heraclitus.UpperOutgoingPrefix
#print axioms Heraclitus.UpperOutgoingPrefix.original_rule_before_crossing
