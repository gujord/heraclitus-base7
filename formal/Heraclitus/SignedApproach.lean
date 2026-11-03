import Heraclitus.ApproachWord
import Heraclitus.ReturnBridge

set_option autoImplicit false

/-! Signed lifting of the complete approach near the outer boundary.
The actual all-step bounds differ from the earlier return band. -/

namespace Heraclitus.SignedApproach
open Outgoing OutgoingWord ReturnBridge

def Bounds (m x : Int) : Prop := 2*m-100 ≤ x ∧ x < 3*m-50

theorem choice (s : FiniteState) (other : RayBoundary) (side : Bool)
    (k : Nat) (C y : Int) (scale : 2*C+1=(7^k : Nat))
    (large : 100000 ≤ (7^k : Nat))
    (xb : Bounds (7^k : Nat) s.current) (yb : Bounds (7^k : Nat) y)
    (filled : 3*(7^k : Nat)-200 ≤ other.front)
    (greedy : Greedy s.toState y) :
    SignedGreedy (liftRay side C other s.toState) (embedRay side C y) := by
  rcases xb with ⟨xl, xu⟩
  rcases yb with ⟨yl, yu⟩
  apply lift_choice s other side k C y scale large (by omega) (by omega) (by omega) greedy
  cases side <;> simp only [CrossWins, Bool.false_eq_true, ite_false, ite_true] <;> omega

def Envelope (m : Int) (s : State) : List Int → Prop
  | [] => True
  | v::vs => Bounds m s.current ∧ Bounds m v ∧ Envelope m (visit s v) vs

theorem envelope_of_bounds (m : Int) (s : State) (w : List Int)
    (current : Bounds m s.current) (choices : ∀ x ∈ w, Bounds m x) : Envelope m s w := by
  induction w generalizing s with
  | nil => trivial
  | cons v vs ih =>
    have vb := choices v (List.mem_cons_self ..)
    exact ⟨current, vb, ih (visit s v) vb (fun x hx => choices x (List.mem_cons_of_mem v hx))⟩

/-- The complete signed word, with every original used point retained. -/
theorem word (s : FiniteState) (other : RayBoundary) (side : Bool)
    (k : Nat) (C : Int) (w : List Int) (scale : 2*C+1=(7^k : Nat))
    (large : 100000 ≤ (7^k : Nat)) (filled : 3*(7^k : Nat)-200 ≤ other.front)
    (valid : ValidWord s.toState w) (envelope : Envelope (7^k : Nat) s.toState w) :
    SignedValidWord (liftRay side C other s.toState) (w.map (embedRay side C)) ∧
    execute (liftRay side C other s.toState) (w.map (embedRay side C)) =
      liftRay side C other (execute s.toState w) := by
  induction w generalizing s with
  | nil => exact ⟨trivial, rfl⟩
  | cons v vs ih =>
    have step := choice s other side k C v scale large envelope.1 envelope.2.1 filled valid.1
    have positive : 0 < C+v := by have h := envelope.2.1.1; omega
    have nextValid : ValidWord (s.addVisit v).toState vs := by
      rw [FiniteState.addVisit_toState]; exact valid.2
    have nextBounds : Envelope (7^k : Nat) (s.addVisit v).toState vs := by
      rw [FiniteState.addVisit_toState]; exact envelope.2.2
    have next := ih (s.addVisit v) nextValid nextBounds
    rw [FiniteState.addVisit_toState, lift_visit _ _ _ _ _ positive] at next
    exact ⟨⟨step, next.1⟩, next.2⟩

def startFinite (r : ApproachWord.Row) (m : Int) : FiniteState :=
  (r.initial.shift (2*m+r.offset)).markPoint (3*m+r.offset)

theorem start_exact (r : ApproachWord.Row) (m : Int) :
    (startFinite r m).toState=r.start m := by
  rw [startFinite, FiniteState.markPoint_toState, FiniteState.shift_toState]
  rfl

/-- Transport a full block across a proved input equality without changing its word. -/
def alignInput {s s' t : State} (b : SignedBlock s t) (same : s=s') : SignedBlock s' t where
  word := b.word
  valid := by rw [← same]; exact b.valid
  endpoint := by rw [← same]; exact b.endpoint

/-- Every certified approach has a complete signed lift at every exponent.
The departed ray is retained verbatim and the affine count is unchanged. -/
theorem all_exponents (c : ApproachWord.Checked) (t : Nat) (C : Int)
    (side : Bool) (other : RayBoundary)
    (scale : 2*C+1=(7^(c.row.exponent t) : Nat))
    (filled : 3*c.row.scale t-200 ≤ other.front) :
    ∃ b : SignedBlock (liftRay side C other (c.row.start (c.row.scale t)))
      (liftRay side C other (c.row.finish (c.row.scale t))),
      b.word=(c.row.word (c.row.scale t)).map (embedRay side C) ∧
      (b.word.length : Int)=c.row.moves (c.row.scale t) := by
  have large : 100000 ≤ (7^(c.row.exponent t) : Nat) := Int.ofNat_le.mp (c.large t)
  obtain ⟨valid, endpoint, count⟩ := c.all_exponents t
  obtain ⟨choices, current⟩ := c.bounds t
  have envelope := envelope_of_bounds (c.row.scale t) (c.row.start (c.row.scale t))
    (c.row.word (c.row.scale t)) current choices
  rw [← start_exact] at valid envelope
  have lifted := word (startFinite c.row (c.row.scale t)) other side
    (c.row.exponent t) C (c.row.word (c.row.scale t)) scale large filled valid envelope
  rw [start_exact, endpoint] at lifted
  exact ⟨⟨_, lifted.1, lifted.2⟩, rfl, by simpa only [List.length_map] using count⟩

end Heraclitus.SignedApproach
