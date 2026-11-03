import Heraclitus.Markers

set_option autoImplicit false

/-!
# Exact signed semantics and history accounting

The half-line order is not the order of the signed walk. This module gives
the latter explicitly, including positive preference at equal magnitude.
All used-set assertions concern physical coordinates. No certificate row,
scale transition, or coverage theorem is postulated.
-/

namespace Heraclitus

/-- Least magnitude, then the larger integer (positive in a nonzero tie). -/
def Preferred (v w : Int) : Prop :=
  v.natAbs < w.natAbs ∨ (v.natAbs = w.natAbs ∧ w ≤ v)

theorem preferred_refl (v : Int) : Preferred v v := by
  exact Or.inr ⟨rfl, Int.le_refl _⟩

theorem preferred_trans {u v w : Int}
    (uv : Preferred u v) (vw : Preferred v w) : Preferred u w := by
  rcases uv with uv | ⟨uv, uv'⟩ <;>
    rcases vw with vw | ⟨vw, vw'⟩
  · left; omega
  · left; omega
  · left; omega
  · right; constructor <;> omega

theorem preferred_antisymm {v w : Int}
    (vw : Preferred v w) (wv : Preferred w v) : v = w := by
  rcases vw with vw | ⟨vw, vw'⟩ <;>
    rcases wv with wv | ⟨wv, wv'⟩ <;> omega

theorem positive_wins_tie (r : Int) (positive : 0 < r) :
    Preferred r (-r) ∧ ¬Preferred (-r) r := by
  constructor
  · exact Or.inr ⟨(Int.natAbs_neg r).symm, by omega⟩
  · intro h
    rcases h with h | ⟨_, h⟩
    · rw [Int.natAbs_neg] at h
      omega
    · omega

def SignedGreedy (s : State) (v : Int) : Prop :=
  ¬s.used v ∧ PowerStep s.current v ∧
    ∀ w, ¬s.used w → PowerStep s.current w → Preferred v w

def signedStart : State := ⟨0, fun x => x = 0⟩

def SignedValidWord (s : State) : List Int → Prop
  | [] => True
  | v :: vs => SignedGreedy s v ∧ SignedValidWord (visit s v) vs

theorem signedGreedy_unique {s : State} {v w : Int}
    (hv : SignedGreedy s v) (hw : SignedGreedy s w) : v = w := by
  exact preferred_antisymm (hv.2.2 w hw.1 hw.2.1) (hw.2.2 v hv.1 hv.2.1)

/-- A finite candidate check excludes ALL larger powers by a proved radius
bound. There is no sampled or assumed exponent cutoff in this theorem. -/
theorem signedGreedy_finite_cutoff (s : State) (v : Int) (J : Nat)
    (unused : ¬s.used v) (step : PowerStep s.current v)
    (cutoff : s.current.natAbs + v.natAbs < 7 ^ J)
    (checked : ∀ j : Nat, j < J → ∀ z : Int,
      (z = s.current + (7 ^ j : Nat) ∨ z = s.current - (7 ^ j : Nat)) →
      ¬s.used z → Preferred v z) : SignedGreedy s v := by
  refine ⟨unused, step, ?_⟩
  intro z zu zs
  obtain ⟨j, distance⟩ := zs
  by_cases small : j < J
  · apply checked j small z
    · rcases Int.natAbs_eq_iff.mp distance with hp | hn
      · left; omega
      · right; omega
    · exact zu
  · have powers : 7 ^ J ≤ 7 ^ j := Nat.pow_le_pow_right (by decide) (by omega)
    have triangle := Int.natAbs_sub_le z s.current
    left
    omega

theorem signedValidWord_append (s : State) (u v : List Int) :
    SignedValidWord s (u ++ v) ↔
      SignedValidWord s u ∧ SignedValidWord (execute s u) v := by
  induction u generalizing s with
  | nil => simp [SignedValidWord, execute]
  | cons x xs ih => simp [SignedValidWord, execute, ih, and_assoc]

/-- Every recorded destination is new, including relative to the initial set. -/
theorem signed_word_fresh {s : State} {w : List Int} (h : SignedValidWord s w) :
    w.Nodup ∧ ∀ x ∈ w, ¬s.used x := by
  induction w generalizing s with
  | nil => simp
  | cons v vs ih =>
    obtain ⟨nd, fresh⟩ := ih h.2
    constructor
    · apply List.nodup_cons.mpr
      refine ⟨?_, nd⟩
      intro hv
      exact fresh v hv (Or.inr rfl)
    · intro x hx
      rcases List.mem_cons.mp hx with rfl | hx
      · exact h.1.1
      · exact fun hu => fresh x hx (Or.inl hu)

/-- Exact set and cardinality witness: markers are not counted as visits.
If `history` lists the initial used set once, `history ++ w` lists the
final set once and has exactly `history.length + w.length` elements.
-/
theorem signed_history_accounting (s : State) (history w : List Int)
    (represents : ∀ x, s.used x ↔ x ∈ history)
    (nodup : history.Nodup) (valid : SignedValidWord s w) :
    (history ++ w).Nodup ∧
      (∀ x, (execute s w).used x ↔ x ∈ history ++ w) ∧
      (history ++ w).length = history.length + w.length := by
  obtain ⟨new_nd, fresh⟩ := signed_word_fresh valid
  refine ⟨?_, ?_, List.length_append⟩
  · apply List.nodup_append.mpr
    refine ⟨nodup, new_nd, ?_⟩
    intro x hx y hy eq
    subst y
    exact fresh x hy ((represents x).mpr hx)
  · intro x
    rw [execute_used_iff, represents, List.mem_append]

/-- A path from the actual initial state has exactly n+1 distinct used points. -/
theorem signed_start_accounting (w : List Int) (valid : SignedValidWord signedStart w) :
    (0 :: w).Nodup ∧
      (∀ x, (execute signedStart w).used x ↔ x ∈ 0 :: w) ∧
      (0 :: w).length = w.length + 1 := by
  have h := signed_history_accounting signedStart [0] w (by simp [signedStart])
    (by simp) valid
  simpa [Nat.add_comm] using h

/-- Independent of normalization: enlarging the used set preserves a winner
provided that the winner itself has not been removed. -/
theorem signedGreedy_mark {s : State} {v : Int} {markers : Int → Prop}
    (h : SignedGreedy s v) (avoid : ¬markers v) :
    SignedGreedy (mark s markers) v := by
  refine ⟨fun hu => hu.elim h.1 avoid, h.2.1, ?_⟩
  intro w hw hs
  exact h.2.2 w (fun hu => hw (Or.inl hu)) hs

end Heraclitus
