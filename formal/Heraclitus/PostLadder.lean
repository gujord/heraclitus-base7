import Heraclitus.SignedLadder
import Heraclitus.SignedTransfer

set_option autoImplicit false

/-! Concrete whole-state and residue matching from the complete ladder to
the next outer-marker transfer. Phase 43 has a separate earlier route. -/

namespace Heraclitus.PostLadder
open SignedLadder OutgoingWord ReturnBridge

/-- Equality of phase indices propagates under the deterministic next map. -/
theorem orbit_add_congr (c : LadderLayers.Ladder) {a b : Nat}
    (same : c.orbit a = c.orbit b) (r : Nat) : c.orbit (a+r) = c.orbit (b+r) := by
  induction r with
  | zero => simpa only [Nat.add_zero] using same
  | succ r ih =>
    change c.next (c.orbit (a+r)) = c.next (c.orbit (b+r))
    rw [ih]

/-- A checked return of the phase index proves all repetitions, not just
equality of two sampled physical states. -/
theorem orbit_progression (c : LadderLayers.Ladder) (n p : Nat)
    (closes : c.orbit (n+p) = c.orbit n) (t : Nat) :
    c.orbit (n+p*t) = c.orbit n := by
  induction t with
  | zero => simp only [Nat.mul_zero, Nat.add_zero]
  | succ t ih =>
    rw [Nat.mul_succ, ← Nat.add_assoc]
    exact (orbit_add_congr c ih p).trans closes

structure Input where
  before : Phase
  ladder : LadderEnvelope.Checked
  matched : SignedBottom.Match before.entrance ladder.original
  route_eq : before.route = .ladder ladder matched
  transfer : SignedTransfer.Checked

def Input.baseHeight (c : Input) : Nat := c.before.entrance.outgoing.row.leastExponent-4

/-- A finite phase-index return, complete input equality, and independent
modular checks at the least admissible exponent. -/
def Input.Claim (c : Input) : Prop :=
  c.ladder.original.bottom.ladder.ladder.orbit (c.baseHeight+36) =
    c.ladder.original.bottom.ladder.ladder.orbit c.baseHeight ∧
  TransferCertificate.sameState (c.ladder.original.bottom.ladder.ladder.entry c.baseHeight)
    c.transfer.original.transfer.initial = true ∧
  7^36 % c.transfer.original.transfer.modulus = 1 % c.transfer.original.transfer.modulus ∧
  ((7^c.before.entrance.outgoing.row.leastExponent : Nat) : Int) %
    c.transfer.original.transfer.modulus = c.transfer.original.transfer.residue

instance (c : Input) : Decidable c.Claim := by
  unfold Input.Claim
  infer_instance

structure Checked where
  input : Input
  checked : input.Claim

theorem Input.height_index (c : Input) (t : Nat) :
    c.before.exponent t-4 = c.baseHeight+36*t := by
  have low := c.before.entrance.outgoing.arithmetic.2.2.2.2.2.2.2.2.1
  dsimp [Phase.exponent, Input.baseHeight]
  omega

theorem Checked.entry_all (c : Checked) (t : Nat) :
    (c.input.ladder.original.bottom.ladder.ladder.entry (c.input.before.exponent t-4)).toState =
      c.input.transfer.original.transfer.initial.toState := by
  rw [c.input.height_index]
  have phase := orbit_progression c.input.ladder.original.bottom.ladder.ladder
    c.input.baseHeight 36 c.checked.1 t
  unfold LadderLayers.Ladder.entry
  rw [phase]
  exact TransferCertificate.sameState_sound c.checked.2.1

theorem Checked.residue_all (c : Checked) (t : Nat) :
    ((7^(c.input.before.exponent t) : Nat) : Int) % c.input.transfer.original.transfer.modulus =
      c.input.transfer.original.transfer.residue := by
  have periodic := FirstCrossing.exponent_residue c.input.transfer.original.transfer.modulus
    c.input.before.entrance.outgoing.row.leastExponent t c.checked.2.2.1
  have lifted := congrArg (fun x : Nat => (x : Int)) periodic
  exact lifted.trans c.checked.2.2.2

theorem marked_input (s : TransferCertificate.Transfer) (m A : Int) :
    mark (translate (A+m) s.initial.toState) (LadderEnvelope.outer A m) =
      ((SignedTransfer.start s m [2*m]).shift (m+A)).toState := by
  rw [FiniteState.shift_toState, SignedTransfer.start_eq]
  apply state_ext
  · change s.initial.current+(A+m)=s.initial.current+(m+A)
    omega
  · intro x
    change (s.initial.toState.used (x-(A+m)) ∨ x=A+2*m ∨ x=A+3*m) ↔
      (s.initial.toState.used (x-(m+A)) ∨ x-(m+A)=m ∨ x-(m+A) ∈ [2*m])
    rw [show A+m=m+A by omega, List.mem_singleton]
    have two : x=A+2*m ↔ x-(m+A)=m := by omega
    have three : x=A+3*m ↔ x-(m+A)=2*m := by omega
    rw [two, three]

