import research.actual_lower_bound.ActualCrossing
import research.upper_machine_audit.TargetContract
set_option autoImplicit false

namespace Heraclitus.ActualLowerBound
open UpperMachineAudit

/-- At the concrete crossing subsequence the cleared-denominator defect
is exactly five, so the deviation ratio is 3/8 + 5/(8n). -/
theorem original_rule_crossing_defect (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (t : Nat) :
    defect a (4*7^(6+36*t)+1)=5 := by
  have crossing := original_rule_crossing42 a rule t
  let m : Nat := 7^(6+36*t)
  let n : Nat := 4*m+1
  have index : n=4*m+1 := rfl
  change 2*a n = -7*(m : Int)-3 at crossing
  have nonneg : (0 : Int) ≤ (m : Int) := Int.natCast_nonneg _
  have abs_a := Int.natAbs_of_nonneg (show 0 ≤ -a n by omega)
  rw [Int.natAbs_neg] at abs_a
  change defect a n=5
  unfold defect twiceDeviation
  dsimp only
  split <;> omega

/-- The original rule implies the complete rational-epsilon lower-limsup
contract. There is no additional transition or crossing hypothesis. -/
theorem original_rule_frequent_lower (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) : FrequentLowerBound a := by
  intro p q _hp _hq N
  let n := 4*7^(6+36*N)+1
  have power := Nat.lt_pow_self (n := 6+36*N) (a := 7) (by decide)
  have large : N ≤ n := by dsimp [n]; omega
  have positive : 0 < n := by dsimp [n]; omega
  refine ⟨n, large, positive, ?_⟩
  have exact_defect : defect a n=5 := original_rule_crossing_defect a rule N
  rw [exact_defect]
  have lhs_nonneg : (0 : Int) ≤ 8*(p : Int)*(n : Int) :=
    Int.mul_nonneg (by omega) (Int.natCast_nonneg _)
  omega

end Heraclitus.ActualLowerBound
#print axioms Heraclitus.ActualLowerBound.original_rule_crossing_defect
#print axioms Heraclitus.ActualLowerBound.original_rule_frequent_lower
