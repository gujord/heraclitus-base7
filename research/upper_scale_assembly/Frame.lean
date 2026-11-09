import AllPhases
import research.upper_machine_audit.TargetContract

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperScaleAssembly
open UpperPhaseBridge GlobalWalk OutgoingWord ReturnBridge

/-- Absolute index of the first crossing in the scheduled scale interval. -/
def crossingIndex (i : Fin 36) (t q : Nat) : Nat :=
  7^(exponent i t) + ((phase i).entrance.outgoing.inner.moves.length +
    q*(phase i).entrance.outgoing.row.phases.size +
    (phase i).entrance.outgoing.row.selected.val+1)

theorem exponent_large (i : Fin 36) (t : Nat) : 6≤exponent i t := by
  unfold exponent
  omega

theorem scale_large (i : Fin 36) (t : Nat) : 100000≤7^(exponent i t) := by
  have power := Nat.pow_le_pow_right (n:=7) (by decide) (exponent_large i t)
  have six : (7:Nat)^6=117649 := by decide
  omega

theorem crossing_after_checkpoint (i : Fin 36) (t q : Nat) :
    7^(exponent i t)<crossingIndex i t q := by
  unfold crossingIndex
  omega

theorem cycle_index_unique (p : SignedLadder.Phase) (t q r : Nat)
    (hq : p.CycleIndex t q) (hr : p.CycleIndex t r) : q=r := by
  obtain ⟨d, hd, qeq, shift⟩ := hq
  obtain ⟨e, he, req, shift'⟩ := hr
  have hp := p.entrance.outgoing.arithmetic.1
  have same : d=e := by
    apply Int.le_antisymm
    · by_cases h : d≤e
      · exact h
      have lt : e<d := by omega
      have prod := Int.mul_lt_mul_of_pos_left lt hp
      omega
    · by_cases h : e≤d
      · exact h
      have lt : d<e := by omega
      have prod := Int.mul_lt_mul_of_pos_left lt hp
      omega
  omega

theorem cycle_index_exists (a : Nat → Int) (walk : IsWalk a)
    (i : Fin 36) (t : Nat) : ∃ q, (phase i).CycleIndex t q := by
  obtain ⟨q, b, _, _, _, hq⟩ := reached_entrance a walk i t
  exact ⟨q, hq⟩

/-- The previously proved complete actual core entry, at a common explicit
index and for any witness satisfying the unique cycle-index relation. -/
theorem actual_core_start (a : Nat → Int) (walk : IsWalk a)
    (i : Fin 36) (t q : Nat) (index : (phase i).CycleIndex t q) :
    stateAt a (crossingIndex i t q+2) =
      liftRay (!(phase i).entrance.outgoing.row.positive)
        (ScaleInduction.radius (exponent i t))
        (farBoundary (phase i).entrance.outgoing q)
        (checkpoint (phase i).entrance.outgoing.geometry.other
          (7^(exponent i t) : Nat) (phase i).entrance.data.anchor).toState ∧
    3*(7^(exponent i t) : Nat)-200≤
      (farBoundary (phase i).entrance.outgoing q).front := by
  obtain ⟨r, b, time, start, filled, cycle⟩ := reached_entrance a walk i t
  have same := cycle_index_unique (phase i) t r q cycle index
  subst r
  have atIndex : b=crossingIndex i t q+2 := by unfold crossingIndex; omega
  rw [atIndex] at start
  exact ⟨start, filled⟩

end Heraclitus.UpperScaleAssembly
