import research.upper_scale_assembly.Frame
import research.upper_return_geometry.CheckpointRadius

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperReturnGeometry
open UpperPhaseBridge UpperScaleAssembly

/-- The complete finite phase inventory gives the exact crossing-time
correction range. These are the original transition objects. -/
theorem all_phase_crossing_offsets : ∀ i : Fin 36,
    let r := (phase i).entrance.outgoing
    let delta := (r.inner.moves.length : Int)+r.row.winningCycle*r.row.model.period+
      (r.row.selected.val : Int)+1-3*r.row.scale;
    -1 ≤ delta ∧ delta ≤ 12 := by decide

/-- The finite correction range propagates to every exponent through the
exact CycleIndex affine relation; no sampled exponent is extrapolated. -/
theorem crossing_time (i : Fin 36) (t q : Nat)
    (index : (phase i).CycleIndex t q) :
    4*((7^(exponent i t) : Nat) : Int)-1 ≤ (crossingIndex i t q : Int) ∧
    (crossingIndex i t q : Int) ≤ 4*((7^(exponent i t) : Nat) : Int)+12 := by
  obtain ⟨d, _nonneg, qeq, shift⟩ := index
  rw [phase_exponent] at shift
  have delta := ReturnBridge.displacement (phase i).entrance.outgoing
    (exponent i t) d q shift qeq
  have offsets := all_phase_crossing_offsets i
  change -1 ≤ ((phase i).entrance.outgoing.inner.moves.length : Int)+
    (phase i).entrance.outgoing.row.winningCycle*
      ((phase i).entrance.outgoing.row.phases.size : Int)+
      ((phase i).entrance.outgoing.row.selected.val : Int)+1-
      3*(phase i).entrance.outgoing.row.scale ∧
    ((phase i).entrance.outgoing.inner.moves.length : Int)+
    (phase i).entrance.outgoing.row.winningCycle*
      ((phase i).entrance.outgoing.row.phases.size : Int)+
      ((phase i).entrance.outgoing.row.selected.val : Int)+1-
      3*(phase i).entrance.outgoing.row.scale ≤ 12 at offsets
  change (q : Int)*((phase i).entrance.outgoing.row.phases.size : Int)-
    3*(7^(exponent i t) : Nat)=
    (phase i).entrance.outgoing.row.winningCycle*
      ((phase i).entrance.outgoing.row.phases.size : Int)-
      3*(phase i).entrance.outgoing.row.scale at delta
  unfold crossingIndex
  simp only [Int.natCast_add, Int.natCast_mul, Int.natCast_one]
  omega

/-- All time/radius premises for the return counting estimate, for every
actual index from the first crossing through the next checkpoint. -/
theorem original_rule_return_geometry (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t q n : Nat)
    (index : (phase i).CycleIndex t q)
    (after : crossingIndex i t q ≤ n)
    (before : n ≤ 7^(exponent i t+1)) :
    4*((7^(exponent i t) : Nat) : Int)-1 ≤ (n : Int) ∧
    ScaleInduction.radius (exponent i t)-4096 ≤ (a n).natAbs ∧
    (a n).natAbs ≤ ScaleInduction.radius (exponent i t+1)+4096 := by
  have time := crossing_time i t q index
  have afterInner := crossing_after_checkpoint i t q
  have radius := original_rule_scale_radius a rule (exponent i t) n
    (exponent_large i t) (by omega) before
  exact ⟨by omega, radius⟩

end Heraclitus.UpperReturnGeometry
#print axioms Heraclitus.UpperReturnGeometry.original_rule_return_geometry
