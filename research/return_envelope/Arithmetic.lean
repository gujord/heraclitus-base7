import Std
set_option autoImplicit false

/- Conditional arithmetic for one return state. This does not establish any
of the physical, temporal, tail, reachability, or scale-transition premises. -/
namespace Heraclitus.ReturnEnvelopeArithmetic

def twiceDeviation (n r : Int) : Int :=
  if 0 ≤ 2*r-n then 2*r-n else n-2*r

/-- An all-segment tail budget and a radius/time envelope imply the two
integer defect bounds used by the proposed return argument. -/
theorem conditional_defects (m C D n r t L : Int)
    (centres : 2*C = m-1 ∧ 2*D = 7*m-1)
    (time : 4*m-1 ≤ n)
    (lower : C-4096 ≤ r)
    (upper : r ≤ D+4096)
    (count : n ≤ D+r+7+t)
    (tail : t ≤ 55+6*L) :
    8*r-7*n ≤ 32771 ∧ n-8*r ≤ 28737+6*L := by
  omega

/-- Cleared-denominator deviation form, expressed as two integer bounds
on the same defect so no unproved asymptotic claim is embedded. -/
theorem conditional_deviation (m C D n r t L K : Int)
    (centres : 2*C = m-1 ∧ 2*D = 7*m-1)
    (time : 4*m-1 ≤ n)
    (lower : C-4096 ≤ r)
    (upper : r ≤ D+4096)
    (count : n ≤ D+r+7+t)
    (tail : t ≤ 55+6*L)
    (outward : 32771 ≤ K) (inward : 28737+6*L ≤ K) :
    4 * twiceDeviation n r - 3*n ≤ K := by
  have bounds := conditional_defects m C D n r t L centres time lower upper count tail
  unfold twiceDeviation
  split <;> omega

/-- A looser single bound convenient for scale-by-scale asymptotics. -/
theorem conditional_simple_bound (m C D n r t L : Int)
    (centres : 2*C = m-1 ∧ 2*D = 7*m-1)
    (time : 4*m-1 ≤ n)
    (lower : C-4096 ≤ r)
    (upper : r ≤ D+4096)
    (count : n ≤ D+r+7+t)
    (tail : t ≤ 55+6*L)
    (nonnegative : 0 ≤ L) :
    4 * twiceDeviation n r - 3*n ≤ 32771+6*L := by
  apply conditional_deviation m C D n r t L _ centres time lower upper count tail <;> omega

end Heraclitus.ReturnEnvelopeArithmetic

#print axioms Heraclitus.ReturnEnvelopeArithmetic.conditional_defects
#print axioms Heraclitus.ReturnEnvelopeArithmetic.conditional_deviation

#print axioms Heraclitus.ReturnEnvelopeArithmetic.conditional_simple_bound
