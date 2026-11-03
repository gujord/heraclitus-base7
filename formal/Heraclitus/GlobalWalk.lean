import Heraclitus.Signed

set_option autoImplicit false

/-!
# The exact infinite signed walk

Existence and uniqueness use only finite used sets and the exact signed
greedy rule. No scale certificate or coverage statement is assumed.
Finite valid words are identified with prefixes of this same walk.
-/

namespace Heraclitus.GlobalWalk

def rank (v : Int) : Nat := 2*v.natAbs + if 0 ≤ v then 0 else 1

theorem rank_order (v w : Int) : rank v ≤ rank w ↔ Preferred v w := by
  have av := Int.natAbs_eq v
  have aw := Int.natAbs_eq w
  by_cases hv : 0 ≤ v <;> by_cases hw : 0 ≤ w
  all_goals
    simp only [rank, hv, hw, ite_true, ite_false, Preferred]
    omega

/-- Least-element principle, proved by strong induction in the standard library. -/
theorem least_nat (P : Nat → Prop) (exists_p : ∃ n, P n) :
    ∃ n, P n ∧ ∀ m, P m → n ≤ m := by
  classical
  obtain ⟨n, hn⟩ := exists_p
  induction n using Nat.strongRecOn with
  | ind n ih =>
    by_cases smaller : ∃ m, m < n ∧ P m
    · obtain ⟨m, lt, hm⟩ := smaller
      exact ih m lt hm
    · refine ⟨n, hn, ?_⟩
      intro m hm
      by_cases h : n ≤ m
      · exact h
      · exact False.elim (smaller ⟨m, by omega, hm⟩)

def Bounded (s : State) : Prop := ∃ B : Nat, ∀ x, s.used x → x.natAbs ≤ B

theorem start_bounded : Bounded signedStart := by
  refine ⟨0, ?_⟩
  intro x hx
  change x=0 at hx
  simp [hx]

theorem visit_bounded (s : State) (v : Int) (bounded : Bounded s) : Bounded (visit s v) := by
  obtain ⟨B, bound⟩ := bounded
  refine ⟨B+v.natAbs, ?_⟩
  intro x hx
  rcases hx with old | same
  · have h := bound x old; omega
  · subst x; omega

theorem admissible_exists (s : State) (bounded : Bounded s) :
    ∃ v, ¬s.used v ∧ PowerStep s.current v := by
  obtain ⟨B, bound⟩ := bounded
  let j := B+s.current.natAbs+1
  have big : j < 7^j := Nat.lt_pow_self (by decide)
  let v : Int := s.current+(7^j : Nat)
  have currentLower := @Int.le_natAbs (-s.current)
  rw [Int.natAbs_neg] at currentLower
  have big' := Int.ofNat_lt.mpr big
  have jeq : (j : Int)=(B : Int)+s.current.natAbs+1 := by simp [j]
  have beyond : (B : Int) < v := by change (B : Int) < s.current+(7^j : Nat); omega
  refine ⟨v, ?_, j, ?_⟩
  · intro used
    have h := bound v used
    have h' := @Int.le_natAbs v
    omega
  · have diff : v-s.current=(7^j : Nat) := by dsimp [v]; omega
    rw [diff, Int.natAbs_natCast]

theorem greedy_exists (s : State) (bounded : Bounded s) : ∃ v, SignedGreedy s v := by
  obtain ⟨v, unused, step⟩ := admissible_exists s bounded
  obtain ⟨n, ⟨w, hu, hs, eq⟩, minimal⟩ :=
    least_nat (fun n => ∃ w, ¬s.used w ∧ PowerStep s.current w ∧ rank w=n)
      ⟨rank v, v, unused, step, rfl⟩
  refine ⟨w, hu, hs, ?_⟩
  intro x xu xs
  apply (rank_order w x).mp
  rw [eq]
  exact minimal (rank x) ⟨x, xu, xs, rfl⟩

structure BoundedState where
  state : State
  bounded : Bounded state

noncomputable def next (s : BoundedState) : Int := Classical.choose (greedy_exists s.state s.bounded)

theorem next_greedy (s : BoundedState) : SignedGreedy s.state (next s) :=
  Classical.choose_spec (greedy_exists s.state s.bounded)

noncomputable def orbit : Nat → BoundedState
  | 0 => ⟨signedStart, start_bounded⟩
  | n+1 => ⟨visit (orbit n).state (next (orbit n)),
      visit_bounded _ _ (orbit n).bounded⟩

noncomputable def sequence (n : Nat) : Int := (orbit n).state.current

theorem sequence_zero : sequence 0=0 := rfl
theorem sequence_succ (n : Nat) : sequence (n+1)=next (orbit n) := rfl

