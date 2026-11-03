import Heraclitus.SignedBottom
import Heraclitus.LadderEnvelope

set_option autoImplicit false

/-! Compose the actual phase-to-old-region match with the complete ladder.
The exceptional unused-anchor route stays explicit. These words begin at
the supplied inner boundary, not at the global initial state a(0)=0. -/

namespace Heraclitus.SignedLadder
open OutgoingWord ReturnBridge

/-- Equality of complete checkpoint states, including the old filled prefix. -/
theorem initial_match (e : CertifiedEntrance) (c : LadderEnvelope.Checked)
    (matched : SignedBottom.Match e c.original) (n : Nat) :
    (checkpoint e.outgoing.geometry.other (LadderLayers.scale n) e.data.anchor).toState =
      (c.initial n).toState := by
  apply state_ext
  · change LadderLayers.scale n+e.data.anchor =
      LadderLayers.scale n+c.original.bottom.entrance.entrance.anchor
    rw [matched.2.1]
  · intro x
    rw [checkpoint_used]
    have old := SignedBottom.oldCore_exact e.outgoing.geometry.other e.checked.2.1 x
    rw [matched.2.2] at old
    rw [old, matched.2.1]
    simp [LadderEnvelope.Checked.initial, checkpoint, FiniteState.toState,
      or_assoc, or_left_comm, or_comm]

/-- The whole ladder fills through A+m; its next front remains genuinely
unused even after the two outer markers are restored. -/
theorem ladder_checkpoint (c : LadderEnvelope.Checked) (n : Nat) :
    (∀ x, x ≤ c.original.bottom.entrance.entrance.anchor+LadderLayers.scale n →
      (c.output n).used x) ∧
    ¬(c.output n).used (c.original.bottom.entrance.entrance.anchor+LadderLayers.scale n+
      (c.original.bottom.ladder.ladder.entry n).front) := by
  have base := c.original.bottom.ladder.ladder.checkpoint c.original.bottom.ladder.checked n
    (c.original.bottom.entrance.entrance.anchor+LadderLayers.scale n)
  constructor
  · intro x hx
    exact Or.inl (base.1 x hx)
  · intro used
    rcases used with used | marker
    · exact base.2 used
    · have front := (c.bounded (c.original.bottom.ladder.ladder.orbit n)).1
      have size := LadderLayers.scale_large n
      change (c.original.bottom.ladder.ladder.entry n).front ≤ 2000 at front
      rcases marker with eq | eq <;> omega

/-- The route is part of the mathematical input, with proof of its match. -/
inductive Route (e : CertifiedEntrance) where
  | ladder (c : LadderEnvelope.Checked) (matched : SignedBottom.Match e c.original)
  | short (matched : SignedBottom.ShortMatch e)

def Route.endpoint {e : CertifiedEntrance} (r : Route e) (n : Nat) : State :=
  match r with
  | .ladder c _ => c.output n
  | .short _ => (SignedBottom.shortEnd (LadderLayers.scale n)).toState

def Route.moves {e : CertifiedEntrance} (r : Route e) (n : Nat) : Int :=
  match r with
  | .ladder c _ => c.moves n
  | .short _ => 2

def Route.isLadder {e : CertifiedEntrance} (r : Route e) : Bool :=
  match r with
  | .ladder _ _ => true
  | .short _ => false

theorem Route.branch_agrees {e : CertifiedEntrance} (r : Route e) :
    r.isLadder = e.data.anchorUsed := by
  cases r with
  | ladder c matched => exact matched.1.symm
  | short matched => exact matched.1.symm

