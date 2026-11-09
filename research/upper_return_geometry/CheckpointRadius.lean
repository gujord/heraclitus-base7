import research.physical_counting.CheckpointExterior

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

/-! Every actual point inside a scale interval is constrained by the complete
checkpoints: injectivity gives the inner exclusion and the next complete
used set gives the outer envelope. No within-word radius premise is needed. -/
namespace Heraclitus.UpperReturnGeometry
open SignedCertificate GlobalWalk

def boundaryBound (b : RayBoundary) : Prop :=
  b.front ≤ 4096 ∧ b.extra.all (fun x => decide (x ≤ 4096)) = true

instance (b : RayBoundary) : Decidable (boundaryBound b) := by
  unfold boundaryBound
  infer_instance

theorem boundary_used_upper (b : RayBoundary) (bound : boundaryBound b)
    (x : Int) (used : boundaryUsed b x) : x ≤ 4096 := by
  rcases used with low | extra
  · exact Int.le_trans (by omega) bound.1
  · have all := List.all_eq_true.mp bound.2 x extra
    simpa only [decide_eq_true_eq] using all

theorem all_phase_radius_bounds : ∀ i : Fin 36,
    let s := (ScaleScheduleData.entry i).checked.link.phase.entrance.outgoing.inner.initial
    boundaryBound s.pos ∧ boundaryBound s.neg := by decide

theorem record_radius_bound (s : Record) (C : Int) (nonneg : 0 ≤ C)
    (pos : boundaryBound s.pos) (neg : boundaryBound s.neg) (x : Int)
    (used : (s.toState C).used x) : (x.natAbs : Int) ≤ C+4096 := by
  change x=0 ∨ (0<x ∧ boundaryUsed s.pos (x-C)) ∨
    (x<0 ∧ boundaryUsed s.neg (-x-C)) at used
  rcases used with zero | ⟨positive, active⟩ | ⟨negative, active⟩
  · subst x; simp only [Int.natAbs_zero, Int.natCast_zero]; omega
  · have b := boundary_used_upper s.pos pos _ active
    have abs := Int.natAbs_of_nonneg (show 0 ≤ x by omega)
    omega
  · have b := boundary_used_upper s.neg neg _ active
    have abs := Int.natAbs_of_nonneg (show 0 ≤ -x by omega)
    rw [Int.natAbs_neg] at abs
    omega

/-- The complete next checkpoint bounds every earlier visited magnitude. -/
theorem original_rule_radius_upper (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (k n : Nat) (large : 6 ≤ k)
    (before : n ≤ 7^k) : (a n).natAbs ≤ ScaleInduction.radius k+4096 := by
  let q := k-6
  have exponent : q+6=k := by dsimp [q]; omega
  have reach := Coverage.plan.reaches a (OriginalProblem.as_walk a rule) q
  change stateAt a (7^(q+6))=ScaleScheduleData.schedule.boundary q at reach
  rw [exponent] at reach
  have used : (stateAt a (7^k)).used (a n) := ⟨n, before, rfl⟩
  rw [reach] at used
  change ((ScaleScheduleData.schedule.input q).toState
    (ScaleInduction.radius (q+6))).used (a n) at used
  rw [exponent] at used
  have all := all_phase_radius_bounds (ScaleSchedule.index q)
  have nonneg : 0 ≤ ScaleInduction.radius k := by
    have exact := ScaleSchedule.radius_exact k
    have zero := Int.natCast_nonneg (7^k)
    omega
  exact record_radius_bound _ _ nonneg all.1 all.2 _ used

/-- After the checkpoint, no previously filled central point can recur. -/
theorem original_rule_radius_lower (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (k n : Nat) (large : 6 ≤ k)
    (after : 7^k < n) : ScaleInduction.radius k-37 < (a n).natAbs := by
  by_cases bound : ScaleInduction.radius k-37 < (a n).natAbs
  · exact bound
  have denied := bound
  have lowabs := @Int.le_natAbs (a n)
  have negabs := @Int.le_natAbs (-(a n))
  rw [Int.natAbs_neg] at negabs
  obtain ⟨j, hj, equal⟩ := OriginalProblem.checkpoint a rule k large (a n)
    (by change -ScaleInduction.radius k+37 ≤ a n; omega)
    (by change a n ≤ ScaleInduction.radius k-37; omega)
  have eq := walk_injective a (OriginalProblem.as_walk a rule) equal
  omega

/-- A stronger radius statement than the return assembly requires: all
indices strictly after the inner checkpoint through the next checkpoint. -/
theorem original_rule_scale_radius (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (k n : Nat) (large : 6 ≤ k)
    (after : 7^k < n) (before : n ≤ 7^(k+1)) :
    ScaleInduction.radius k-4096 ≤ (a n).natAbs ∧
    (a n).natAbs ≤ ScaleInduction.radius (k+1)+4096 := by
  have lower := original_rule_radius_lower a rule k n large after
  have upper := original_rule_radius_upper a rule (k+1) n (by omega) before
  exact ⟨by omega, upper⟩

end Heraclitus.UpperReturnGeometry
#print axioms Heraclitus.UpperReturnGeometry.original_rule_scale_radius
