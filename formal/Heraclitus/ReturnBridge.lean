import Heraclitus.OutgoingWord

set_option autoImplicit false

/-! Exact signed return entrance and the bounded half-line/signed interface.
The later ladder/bottom words and their envelope remain separate obligations. -/

namespace Heraclitus.ReturnBridge
open Outgoing OutgoingWord

theorem lift_choice (s : FiniteState) (other : RayBoundary) (side : Bool)
    (k : Nat) (C y : Int) (scale : 2*C+1 = (7^k : Nat))
    (large : 100000 ≤ (7^k : Nat))
    (xb : -100 ≤ s.current ∧ s.current ≤ 3*(7^k : Nat)+9)
    (yb : -100 ≤ y ∧ y ≤ 3*(7^k : Nat)+9)
    (reflection : 1-s.current < other.front)
    (greedy : Greedy s.toState y)
    (noCross : ¬CrossWins side (7^k : Nat) s.current y) :
    SignedGreedy (liftRay side C other s.toState) (embedRay side C y) := by
  let b := record side other s
  have active : halfBoundary (if side then b.pos else b.neg) s.current = s.toState := by
    cases side <;> rfl
  have opposite : otherBoundary side b.pos b.neg = other := by
    cases side <;> rfl
  rw [← record_lift]
  apply local_choice_sound k C s.current y b.pos b.neg side scale large xb yb
  · rw [opposite]; exact reflection
  · rw [active]; exact greedy
  · exact noCross

/-- All exponents and both tie cases in the stated return envelope. -/
theorem return_choice (s : FiniteState) (other : RayBoundary) (side : Bool)
    (k : Nat) (C y : Int) (scale : 2*C+1 = (7^k : Nat))
    (large : 100000 ≤ (7^k : Nat))
    (xb : -100 ≤ s.current ∧ s.current ≤ 2*(7^k : Nat)+4096)
    (yb : -100 ≤ y ∧ y ≤ 2*(7^k : Nat)+4096)
    (filled : 3*(7^k : Nat)-200 ≤ other.front)
    (greedy : Greedy s.toState y) :
    SignedGreedy (liftRay side C other s.toState) (embedRay side C y) := by
  apply lift_choice s other side k C y scale large (by omega) (by omega) (by omega) greedy
  cases side <;> simp only [CrossWins, Bool.false_eq_true, ite_false, ite_true] <;> omega

def Envelope (m : Int) (s : State) : List Int → Prop
  | [] => True
  | v :: vs => (-100 ≤ s.current ∧ s.current ≤ 2*m+4096) ∧
    (-100 ≤ v ∧ v ≤ 2*m+4096) ∧ Envelope m (visit s v) vs

/-- A whole finite half-line return word lifts with its complete used set.
The envelope must be proved for the actual word, not merely its endpoints. -/
theorem return_word (s : FiniteState) (other : RayBoundary) (side : Bool)
    (k : Nat) (C : Int) (w : List Int) (scale : 2*C+1 = (7^k : Nat))
    (large : 100000 ≤ (7^k : Nat)) (filled : 3*(7^k : Nat)-200 ≤ other.front)
    (valid : ValidWord s.toState w) (envelope : Envelope (7^k : Nat) s.toState w) :
    SignedValidWord (liftRay side C other s.toState) (w.map (embedRay side C)) ∧
    execute (liftRay side C other s.toState) (w.map (embedRay side C)) =
      liftRay side C other (execute s.toState w) := by
  induction w generalizing s with
  | nil => exact ⟨True.intro, rfl⟩
  | cons v vs ih =>
    have step := return_choice s other side k C v scale large envelope.1 envelope.2.1 filled valid.1
    have positive : 0 < C+v := by have h := envelope.2.1.1; omega
    have nextValid : ValidWord (s.addVisit v).toState vs := by
      rw [FiniteState.addVisit_toState]; exact valid.2
    have nextBounds : Envelope (7^k : Nat) (s.addVisit v).toState vs := by
      rw [FiniteState.addVisit_toState]; exact envelope.2.2
    have next := ih (s.addVisit v) nextValid nextBounds
    rw [FiniteState.addVisit_toState, lift_visit _ _ _ _ _ positive] at next
    exact ⟨⟨step, next.1⟩, next.2⟩

