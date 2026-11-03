import Heraclitus.GlobalWalk
import Heraclitus.Refinement

set_option autoImplicit false

/-!
# Exact base-to-infinity induction interface

This module proves the logical assembly theorem. Its `Plan` is an explicit
unfilled obligation: a valid base block from zero and a valid complete
scale block at EVERY exponent, with exact lengths and whole endpoints.
No concrete plan for the 36-phase certificate is supplied here.
-/

namespace Heraclitus.ScaleInduction
open GlobalWalk

/-- Entry n is the complete physical state at exponent n+6. -/
structure Plan where
  boundary : Nat → State
  base : SignedBlock signedStart (boundary 0)
  base_length : base.word.length=7^6
  transition : (n : Nat) → SignedBlock (boundary n) (boundary (n+1))
  transition_length : ∀ n, (transition n).word.length=6*7^(n+6)

def Plan.prefix (p : Plan) : (n : Nat) → SignedBlock signedStart (p.boundary n)
  | 0 => p.base
  | n+1 => (p.prefix n).then (p.transition n)

theorem Plan.prefix_length (p : Plan) (n : Nat) : (p.prefix n).word.length=7^(n+6) := by
  induction n with
  | zero => exact p.base_length
  | succ n ih =>
    change ((p.prefix n).then (p.transition n)).word.length=_
    rw [signedBlock_length, ih, p.transition_length]
    rw [show n+1+6=(n+6)+1 by omega]
    calc
      7^(n+6)+6*7^(n+6)=7^(n+6)*7 := by omega
      _=7^((n+6)+1) := (Nat.pow_succ _ _).symm

/-- Every whole checkpoint is reached by the actual exact greedy walk. -/
theorem Plan.reaches (p : Plan) (a : Nat → Int) (walk : IsWalk a) (n : Nat) :
    stateAt a (7^(n+6))=p.boundary n := by
  have eq := valid_word_endpoint a walk 0 (p.prefix n).word
    (by rw [stateAt_zero a walk.1]; exact (p.prefix n).valid)
  rw [stateAt_zero a walk.1, Nat.zero_add, p.prefix_length] at eq
  exact eq.symm.trans (p.prefix n).endpoint

theorem Plan.visited_iff (p : Plan) (a : Nat → Int) (walk : IsWalk a) (n : Nat) (x : Int) :
    (p.boundary n).used x ↔ ∃ i, i ≤ 7^(n+6) ∧ a i=x := by
  rw [← p.reaches a walk n]
  rfl

def radius (k : Nat) : Int := (((7^k : Nat) : Int)-1)/2

/-- Exact integer form of the central interval in the proposed theorem. -/
def Filled (p : Plan) : Prop := ∀ n x,
  -radius (n+6)+37 ≤ x → x ≤ radius (n+6)-37 → (p.boundary n).used x

theorem intervals_exhaust (x : Int) : ∃ n,
    -radius (n+6)+37 ≤ x ∧ x ≤ radius (n+6)-37 := by
  let n := 2*x.natAbs+75
  refine ⟨n, ?_⟩
  have grow : n+6 < 7^(n+6) := Nat.lt_pow_self (by decide)
  have upper := @Int.le_natAbs x
  have lower := @Int.le_natAbs (-x)
  rw [Int.natAbs_neg] at lower
  have ne : (n : Int)=2*(x.natAbs : Int)+75 := by simp [n]
  dsimp only [radius]
  omega

/-- Conditional only on the explicit complete plan and its filled intervals.
There is no simulation cutoff or assumed period in the induction itself. -/
theorem Plan.covers (p : Plan) (filled : Filled p) (a : Nat → Int) (walk : IsWalk a) :
    ∀ x : Int, ∃ i : Nat, a i=x := by
  intro x
  obtain ⟨n, low, high⟩ := intervals_exhaust x
  obtain ⟨i, _, hit⟩ := (p.visited_iff a walk n x).mp (filled n x low high)
  exact ⟨i, hit⟩

theorem Plan.exactly_once (p : Plan) (filled : Filled p) (a : Nat → Int) (walk : IsWalk a) :
    ∀ x : Int, ∃ i : Nat, a i=x ∧ ∀ j, a j=x → j=i := by
  intro x
  obtain ⟨i, hit⟩ := p.covers filled a walk x
  exact ⟨i, hit, fun j hj => walk_injective a walk (hj.trans hit.symm)⟩

theorem Plan.canonical_coverage (p : Plan) (filled : Filled p) :
    ∀ x : Int, ∃ i : Nat, sequence i=x ∧ ∀ j, sequence j=x → j=i :=
  p.exactly_once filled sequence sequence_isWalk

end Heraclitus.ScaleInduction
