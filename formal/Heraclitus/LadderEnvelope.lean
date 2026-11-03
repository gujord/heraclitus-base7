import Heraclitus.LadderBottom
import Heraclitus.ReturnBridge

set_option autoImplicit false

/-! Bounds for the complete ladder word follow from its complete used-set
endpoint. This retains distant markers and discharges the signed return
envelope; identification of the crossing cases is a separate obligation. -/

namespace Heraclitus.LadderEnvelope

open LadderLayers LadderDescent LadderBottom Outgoing OutgoingWord

/-- The front alone does not bound the explicitly listed used points. -/
def OutputBound (s : FiniteState) (H : Int) : Prop :=
  s.front ≤ H ∧ ∀ x ∈ s.points, x < H

instance (s : FiniteState) (H : Int) : Decidable (OutputBound s H) :=
  inferInstanceAs (Decidable (s.front ≤ H ∧ ∀ x ∈ s.points, x < H))

theorem outputBound_sound {s : FiniteState} {H x : Int}
    (bound : OutputBound s H) (used : s.toState.used x) : x < H := by
  rcases used with below | point
  · have front := bound.1; omega
  · exact bound.2 x point

def Bounded (c : Bottom) : Prop :=
  ∀ i : Fin c.ladder.ladder.size,
    OutputBound (c.ladder.ladder.row i).entrance 2000

instance (c : Bottom) : Decidable (Bounded c) :=
  inferInstanceAs (Decidable (∀ i : Fin c.ladder.ladder.size,
    OutputBound (c.ladder.ladder.row i).entrance 2000))

structure Checked where
  original : CheckedBottom
  bounded : Bounded original.bottom

def Checked.initial (c : Checked) (n : Nat) : FiniteState :=
  ReturnBridge.checkpoint ⟨-100, c.original.bottom.entrance.entrance.points⟩
    (scale n) c.original.bottom.entrance.entrance.anchor

def outer (A m x : Int) : Prop := x = A+2*m ∨ x = A+3*m

def Checked.output (c : Checked) (n : Nat) : State :=
  mark (translate (c.original.bottom.entrance.entrance.anchor+scale n)
    (c.original.bottom.ladder.ladder.entry n).toState)
    (outer c.original.bottom.entrance.entrance.anchor (scale n))

def Checked.moves (c : Checked) (n : Nat) : Int :=
  6*(n : Int) + c.original.bottom.moves + scale n - 2401 +
    c.original.bottom.ladder.ladder.cumulative 0 n

/-- Every choice remains in the final used set, including intermediate peaks. -/
theorem word_upper_of_endpoint (s t : State) (w : List Int) (H : Int)
    (endpoint : execute s w = t) (bound : ∀ x, t.used x → x < H) :
    ∀ x ∈ w, x < H := by
  intro x hx
  apply bound x
  rw [← endpoint]
  exact (execute_used_iff s w x).mpr (Or.inr hx)

theorem word_lower_of_valid (s : State) (w : List Int) (lo : Int)
    (filled : ∀ x, x < lo → s.used x) (valid : ValidWord s w) :
    ∀ x ∈ w, lo ≤ x := by
  induction w generalizing s with
  | nil => simp
  | cons v vs ih =>
    have lower : lo ≤ v := by
      by_cases h : lo ≤ v
      · exact h
      · exact False.elim (valid.1.1 (filled v (by omega)))
    intro x hx
    rcases List.mem_cons.mp hx with eq | rest
    · simpa only [eq] using lower
    · exact ih (visit s v) (fun y hy => Or.inl (filled y hy)) valid.2 x rest

theorem envelope_of_choices (s : State) (w : List Int) (m : Int)
    (current : -100 ≤ s.current ∧ s.current ≤ 2*m+4096)
    (choices : ∀ x ∈ w, -100 ≤ x ∧ x ≤ 2*m+4096) :
    ReturnBridge.Envelope m s w := by
  induction w generalizing s with
  | nil => trivial
  | cons v vs ih =>
    have hv := choices v (by simp)
    refine ⟨current, hv, ih (visit s v) hv ?_⟩
    intro x hx
    exact choices x (by simp [hx])

