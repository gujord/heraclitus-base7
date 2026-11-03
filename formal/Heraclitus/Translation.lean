import Std

set_option autoImplicit false

/-!
# Physical half-line semantics and translation cycles

The order here is the integer order, not the signed walk's absolute-value
order. A filled lower half-line is represented as part of `used`. The
signed/half-line interface and the JSON certificate checks are not formalized.
-/

namespace Heraclitus

structure State where
  current : Int
  used : Int → Prop

theorem state_ext {s t : State} (hc : s.current = t.current)
    (hu : ∀ x, s.used x ↔ t.used x) : s = t := by
  cases s with
  | mk c u =>
    cases t with
    | mk d v =>
      dsimp at hc hu
      have huv : u = v := funext (fun x => propext (hu x))
      cases hc
      cases huv
      rfl

/-- Precisely the allowed distances 7^j, including j = 0. -/
def PowerStep (x y : Int) : Prop := ∃ j : Nat, (y - x).natAbs = 7 ^ j

/-- The least unused half-line neighbor. Existence is not postulated. -/
def Greedy (s : State) (v : Int) : Prop :=
  ¬s.used v ∧ PowerStep s.current v ∧
    ∀ w, ¬s.used w → PowerStep s.current w → v ≤ w

def visit (s : State) (v : Int) : State :=
  ⟨v, fun x => s.used x ∨ x = v⟩

def translate (d : Int) (s : State) : State :=
  ⟨s.current + d, fun x => s.used (x - d)⟩

theorem powerStep_translate (x y d : Int) :
    PowerStep (x + d) (y + d) ↔ PowerStep x y := by
  have h : y + d - (x + d) = y - x := by omega
  simp only [PowerStep, h]

theorem greedy_unique {s : State} {v w : Int}
    (hv : Greedy s v) (hw : Greedy s w) : v = w := by
  exact Int.le_antisymm (hv.2.2 w hw.1 hw.2.1) (hw.2.2 v hv.1 hv.2.1)

theorem greedy_translate {s : State} {v : Int} (d : Int)
    (h : Greedy s v) : Greedy (translate d s) (v + d) := by
  refine ⟨?_, ?_, ?_⟩
  · simpa [translate] using h.1
  · exact (powerStep_translate s.current v d).mpr h.2.1
  · intro w hw hs
    have step : PowerStep s.current (w - d) := by
      apply (powerStep_translate s.current (w - d) d).mp
      simpa [translate] using hs
    have lower := h.2.2 (w - d) hw step
    omega

theorem translate_zero (s : State) : translate 0 s = s := by
  apply state_ext <;> simp [translate]

theorem translate_translate (d e : Int) (s : State) :
    translate d (translate e s) = translate (d + e) s := by
  apply state_ext
  · dsimp [translate]; omega
  · intro x
    have h : x - d - e = x - (d + e) := by omega
    simp only [translate, h]

theorem translate_visit (d : Int) (s : State) (v : Int) :
    translate d (visit s v) = visit (translate d s) (v + d) := by
  apply state_ext
  · rfl
  · intro x
    change (s.used (x - d) ∨ x - d = v) ↔ (s.used (x - d) ∨ x = v + d)
    have h : x - d = v ↔ x = v + d := by omega
    rw [h]

/-- Execution only updates the set. `ValidWord` separately proves legality. -/
def execute (s : State) : List Int → State
  | [] => s
  | v :: vs => execute (visit s v) vs

def ValidWord (s : State) : List Int → Prop
  | [] => True
  | v :: vs => Greedy s v ∧ ValidWord (visit s v) vs

theorem execute_append (s : State) (u v : List Int) :
    execute s (u ++ v) = execute (execute s u) v := by
  induction u generalizing s with
  | nil => rfl
  | cons x xs ih => simpa [execute] using ih (visit s x)

theorem validWord_append (s : State) (u v : List Int) :
    ValidWord s (u ++ v) ↔ ValidWord s u ∧ ValidWord (execute s u) v := by
  induction u generalizing s with
  | nil => simp [ValidWord, execute]
  | cons x xs ih => simp [ValidWord, execute, ih, and_assoc]

theorem execute_translate (d : Int) (s : State) (w : List Int) :
    execute (translate d s) (w.map (fun x => x + d)) = translate d (execute s w) := by
  induction w generalizing s with
  | nil => rfl
  | cons v vs ih =>
    simp only [List.map_cons, execute]
    rw [← translate_visit]
    exact ih (visit s v)

