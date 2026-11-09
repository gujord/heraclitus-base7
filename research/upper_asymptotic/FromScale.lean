import research.upper_machine_audit.TargetContract
set_option autoImplicit false

/-! Exact discrete asymptotics. This module proves the epsilon conclusion
from a uniform all-index scale bound; it does not supply that scale bound. -/
namespace Heraclitus.UpperAsymptotic
open UpperMachineAudit

theorem square_le_pow (k : Nat) : k*k ≤ 7^k := by
  induction k with
  | zero => decide
  | succ k ih =>
    have growth := Nat.lt_pow_self (n := k) (a := 7) (by decide)
    simp only [Nat.pow_succ, Nat.mul_add, Nat.add_mul,
      Nat.one_mul, Nat.mul_one]
    omega

theorem scale_bracket (n : Nat) (positive : 0 < n) :
    ∃ k : Nat, 7^k ≤ n ∧ n < 7^(k+1) := by
  obtain ⟨j, higher, least⟩ := GlobalWalk.least_nat (fun j => n < 7^j)
    ⟨n, Nat.lt_pow_self (a := 7) (by decide)⟩
  have jpos : 0 < j := by
    by_cases h : 0 < j
    · exact h
    have zero : j=0 := by omega
    simp only [zero, Nat.pow_zero] at higher
    omega
  refine ⟨j-1, ?_, ?_⟩
  · by_cases h : 7^(j-1) ≤ n
    · exact h
    have smaller := least (j-1) (by omega)
    omega
  · have index : j-1+1=j := by omega
    simpa only [index] using higher

/-- A defect bounded by A+B*k on every index of every sufficiently large
scale implies the exact rational-epsilon upper-limsup contract. The proof
gives the explicit (deliberately coarse) threshold 7^(6+q*(A+B)+1). -/
theorem eventual_upper_of_scale_bound (a : Nat → Int) (A B : Nat)
    (bounds : ∀ k : Nat, 6 ≤ k → ∀ n : Nat, 7^k ≤ n → n < 7^(k+1) →
      defect a n ≤ ((A+B*k : Nat) : Int)) : EventualUpperBound a := by
  intro p q hp _hq
  let K := 6+q*(A+B)+1
  refine ⟨7^K, ?_⟩
  intro n hn positive
  obtain ⟨k, low, high⟩ := scale_bracket n positive
  have large : K ≤ k := by
    by_cases h : K ≤ k
    · exact h
    have exponent : k+1 ≤ K := by omega
    have powers := Nat.pow_le_pow_right (n := 7) (by decide) exponent
    omega
  have k6 : 6 ≤ k := by dsimp [K] at large; omega
  have threshold : q*(A+B) ≤ k := by dsimp [K] at large; omega
  have step : A ≤ A*k := by
    have h := Nat.mul_le_mul_left A (show 1 ≤ k by omega)
    simpa only [Nat.mul_one] using h
  have polynomial : q*(A+B*k) ≤ n := calc
    q*(A+B*k) ≤ q*(A*k+B*k) := Nat.mul_le_mul_left q (by omega)
    _ = (q*(A+B))*k := by simp only [Nat.mul_add, Nat.add_mul, Nat.mul_assoc]
    _ ≤ k*k := Nat.mul_le_mul_right k threshold
    _ ≤ 7^k := square_le_pow k
    _ ≤ n := low
  have bound := bounds k k6 n low high
  have multiplied := Int.mul_le_mul_of_nonneg_left bound (Int.natCast_nonneg q)
  have castbound : ((q*(A+B*k) : Nat) : Int) ≤ (n : Int) := by omega
  rw [Int.natCast_mul] at castbound
  have enlarged := Int.mul_le_mul_of_nonneg_right
    (show (1 : Int) ≤ 8*(p : Int) by omega) (Int.natCast_nonneg n)
  simp only [Int.one_mul] at enlarged
  exact Int.le_trans (Int.le_trans multiplied castbound) enlarged

/-- The proposed logarithmic return envelope, once instantiated at every
actual index and scale, suffices for the requested eventual upper bound. -/
theorem eventual_upper_of_proposed_envelope (a : Nat → Int)
    (bounds : ∀ k : Nat, 6 ≤ k → ∀ n : Nat, 7^k ≤ n → n < 7^(k+1) →
      defect a n ≤ 32771+6*((k : Int)-4)) : EventualUpperBound a := by
  apply eventual_upper_of_scale_bound a 32771 6
  intro k hk n lo hi
  have h := bounds k hk n lo hi
  omega

end Heraclitus.UpperAsymptotic
#print axioms Heraclitus.UpperAsymptotic.eventual_upper_of_scale_bound
#print axioms Heraclitus.UpperAsymptotic.eventual_upper_of_proposed_envelope
