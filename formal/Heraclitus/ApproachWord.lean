import Heraclitus.LadderEnvelope
import Heraclitus.FirstCrossing

set_option autoImplicit false

/-! Complete half-line approach words. Existing checked transfer routes
provide only the transient and cycle; their marker repair is not used.
The quotient, complete endpoint, retained outer marker and word bounds
are proved here. Signed lifting and reachability are separate obligations. -/

namespace Heraclitus.ApproachWord
open TransferCertificate

structure Row where
  label : Nat
  leastExponent : Nat
  offset : Int
  front : Int
  original : CheckedTransfer
  initial : FiniteState
  output : FiniteState

def Row.exponent (r : Row) (t : Nat) : Nat := r.leastExponent+36*t
def Row.scale (r : Row) (t : Nat) : Int := (7^(r.exponent t) : Nat)
def Row.quotient (r : Row) (m : Int) : Nat :=
  ((m-r.offset-256-r.original.transfer.entryFront)/r.original.transfer.modulus).toNat
def Row.localWord (r : Row) (q : Nat) : List Int :=
  r.original.transfer.transient.word r.original.transfer.initialFront ++
    repeatedWord (r.original.transfer.cycle.word r.original.transfer.entryFront)
      r.original.transfer.modulus q
def Row.word (r : Row) (m : Int) : List Int :=
  (r.localWord (r.quotient m)).map (fun x => x+(2*m+r.offset))
def Row.start (r : Row) (m : Int) : State :=
  mark (translate (2*m+r.offset) r.initial.toState) (fun x => x=3*m+r.offset)
def Row.finish (r : Row) (m : Int) : State :=
  mark (translate (3*m) r.output.toState) (fun x => x=3*m+r.offset)
def Row.moves (r : Row) (m : Int) : Int :=
  r.original.transfer.transient.edges.length+m-r.offset+r.front-r.original.transfer.entryFront

def Row.Claim (r : Row) : Prop :=
  6 ≤ r.leastExponent ∧ 0 < r.original.transfer.modulus ∧
  7^36 % r.original.transfer.modulus = 1 % r.original.transfer.modulus ∧
  ((7^r.leastExponent : Nat)-r.offset-256-r.original.transfer.entryFront) %
    r.original.transfer.modulus = -256-r.front ∧
  r.offset+256+r.original.transfer.entryFront ≤ 100000 ∧
  sameState r.original.transfer.initial r.initial = true ∧
  sameState (r.original.transfer.cycle.initial.at r.front) r.output = true ∧
  LadderEnvelope.OutputBound r.output (-50) ∧ r.output.current < -50 ∧
  -3 ≤ r.offset ∧ -100 ≤ r.initial.front+r.offset ∧
  -100 ≤ r.initial.current+r.offset ∧ r.initial.current+r.offset ≤ 4096

instance (r : Row) : Decidable r.Claim := by unfold Row.Claim; infer_instance

structure Checked where
  row : Row
  checked : row.Claim

theorem Checked.large (c : Checked) (t : Nat) : 100000 ≤ c.row.scale t := by
  have h := Nat.pow_le_pow_right (n := 7) (by decide)
    (show 6 ≤ c.row.exponent t by have h := c.checked.1; unfold Row.exponent; omega)
  have value : (7^6 : Nat)=117649 := by decide
  have lifted := Int.ofNat_le.mpr h
  change 100000 ≤ ((7^(c.row.exponent t) : Nat) : Int)
  rw [value] at lifted
  omega

theorem Checked.remainder (c : Checked) (t : Nat) :
    (c.row.scale t-c.row.offset-256-c.row.original.transfer.entryFront) %
      c.row.original.transfer.modulus = -256-c.row.front := by
  have periodic := FirstCrossing.exponent_residue c.row.original.transfer.modulus
    c.row.leastExponent t c.checked.2.2.1
  have lifted := congrArg (fun n : Nat => (n : Int)) periodic
  have h := c.checked.2.2.2.1
  change c.row.scale t % c.row.original.transfer.modulus =
    ((7^c.row.leastExponent : Nat) : Int) % c.row.original.transfer.modulus at lifted
  have first := (Int.emod_sub_cancel_right c.row.offset).mpr lifted
  have second := (Int.emod_sub_cancel_right 256).mpr first
  exact ((Int.emod_sub_cancel_right c.row.original.transfer.entryFront).mpr second).trans h