/-- Exact whole-state bridge at every exponent; no sampled-state premise. -/
theorem Checked.input_all (c : Checked) (t : Nat) :
    c.input.before.endpoint t =
      ((SignedTransfer.start c.input.transfer.original.transfer
        (7^(c.input.before.exponent t) : Nat) [2*(7^(c.input.before.exponent t) : Nat)]).shift
          ((7^(c.input.before.exponent t) : Nat)+c.input.before.entrance.data.anchor)).toState := by
  unfold Phase.endpoint
  rw [c.input.route_eq]
  change c.input.ladder.output (c.input.before.exponent t-4) = _
  unfold LadderEnvelope.Checked.output
  rw [c.entry_all, (c.input.before.height t).2, c.input.matched.2.1]
  exact marked_input _ _ _

def Input.endpoint (c : Input) (t : Nat) : State :=
  mark (translate (2*(7^(c.before.exponent t) : Nat)+c.before.entrance.data.anchor)
    c.transfer.original.transfer.output.toState)
    (fun x => x=3*(7^(c.before.exponent t) : Nat)+c.before.entrance.data.anchor)

def Input.transferMoves (c : Input) (r : Nat) : Nat :=
  c.transfer.original.transfer.transient.edges.length+c.transfer.original.transfer.modulus*r+
    c.transfer.original.transfer.phase+c.transfer.original.transfer.repair.edges.length

theorem Input.endpoint_used (c : Input) (t : Nat) (x : Int) :
    (c.endpoint t).used x ↔ c.transfer.original.transfer.output.toState.used
      (x-(2*(7^(c.before.exponent t) : Nat)+c.before.entrance.data.anchor)) ∨
      x=3*(7^(c.before.exponent t) : Nat)+c.before.entrance.data.anchor := Iff.rfl

theorem Input.retains_last (c : Input) (t : Nat) :
    (c.endpoint t).used (3*(7^(c.before.exponent t) : Nat)+c.before.entrance.data.anchor) :=
  Or.inr rfl

/-- Compose from the supplied initial inner boundary through the transfer
at 2m+A, retaining the complete departed ray and final marker at 3m+A. -/
theorem Checked.all_exponents (c : Checked) (t : Nat) (C : Int)
    (radius : 2*C+1=(7^(c.input.before.exponent t) : Nat)) :
    ∃ q r : Nat, ∃ b : SignedBlock (c.input.before.entrance.outgoing.inner.initial.toState C)
      (liftRay (!c.input.before.entrance.outgoing.row.positive) C
        (farBoundary c.input.before.entrance.outgoing q) (c.input.endpoint t)),
      (b.word.length : Int) = c.input.before.moves t q+c.input.transferMoves r ∧
      (7^(c.input.before.exponent t) : Nat) = c.input.transfer.original.transfer.target+
        (r : Int)*c.input.transfer.original.transfer.modulus ∧
      3*(7^(c.input.before.exponent t) : Nat)-200 ≤
        (farBoundary c.input.before.entrance.outgoing q).front ∧
      c.input.before.CycleIndex t q := by
  obtain ⟨q, first, firstLen, filled, cycle⟩ := c.input.before.all_exponents t C radius
  have low : 6 ≤ c.input.before.exponent t := by
    have h := (c.input.before.height t).1
    omega
  have large : 100000 ≤ (7^(c.input.before.exponent t) : Nat) := by
    have h := Nat.pow_le_pow_right (n := 7) (by decide) low
    have value : (7^6 : Nat)=117649 := by decide
    omega
  have tail := c.input.transfer.after_ladder (c.input.before.exponent t) C
    c.input.before.entrance.data.anchor (!c.input.before.entrance.outgoing.row.positive)
    (farBoundary c.input.before.entrance.outgoing q) radius large
    c.input.before.entrance.checked.1 (c.residue_all t) filled
  rw [← c.input_all t] at tail
  obtain ⟨r, last, spacing, lastLen⟩ := tail
  refine ⟨q, r, first.then last, ?_, spacing, filled, cycle⟩
  change ((first.word ++ last.word).length : Int) = _
  rw [List.length_append, Int.natCast_add, firstLen, lastLen]
  rfl

end Heraclitus.PostLadder
