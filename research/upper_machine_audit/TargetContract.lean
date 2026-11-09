import Heraclitus.OriginalProblem

set_option autoImplicit false

/-! Exact target statements, not proofs. These definitions avoid any real-analysis
library. For n > 0, defect a n = 8 * ||a(n)| - n/2| - 3*n.
The positive p/q quantifiers are rational epsilon tests for limsup = 3/8.
No theorem asserting either target is supplied here. -/
namespace Heraclitus.UpperMachineAudit

def twiceDeviation (a : Nat → Int) (n : Nat) : Int :=
  let d := 2 * (a n).natAbs - (n : Int)
  if 0 ≤ d then d else -d

def defect (a : Nat → Int) (n : Nat) : Int :=
  4 * twiceDeviation a n - 3 * (n : Int)

/-- For every rational epsilon > 0, all sufficiently late deviations are
at most (3/8 + epsilon)*n. -/
def EventualUpperBound (a : Nat → Int) : Prop :=
  ∀ p q : Nat, 0 < p → 0 < q →
    ∃ N : Nat, ∀ n : Nat, N ≤ n → 0 < n →
      (q : Int) * defect a n ≤ 8 * (p : Int) * (n : Int)

/-- For every rational epsilon > 0 and every cutoff, a positive later index
has deviation at least (3/8 - epsilon)*n. -/
def FrequentLowerBound (a : Nat → Int) : Prop :=
  ∀ p q : Nat, 0 < p → 0 < q →
    ∀ N : Nat, ∃ n : Nat, N ≤ n ∧ 0 < n ∧
      -(8 * (p : Int) * (n : Int)) ≤ (q : Int) * defect a n

/-- The requested combined original-rule target. This is only a named Prop,
not an inhabitant/proof of that Prop. -/
def OriginalRuleThreeEighths : Prop :=
  ∀ a : Nat → Int, OriginalProblem.FollowsRule a →
    EventualUpperBound a ∧ FrequentLowerBound a

end Heraclitus.UpperMachineAudit
