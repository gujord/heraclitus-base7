import Std
set_option autoImplicit false

/-! Conditional arithmetic at the end of the ordinary forced descent in
phase 42. The exact time/radius and actual reachability are NOT proved here. -/
namespace Heraclitus.DescentDefect

def twiceDeviation (n r : Int) : Int :=
  if 0 ≤ 2*r-n then 2*r-n else n-2*r

theorem phase42_defect (m n r t : Int)
    (large : 117649 ≤ m) (nonnegative : 0 ≤ t)
    (time : n=4*m+15+216*t) (radius : 2*r=m+4805) :
    0 < n-2*r ∧ n-8*r=216*t-19205 ∧
      4*twiceDeviation n r-3*n=216*t-19205 := by
  have sign : ¬ 0 ≤ 2*r-n := by omega
  unfold twiceDeviation
  simp only [sign, ↓reduceIte]
  omega

/-- No fixed constant bounds the displayed arithmetic progression. -/
theorem exceeds_constant (t B : Int)
    (nonnegative : 0 ≤ t) (threshold : B+19206 ≤ t) :
    B < 216*t-19205 := by omega

end Heraclitus.DescentDefect
#print axioms Heraclitus.DescentDefect.phase42_defect
#print axioms Heraclitus.DescentDefect.exceeds_constant
