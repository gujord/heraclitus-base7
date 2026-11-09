import Std
set_option autoImplicit false

/- Conditional arithmetic only. The hypotheses about actual times, physical
coordinates, used-set counting and the tail are not proved in this file. -/
namespace Heraclitus.DescentBottomBound

theorem defects (m C D n r t L : Int)
    (centres : 2*C = m-1 ∧ 2*D = 7*m-1)
    (positive : 0 ≤ m)
    (time : 4*m-1 ≤ n)
    (lower : C-100 ≤ r)
    (upper : r ≤ C+2*m+4096)
    (count : n ≤ D+r+7+t)
    (tail : t ≤ 55+6*L) :
    8*r-7*n ≤ 32771 ∧ n-8*r ≤ 28737+6*L := by
  omega

/-- The two post-crossing moves and the exceptional short word use the same
   arithmetic provided their separate, explicitly stated physical bounds hold. -/
theorem short_defects (m C D n r t : Int)
    (centres : 2*C = m-1 ∧ 2*D = 7*m-1)
    (time : 4*m-1 ≤ n)
    (upper : r ≤ D+4096)
    (count : n ≤ D+r+7+t)
    (tail : t ≤ 4) :
    8*r-7*n ≤ 32771 ∧ n-8*r ≤ 91 := by
  omega

#print axioms defects
#print axioms short_defects
end Heraclitus.DescentBottomBound
