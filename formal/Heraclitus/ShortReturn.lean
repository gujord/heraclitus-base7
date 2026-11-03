import Heraclitus.SignedLadder
import Heraclitus.SignedTransfer

set_option autoImplicit false

/-! The unused-anchor return has two concrete marker transfers. Their
whole-state matches, residues and counts are part of the checked contract. -/

namespace Heraclitus.ShortReturn
open TransferCertificate SignedTransfer OutgoingWord ReturnBridge

def FirstShape (t : Transfer) : Prop :=
  sameState t.initial ⟨-1, 1, []⟩ = true ∧
  sameState t.output ⟨1, 2, []⟩ = true ∧
  t.modulus=8 ∧ t.residue=7 ∧ t.target=7 ∧
  t.transient.edges.length=0 ∧ t.phase=7 ∧ t.repair.edges.length=0

def SecondShape (t : Transfer) : Prop :=
  sameState t.initial ⟨1, 2, []⟩ = true ∧
  sameState t.output ⟨-1, 1, []⟩ = true ∧
  t.modulus=1 ∧ t.residue=0 ∧ t.target=2 ∧
  t.transient.edges.length=0 ∧ t.phase=0 ∧ t.repair.edges.length=0

instance (t : Transfer) : Decidable (FirstShape t) := by unfold FirstShape; infer_instance
instance (t : Transfer) : Decidable (SecondShape t) := by unfold SecondShape; infer_instance

structure Chain where
  first : SignedTransfer.Checked
  second : SignedTransfer.Checked
  firstShape : FirstShape first.original.transfer
  secondShape : SecondShape second.original.transfer

def middle (m : Int) : FiniteState := ⟨m+3, m+4, [2*m+2, 3*m+2]⟩
def finalState (m : Int) : FiniteState := ⟨2*m+1, 2*m+3, [3*m+2]⟩

theorem Chain.first_input (c : Chain) (m : Int) :
    ((start c.first.original.transfer m [2*m, 3*m]).shift 2).toState =
      (SignedBottom.shortEnd m).toState := by
  rw [FiniteState.shift_toState, start_eq, sameState_sound c.firstShape.1]
  apply state_ext
  · rfl
  · intro x
    simp only [translate, mark, FiniteState.toState, SignedBottom.shortEnd,
      List.mem_cons, List.not_mem_nil, or_false]
    omega

theorem Chain.first_output (c : Chain) (m : Int) :
    translate 2 (endpoint c.first.original.transfer m [2*m, 3*m]) = (middle m).toState := by
  unfold endpoint
  rw [sameState_sound c.firstShape.2.1]
  apply state_ext
  · change 1+m+2=m+3; omega
  · intro x
    simp only [translate, mark, FiniteState.toState, middle,
      List.mem_cons, List.not_mem_nil, or_false]
    omega

theorem Chain.second_input (c : Chain) (m : Int) :
    ((start c.second.original.transfer m [2*m]).shift (m+2)).toState = (middle m).toState := by
  rw [FiniteState.shift_toState, start_eq, sameState_sound c.secondShape.1]
  apply state_ext
  · change 1+(m+2)=m+3; omega
  · intro x
    simp only [translate, mark, FiniteState.toState, middle,
      List.mem_cons, List.not_mem_nil, or_false]
    omega

theorem Chain.second_output (c : Chain) (m : Int) :
    mark (translate (2*m+2) c.second.original.transfer.output.toState) (fun x => x=3*m+2) =
      (finalState m).toState := by
  rw [sameState_sound c.secondShape.2.1]
  apply state_ext
  · change -1+(2*m+2)=2*m+1; omega
  · intro x
    simp only [translate, mark, FiniteState.toState, finalState,
      List.mem_cons, List.not_mem_nil, or_false]
    omega

