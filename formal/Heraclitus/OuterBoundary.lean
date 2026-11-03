import Heraclitus.SignedApproach
import Heraclitus.SignedLadder
import Heraclitus.BoundaryCounting

set_option autoImplicit false

/-! Exact change of centre after the signed approach. Both rays and every
premarked point are retained. No reachability from zero is assumed. -/

namespace Heraclitus.OuterBoundary
open OutgoingWord ReturnBridge SignedCertificate

def shiftBoundary (d : Int) (b : RayBoundary) : RayBoundary :=
  ⟨b.front+d, b.extra.map (fun x => x+d)⟩

theorem shiftBoundary_used (d : Int) (b : RayBoundary) (x : Int) :
    boundaryUsed (shiftBoundary d b) x ↔ boundaryUsed b (x-d) := by
  change (x<b.front+d ∨ x ∈ b.extra.map (fun z => z+d)) ↔ (x-d<b.front ∨ x-d ∈ b.extra)
  have below : x<b.front+d ↔ x-d<b.front := by omega
  rw [below, List.mem_map]
  constructor
  · rintro (h | ⟨z, hz, eq⟩)
    · exact Or.inl h
    · have same : x-d=z := by omega
      exact Or.inr (same ▸ hz)
  · rintro (h | hz)
    · exact Or.inl h
    · exact Or.inr ⟨x-d, hz, by omega⟩

theorem recenter (s : State) (other : RayBoundary) (side : Bool) (C d : Int) :
    liftRay side C (shiftBoundary d other) (translate d s) =
      liftRay side (C+d) other s := by
  apply state_ext
  · change embedRay side C (s.current+d)=embedRay side (C+d) s.current
    have eq : C+(s.current+d)=(C+d)+s.current := by omega
    unfold embedRay
    rw [eq]
  · intro z
    have hp : z-C-d=z-(C+d) := by omega
    have hn : -z-C-d= -z-(C+d) := by omega
    cases side <;> simp only [liftRay, translate, Bool.false_eq_true, ite_false, ite_true,
      shiftBoundary_used, hp, hn]

def farOffset (a : OutgoingWord.CertifiedRow) : Int :=
  a.row.winningCycle*a.row.model.period-3*a.row.scale

def normalizedFar (a : OutgoingWord.CertifiedRow) : RayBoundary :=
  let s := a.cycle.states a.row.selected.val
  ⟨s.front+farOffset a, s.points.map (fun x => x+farOffset a)⟩

theorem far_exact (p : SignedLadder.Phase) (t q : Nat) (index : p.CycleIndex t q) :
    farBoundary p.entrance.outgoing q =
      shiftBoundary (3*(7^(p.exponent t) : Nat)) (normalizedFar p.entrance.outgoing) := by
  obtain ⟨d, _nonnegative, count, scale⟩ := index
  have delta := displacement p.entrance.outgoing (p.exponent t) d q scale count
  change (q : Int)*p.entrance.outgoing.row.model.period-3*(7^(p.exponent t) : Nat) =
    farOffset p.entrance.outgoing at delta
  let a := p.entrance.outgoing
  let s := a.cycle.states a.row.selected.val
  change (q : Int)*a.row.model.period-3*((7^(p.exponent t) : Nat) : Int)=farOffset a at delta
  have shift : (q : Int)*a.row.model.period=farOffset a+3*((7^(p.exponent t) : Nat) : Int) := by omega
  have front : s.front+(q : Int)*a.row.model.period =
      (s.front+farOffset a)+3*((7^(p.exponent t) : Nat) : Int) := by rw [shift]; omega
  have points : s.points.map (fun x => x+(q : Int)*a.row.model.period) =
      (s.points.map (fun x => x+farOffset a)).map (fun x => x+3*((7^(p.exponent t) : Nat) : Int)) := by
    rw [List.map_map, shift]
    apply List.map_congr_left
    intro x _hx
    dsimp
    omega
  change RayBoundary.mk (s.front+(q : Int)*a.row.model.period)
    (s.points.map (fun x => x+(q : Int)*a.row.model.period)) =
      RayBoundary.mk ((s.front+farOffset a)+3*((7^(p.exponent t) : Nat) : Int))
        ((s.points.map (fun x => x+farOffset a)).map (fun x => x+3*((7^(p.exponent t) : Nat) : Int)))
  rw [front, points]

theorem finish_recenter (r : ApproachWord.Row) (m : Int) :
    r.finish m=translate (3*m) (r.output.markPoint r.offset).toState := by
  rw [FiniteState.markPoint_toState]
  apply state_ext
  · rfl
  · intro x
    change (r.output.toState.used (x-3*m) ∨ x=3*m+r.offset) ↔
      (r.output.toState.used (x-3*m) ∨ x-3*m=r.offset)
    have same : x=3*m+r.offset ↔ x-3*m=r.offset := by omega
    rw [same]

def normalized (p : SignedLadder.Phase) (r : ApproachWord.Row) : Record :=
  record (!p.entrance.outgoing.row.positive) (normalizedFar p.entrance.outgoing)
    (r.output.markPoint r.offset)

theorem normalized_exact (p : SignedLadder.Phase) (r : ApproachWord.Row)
    (t q : Nat) (C : Int) (exponent : r.exponent t=p.exponent t)
    (index : p.CycleIndex t q) :
    liftRay (!p.entrance.outgoing.row.positive) C (farBoundary p.entrance.outgoing q)
      (r.finish (r.scale t)) = (normalized p r).toState (C+3*r.scale t) := by
  have scale : r.scale t=(7^(p.exponent t) : Nat) := by unfold ApproachWord.Row.scale; rw [exponent]
  rw [finish_recenter, far_exact p t q index, ← scale, recenter]
  exact (record_lift _ _ _ _).symm