/-- In the high return band, subtraction of m is the half-line minimum
when fresh. Larger powers land below the filled old prefix. -/
theorem subtract_scale (s : State) (k : Nat) (large : 100000 ≤ (7^k : Nat))
    (upper : s.current ≤ 3*(7^k : Nat)+3)
    (filled : ∀ x, x < -100 → s.used x)
    (fresh : ¬s.used (s.current-(7^k : Nat))) :
    Greedy s (s.current-(7^k : Nat)) := by
  refine ⟨fresh, ?_, ?_⟩
  · refine ⟨k, ?_⟩
    have eq : s.current-(7^k : Nat)-s.current = -((7^k : Nat) : Int) := by omega
    rw [eq]
    simp
  · intro w unused step
    obtain ⟨j, distance⟩ := step
    rcases Int.natAbs_eq_iff.mp distance with forward | backward
    · have nonnegative : (0 : Int) ≤ (7^j : Nat) := by omega
      omega
    · rcases power_scale_trichotomy j k with small | equal | big
      · have cast : (7^j : Nat) ≤ (7^k : Nat) := by omega
        omega
      · subst j; omega
      · have cast : 7*((7^k : Nat) : Int) ≤ (7^j : Nat) := by omega
        exact False.elim (unused (filled w (by omega)))

def initial (old : RayBoundary) (m A : Int) : FiniteState :=
  ⟨3*m+A, old.front, (3*m+A) :: old.extra⟩

def checkpoint (old : RayBoundary) (m A : Int) : FiniteState :=
  ⟨m+A, old.front, [m+A, 2*m+A, 3*m+A] ++ old.extra⟩

theorem checkpoint_used (old : RayBoundary) (m A x : Int) :
    (checkpoint old m A).toState.used x ↔
      boundaryUsed old x ∨ x=m+A ∨ x=2*m+A ∨ x=3*m+A := by
  simp [checkpoint, FiniteState.toState, boundaryUsed, or_assoc, or_left_comm, or_comm]

theorem two_half_steps (old : RayBoundary) (k : Nat) (A : Int)
    (large : 100000 ≤ (7^k : Nat)) (anchor : -3 ≤ A ∧ A ≤ 3)
    (front : -100 ≤ old.front ∧ old.front < 100)
    (points : ∀ x ∈ old.extra, x < 100) :
    ValidWord (initial old (7^k : Nat) A).toState
      [2*(7^k : Nat)+A, (7^k : Nat)+A] := by
  let m : Int := (7^k : Nat)
  have hm : 100000 ≤ m := by exact Int.ofNat_le.mpr large
  have firstFresh : ¬(initial old m A).toState.used (2*m+A) := by
    intro used
    rcases used with below | member
    · change 2*m+A < old.front at below; omega
    · change 2*m+A ∈ (3*m+A) :: old.extra at member
      rcases List.mem_cons.mp member with eq | mem
      · omega
      · have h := points _ mem; omega
  have secondFresh : ¬(visit (initial old m A).toState (2*m+A)).used (m+A) := by
    intro used
    rcases used with (below | member) | eq
    · change m+A < old.front at below; omega
    · change m+A ∈ (3*m+A) :: old.extra at member
      rcases List.mem_cons.mp member with eq | mem
      · omega
      · have h := points _ mem; omega
    · omega
  have e1 : 3*m+A-m=2*m+A := by omega
  have e2 : 2*m+A-m=m+A := by omega
  have first := subtract_scale (initial old m A).toState k large
    (by change 3*m+A ≤ 3*m+3; omega)
    (by intro x hx; exact Or.inl (by change x < old.front; omega))
    (by change ¬(initial old m A).toState.used (3*m+A-m); rw [e1]; exact firstFresh)
  have second := subtract_scale (visit (initial old m A).toState (2*m+A)) k large
    (by change 2*m+A ≤ 3*m+3; omega)
    (by intro x hx; exact Or.inl (Or.inl (by change x < old.front; omega)))
    (by change ¬(visit (initial old m A).toState (2*m+A)).used (2*m+A-m)
        rw [e2]; exact secondFresh)
  change Greedy (initial old m A).toState (3*m+A-m) at first
  change Greedy (visit (initial old m A).toState (2*m+A)) (2*m+A-m) at second
  rw [e1] at first
  rw [e2] at second
  exact ⟨first, second, True.intro⟩

