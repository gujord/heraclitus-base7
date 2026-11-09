import Std

set_option autoImplicit false

/-!
Universal integer arithmetic for the first-crossing deviation formula.
These results assume the index, radius and offset bounds; they do not
establish that any crossing of the greedy walk has those properties.
-/
namespace Heraclitus.CrossingArithmetic

def twiceDeviation (n r : Int) : Int :=
  if 0 ≤ 2 * r - n then 2 * r - n else n - 2 * r

/-- Formula (8) with denominators cleared. The bounds force the branch of
absolute value used in the calculation and guarantee a positive index. -/
theorem crossing_identity (m n r A delta : Int)
    (scale : 7 ≤ m)
    (index : n = 4 * m + delta)
    (radius : 2 * r = 7 * m - 1 + 2 * A)
    (abounds : -3 ≤ A ∧ A ≤ 3)
    (dbounds : -1 ≤ delta ∧ delta ≤ 12) :
    0 < n ∧ 0 ≤ 2 * r - n ∧
      4 * twiceDeviation n r - 3 * n = 8 * A - 4 - 7 * delta := by
  have sign : 0 ≤ 2 * r - n := by omega
  refine ⟨by omega, sign, ?_⟩
  unfold twiceDeviation
  simp only [sign, ↓reduceIte]
  omega

/-- A uniform numerator bound yields an explicit rational error estimate
once divided by 8n. No asymptotic library or reachability claim is used. -/
theorem crossing_error_bounds (m n r A delta : Int)
    (scale : 7 ≤ m)
    (index : n = 4 * m + delta)
    (radius : 2 * r = 7 * m - 1 + 2 * A)
    (abounds : -3 ≤ A ∧ A ≤ 3)
    (dbounds : -1 ≤ delta ∧ delta ≤ 12) :
    0 < n ∧ 4 * m - 1 ≤ n ∧
      -112 ≤ 4 * twiceDeviation n r - 3 * n ∧
      4 * twiceDeviation n r - 3 * n ≤ 27 := by
  have h := crossing_identity m n r A delta scale index radius abounds dbounds
  omega

end Heraclitus.CrossingArithmetic

#print axioms Heraclitus.CrossingArithmetic.crossing_identity
#print axioms Heraclitus.CrossingArithmetic.crossing_error_bounds