theorem next_radius (k : Nat) (C : Int) (scale : 2*C+1=(7^k : Nat)) :
    2*(C+3*(7^k : Nat))+1=(7^(k+1) : Nat) := by
  rw [Nat.pow_succ, Int.natCast_mul]
  omega

theorem next_large (k : Nat) (large : 100000 ≤ (7^k : Nat)) :
    100000 ≤ (7^(k+1) : Nat) := by
  have h := Nat.pow_le_pow_right (n := 7) (by decide) (show k ≤ k+1 by omega)
  omega

structure Link where
  phase : SignedLadder.Phase
  approach : ApproachWord.Checked
  outer : CheckedBoundary
  following : Record

def Link.Claim (c : Link) : Prop :=
  c.approach.row.leastExponent=c.phase.entrance.outgoing.row.leastExponent ∧
  c.outer.label=c.approach.row.label ∧ c.outer.outer=true ∧
  (normalized c.phase c.approach.row).equalityCheck c.outer.initial=true ∧
  c.outer.final.equalityCheck c.following=true ∧
  -36 ≤ c.phase.entrance.outgoing.inner.initial.pos.front ∧
  -36 ≤ c.phase.entrance.outgoing.inner.initial.neg.front

instance (c : Link) : Decidable c.Claim := by unfold Link.Claim; infer_instance

structure Checked where
  link : Link
  checked : link.Claim

theorem Checked.exponent (c : Checked) (t : Nat) :
    c.link.approach.row.exponent t=c.link.phase.exponent t := by
  unfold ApproachWord.Row.exponent SignedLadder.Phase.exponent
  rw [c.checked.1]

theorem Checked.input_all (c : Checked) (t q : Nat) (C : Int)
    (index : c.link.phase.CycleIndex t q) :
    liftRay (!c.link.phase.entrance.outgoing.row.positive) C
      (farBoundary c.link.phase.entrance.outgoing q)
      (c.link.approach.row.finish (c.link.approach.row.scale t)) =
        c.link.outer.initial.toState (C+3*c.link.approach.row.scale t) := by
  exact (normalized_exact _ _ t q C (c.exponent t) index).trans
    (Record.equalityCheck_sound _ _ c.checked.2.2.2.1 _)

theorem Checked.closure (c : Checked) (D : Int) :
    c.link.outer.final.toState D=c.link.following.toState D :=
  Record.equalityCheck_sound _ _ c.checked.2.2.2.2.1 D

def Checked.block (c : Checked) (t : Nat) (C : Int)
    (radius : 2*C+1=(7^(c.link.approach.row.exponent t) : Nat)) :
    SignedBlock (c.link.outer.initial.toState (C+3*c.link.approach.row.scale t))
      (c.link.following.toState (C+3*c.link.approach.row.scale t)) :=
  let b := c.link.outer.atScale (c.link.approach.row.exponent t+1)
    (C+3*c.link.approach.row.scale t) (next_radius _ C radius)
    (next_large _ (Int.ofNat_le.mp (c.link.approach.large t)))
  ⟨b.word, b.valid, b.endpoint.trans (c.closure _)⟩

theorem Checked.block_length (c : Checked) (t : Nat) (C : Int)
    (radius : 2*C+1=(7^(c.link.approach.row.exponent t) : Nat)) :
    (c.block t C radius).word.length=c.link.outer.moves.length := by
  exact List.length_map _

theorem Checked.inner_filled (c : Checked) (C x : Int)
    (low : -C+37 ≤ x) (high : x ≤ C-37) :
    (c.link.phase.entrance.outgoing.inner.initial.toState C).used x := by
  have pos := c.checked.2.2.2.2.2.1
  have neg := c.checked.2.2.2.2.2.2
  by_cases zero : x=0
  · exact Or.inl zero
  · by_cases positive : 0<x
    · exact Or.inr (Or.inl ⟨positive, Or.inl (by omega)⟩)
    · exact Or.inr (Or.inr ⟨by omega, Or.inl (by omega)⟩)

def alignOutput {s t t' : State} (b : SignedBlock s t) (same : t=t') : SignedBlock s t' where
  word := b.word
  valid := b.valid
  endpoint := b.endpoint.trans same

/-- A complete transition with whole-set counting premises. Reachability from
zero remains a separate base and induction obligation. -/
structure Transition where
  checked : Checked
  inputProper : BoundaryCounting.Proper checked.link.phase.entrance.outgoing.inner.initial
  outputProper : BoundaryCounting.Proper checked.link.following
  path : ∀ (t : Nat) (C : Int),
    2*C+1=(7^(checked.link.approach.row.exponent t) : Nat) →
    Nonempty (SignedBlock (checked.link.phase.entrance.outgoing.inner.initial.toState C)
      (checked.link.following.toState (C+3*checked.link.approach.row.scale t)))

theorem Transition.exact (c : Transition) (t : Nat) (C : Int)
    (radius : 2*C+1=(7^(c.checked.link.approach.row.exponent t) : Nat)) :
    ∃ b : SignedBlock (c.checked.link.phase.entrance.outgoing.inner.initial.toState C)
      (c.checked.link.following.toState (C+3*c.checked.link.approach.row.scale t)),
      b.word.length=6*7^(c.checked.link.approach.row.exponent t) := by
  obtain ⟨b⟩ := c.path t C radius
  exact ⟨b, BoundaryCounting.scale_block_length _ _ c.inputProper c.outputProper _ C
    radius (Int.ofNat_le.mp (c.checked.link.approach.large t)) b⟩

end Heraclitus.OuterBoundary
