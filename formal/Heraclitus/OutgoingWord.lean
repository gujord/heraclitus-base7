import Heraclitus.Outgoing
import Heraclitus.SignedCertificate

set_option autoImplicit false

/-! Exact outgoing word semantics. Finite cycle checks supply the full
half-line state at every phase; induction preserves the physical used set.
This is a segment theorem, not the complete signed scale induction. -/

namespace Heraclitus.OutgoingWord
open Outgoing

def liftRay (side : Bool) (C : Int) (other : RayBoundary) (s : State) : State :=
  ⟨embedRay side C s.current, fun z => z = 0 ∨
    (0 < z ∧ (if side then s.used (z-C) else boundaryUsed other (z-C))) ∨
    (z < 0 ∧ (if side then boundaryUsed other (-z-C) else s.used (-z-C)))⟩

theorem lift_visit (side : Bool) (C : Int) (other : RayBoundary)
    (s : State) (v : Int) (vp : 0 < C+v) :
    liftRay side C other (visit s v) = visit (liftRay side C other s) (embedRay side C v) := by
  apply state_ext
  · rfl
  · intro z
    cases side
    · change (z = 0 ∨ (0 < z ∧ boundaryUsed other (z-C)) ∨
        (z < 0 ∧ (s.used (-z-C) ∨ -z-C = v))) ↔
        (z = 0 ∨ (0 < z ∧ boundaryUsed other (z-C)) ∨ (z < 0 ∧ s.used (-z-C))) ∨
          z = -(C+v)
      by_cases eq : z = -(C+v)
      · subst z
        have coord : C+v-C = v := by omega
        simp [vp, coord]
      · have coord : -z-C ≠ v := by omega
        simp [eq, coord]
    · change (z = 0 ∨ (0 < z ∧ (s.used (z-C) ∨ z-C = v)) ∨
        (z < 0 ∧ boundaryUsed other (-z-C))) ↔
        (z = 0 ∨ (0 < z ∧ s.used (z-C)) ∨ (z < 0 ∧ boundaryUsed other (-z-C))) ∨
          z = C+v
      by_cases eq : z = C+v
      · subst z
        have coord : C+v-C = v := by omega
        simp [vp, coord]
      · have coord : z-C ≠ v := by omega
        simp [eq, coord]

def record (side : Bool) (other : RayBoundary) (s : FiniteState) : SignedCertificate.Record :=
  ⟨side, s.current, if side then ⟨s.front, s.points⟩ else other,
    if side then other else ⟨s.front, s.points⟩⟩

theorem record_lift (side : Bool) (C : Int) (other : RayBoundary) (s : FiniteState) :
    (record side other s).toState C = liftRay side C other s.toState := by
  cases side <;> rfl

structure CycleData (r : FirstCrossing.Row) where
  states : Nat → FiniteState
  choices : Nat → Int
  lo : Int
  hi : Int

def CycleData.Checked {r : FirstCrossing.Row} (c : CycleData r) : Prop :=
  (∀ i : Fin r.phases.size,
    (c.states i.val).current = r.front + r.model.current i ∧
    c.choices i.val = r.front + r.model.choice i ∧
    (c.states i.val).edgeCheck (c.choices i.val) = true ∧
    ((c.states i.val).addVisit (c.choices i.val)).equalityCheck (c.states (i.val+1)) c.lo c.hi = true) ∧
  (c.states r.phases.size).equalityCheck ((c.states 0).shift r.model.period) c.lo c.hi = true

instance {r : FirstCrossing.Row} (c : CycleData r) : Decidable c.Checked := by
  unfold CycleData.Checked
  infer_instance

def CycleData.half {r : FirstCrossing.Row} (c : CycleData r) (q : Nat) (i : Nat) : State :=
  translate ((q : Int) * r.model.period) (c.states i).toState

def CycleData.frame {r : FirstCrossing.Row} (c : CycleData r)
    (g : GeometryData r) (C : Int) (q i : Nat) : State :=
  liftRay r.positive C g.other (c.half q i)

theorem half_current {r : FirstCrossing.Row} (c : CycleData r) (hc : c.Checked)
    (q : Nat) (i : Fin r.phases.size) :
    (c.half q i.val).current = cycleCurrent r q i := by
  have h := (hc.1 i).1
  simp only [CycleData.half, translate, FiniteState.toState, cycleCurrent]
  omega

theorem half_greedy {r : FirstCrossing.Row} (c : CycleData r) (hc : c.Checked)
    (q : Nat) (i : Fin r.phases.size) :
    Greedy (c.half q i.val) (cycleChoice r q i) := by
  have h := greedy_translate ((q : Int)*r.model.period)
    (FiniteState.edgeCheck_sound (hc.1 i).2.2.1)
  have eq : c.choices i.val + (q : Int)*r.model.period = cycleChoice r q i := by
    have h := (hc.1 i).2.1
    unfold cycleChoice
    omega
  rw [eq] at h
  exact h