/-- The natural repetition count is the nonnegative Euclidean quotient. -/
theorem Checked.floor_law (c : Checked) (t : Nat) :
    (c.row.quotient (c.row.scale t) : Int) =
      (c.row.scale t-c.row.offset-256-c.row.original.transfer.entryFront) /
        c.row.original.transfer.modulus ∧
    c.row.original.transfer.entryFront+
      (c.row.quotient (c.row.scale t) : Int)*c.row.original.transfer.modulus =
        c.row.scale t-c.row.offset+c.row.front := by
  have large := c.large t
  have bound := c.checked.2.2.2.2.1
  have nonnegative : 0 ≤ c.row.scale t-c.row.offset-256-c.row.original.transfer.entryFront := by omega
  have qnonnegative := Int.ediv_nonneg nonnegative
    (show (0 : Int) ≤ c.row.original.transfer.modulus by omega)
  have q : (c.row.quotient (c.row.scale t) : Int) =
      (c.row.scale t-c.row.offset-256-c.row.original.transfer.entryFront) /
        c.row.original.transfer.modulus := Int.toNat_of_nonneg qnonnegative
  refine ⟨q, ?_⟩
  have division := Int.emod_add_ediv_mul
    (c.row.scale t-c.row.offset-256-c.row.original.transfer.entryFront)
    c.row.original.transfer.modulus
  rw [c.remainder t, ← q] at division
  omega

theorem Checked.local_sound (c : Checked) (q : Nat) :
    ValidWord c.row.initial.toState (c.row.localWord q) ∧
    execute c.row.initial.toState (c.row.localWord q) =
      translate ((q : Int)*c.row.original.transfer.modulus)
        c.row.original.transfer.entry.toState := by
  let s := c.row.original.transfer
  have pre := s.transient.sound s.initialFront
  have cyc := s.cycle.sound s.entryFront
  have preEnd : execute s.initial.toState (s.transient.word s.initialFront) = s.entry.toState := by
    simpa only [s, Transfer.initial, Transfer.entry, Transfer.entryFront, c.row.original.checked.1]
      using pre.2
  have closes : execute s.entry.toState (s.cycle.word s.entryFront) =
      translate s.modulus s.entry.toState := by
    simpa only [s, Transfer.entry, Node.at_state, c.row.original.checked.2.2.1,
      c.row.original.checked.2.2.2.1, translate_translate,
      Int.add_comm c.row.original.transfer.entryFront (c.row.original.transfer.modulus : Int)] using cyc.2
  have repeated := translation_cycle cyc.1 closes q
  have same := sameState_sound c.checked.2.2.2.2.2.1
  rw [← same]
  refine ⟨(validWord_append _ _ _).mpr ⟨pre.1, ?_⟩, ?_⟩
  · rw [preEnd]; exact repeated.1
  · change execute s.initial.toState (_ ++ _) = _
    rw [execute_append, preEnd]
    exact repeated.2

theorem Checked.unmarked (c : Checked) (t : Nat) :
    ValidWord (translate (2*c.row.scale t+c.row.offset) c.row.initial.toState)
      (c.row.word (c.row.scale t)) ∧
    execute (translate (2*c.row.scale t+c.row.offset) c.row.initial.toState)
      (c.row.word (c.row.scale t)) = translate (3*c.row.scale t) c.row.output.toState := by
  have unmarked := c.local_sound (c.row.quotient (c.row.scale t))
  refine ⟨validWord_translate _ unmarked.1, ?_⟩
  unfold Row.word
  rw [execute_translate, unmarked.2]
  have output := sameState_sound c.checked.2.2.2.2.2.2.1
  rw [← output, Transfer.entry, Node.at_state, Node.at_state,
    translate_translate, translate_translate, translate_translate]
  congr 1
  have floor := (c.floor_law t).2
  omega

