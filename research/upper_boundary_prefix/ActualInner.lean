import ActualBoundary
import Heraclitus.OriginalProblem
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperBoundaryPrefix
open SignedCertificate GlobalWalk

def scheduledInner (k : Nat) : CheckedBoundary :=
  (ScaleScheduleData.entry (ScaleSchedule.index (k-6))).checked.link.phase.entrance.outgoing.inner

theorem inner_membership (i : Fin 36) :
    (ScaleScheduleData.entry i).checked.link.phase.entrance.outgoing.inner ∈ SignedBoundaryData.catalogue := by
  obtain ⟨i, bound⟩ := i
  have cases : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 ∨ i=33 ∨ i=34 ∨ i=35 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · change SignedBoundaryData.row42_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row43_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row44_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row45_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row46_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row47_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row48_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row49_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row50_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row51_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row52_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row53_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row54_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row55_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row56_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row57_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row58_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row59_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row60_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row61_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row62_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row63_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row64_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row65_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row66_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row67_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row68_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row69_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row70_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row71_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row72_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row73_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row74_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row75_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row40_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row41_inner ∈ SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]

theorem scheduled_inner_start (a : Nat → Int) (walk : IsWalk a) (k : Nat) (large : 6≤k) :
    stateAt a (7^k)=(scheduledInner k).initial.toState (ScaleInduction.radius k) := by
  have exponent : k-6+6=k := by omega
  have reached := Coverage.plan.reaches a walk (k-6)
  change stateAt a (7^(k-6+6))=ScaleScheduleData.schedule.boundary (k-6) at reached
  rw [exponent] at reached
  rw [reached]
  unfold ScaleSchedule.Schedule.boundary ScaleSchedule.Schedule.input
  rw [exponent]
  rfl

/-- Complete original-rule instance for every inner boundary at every k>=6.
There is no reached-state, finite-score or validity assumption. -/
theorem original_rule_inner_tail (a : Nat → Int) (rule : OriginalProblem.FollowsRule a)
    (k : Nat) (large : 6≤k) (D i : Nat) (hi : i≤(scheduledInner k).moves.length) :
    PhysicalTail.count a (7^k+i) D≤39 := by
  have walk := OriginalProblem.as_walk a rule
  have scale := ScaleSchedule.radius_exact k
  have size : 100000≤(7^k : Nat) := by
    have powers := Nat.pow_le_pow_right (n:=7) (by decide) large
    have six : (7:Nat)^6=117649 := by decide
    omega
  exact actual_catalogue_boundary_tail (scheduledInner k)
    (inner_membership (ScaleSchedule.index (k-6))) a walk (7^k) k _ scale size
    (scheduled_inner_start a walk k large) D i hi

end Heraclitus.UpperBoundaryPrefix
#print axioms Heraclitus.UpperBoundaryPrefix.original_rule_inner_tail