theorem validWord_translate (d : Int) {s : State} {w : List Int}
    (h : ValidWord s w) : ValidWord (translate d s) (w.map (fun x => x + d)) := by
  induction w generalizing s with
  | nil => trivial
  | cons v vs ih =>
    refine ⟨greedy_translate d h.1, ?_⟩
    rw [← translate_visit]
    exact ih h.2

/-- Exactly q consecutive copies, with block r shifted by r*d. -/
def repeatedWord (w : List Int) (d : Int) : Nat → List Int
  | 0 => []
  | q + 1 => repeatedWord w d q ++ w.map (fun x => x + (q : Int) * d)

theorem repeatedWord_length (w : List Int) (d : Int) (q : Nat) :
    (repeatedWord w d q).length = q * w.length := by
  induction q with
  | zero => simp [repeatedWord]
  | succ q ih => simp [repeatedWord, ih, Nat.succ_mul]

/-- A finite full-state return implies valid repetition at every height q. -/
theorem translation_cycle {s : State} {w : List Int} {d : Int}
    (hvalid : ValidWord s w) (hclose : execute s w = translate d s) :
    ∀ q : Nat, ValidWord s (repeatedWord w d q) ∧
      execute s (repeatedWord w d q) = translate ((q : Int) * d) s := by
  intro q
  induction q with
  | zero => simp [repeatedWord, ValidWord, execute, translate_zero]
  | succ q ih =>
    have hd : ((q + 1 : Nat) : Int) * d = (q : Int) * d + d := by
      simp [Int.add_mul]
    constructor
    · apply (validWord_append s _ _).mpr
      refine ⟨ih.1, ?_⟩
      rw [ih.2]
      exact validWord_translate ((q : Int) * d) hvalid
    · change execute s (repeatedWord w d q ++ _) = _
      rw [execute_append, ih.2, execute_translate, hclose, translate_translate, hd]

/-- A finite representation of the entire used/forbidden half-line set. -/
structure LocalState where
  current : Int
  extra : List Int
  positive : ∀ x ∈ extra, 0 < x
  current_used : current < 0 ∨ current ∈ extra

def decode (front : Int) (s : LocalState) : State :=
  ⟨front + s.current, fun x => x < front ∨ x - front ∈ s.extra⟩

theorem decode_front_unused (f : Int) (s : LocalState) : ¬(decode f s).used f := by
  intro h
  rcases h with h | h
  · omega
  · have hp := s.positive 0 (by simpa using h)
    omega

theorem decode_current_used (f : Int) (s : LocalState) :
    (decode f s).used (decode f s).current := by
  rcases s.current_used with h | h
  · left; dsimp [decode]; omega
  · right
    have heq : f + s.current - f = s.current := by omega
    simpa only [decode, heq] using h

theorem decode_translate (d f : Int) (s : LocalState) :
    translate d (decode f s) = decode (f + d) s := by
  apply state_ext
  · dsimp [translate, decode]; omega
  · intro x
    change (x - d < f ∨ x - d - f ∈ s.extra) ↔
      (x < f + d ∨ x - (f + d) ∈ s.extra)
    have h₁ : x - d < f ↔ x < f + d := by omega
    have h₂ : x - d - f = x - (f + d) := by omega
    rw [h₁, h₂]

/-- Paper Section 3: full normalized return with shift equal to word length.
The finite word's validity and closing equality remain explicit hypotheses;
this theorem does not import or certify a JSON file.
-/
theorem normalized_cycle_repeats (s : LocalState) (w : List Int)
    (hvalid : ValidWord (decode 0 s) w)
    (hclose : execute (decode 0 s) w = decode (w.length : Int) s) :
    ∀ q : Nat, ValidWord (decode 0 s) (repeatedWord w (w.length : Int) q) ∧
      execute (decode 0 s) (repeatedWord w (w.length : Int) q) =
        decode ((q : Int) * (w.length : Int)) s := by
  have hc : execute (decode 0 s) w = translate (w.length : Int) (decode 0 s) := by
    simpa [decode_translate] using hclose
  intro q
  simpa [decode_translate] using translation_cycle hvalid hc q

end Heraclitus