theorem Checked.bounds (c : Checked) (t : Nat) :
    (∀ x ∈ c.row.word (c.row.scale t),
      2*c.row.scale t-100 ≤ x ∧ x < 3*c.row.scale t-50) ∧
    2*c.row.scale t-100 ≤ (c.row.start (c.row.scale t)).current ∧
    (c.row.start (c.row.scale t)).current < 3*c.row.scale t-50 := by
  have sound := c.unmarked t
  have upper := LadderEnvelope.word_upper_of_endpoint _ _ _ (3*c.row.scale t-50) sound.2 (by
    intro x hx
    have bound := LadderEnvelope.outputBound_sound c.checked.2.2.2.2.2.2.2.1 hx
    omega)
  have lower := LadderEnvelope.word_lower_of_valid
    (translate (2*c.row.scale t+c.row.offset) c.row.initial.toState)
    (c.row.word (c.row.scale t)) (2*c.row.scale t-100) (by
      intro x hx
      apply Or.inl
      change x-(2*c.row.scale t+c.row.offset) < c.row.initial.front
      have bound := c.checked.2.2.2.2.2.2.2.2.2.2.1
      omega) sound.1
  refine ⟨fun x hx => ⟨lower x hx, upper x hx⟩, ?_, ?_⟩
  · change 2*c.row.scale t-100 ≤ c.row.initial.current+(2*c.row.scale t+c.row.offset)
    have h := c.checked.2.2.2.2.2.2.2.2.2.2.2.1
    omega
  · change c.row.initial.current+(2*c.row.scale t+c.row.offset) < 3*c.row.scale t-50
    have h := c.checked.2.2.2.2.2.2.2.2.2.2.2.2
    have large := c.large t
    omega

theorem Checked.word_length (c : Checked) (t : Nat) :
    ((c.row.word (c.row.scale t)).length : Int) = c.row.moves (c.row.scale t) := by
  unfold Row.word Row.localWord
  rw [List.length_map, List.length_append, repeatedWord_length]
  simp only [Route.word, TransferCertificate.word_length,
    c.row.original.checked.2.2.2.2.1, Int.natCast_add, Int.natCast_mul]
  have floor := (c.floor_law t).2
  unfold Row.moves
  omega

/-- Complete marked word, exact physical endpoint and exact move count. -/
theorem Checked.all_exponents (c : Checked) (t : Nat) :
    ValidWord (c.row.start (c.row.scale t)) (c.row.word (c.row.scale t)) ∧
    execute (c.row.start (c.row.scale t)) (c.row.word (c.row.scale t)) =
      c.row.finish (c.row.scale t) ∧
    ((c.row.word (c.row.scale t)).length : Int) = c.row.moves (c.row.scale t) := by
  have sound := c.unmarked t
  have bounds := (c.bounds t).1
  refine ⟨validWord_mark sound.1 ?_, ?_, c.word_length t⟩
  · intro x hx marker
    have bound := (bounds x hx).2
    have offset := c.checked.2.2.2.2.2.2.2.2.2.1
    omega
  · unfold Row.start Row.finish
    rw [execute_mark, sound.2]

theorem Row.finish_used (r : Row) (m x : Int) :
    (r.finish m).used x ↔ x-3*m < r.output.front ∨
      x-3*m ∈ r.output.points ∨ x=3*m+r.offset := by
  change ((x-3*m < r.output.front ∨ x-3*m ∈ r.output.points) ∨ x=3*m+r.offset) ↔ _
  exact or_assoc

theorem Row.retains_last (r : Row) (m : Int) : (r.finish m).used (3*m+r.offset) := Or.inr rfl

end Heraclitus.ApproachWord