/-- The two initial m-subtractions, including the complete marker state. -/
theorem two_signed_steps (old other : RayBoundary) (side : Bool)
    (k : Nat) (C A : Int) (scale : 2*C+1 = (7^k : Nat))
    (large : 100000 ≤ (7^k : Nat)) (anchor : -3 ≤ A ∧ A ≤ 3)
    (front : -100 ≤ old.front ∧ old.front < 100)
    (points : ∀ x ∈ old.extra, x < 100)
    (filled : 3*(7^k : Nat)-200 ≤ other.front) :
    ∃ b : SignedBlock (liftRay side C other (initial old (7^k : Nat) A).toState)
      (liftRay side C other (checkpoint old (7^k : Nat) A).toState), b.word.length = 2 := by
  let m : Int := (7^k : Nat)
  have hm : 100000 ≤ m := by exact Int.ofNat_le.mpr large
  have half := two_half_steps old k A large anchor front points
  let s := initial old m A
  have first : SignedGreedy (liftRay side C other s.toState) (embedRay side C (2*m+A)) := by
    apply lift_choice s other side k C (2*m+A) scale large
      (by change -100 ≤ 3*m+A ∧ 3*m+A ≤ 3*m+9; omega) (by omega)
      (by change 1-(3*m+A) < other.front; omega) half.1
    change ¬CrossWins side m (3*m+A) (2*m+A)
    cases side <;> simp only [CrossWins, Bool.false_eq_true, ite_false, ite_true] <;> omega
  have second : SignedGreedy (liftRay side C other (s.addVisit (2*m+A)).toState)
      (embedRay side C (m+A)) := by
    apply return_choice _ other side k C (m+A) scale large
      (by change -100 ≤ 2*m+A ∧ 2*m+A ≤ 2*m+4096; omega) (by omega) filled
    rw [FiniteState.addVisit_toState]
    exact half.2.1
  have firstPositive : 0 < C+(2*m+A) := by omega
  have secondPositive : 0 < C+(m+A) := by omega
  have next : (s.addVisit (2*m+A)).addVisit (m+A) = checkpoint old m A := rfl
  have updates := congrArg (fun t : FiniteState => liftRay side C other t.toState) next
  rw [FiniteState.addVisit_toState, FiniteState.addVisit_toState,
    lift_visit _ _ _ _ _ secondPositive, lift_visit _ _ _ _ _ firstPositive] at updates
  rw [FiniteState.addVisit_toState, lift_visit _ _ _ _ _ firstPositive] at second
  exact ⟨⟨[embedRay side C (2*m+A), embedRay side C (m+A)],
    ⟨first, second, True.intro⟩, updates⟩, rfl⟩

/-- Changing the active ray at the crossing preserves every old used point. -/
theorem cross_visit_switch (s : FiniteState) (old : RayBoundary) (side : Bool)
    (C v : Int) (positive : 0 < C+v) :
    visit (liftRay side C old s.toState) (embedRay (!side) C v) =
      liftRay (!side) C ⟨s.front, s.points⟩ (FiniteState.mk v old.front (v :: old.extra)).toState := by
  apply state_ext
  · rfl
  · intro z
    cases side
    · change ((z=0 ∨ (0<z ∧ boundaryUsed old (z-C)) ∨
          (z<0 ∧ s.toState.used (-z-C))) ∨ z=C+v) ↔
        (z=0 ∨ (0<z ∧ (z-C<old.front ∨ z-C ∈ v::old.extra)) ∨
          (z<0 ∧ boundaryUsed ⟨s.front,s.points⟩ (-z-C)))
      simp only [boundaryUsed, FiniteState.toState, List.mem_cons]
      have eq : z-C=v ↔ z=C+v := by omega
      rw [eq]
      by_cases hit : z=C+v
      · simp [hit, positive]
      · simp [hit]
    · change ((z=0 ∨ (0<z ∧ s.toState.used (z-C)) ∨
          (z<0 ∧ boundaryUsed old (-z-C))) ∨ z=-(C+v)) ↔
        (z=0 ∨ (0<z ∧ boundaryUsed ⟨s.front,s.points⟩ (z-C)) ∨
          (z<0 ∧ (-z-C<old.front ∨ -z-C ∈ v::old.extra)))
      simp only [boundaryUsed, FiniteState.toState, List.mem_cons]
      have eq : -z-C=v ↔ z=-(C+v) := by omega
      rw [eq]
      by_cases hit : z=-(C+v)
      · simp [hit, positive]
      · simp [hit]

def farBoundary (a : CertifiedRow) (q : Nat) : RayBoundary :=
  let s := (a.cycle.states a.row.selected.val).shift ((q : Int)*a.row.model.period)
  ⟨s.front, s.points⟩

structure EntranceData (a : CertifiedRow) where
  anchor : Int
  anchorUsed : Bool