/-- The whole checkpoint-to-ladder-end word, or the two-move short route.
Every old-region, marker and opposite-ray state is preserved exactly. -/
theorem Route.signed_path {e : CertifiedEntrance} (r : Route e)
    (n : Nat) (height : 2 ≤ n) (C : Int) (far : RayBoundary)
    (radius : 2*C+1 = LadderLayers.scale n)
    (filled : 3*LadderLayers.scale n-200 ≤ far.front) :
    ∃ b : SignedBlock
      (liftRay (!e.outgoing.row.positive) C far
        (checkpoint e.outgoing.geometry.other (LadderLayers.scale n) e.data.anchor).toState)
      (liftRay (!e.outgoing.row.positive) C far (r.endpoint n)),
      (b.word.length : Int) = r.moves n := by
  cases r with
  | ladder c matched =>
    obtain ⟨w, valid, endpoint, count⟩ := c.signed_all_heights n (!e.outgoing.row.positive)
      C far radius (LadderEnvelope.scale_sufficient n height) filled
    rw [initial_match e c matched n]
    exact ⟨⟨w, valid, endpoint⟩, count⟩
  | short matched =>
    obtain ⟨b, count⟩ := SignedBottom.short_signed e matched (4+n) C far
      radius (LadderEnvelope.scale_sufficient n height) filled
    exact ⟨b, by change (b.word.length : Int)=2; omega⟩

structure Phase where
  entrance : CertifiedEntrance
  route : Route entrance

def Phase.exponent (c : Phase) (t : Nat) : Nat :=
  c.entrance.outgoing.row.leastExponent+36*t

def Phase.endpoint (c : Phase) (t : Nat) : State :=
  c.route.endpoint (c.exponent t-4)

/-- Word length from the specified inner boundary; not an index from zero. -/
def Phase.moves (c : Phase) (t q : Nat) : Int :=
  (c.entrance.outgoing.inner.moves.length+q*c.entrance.outgoing.row.phases.size+
    c.entrance.outgoing.row.selected.val+3 : Nat) + c.route.moves (c.exponent t-4)

/-- Retain the exact outgoing cycle-index relation for later count assembly. -/
def Phase.CycleIndex (c : Phase) (t q : Nat) : Prop :=
  ∃ d : Int, 0 ≤ d ∧ (q : Int) = c.entrance.outgoing.row.winningCycle+3*d ∧
    (7^(c.exponent t) : Nat) =
      c.entrance.outgoing.row.scale+c.entrance.outgoing.row.model.period*d

theorem Phase.height (c : Phase) (t : Nat) : 2 ≤ c.exponent t-4 ∧
    LadderLayers.scale (c.exponent t-4) = (7^(c.exponent t) : Nat) := by
  have lower := c.entrance.outgoing.arithmetic.2.2.2.2.2.2.2.2.1
  have large : 6 ≤ c.exponent t := by dsimp [Phase.exponent]; omega
  refine ⟨by omega, ?_⟩
  change ((7^(4+(c.exponent t-4)) : Nat) : Int)=(7^(c.exponent t) : Nat)
  rw [show 4+(c.exponent t-4)=c.exponent t by omega]

/-- One exact signed word through outgoing/crossing/return entrance and the
complete ladder (or the explicit short branch) at every phase exponent. -/
theorem Phase.all_exponents (c : Phase) (t : Nat) (C : Int)
    (radius : 2*C+1 = (7^(c.exponent t) : Nat)) :
    ∃ q : Nat, ∃ b : SignedBlock (c.entrance.outgoing.inner.initial.toState C)
      (liftRay (!c.entrance.outgoing.row.positive) C (farBoundary c.entrance.outgoing q)
        (c.endpoint t)),
      (b.word.length : Int) = c.moves t q ∧
      3*(7^(c.exponent t) : Nat)-200 ≤ (farBoundary c.entrance.outgoing q).front ∧
      c.CycleIndex t q := by
  obtain ⟨q, first, firstLen, filled, index⟩ := c.entrance.all_exponents t C radius
  have height := c.height t
  have tail := c.route.signed_path (c.exponent t-4) height.1 C
    (farBoundary c.entrance.outgoing q) (by rw [height.2]; exact radius)
    (by rw [height.2]; exact filled)
  rw [height.2] at tail
  obtain ⟨last, lastLen⟩ := tail
  refine ⟨q, first.then last, ?_, filled, index⟩
  change ((first.word ++ last.word).length : Int) = _
  rw [List.length_append, Int.natCast_add, firstLen, lastLen]
  rfl

end Heraclitus.SignedLadder
