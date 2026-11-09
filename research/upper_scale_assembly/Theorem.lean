import research.upper_scale_assembly.Counting
import research.upper_outgoing_prefix.Actual
import research.upper_return_geometry.EntranceTail
import research.upper_return_tail.End
import research.actual_lower_bound.LowerBound

set_option autoImplicit false

namespace Heraclitus.UpperScaleAssembly
open UpperPhaseBridge UpperMachineAudit

/-- Every actual index from first crossing through the next checkpoint,
including the two entrance moves and every seam of the remaining return. -/
theorem original_rule_return_tail (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t q : Nat)
    (index : (phase i).CycleIndex t q) (n : Nat)
    (after : crossingIndex i t q≤n) (before : n≤7^(exponent i t+1)) (D : Nat) :
    PhysicalTail.count a n D≤55+6*(exponent i t-4) := by
  by_cases inCore : crossingIndex i t q+2≤n
  · exact UpperReturnTail.original_rule_core_to_checkpoint a rule i t q index n inCore before D
  · let j := n-crossingIndex i t q
    have hj : j≤2 := by dsimp [j]; omega
    have entry := UpperReturnGeometry.original_rule_entrance_tail a rule i t q j D index hj
    have atIndex : crossingIndex i t q+j=n := by dsimp [j]; omega
    rw [atIndex] at entry
    omega

/-- The complete exact all-index scale estimate, for every schedule phase
and every repetition, from the literal original rule alone. -/
theorem original_rule_phase_bound (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t n : Nat)
    (lower : 7^(exponent i t)≤n) (upper : n≤7^(exponent i t+1)) :
    defect a n≤32771+6*((exponent i t : Int)-4) := by
  obtain ⟨q, index⟩ := cycle_index_exists a (OriginalProblem.as_walk a rule) i t
  have large := exponent_large i t
  by_cases beforeCrossing : n<crossingIndex i t q
  · have bound := UpperOutgoingPrefix.original_rule_before_crossing a rule i t q index n lower beforeCrossing
    omega
  · have after : crossingIndex i t q≤n := by omega
    have geometry := UpperReturnGeometry.original_rule_return_geometry a rule i t q n index after upper
    have tail := original_rule_return_tail a rule i t q index n after upper
      (ScaleInduction.radius (exponent i t+1)).toNat
    exact return_defect a rule (exponent i t) n large upper geometry.1 geometry.2.1 geometry.2.2 tail

/-- All integer exponents and all indices in each scale interval. -/
theorem original_rule_scale_bound (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (k : Nat) (large : 6≤k)
    (n : Nat) (lower : 7^k≤n) (upper : n≤7^(k+1)) :
    defect a n≤32771+6*((k : Int)-4) := by
  have same := scale_parameters k large
  have lo : 7^(exponent (ScaleSchedule.index (k-6)) ((k-6)/36))≤n := by rw [same]; exact lower
  have hi : n≤7^(exponent (ScaleSchedule.index (k-6)) ((k-6)/36)+1) := by rw [same]; exact upper
  simpa only [same] using original_rule_phase_bound a rule (ScaleSchedule.index (k-6)) ((k-6)/36) n lo hi

/-- The precise rational-epsilon upper-limsup contract. -/
theorem original_rule_eventual_upper (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) : EventualUpperBound a := by
  apply UpperAsymptotic.eventual_upper_of_proposed_envelope a
  intro k hk n lo hi
  exact original_rule_scale_bound a rule k hk n lo (by omega)

/-- The exact combined equality target, with no added transition, tail,
reachability, time, radius, or all-index estimate hypothesis. -/
theorem original_rule_three_eighths : OriginalRuleThreeEighths := by
  intro a rule
  exact ⟨original_rule_eventual_upper a rule,
    ActualLowerBound.original_rule_frequent_lower a rule⟩

theorem canonical_three_eighths :
    EventualUpperBound GlobalWalk.sequence ∧ FrequentLowerBound GlobalWalk.sequence :=
  original_rule_three_eighths GlobalWalk.sequence OriginalProblem.canonical_follows_rule

end Heraclitus.UpperScaleAssembly
#print axioms Heraclitus.UpperScaleAssembly.original_rule_scale_bound
#print axioms Heraclitus.UpperScaleAssembly.original_rule_three_eighths