def EntranceData.Checked {a : CertifiedRow} (e : EntranceData a) : Prop :=
  (-3 ≤ e.anchor ∧ e.anchor ≤ 3) ∧
  -100 ≤ a.geometry.other.front ∧
  -200 ≤ (a.cycle.states a.row.selected.val).front +
    a.row.winningCycle*a.row.model.period - 3*a.row.scale ∧
  6*a.row.scale+1-cycleCurrent a.row a.row.winningCycle a.row.selected = 3*a.row.scale+e.anchor ∧
  (e.anchorUsed = true ↔ boundaryUsed a.geometry.other e.anchor)

instance {a : CertifiedRow} (e : EntranceData a) : Decidable e.Checked := by
  unfold EntranceData.Checked
  infer_instance

/-- The complete displacement, rather than a sampled large-scale equality. -/
theorem displacement (a : CertifiedRow) (k : Nat) (d : Int) (q : Nat)
    (shift : (7^k : Nat) = a.row.scale+a.row.model.period*d)
    (qeq : (q : Int) = a.row.winningCycle+3*d) :
    (q : Int)*a.row.model.period-3*(7^k : Nat) =
      a.row.winningCycle*a.row.model.period-3*a.row.scale := by
  have h := FirstCrossing.normalized_front_shift 0 a.row.model.period 0
    a.row.scale a.row.winningCycle d
  simp only [Int.zero_add, Int.add_zero] at h
  rw [← shift, ← qeq] at h
  exact h

theorem entrance_geometry {a : CertifiedRow} (e : EntranceData a) (he : e.Checked)
    (k : Nat) (d : Int) (q : Nat)
    (shift : (7^k : Nat) = a.row.scale+a.row.model.period*d)
    (qeq : (q : Int) = a.row.winningCycle+3*d) :
    3*(7^k : Nat)-200 ≤ (farBoundary a q).front ∧
    6*(7^k : Nat)+1-cycleCurrent a.row q a.row.selected = 3*(7^k : Nat)+e.anchor := by
  have h := displacement a k d q shift qeq
  have front := he.2.2.1
  have current := he.2.2.2.1
  simp only [farBoundary, FiniteState.shift, cycleCurrent] at current ⊢
  omega

theorem crossing_endpoint {a : CertifiedRow} (e : EntranceData a) (he : e.Checked)
    (k : Nat) (C d : Int) (q : Nat)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (shift : (7^k : Nat) = a.row.scale+a.row.model.period*d)
    (qeq : (q : Int) = a.row.winningCycle+3*d) :
    visit (a.cycle.frame a.geometry C q a.row.selected.val) (crossing (r := a.row) k C q) =
      liftRay (!a.row.positive) C (farBoundary a q)
        (initial a.geometry.other (7^k : Nat) e.anchor).toState := by
  have eq := (entrance_geometry e he k d q shift qeq).2
  have positive : 0 < C+(3*(7^k : Nat)+e.anchor) := by have h := he.1; omega
  unfold CycleData.frame CycleData.half crossing
  rw [eq, ← FiniteState.shift_toState]
  exact cross_visit_switch _ _ _ _ _ positive

/-- Exact handoff from the proved first crossing to the return checkpoint. -/
theorem continuation {a : CertifiedRow} (e : EntranceData a) (he : e.Checked)
    (k : Nat) (C d : Int) (q : Nat)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (shift : (7^k : Nat) = a.row.scale+a.row.model.period*d)
    (qeq : (q : Int) = a.row.winningCycle+3*d) :
    ∃ b : SignedBlock
      (visit (a.cycle.frame a.geometry C q a.row.selected.val) (crossing (r := a.row) k C q))
      (liftRay (!a.row.positive) C (farBoundary a q)
        (checkpoint a.geometry.other (7^k : Nat) e.anchor).toState), b.word.length = 2 := by
  rw [crossing_endpoint e he k C d q scale large shift qeq]
  exact two_signed_steps _ _ _ k C e.anchor scale large he.1
    ⟨he.2.1, a.bounds.1⟩ a.bounds.2.1 (entrance_geometry e he k d q shift qeq).1

structure CertifiedEntrance where
  outgoing : CertifiedRow
  data : EntranceData outgoing
  checked : data.Checked