theorem orbit_used (n : Nat) (x : Int) :
    (orbit n).state.used x ↔ ∃ i, i ≤ n ∧ sequence i=x := by
  induction n with
  | zero =>
    change x=0 ↔ ∃ i, i ≤ 0 ∧ sequence i=x
    constructor
    · intro h; exact ⟨0, Nat.le_refl _, h.symm⟩
    · rintro ⟨i, hi, h⟩
      have eq : i=0 := by omega
      simpa [eq, sequence_zero] using h.symm
  | succ n ih =>
    change ((orbit n).state.used x ∨ x=sequence (n+1)) ↔ _
    rw [ih]
    constructor
    · rintro (⟨i, hi, hx⟩ | hx)
      · exact ⟨i, by omega, hx⟩
      · exact ⟨n+1, Nat.le_refl _, hx.symm⟩
    · rintro ⟨i, hi, hx⟩
      by_cases small : i ≤ n
      · exact Or.inl ⟨i, small, hx⟩
      · have eq : i=n+1 := by omega
        exact Or.inr (by simpa [eq] using hx.symm)

def stateAt (a : Nat → Int) (n : Nat) : State :=
  ⟨a n, fun x => ∃ i, i ≤ n ∧ a i=x⟩

def IsWalk (a : Nat → Int) : Prop :=
  a 0=0 ∧ ∀ n, SignedGreedy (stateAt a n) (a (n+1))

theorem orbit_state (n : Nat) : (orbit n).state=stateAt sequence n := by
  apply state_ext
  · rfl
  · exact orbit_used n

theorem sequence_isWalk : IsWalk sequence := by
  refine ⟨sequence_zero, ?_⟩
  intro n
  rw [← orbit_state, sequence_succ]
  exact next_greedy _

theorem stateAt_zero (a : Nat → Int) (zero : a 0=0) : stateAt a 0=signedStart := by
  apply state_ext zero
  intro x
  simp [stateAt, signedStart, zero, eq_comm]

theorem stateAt_succ (a : Nat → Int) (n : Nat) :
    stateAt a (n+1)=visit (stateAt a n) (a (n+1)) := by
  apply state_ext
  · rfl
  intro x
  change (∃ i, i ≤ n+1 ∧ a i=x) ↔ (∃ i, i ≤ n ∧ a i=x) ∨ x=a (n+1)
  constructor
  · rintro ⟨i, hi, hx⟩
    by_cases low : i ≤ n
    · exact Or.inl ⟨i, low, hx⟩
    · have eq : i=n+1 := by omega
      exact Or.inr (by simpa [eq] using hx.symm)
  · rintro (⟨i, hi, hx⟩ | hx)
    · exact ⟨i, by omega, hx⟩
    · exact ⟨n+1, Nat.le_refl _, hx.symm⟩

/-- A valid block from an actual state has exactly the actual next states. -/
theorem valid_word_endpoint (a : Nat → Int) (walk : IsWalk a) (n : Nat)
    (w : List Int) (valid : SignedValidWord (stateAt a n) w) :
    execute (stateAt a n) w=stateAt a (n+w.length) := by
  induction w generalizing n with
  | nil => simp [execute]
  | cons v vs ih =>
    have eq := signedGreedy_unique valid.1 (walk.2 n)
    subst v
    rw [execute, ← stateAt_succ]
    have tail := ih (n+1) (by simpa only [stateAt_succ] using valid.2)
    simpa [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using tail

theorem walk_unique (a b : Nat → Int) (ha : IsWalk a) (hb : IsWalk b) : a=b := by
  funext n
  induction n using Nat.strongRecOn with
  | ind n ih =>
    cases n with
    | zero => exact ha.1.trans hb.1.symm
    | succ n =>
      have states : stateAt a n=stateAt b n := by
        apply state_ext (ih n (by omega))
        intro x
        change (∃ i, i ≤ n ∧ a i=x) ↔ (∃ i, i ≤ n ∧ b i=x)
        constructor <;> rintro ⟨i, hi, hx⟩
        · exact ⟨i, hi, by rw [← ih i (by omega)]; exact hx⟩
        · exact ⟨i, hi, by rw [ih i (by omega)]; exact hx⟩
      have step := ha.2 n
      rw [states] at step
      exact signedGreedy_unique step (hb.2 n)

theorem walk_injective (a : Nat → Int) (walk : IsWalk a) {i j : Nat}
    (same : a i=a j) : i=j := by
  by_cases low : i < j
  · cases j with
    | zero => omega
    | succ j => exact False.elim ((walk.2 j).1 ⟨i, by omega, same⟩)
  · by_cases high : j < i
    · cases i with
      | zero => omega
      | succ i => exact False.elim ((walk.2 i).1 ⟨j, by omega, same.symm⟩)
    · omega

end Heraclitus.GlobalWalk