/-- Both transfers as actual signed words, with no unproved input-state match. -/
theorem Chain.signed (c : Chain) (k : Nat) (C : Int) (side : Bool) (other : RayBoundary)
    (radius : 2*C+1=(7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (residue : ((7^k : Nat) : Int)%8=7)
    (filled : 3*(7^k : Nat)-200 ≤ other.front) :
    ∃ b : SignedBlock (liftRay side C other (SignedBottom.shortEnd (7^k : Nat)).toState)
      (liftRay side C other (finalState (7^k : Nat)).toState),
      (b.word.length : Int)=2*(7^k : Nat)-2 := by
  let m : Int := (7^k : Nat)
  have big : 100000 ≤ m := Int.ofNat_le.mpr large
  have first := c.first.signed k C 2 m [2*m, 3*m] side other radius large
    (by omega) (by rw [c.firstShape.2.2.1, c.firstShape.2.2.2.1]; exact residue)
    (by intro x hx; simp only [List.mem_cons, List.not_mem_nil, or_false] at hx; omega)
    (by decide) (by change 2+m ≤ 2*m+3; omega) filled
  rw [c.first_input m, c.first_output m] at first
  obtain ⟨q1, b1, spacing1, count1⟩ := first
  have second := c.second.after_ladder k C 2 side other radius large (by decide)
    (by rw [c.secondShape.2.2.1, c.secondShape.2.2.2.1]; exact Int.emod_one _) filled
  change ∃ q2 : Nat, ∃ b2 : SignedBlock
      (liftRay side C other ((start c.second.original.transfer m [2*m]).shift (m+2)).toState)
      (liftRay side C other (mark (translate (2*m+2) c.second.original.transfer.output.toState)
        (fun x => x=3*m+2))), m=c.second.original.transfer.target+(q2 : Int)*c.second.original.transfer.modulus ∧
      b2.word.length=c.second.original.transfer.transient.edges.length+c.second.original.transfer.modulus*q2+
        c.second.original.transfer.phase+c.second.original.transfer.repair.edges.length at second
  rw [c.second_input m, c.second_output m] at second
  obtain ⟨q2, b2, spacing2, count2⟩ := second
  rcases c.firstShape with ⟨_, _, mod1, _, target1, pre1, phase1, repair1⟩
  rcases c.secondShape with ⟨_, _, mod2, _, target2, pre2, phase2, repair2⟩
  rw [mod1, target1] at spacing1
  rw [mod2, target2] at spacing2
  rw [mod1, pre1, phase1, repair1] at count1
  rw [mod2, pre2, phase2, repair2] at count2
  refine ⟨b1.then b2, ?_⟩
  change (((b1.word ++ b2.word).length : Nat) : Int)=2*m-2
  rw [List.length_append, Int.natCast_add, count1, count2]
  omega

theorem final_used (m x : Int) : (finalState m).toState.used x ↔ x<2*m+3 ∨ x=3*m+2 := by
  simp only [finalState, FiniteState.toState, List.mem_singleton]

theorem final_checkpoint (m : Int) (large : 100000 ≤ m) :
    (∀ x, x ≤ 2*m+2 → (finalState m).toState.used x) ∧
      ¬(finalState m).toState.used (2*m+3) ∧ (finalState m).toState.used (3*m+2) := by
  constructor
  · intro x hx; rw [final_used]; left; omega
  · rw [final_used, final_used]; omega

theorem short_phase_endpoint (p : SignedLadder.Phase) (short : p.route.isLadder=false) (t : Nat) :
    p.endpoint t=(SignedBottom.shortEnd (7^(p.exponent t) : Nat)).toState := by
  have height := (p.height t).2
  cases eq : p.route with
  | ladder c matched => simp [eq, SignedLadder.Route.isLadder] at short
  | short matched =>
    change (p.route.endpoint (p.exponent t-4))=_
    rw [eq]
    change (SignedBottom.shortEnd (LadderLayers.scale (p.exponent t-4))).toState=_
    rw [height]

theorem Chain.all_exponents (c : Chain) (p : SignedLadder.Phase)
    (short : p.route.isLadder=false) (t : Nat) (C : Int)
    (radius : 2*C+1=(7^(p.exponent t) : Nat))
    (residue : ((7^(p.exponent t) : Nat) : Int)%8=7) :
    ∃ q : Nat, ∃ b : SignedBlock (p.entrance.outgoing.inner.initial.toState C)
      (liftRay (!p.entrance.outgoing.row.positive) C (farBoundary p.entrance.outgoing q)
        (finalState (7^(p.exponent t) : Nat)).toState),
      (b.word.length : Int)=p.moves t q+2*(7^(p.exponent t) : Nat)-2 ∧
      3*(7^(p.exponent t) : Nat)-200 ≤ (farBoundary p.entrance.outgoing q).front ∧ p.CycleIndex t q := by
  have entry := p.all_exponents t C radius
  rw [short_phase_endpoint p short t] at entry
  obtain ⟨q, first, count, filled, index⟩ := entry
  have large : 100000 ≤ (7^(p.exponent t) : Nat) := by
    have lower := (p.height t).1
    have bound := Nat.pow_le_pow_right (n := 7) (by decide) (show 6 ≤ p.exponent t by omega)
    have value : (7^6 : Nat)=117649 := by decide
    omega
  obtain ⟨last, len⟩ := c.signed (p.exponent t) C (!p.entrance.outgoing.row.positive)
    (farBoundary p.entrance.outgoing q) radius large residue filled
  refine ⟨q, first.then last, ?_, filled, index⟩
  change (((first.word ++ last.word).length : Nat) : Int)=_
  rw [List.length_append, Int.natCast_add, count, len]
  omega

end Heraclitus.ShortReturn
