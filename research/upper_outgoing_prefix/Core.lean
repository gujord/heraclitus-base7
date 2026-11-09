import research.upper_outgoing_prefix.Data
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperOutgoingPrefix
open SignedCertificate GlobalWalk OutgoingWord UpperMachineAudit

/-- Every prefix of a checked boundary, including the last state, retains
its checked coordinate band. -/
theorem boundary_prefix_band (s : Record) (ms : List Move)
    (initial : -512≤s.current ∧ s.current≤512) (valid : wordCheck s ms=true)
    (j : Nat) (hj : j≤ms.length) :
    -512≤(s.run (ms.take j)).current ∧ (s.run (ms.take j)).current≤512 := by
  induction ms generalizing s j with
  | nil => simpa only [List.take_nil, Record.run] using initial
  | cons m ms ih =>
    cases j with
    | zero => exact initial
    | succ j =>
      have parts : decide (MoveClaim s m)=true ∧ wordCheck (s.update m.positive m.value m.front) ms=true := by
        simpa only [wordCheck,Bool.and_eq_true] using valid
      have claim : MoveClaim s m := of_decide_eq_true parts.1
      exact ih _ claim.1.2.1 parts.2 j (by simpa using Nat.le_of_succ_le_succ hj)

theorem defect_of_two_bounds (a : Nat → Int) (n : Nat) (K : Int)
    (up : 8*((a n).natAbs : Int)-7*n≤K)
    (down : (n : Int)-8*(a n).natAbs≤K) : defect a n≤K := by
  unfold defect twiceDeviation
  dsimp only
  split <;> omega

theorem inner_defect (c : CertifiedRow) (data : RowBounds c)
    (a : Nat → Int) (walk : IsWalk a) (k : Nat) (C : Int)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000≤(7^k : Nat))
    (start : stateAt a (7^k)=c.inner.initial.toState C)
    (j : Nat) (hj : j≤c.inner.moves.length) :
    defect a (7^k+j)≤16261 := by
  have state := UpperBoundaryPrefix.actual_prefix_state c.inner a walk (7^k) k C scale large start j hj
  have band := boundary_prefix_band c.inner.initial c.inner.moves data.2.2.1 c.inner.valid j hj
  have current := congrArg State.current state
  change a (7^k+j)=embedRay (c.inner.initial.run (c.inner.moves.take j)).positive C
    (c.inner.initial.run (c.inner.moves.take j)).current at current
  have mag := embedRay_magnitude (c.inner.initial.run (c.inner.moves.take j)).positive C
    (c.inner.initial.run (c.inner.moves.take j)).current (by omega)
  rw [← current] at mag
  have len := data.1
  apply defect_of_two_bounds <;> omega

/-- Full actual state at any cycle prefix before the crossing, including
its final same-side state. -/
theorem actual_cycle_frame (c : CertifiedRow)
    (a : Nat → Int) (walk : IsWalk a) (k : Nat) (C d : Int)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000≤(7^k : Nat))
    (start : stateAt a (7^k)=c.inner.initial.toState C)
    (shift : (7^k : Nat)=c.row.scale+c.row.model.period*d)
    (q u : Nat) (qeq : (q : Int)=c.row.winningCycle+3*d)
    (uq : u≤q) (v : Fin c.row.phases.size)
    (last : u=q → v.val≤c.row.selected.val) :
    stateAt a (7^k+c.inner.moves.length+u*c.row.phases.size+v.val)=
      c.cycle.frame c.geometry C u v.val := by
  have entry := UpperBoundaryPrefix.actual_prefix_state c.inner a walk (7^k) k C scale large start
    c.inner.moves.length (by omega)
  rw [List.take_length] at entry
  have closes := Record.equalityCheck_sound _ _ c.inner.closes C
  have entrance := Record.equalityCheck_sound _ _ c.entrance C
  rw [OutgoingWord.record_lift] at entrance
  have frame : c.inner.final.toState C=c.cycle.frame c.geometry C 0 0 := by
    simpa only [CycleData.frame,CycleData.half,Int.natCast_zero,Int.zero_mul,translate_zero] using entrance
  have entryFrame : stateAt a (7^k+c.inner.moves.length)=c.cycle.frame c.geometry C 0 0 :=
    entry.trans (closes.trans frame)
  obtain ⟨cycles, clen⟩ := complete_cycles c.cycle c.geometry c.arithmetic c.cycleChecked c.bounds
    k C d scale large shift u (by omega)
  obtain ⟨part, plen⟩ := phase_prefix c.cycle c.geometry c.arithmetic c.cycleChecked c.bounds
    k C d scale large shift u v.val (by omega) (by
      intro i hi
      unfold FirstCrossing.Before
      by_cases eq : u=q
      · have h := last eq; right; constructor <;> omega
      · left; omega)
  let whole := cycles.then part
  have valid : SignedValidWord (stateAt a (7^k+c.inner.moves.length)) whole.word := by
    rw [entryFrame]; exact whole.valid
  have reached := valid_word_endpoint a walk (7^k+c.inner.moves.length) whole.word valid
  rw [entryFrame,whole.endpoint] at reached
  have len : whole.word.length=u*c.row.phases.size+v.val := by
    change (cycles.word++part.word).length=_
    rw [List.length_append,clen,plen]
  rw [len] at reached
  simpa only [Nat.add_assoc] using reached.symm

/-- Exact time and coordinate alignment bounds the defect without an
additional cardinality estimate on the outgoing side. -/
theorem cycle_defect (c : CertifiedRow) (data : RowBounds c)
    (a : Nat → Int) (walk : IsWalk a) (k : Nat) (C d : Int)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000≤(7^k : Nat))
    (start : stateAt a (7^k)=c.inner.initial.toState C)
    (shift : (7^k : Nat)=c.row.scale+c.row.model.period*d)
    (q u : Nat) (qeq : (q : Int)=c.row.winningCycle+3*d)
    (uq : u≤q) (v : Fin c.row.phases.size)
    (last : u=q → v.val≤c.row.selected.val) :
    defect a (7^k+c.inner.moves.length+u*c.row.phases.size+v.val)≤16261 := by
  have state := actual_cycle_frame c a walk k C d scale large start shift q u qeq uq v last
  have current := congrArg State.current state
  change a _ = embedRay c.row.positive C (c.cycle.half u v.val).current at current
  rw [half_current c.cycle c.cycleChecked] at current
  have geom := Outgoing.cycle_geometry c.geometry c.arithmetic c.bounds d (u : Int) v (by omega) (by omega)
  rw [← shift] at geom
  have mag := embedRay_magnitude c.row.positive C (Outgoing.cycleCurrent c.row u v) (by have h := geom.1.1; omega)
  rw [← current] at mag
  have low := (c.bounds.2.2.1 v).1
  have high := data.2.2.2 v
  have len := data.1
  have period := data.2.1
  have positive := c.arithmetic.1
  have product : 0≤(u : Int)*c.row.model.period := Int.mul_nonneg (by omega) (by omega)
  have cb := geom.1.2
  simp only [Outgoing.cycleCurrent] at mag cb
  have castPeriod : c.row.model.period=(c.row.phases.size : Int) := rfl
  rw [castPeriod] at mag cb product
  apply defect_of_two_bounds
  all_goals
    simp only [Int.natCast_add,Int.natCast_mul]
    omega

end Heraclitus.UpperOutgoingPrefix