/-- The exceptional unused-anchor case takes a direct third m-subtraction.
The finite bottom word after this step is outside the theorem's scope. -/
theorem direct_anchor_step (old other : RayBoundary) (side : Bool)
    (k : Nat) (C A : Int) (scale : 2*C+1 = (7^k : Nat))
    (large : 100000 ≤ (7^k : Nat)) (anchor : -3 ≤ A ∧ A ≤ 3)
    (front : -100 ≤ old.front) (unused : ¬boundaryUsed old A)
    (filled : 3*(7^k : Nat)-200 ≤ other.front) :
    SignedGreedy (liftRay side C other (checkpoint old (7^k : Nat) A).toState)
      (embedRay side C A) := by
  let m : Int := (7^k : Nat)
  have hm : 100000 ≤ m := Int.ofNat_le.mpr large
  have fresh : ¬(checkpoint old m A).toState.used A := by
    rw [checkpoint_used]
    intro h
    rcases h with oldUsed | h | h | h
    · exact unused oldUsed
    · omega
    · omega
    · omega
  have half := subtract_scale (checkpoint old m A).toState k large
    (by change m+A ≤ 3*m+3; omega)
    (by intro x hx; exact Or.inl (by change x<old.front; omega))
    (by change ¬(checkpoint old m A).toState.used (m+A-m)
        have eq : m+A-m=A := by omega
        rw [eq]; exact fresh)
  have eq : m+A-m=A := by omega
  change Greedy (checkpoint old m A).toState (m+A-m) at half
  rw [eq] at half
  apply return_choice _ other side k C A scale large
    (by change -100 ≤ m+A ∧ m+A ≤ 2*m+4096; omega) (by omega) filled half

theorem CertifiedEntrance.direct_if_unused (e : CertifiedEntrance)
    (unused : e.data.anchorUsed = false) (k : Nat) (C d : Int) (q : Nat)
    (scale : 2*C+1 = (7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (shift : (7^k : Nat) = e.outgoing.row.scale+e.outgoing.row.model.period*d)
    (qeq : (q : Int) = e.outgoing.row.winningCycle+3*d) :
    SignedGreedy
      (liftRay (!e.outgoing.row.positive) C (farBoundary e.outgoing q)
        (checkpoint e.outgoing.geometry.other (7^k : Nat) e.data.anchor).toState)
      (embedRay (!e.outgoing.row.positive) C e.data.anchor) := by
  apply direct_anchor_step _ _ _ k C e.data.anchor scale large e.checked.1 e.checked.2.1
  · intro used
    have h := e.checked.2.2.2.2.mpr used
    rw [unused] at h
    contradiction
  · exact (entrance_geometry e.data e.checked k d q shift qeq).1

/-- Inner boundary, outgoing word, crossing and two return moves, at every
exponent in each row's residue class. The physical endpoint is explicit. -/
theorem CertifiedEntrance.all_exponents (e : CertifiedEntrance) (t : Nat) (C : Int)
    (scale : 2*C+1 = (7^(e.outgoing.row.leastExponent+36*t) : Nat)) :
    ∃ q : Nat, ∃ b : SignedBlock (e.outgoing.inner.initial.toState C)
      (liftRay (!e.outgoing.row.positive) C (farBoundary e.outgoing q)
        (checkpoint e.outgoing.geometry.other
          (7^(e.outgoing.row.leastExponent+36*t) : Nat) e.data.anchor).toState),
      b.word.length = e.outgoing.inner.moves.length+q*e.outgoing.row.phases.size+
        e.outgoing.row.selected.val+3 ∧
      3*(7^(e.outgoing.row.leastExponent+36*t) : Nat)-200 ≤ (farBoundary e.outgoing q).front ∧
      ∃ d : Int, 0 ≤ d ∧ (q : Int) = e.outgoing.row.winningCycle+3*d ∧
        (7^(e.outgoing.row.leastExponent+36*t) : Nat) =
          e.outgoing.row.scale+e.outgoing.row.model.period*d := by
  let a := e.outgoing
  obtain ⟨q, before, len, d, hd, qeq, shift⟩ := a.all_exponents t C scale
  have expbound : 6 ≤ a.row.leastExponent+36*t := by
    have h := a.arithmetic.2.2.2.2.2.2.2.2.1
    omega
  have large : 100000 ≤ (7^(a.row.leastExponent+36*t) : Nat) := by
    have h := Nat.pow_le_pow_right (n := 7) (by decide) expbound
    have num : (7 : Nat)^6 = 117649 := by decide
    omega
  obtain ⟨after, alen⟩ := continuation e.data e.checked _ C d q scale large shift qeq
  refine ⟨q, before.then after, ?_, (entrance_geometry e.data e.checked _ d q shift qeq).1,
    d, hd, qeq, shift⟩
  change (before.word ++ after.word).length = _
  rw [List.length_append, len, alen]

end Heraclitus.ReturnBridge