/-- All heights; arbitrary sufficiently distant markers survive every layer. -/
theorem Checked.with_later (c : Checked) (n : Nat) (later : Int → Prop)
    (far : ∀ x, later x →
      c.original.bottom.entrance.entrance.anchor+scale n+2000 ≤ x) :
    ∃ w : List Int,
      ValidWord (mark (c.original.bottom.entrance.entrance.initial n) later) w ∧
      execute (mark (c.original.bottom.entrance.entrance.initial n) later) w =
        mark (translate (c.original.bottom.entrance.entrance.anchor+scale n)
          (c.original.bottom.ladder.ladder.entry n).toState) later ∧
      (w.length : Int) = c.moves n ∧
      (∀ x ∈ w, -100 ≤ x ∧
        x < c.original.bottom.entrance.entrance.anchor+scale n+2000) ∧
      ReturnBridge.Envelope (scale n)
        (mark (c.original.bottom.entrance.entrance.initial n) later) w := by
  obtain ⟨w, valid, endpoint, count⟩ :=
    c.original.bottom.all_heights c.original.checked n
  have upper := word_upper_of_endpoint _ _ w
    (c.original.bottom.entrance.entrance.anchor+scale n+2000) endpoint (by
      intro x hx
      change (c.original.bottom.ladder.ladder.entry n).toState.used
        (x-(c.original.bottom.entrance.entrance.anchor+scale n)) at hx
      have h := outputBound_sound
        (c.bounded (c.original.bottom.ladder.ladder.orbit n)) hx
      omega)
  have lower := word_lower_of_valid _ w (-100)
    (fun _ hx => Or.inl (Or.inl hx)) valid
  have marked : ValidWord
      (mark (c.original.bottom.entrance.entrance.initial n) later) w := by
    apply validWord_mark valid
    intro x hx hl
    have hi := upper x hx
    have farx := far x hl
    omega
  have anchor := c.original.bottom.entrance.checked
  have size := scale_large n
  refine ⟨w, marked, ?_, count, ?_, ?_⟩
  · rw [execute_mark, endpoint]
  · intro x hx; exact ⟨lower x hx, upper x hx⟩
  · apply envelope_of_choices
    · change -100 ≤ c.original.bottom.entrance.entrance.anchor+scale n ∧
        c.original.bottom.entrance.entrance.anchor+scale n ≤ 2*scale n+4096
      have a := anchor.1
      have b := anchor.2.1
      omega
    · intro x hx
      have hi := upper x hx
      have b := anchor.2.1
      exact ⟨lower x hx, by omega⟩

theorem outer_far (A : Int) (n : Nat) :
    ∀ x, outer A (scale n) x → A+scale n+2000 ≤ x := by
  intro x hx
  have large := scale_large n
  rcases hx with eq | eq <;> omega

theorem Checked.initial_eq (c : Checked) (n : Nat) :
    (c.initial n).toState =
      mark (c.original.bottom.entrance.entrance.initial n)
        (outer c.original.bottom.entrance.entrance.anchor (scale n)) := by
  apply state_ext
  · change scale n+c.original.bottom.entrance.entrance.anchor =
      c.original.bottom.entrance.entrance.anchor+scale n
    omega
  · intro x
    simp [Checked.initial, ReturnBridge.checkpoint, FiniteState.toState,
      mark, Entrance.initial, outer, Int.add_comm, or_assoc, or_left_comm, or_comm]

/-- Complete descent, bottom and all layers with both outer markers retained. -/
theorem Checked.halfline_all_heights (c : Checked) (n : Nat) :
    ∃ w : List Int,
      ValidWord (c.initial n).toState w ∧
      execute (c.initial n).toState w = c.output n ∧
      (w.length : Int) = c.moves n ∧
      ReturnBridge.Envelope (scale n) (c.initial n).toState w := by
  obtain ⟨w, valid, endpoint, count, _, envelope⟩ :=
    c.with_later n (outer c.original.bottom.entrance.entrance.anchor (scale n))
      (outer_far _ n)
  rw [← c.initial_eq n] at valid endpoint envelope
  exact ⟨w, valid, endpoint, count, envelope⟩

/-- Either signed ray, with no assumed word-validity or word-envelope premise.
The opposite ray must satisfy the explicit filled-prefix hypothesis. -/
theorem Checked.signed_all_heights (c : Checked) (n : Nat) (side : Bool)
    (C : Int) (other : RayBoundary)
    (radius : 2*C+1 = scale n) (large : 100000 ≤ (7^(4+n) : Nat))
    (filled : 3*scale n-200 ≤ other.front) :
    ∃ w : List Int,
      SignedValidWord (liftRay side C other (c.initial n).toState) w ∧
      execute (liftRay side C other (c.initial n).toState) w =
        liftRay side C other (c.output n) ∧
      (w.length : Int) = c.moves n := by
  obtain ⟨w, valid, endpoint, count, envelope⟩ := c.halfline_all_heights n
  have lifted := ReturnBridge.return_word (c.initial n) other side (4+n) C w
    radius large filled valid envelope
  refine ⟨w.map (embedRay side C), lifted.1, ?_, ?_⟩
  · rw [lifted.2, endpoint]
  · simpa only [List.length_map] using count

theorem scale_sufficient (n : Nat) (height : 2 ≤ n) :
    100000 ≤ (7^(4+n) : Nat) := by
  have bound := Nat.pow_le_pow_right (n := 7) (by decide) (show 6 ≤ 4+n by omega)
  have exactValue : (7^6 : Nat) = 117649 := by decide
  rw [exactValue] at bound
  omega

end Heraclitus.LadderEnvelope