theorem half_next {r : FirstCrossing.Row} (c : CycleData r) (hc : c.Checked)
    (q : Nat) (i : Fin r.phases.size) :
    c.half q (i.val+1) = visit (c.half q i.val) (cycleChoice r q i) := by
  have eq := FiniteState.equalityCheck_sound (hc.1 i).2.2.2
  rw [FiniteState.addVisit_toState] at eq
  have choice : c.choices i.val + (q : Int)*r.model.period = cycleChoice r q i := by
    have h := (hc.1 i).2.1
    unfold cycleChoice
    omega
  unfold CycleData.half
  rw [← eq, translate_visit, choice]

theorem frame_close {r : FirstCrossing.Row} (c : CycleData r) (hc : c.Checked)
    (g : GeometryData r) (C : Int) (q : Nat) :
    c.frame g C q r.phases.size = c.frame g C (q+1) 0 := by
  have eq := FiniteState.equalityCheck_sound hc.2
  rw [FiniteState.shift_toState] at eq
  unfold CycleData.frame CycleData.half
  rw [eq, translate_translate]
  congr 2
  simp [Int.add_mul]

theorem frame_record {r : FirstCrossing.Row} (c : CycleData r)
    (g : GeometryData r) (C : Int) (q i : Nat) :
    c.frame g C q i = (record r.positive g.other
      ((c.states i).shift ((q : Int)*r.model.period))).toState C := by
  rw [record_lift, FiniteState.shift_toState]
  rfl

theorem frame_step {r : FirstCrossing.Row} (c : CycleData r) (g : GeometryData r)
    (hr : r.Checked) (hc : c.Checked) (hg : g.Checked) (k : Nat) (C d : Int)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (shift : (7^k : Nat) = r.scale+r.model.period*d)
    (q : Nat) (i : Fin r.phases.size)
    (earlier : FirstCrossing.Before q i (r.winningCycle+3*d) r.selected) :
    SignedGreedy (c.frame g C q i.val) (embedRay r.positive C (cycleChoice r q i)) ∧
    c.frame g C q (i.val+1) = visit (c.frame g C q i.val)
      (embedRay r.positive C (cycleChoice r q i)) := by
  let s := (c.states i.val).shift ((q : Int)*r.model.period)
  let b := record r.positive g.other s
  have cur : s.current = cycleCurrent r q i := half_current c hc q i
  have active : halfBoundary (if r.positive then b.pos else b.neg) (cycleCurrent r q i) =
      c.half q i.val := by
    unfold CycleData.half
    rw [← FiniteState.shift_toState]
    change halfBoundary (if r.positive then b.pos else b.neg) (cycleCurrent r q i) = s.toState
    rw [← cur]
    cases h : r.positive <;> simp [b, record, h, halfBoundary, FiniteState.toState] <;> rfl
  have other : otherBoundary r.positive b.pos b.neg = g.other := by
    cases h : r.positive <;> simp [b, record, otherBoundary, h]
  have physical : signedBoundary C b.pos b.neg r.positive (cycleCurrent r q i) =
      c.frame g C q i.val := by
    rw [frame_record, ← cur]
    rfl
  constructor
  · rw [← physical]
    apply before_first_choice g hr hg k C b.pos b.neg d q i scale large (by omega) shift other earlier
    rw [active]
    exact half_greedy c hc q i
  · have last : (q : Int) ≤ r.winningCycle+3*d := by unfold FirstCrossing.Before at earlier; omega
    have bound := (cycle_geometry g hr hg d q i (by omega) last).2.1.1
    have positive : 0 < C+cycleChoice r q i := by omega
    unfold CycleData.frame
    rw [half_next c hc, lift_visit _ _ _ _ _ positive]

/-- A bounded prefix, with its exact entire endpoint state and step count. -/
theorem phase_prefix {r : FirstCrossing.Row} (c : CycleData r) (g : GeometryData r)
    (hr : r.Checked) (hc : c.Checked) (hg : g.Checked) (k : Nat) (C d : Int)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (shift : (7^k : Nat) = r.scale+r.model.period*d) (q count : Nat)
    (bound : count ≤ r.phases.size)
    (earlier : ∀ i : Fin r.phases.size, i.val < count →
      FirstCrossing.Before q i (r.winningCycle+3*d) r.selected) :
    ∃ b : SignedBlock (c.frame g C q 0) (c.frame g C q count), b.word.length = count := by
  induction count with
  | zero => exact ⟨⟨[], True.intro, rfl⟩, rfl⟩
  | succ n ih =>
    obtain ⟨b, len⟩ := ih (by omega) (fun i h => earlier i (by omega))
    let i : Fin r.phases.size := ⟨n, by omega⟩
    have step := frame_step c g hr hc hg k C d scale large shift q i (earlier i (by dsimp [i]; omega))
    let last : SignedBlock (c.frame g C q n) (c.frame g C q (n+1)) :=
      ⟨[embedRay r.positive C (cycleChoice r q i)], ⟨step.1, True.intro⟩, step.2.symm⟩
    refine ⟨b.then last, ?_⟩
    change (b.word ++ last.word).length = n+1
    simp [len, last]

