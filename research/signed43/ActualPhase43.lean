import SignedTail
import Heraclitus.Coverage
import Heraclitus.OriginalProblem
import Heraclitus.ShortReturnData

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000

/-! Concrete reachability for the 43 phase, followed by the physical
short-word tail bound. No global all-segment bound is asserted. -/
namespace Heraclitus.SignedTail43
open Heraclitus.ReturnBridge

/-- The actual walk has the exact inner-boundary record for phase 43 at
its starting checkpoint, at every exponent congruent to 7 modulo 36. -/
theorem phase43_checkpoint (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (t : Nat) :
    GlobalWalk.stateAt a (7^(7+36*t)) =
      ShortReturnData.phase.entrance.outgoing.inner.initial.toState
        (ScaleInduction.radius (7+36*t)) := by
  have ix : ScaleSchedule.index (1+36*t) = ⟨1, by decide⟩ := by
    apply Fin.ext
    simp [ScaleSchedule.index, Nat.add_mod]
  have reach := Coverage.plan.reaches a walk (1+36*t)
  change GlobalWalk.stateAt a (7^((1+36*t)+6)) =
    ScaleScheduleData.schedule.boundary (1+36*t) at reach
  have exponent : (1+36*t)+6 = 7+36*t := by omega
  rw [exponent] at reach
  rw [reach]
  unfold ScaleSchedule.Schedule.boundary ScaleSchedule.Schedule.input
  rw [ix, exponent]
  rfl

/-- Every phase-43 checkpoint is followed by an actual signed short word;
its physical same-side tail has size at most four at all three prefixes. -/
theorem actual_phase43_short_tail (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (t : Nat) :
    ∃ q base : Nat, 7^(7+36*t) ≤ base ∧
      GlobalWalk.stateAt a base =
        OutgoingWord.liftRay (!ShortReturnData.phase.entrance.outgoing.row.positive)
          (ScaleInduction.radius (7+36*t))
          (farBoundary ShortReturnData.phase.entrance.outgoing q)
          (checkpoint ⟨1, []⟩ (7^(7+36*t) : Nat) 2).toState ∧
      ∀ i, i ≤ 2 → ∀ D, PhysicalTail.count a (base+i) D ≤ 4 := by
  let e := ShortReturnData.phase.entrance
  let k := 7+36*t
  let C := ScaleInduction.radius k
  have scale : 2*C+1=(7^k : Nat) := ScaleSchedule.radius_exact k
  have large : 100000 ≤ (7^k : Nat) := by
    have bound := Nat.pow_le_pow_right (n := 7) (by decide) (show 6 ≤ k by dsimp [k]; omega)
    have value : (7:Nat)^6=117649 := by decide
    rw [value] at bound
    omega
  have beginState : GlobalWalk.stateAt a (7^k) = e.outgoing.inner.initial.toState C := by
    exact phase43_checkpoint a walk t
  have eScale : 2*C+1=(7^(e.outgoing.row.leastExponent+36*t) : Nat) := by
    have ex : e.outgoing.row.leastExponent=7 := ShortReturnData.phase_identity.2.1
    simpa [ex, k] using scale
  obtain ⟨q, b, length, filled, _rest⟩ := e.all_exponents t C eScale
  have startValid : SignedValidWord (GlobalWalk.stateAt a (7^k)) b.word := by
    rw [beginState]
    exact b.valid
  have endeq := GlobalWalk.valid_word_endpoint a walk (7^k) b.word startValid
  rw [beginState, b.endpoint] at endeq
  let base := 7^k+b.word.length
  have startAt : GlobalWalk.stateAt a base =
    OutgoingWord.liftRay (!e.outgoing.row.positive) C (farBoundary e.outgoing q)
      (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState := by
    have old : e.outgoing.geometry.other = ⟨1, []⟩ := by
      have mat : SignedBottom.ShortMatch e := SignedBottomData.match43
      cases h : e.outgoing.geometry.other
      have front := mat.2.2.1
      have extra := mat.2.2.2
      simp only [h] at front extra
      simp only [front, extra]
    have anchor : e.data.anchor=2 := SignedBottomData.match43.2.1
    have exp : e.outgoing.row.leastExponent+36*t = k := by
      have ex : e.outgoing.row.leastExponent=7 := ShortReturnData.phase_identity.2.1
      simp [ex, k]
    rw [← endeq]
    simp only [old, anchor, exp]
  have least : e.outgoing.row.leastExponent=7 := ShortReturnData.phase_identity.2.1
  refine ⟨q, base, by dsimp [base, k]; omega, startAt, ?_⟩
  intro i hi D
  exact actual_walk_tail_count a walk base k (!e.outgoing.row.positive) C
    (farBoundary e.outgoing q) scale large (by simpa [k, least] using filled) startAt i hi D

/-- Literal original-rule corollary, including the reached full state. -/
theorem original_rule_phase43_short_tail (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (t : Nat) :
    ∃ q base : Nat, 7^(7+36*t) ≤ base ∧
      GlobalWalk.stateAt a base =
        OutgoingWord.liftRay (!ShortReturnData.phase.entrance.outgoing.row.positive)
          (ScaleInduction.radius (7+36*t))
          (farBoundary ShortReturnData.phase.entrance.outgoing q)
          (checkpoint ⟨1, []⟩ (7^(7+36*t) : Nat) 2).toState ∧
      ∀ i, i ≤ 2 → ∀ D, PhysicalTail.count a (base+i) D ≤ 4 :=
  actual_phase43_short_tail a (OriginalProblem.as_walk a rule) t

end Heraclitus.SignedTail43
#print axioms Heraclitus.SignedTail43.phase43_checkpoint
#print axioms Heraclitus.SignedTail43.actual_phase43_short_tail

#print axioms Heraclitus.SignedTail43.original_rule_phase43_short_tail
