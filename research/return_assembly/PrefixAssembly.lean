import Heraclitus.Refinement
import Heraclitus.GlobalWalk
set_option autoImplicit false

/-! General all-prefix composition for physical states and elapsed time.
This does not instantiate any 3/8-specific bound. -/
namespace Heraclitus.ReturnPrefix

/-- P receives the global index and complete physical state. -/
def All (P : Nat → State → Prop) (base : Nat) (s : State) (w : List Int) : Prop :=
  ∀ i, i ≤ w.length → P (base + i) (execute s (w.take i))

theorem append (P : Nat → State → Prop) (base : Nat) (s : State)
    (u v : List Int) (h₁ : All P base s u)
    (h₂ : All P (base + u.length) (execute s u) v) :
    All P base s (u ++ v) := by
  intro i hi
  by_cases le : i ≤ u.length
  · rw [List.take_append_of_le_length le]
    exact h₁ i le
  · have length_le : u.length ≤ i := by omega
    have rem_le : i - u.length ≤ v.length := by simp only [List.length_append] at hi; omega
    rw [List.take_append, List.take_of_length_le length_le, execute_append]
    have result := h₂ (i-u.length) rem_le
    have eq : base + u.length + (i-u.length) = base+i := by omega
    rw [eq] at result
    exact result

/-- Exact endpoint equality closes the seam between concrete signed blocks. -/
theorem blocks (P : Nat → State → Prop) (base : Nat) {s t z : State}
    (first : SignedBlock s t) (second : SignedBlock t z)
    (h₁ : All P base s first.word)
    (h₂ : All P (base + first.word.length) t second.word) :
    All P base s (first.then second).word := by
  apply append P base s first.word second.word h₁
  rw [first.endpoint]
  exact h₂

/-- A property of all block prefixes transfers to the actual greedy walk,
provided its complete starting state and signed validity match. -/
theorem actual_walk (P : Nat → State → Prop) (a : Nat → Int)
    (walk : GlobalWalk.IsWalk a) (base : Nat) (w : List Int)
    (valid : SignedValidWord (GlobalWalk.stateAt a base) w)
    (all : All P base (GlobalWalk.stateAt a base) w) :
    ∀ i, i ≤ w.length → P (base+i) (GlobalWalk.stateAt a (base+i)) := by
  intro i hi
  have pv : SignedValidWord (GlobalWalk.stateAt a base) (w.take i) := by
    have v : SignedValidWord (GlobalWalk.stateAt a base) (w.take i ++ w.drop i) := by
      simpa only [List.take_append_drop] using valid
    exact ((signedValidWord_append _ _ _).mp v).1
  have endeq := GlobalWalk.valid_word_endpoint a walk base (w.take i) pv
  have len : (w.take i).length=i := by simp [List.length_take, Nat.min_eq_left hi]
  rw [len] at endeq
  have hp := all i hi
  rw [endeq] at hp
  exact hp

/-- Signed greedy words of the same length from the same complete state are
identical. This permits matching a prefix-annotated constructed witness with
another witness without assuming their hidden words are definitionally equal. -/
theorem valid_words_unique (s : State) (u v : List Int)
    (hu : SignedValidWord s u) (hv : SignedValidWord s v)
    (length : u.length = v.length) : u = v := by
  induction u generalizing s v with
  | nil =>
    cases v with
    | nil => rfl
    | cons x xs => simp at length
  | cons x xs ih =>
    cases v with
    | nil => simp at length
    | cons y ys =>
      have same : x = y := signedGreedy_unique hu.1 hv.1
      subst y
      congr 1
      exact ih (visit s x) ys hu.2 hv.2 (by simpa using length)

end Heraclitus.ReturnPrefix

#print axioms Heraclitus.ReturnPrefix.append
#print axioms Heraclitus.ReturnPrefix.blocks

#print axioms Heraclitus.ReturnPrefix.actual_walk

#print axioms Heraclitus.ReturnPrefix.valid_words_unique
