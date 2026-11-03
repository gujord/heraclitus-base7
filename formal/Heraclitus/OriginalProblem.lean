import Heraclitus.Coverage

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

/-! A direct statement of the original problem, without a boundary, period,
coverage or computer-certificate hypothesis in the sequence definition. -/

namespace Heraclitus.OriginalProblem
open GlobalWalk

/-- Zero initially; every new term is unused, differs by a power of seven,
and minimizes magnitude with preference for the larger integer on a tie. -/
def FollowsRule (a : Nat → Int) : Prop :=
  a 0=0 ∧ ∀ n : Nat,
    (¬∃ i : Nat, i≤n ∧ a i=a (n+1)) ∧
    (∃ j : Nat, (a (n+1)-a n).natAbs=7^j) ∧
    ∀ v : Int, (¬∃ i : Nat, i≤n ∧ a i=v) →
      (∃ j : Nat, (v-a n).natAbs=7^j) →
      (a (n+1)).natAbs≤v.natAbs ∧
      ((a (n+1)).natAbs=v.natAbs → v≤a (n+1))

theorem as_walk (a : Nat → Int) (rule : FollowsRule a) : IsWalk a := by
  refine ⟨rule.1, ?_⟩
  intro n
  obtain ⟨unused, step, minimum⟩ := rule.2 n
  refine ⟨unused, step, ?_⟩
  intro v vu vs
  obtain ⟨bound, tie⟩ := minimum v vu vs
  by_cases equal : (a (n+1)).natAbs=v.natAbs
  · exact Or.inr ⟨equal, tie equal⟩
  · exact Or.inl (by omega)

theorem from_walk (a : Nat → Int) (walk : IsWalk a) : FollowsRule a := by
  refine ⟨walk.1, ?_⟩
  intro n
  have choice := walk.2 n
  refine ⟨choice.1, choice.2.1, ?_⟩
  intro v vu vs
  have preferred := choice.2.2 v vu vs
  change (a (n+1)).natAbs<v.natAbs ∨ ((a (n+1)).natAbs=v.natAbs ∧ v≤a (n+1)) at preferred
  constructor
  · rcases preferred with less | equal <;> omega
  · intro equal
    rcases preferred with less | tied <;> omega

theorem rule_iff_walk (a : Nat → Int) : FollowsRule a ↔ IsWalk a :=
  ⟨as_walk a, from_walk a⟩

theorem canonical_follows_rule : FollowsRule sequence := from_walk sequence sequence_isWalk

/-- Every sequence obeying the original rule visits each integer exactly once. -/
theorem coverage (a : Nat → Int) (rule : FollowsRule a) :
    ∀ x : Int, ∃ i : Nat, a i=x ∧ ∀ j : Nat, a j=x → j=i :=
  Coverage.all_walks a (as_walk a rule)

/-- The stated checkpoint interval, directly at every integer exponent k>=6. -/
theorem checkpoint (a : Nat → Int) (rule : FollowsRule a) (k : Nat) (large : 6≤k) (x : Int)
    (low : -((((7^k : Nat) : Int)-1)/2)+37≤x)
    (high : x≤(((7^k : Nat) : Int)-1)/2-37) :
    ∃ i : Nat, i≤7^k ∧ a i=x := by
  let n := k-6
  have exponent : n+6=k := by dsimp [n]; omega
  have filled := Coverage.filled n x
  have inside : (Coverage.plan.boundary n).used x := by
    apply filled
    · simpa only [ScaleInduction.radius, exponent] using low
    · simpa only [ScaleInduction.radius, exponent] using high
  have visited := (Coverage.plan.visited_iff a (as_walk a rule) n x).mp inside
  rw [exponent] at visited
  exact visited

end Heraclitus.OriginalProblem
