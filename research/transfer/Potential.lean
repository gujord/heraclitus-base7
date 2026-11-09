import Std

set_option autoImplicit false

/-!
Exact algebra for the potential investigation. These results are universal
arithmetic lemmas. No reachability, bounded-marker, or coverage assertion
is assumed or proved by this file.
-/

namespace Heraclitus.Transfer

def twiceDeviation (n radius : Int) : Int :=
  if 0 ≤ 2 * radius - n then 2 * radius - n else n - 2 * radius

def outward (n radius : Int) : Int := 8 * radius - 7 * n
def inward (n radius : Int) : Int := n - 8 * radius

/-- E <= 3n/8 + K/8 is exactly these two integer inequalities. -/
theorem defect_bound_iff (n radius K : Int) :
    4 * twiceDeviation n radius - 3 * n ≤ K ↔
      outward n radius ≤ K ∧ inward n radius ≤ K := by
  unfold twiceDeviation outward inward
  split <;> omega

theorem outward_cycle_increment (n radius shift : Int) :
    outward (n + shift) (radius + shift) = outward n radius + shift := by
  unfold outward
  omega

theorem inward_cycle_increment (n radius shift : Int) :
    inward (n + shift) (radius + shift) = inward n radius - 7 * shift := by
  unfold inward
  omega

/-- A phase-only additive correction cannot make the outward defect
nonincreasing on a positive-shift full-state cycle. -/
theorem phase_only_obstruction (n radius penalty P : Int) (positive : 0 < P) :
    outward n radius + penalty < outward (n + P) (radius + P) + penalty := by
  rw [outward_cycle_increment]
  omega

/-- For a fixed cycle phase, all intermediate outward values are bounded
by the last repetition; inward values by the first. -/
theorem cycle_extrema (n radius shift total : Int)
    (nonneg : 0 ≤ shift) (last : shift ≤ total) :
    outward (n + shift) (radius + shift) ≤ outward (n + total) (radius + total) ∧
      inward (n + shift) (radius + shift) ≤ inward n radius := by
  rw [outward_cycle_increment, outward_cycle_increment, inward_cycle_increment]
  omega

/-- A sufficient return-segment envelope. Establishing `count` and the
coordinate hypotheses for ALL actual segments is a separate obligation.
Here C=(m-1)/2 and D=(7m-1)/2 are specified by exact integer equations.
-/
theorem return_envelope (m C D n radius H B delta : Int)
    (centres : 2 * C = m - 1 ∧ 2 * D = 7 * m - 1)
    (after_crossing : 4 * m + delta ≤ n)
    (upper : radius ≤ D + H) (lower : C - H ≤ radius)
    (count : n ≤ D + radius + B) :
    outward n radius ≤ 8 * H - 4 - 7 * delta ∧
      inward n radius ≤ 7 * H + 3 + B := by
  unfold outward inward
  omega

/-- Translation of geometric step sets is base-independent. This does
not prove a universal finite-state description or base-nine coverage. -/
def BasePowerStep (base : Nat) (x y : Int) : Prop :=
  ∃ j : Nat, (y - x).natAbs = base ^ j

theorem base_power_translation (base : Nat) (x y d : Int) :
    BasePowerStep base (x + d) (y + d) ↔ BasePowerStep base x y := by
  have eq : y + d - (x + d) = y - x := by omega
  simp only [BasePowerStep, eq]

end Heraclitus.Transfer

#print axioms Heraclitus.Transfer.defect_bound_iff
#print axioms Heraclitus.Transfer.outward_cycle_increment
#print axioms Heraclitus.Transfer.inward_cycle_increment
#print axioms Heraclitus.Transfer.phase_only_obstruction
#print axioms Heraclitus.Transfer.cycle_extrema
#print axioms Heraclitus.Transfer.return_envelope
#print axioms Heraclitus.Transfer.base_power_translation