/-- Arbitrarily many complete outgoing cycles before the first crossing. -/
theorem complete_cycles {r : FirstCrossing.Row} (c : CycleData r) (g : GeometryData r)
    (hr : r.Checked) (hc : c.Checked) (hg : g.Checked) (k : Nat) (C d : Int)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (shift : (7^k : Nat) = r.scale+r.model.period*d) (q : Nat)
    (bound : (q : Int) ≤ r.winningCycle+3*d) :
    ∃ b : SignedBlock (c.frame g C 0 0) (c.frame g C q 0),
      b.word.length = q*r.phases.size := by
  induction q with
  | zero => exact ⟨⟨[], True.intro, rfl⟩, by simp⟩
  | succ q ih =>
    obtain ⟨b, len⟩ := ih (by omega)
    obtain ⟨next, nlen⟩ := phase_prefix c g hr hc hg k C d scale large shift q r.phases.size
      (Nat.le_refl _) (fun _ _ => Or.inl (by omega))
    have close := frame_close c hc g C q
    let last : SignedBlock (c.frame g C q 0) (c.frame g C (q+1) 0) :=
      ⟨next.word, next.valid, next.endpoint.trans close⟩
    refine ⟨b.then last, ?_⟩
    change (b.word ++ next.word).length = (q+1)*r.phases.size
    rw [List.length_append, len, nlen, Nat.add_mul, Nat.one_mul]

def crossing {r : FirstCrossing.Row} (k : Nat) (C : Int) (q : Nat) : Int :=
  embedRay (!r.positive) C (6*(7^k : Nat)+1-cycleCurrent r q r.selected)

theorem crossing_step {r : FirstCrossing.Row} (c : CycleData r) (g : GeometryData r)
    (hr : r.Checked) (hc : c.Checked) (hg : g.Checked) (k : Nat) (C d : Int)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat)) (hd : 0 ≤ d)
    (shift : (7^k : Nat) = r.scale+r.model.period*d) (q : Nat)
    (qeq : (q : Int) = r.winningCycle+3*d) :
    SignedGreedy (c.frame g C q r.selected.val) (crossing (r := r) k C q) := by
  let s := (c.states r.selected.val).shift ((q : Int)*r.model.period)
  let b := record r.positive g.other s
  have cur : s.current = cycleCurrent r q r.selected := half_current c hc q r.selected
  have active : halfBoundary (if r.positive then b.pos else b.neg)
      (cycleCurrent r q r.selected) = c.half q r.selected.val := by
    unfold CycleData.half
    rw [← FiniteState.shift_toState]
    change halfBoundary (if r.positive then b.pos else b.neg) (cycleCurrent r q r.selected) = s.toState
    rw [← cur]
    cases h : r.positive <;> simp [b, record, h, halfBoundary, FiniteState.toState] <;> rfl
  have other : otherBoundary r.positive b.pos b.neg = g.other := by
    cases h : r.positive <;> simp [b, record, otherBoundary, h]
  have physical : signedBoundary C b.pos b.neg r.positive (cycleCurrent r q r.selected) =
      c.frame g C q r.selected.val := by
    rw [frame_record, ← cur]
    rfl
  unfold crossing
  rw [← physical, qeq]
  apply at_first_crossing g hr hg k C b.pos b.neg d scale large hd shift other
  rw [← qeq, active]
  exact half_greedy c hc q r.selected

/-- The complete outgoing word, including the first opposite-ray visit.
No physical-state or half-line-greedy premise remains at intermediate phases. -/
theorem through_crossing {r : FirstCrossing.Row} (c : CycleData r) (g : GeometryData r)
    (hr : r.Checked) (hc : c.Checked) (hg : g.Checked) (k : Nat) (C d : Int)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat)) (hd : 0 ≤ d)
    (shift : (7^k : Nat) = r.scale+r.model.period*d) (q : Nat)
    (qeq : (q : Int) = r.winningCycle+3*d) :
    ∃ b : SignedBlock (c.frame g C 0 0)
      (visit (c.frame g C q r.selected.val) (crossing (r := r) k C q)),
      b.word.length = q*r.phases.size+r.selected.val+1 := by
  obtain ⟨cycles, clen⟩ := complete_cycles c g hr hc hg k C d scale large shift q (by omega)
  obtain ⟨tailBlock, plen⟩ := phase_prefix c g hr hc hg k C d scale large shift q r.selected.val
    (by have h := r.selected.isLt; omega) (fun _ h => Or.inr ⟨qeq, h⟩)
  let jump : SignedBlock (c.frame g C q r.selected.val)
      (visit (c.frame g C q r.selected.val) (crossing (r := r) k C q)) :=
    ⟨[crossing (r := r) k C q],
      ⟨crossing_step c g hr hc hg k C d scale large hd shift q qeq, True.intro⟩, rfl⟩
  refine ⟨(cycles.then tailBlock).then jump, ?_⟩
  change ((cycles.word ++ tailBlock.word) ++ jump.word).length = _
  simp [clen, plen, jump, Nat.add_assoc]

structure CertifiedRow where
  row : FirstCrossing.Row
  geometry : GeometryData row
  cycle : CycleData row
  arithmetic : row.Checked
  bounds : geometry.Checked
  cycleChecked : cycle.Checked
  inner : SignedCertificate.CheckedBoundary
  entrance : inner.final.equalityCheck
    (record row.positive geometry.other (cycle.states 0)) = true

/-- Compose the already proved inner boundary with the outgoing segment. -/
theorem CertifiedRow.from_inner (a : CertifiedRow) (k : Nat) (C d : Int)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat)) (hd : 0 ≤ d)
    (shift : (7^k : Nat) = a.row.scale+a.row.model.period*d) (q : Nat)
    (qeq : (q : Int) = a.row.winningCycle+3*d) :
    ∃ b : SignedBlock (a.inner.initial.toState C)
      (visit (a.cycle.frame a.geometry C q a.row.selected.val)
        (crossing (r := a.row) k C q)),
      b.word.length = a.inner.moves.length+q*a.row.phases.size+a.row.selected.val+1 := by
  obtain ⟨outgoing, olen⟩ := through_crossing a.cycle a.geometry a.arithmetic a.cycleChecked
    a.bounds k C d scale large hd shift q qeq
  let inner := a.inner.atScale k C scale large
  have entrance := a.inner.final.equalityCheck_sound _ a.entrance C
  rw [record_lift] at entrance
  have start : a.inner.final.toState C = a.cycle.frame a.geometry C 0 0 := by
    simpa only [CycleData.frame, CycleData.half, Int.natCast_zero, Int.zero_mul,
      translate_zero] using entrance
  let first : SignedBlock (a.inner.initial.toState C) (a.cycle.frame a.geometry C 0 0) :=
    ⟨inner.word, inner.valid, inner.endpoint.trans start⟩
  have ilen : first.word.length = a.inner.moves.length :=
    SignedCertificate.checkedBlock_length a.inner.initial a.inner.final a.inner.moves
      a.inner.valid a.inner.closes k C scale large
  refine ⟨first.then outgoing, ?_⟩
  change (first.word ++ outgoing.word).length = _
  rw [List.length_append, ilen, olen]
  omega

/-- Every exponent in the certified residue class, with exact step count. -/
theorem CertifiedRow.all_exponents (a : CertifiedRow) (t : Nat) (C : Int)
    (scale : 2*C+1 = (7^(a.row.leastExponent+36*t) : Nat)) :
    ∃ q : Nat, ∃ b : SignedBlock (a.inner.initial.toState C)
      (visit (a.cycle.frame a.geometry C q a.row.selected.val)
        (crossing (r := a.row) (a.row.leastExponent+36*t) C q)),
      b.word.length = a.inner.moves.length+q*a.row.phases.size+a.row.selected.val+1 ∧
      ∃ d : Int, 0 ≤ d ∧ (q : Int) = a.row.winningCycle+3*d ∧
        (7^(a.row.leastExponent+36*t) : Nat) = a.row.scale+a.row.model.period*d := by
  obtain ⟨d, hd, shift, _⟩ := a.row.all_exponents a.arithmetic t
  have qnonneg : 0 ≤ a.row.winningCycle+3*d := by
    have h := a.arithmetic.2.2.2.1
    omega
  let q := (a.row.winningCycle+3*d).toNat
  have qeq : (q : Int) = a.row.winningCycle+3*d := Int.toNat_of_nonneg qnonneg
  have expbound : 6 ≤ a.row.leastExponent+36*t := by
    have h := a.arithmetic.2.2.2.2.2.2.2.2.1
    omega
  have large : 100000 ≤ (7^(a.row.leastExponent+36*t) : Nat) := by
    have h := Nat.pow_le_pow_right (n := 7) (by decide) expbound
    have num : (7 : Nat)^6 = 117649 := by decide
    omega
  obtain ⟨b, len⟩ := a.from_inner _ C d scale large hd shift q qeq
  exact ⟨q, b, len, d, hd, qeq, shift⟩

end Heraclitus.OutgoingWord
