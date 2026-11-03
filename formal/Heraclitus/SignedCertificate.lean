import Heraclitus.Refinement
import Heraclitus.FiniteCertificate

set_option autoImplicit false

/-! Finite signed-boundary claims with universal-scale soundness.
Data preparation is untrusted. A successful finite claim supplies the
same-ray minima and reflected minimum used by `boundary_rule_sound`.
-/

namespace Heraclitus.SignedCertificate

def LocalPower (x y : Int) : Prop := ∃ j : Fin 4, (y - x).natAbs = 7 ^ j.val
instance (x y : Int) : Decidable (LocalPower x y) :=
  inferInstanceAs (Decidable (∃ j : Fin 4, (y - x).natAbs = 7 ^ j.val))

theorem localPower_sound {x y : Int} (h : LocalPower x y) : PowerStep x y := by
  obtain ⟨j, hj⟩ := h
  exact ⟨j.val, hj⟩

theorem localPower_complete {x y : Int} (h : PowerStep x y)
    (bound : (y - x).natAbs < 2401) : LocalPower x y := by
  obtain ⟨j, hj⟩ := h
  have small : j < 4 := by
    by_cases small : j < 4
    · exact small
    · have big := Nat.pow_le_pow_right (n := 7) (by decide) (show 4 ≤ j by omega)
      have num : (7 : Nat) ^ 4 = 2401 := by decide
      rw [num] at big
      omega
  exact ⟨⟨j, small⟩, hj⟩

structure Record where
  positive : Bool
  current : Int
  pos : RayBoundary
  neg : RayBoundary

def Record.ray (s : Record) (side : Bool) : RayBoundary := if side then s.pos else s.neg
def Record.toState (s : Record) (C : Int) : State :=
  signedBoundary C s.pos s.neg s.positive s.current

instance (b : RayBoundary) (x : Int) : Decidable (boundaryUsed b x) :=
  inferInstanceAs (Decidable (x < b.front ∨ x ∈ b.extra))

instance (a : Bool) (x : Int) (b : Bool) (y : Int) : Decidable (BoundaryPreferred a x b y) :=
  inferInstanceAs (Decidable (x < y ∨ (x = y ∧
    (if b then (1 : Int) else -1) ≤ (if a then 1 else -1))))

def Candidate (s : Record) (side : Bool) (v : Int) : Prop :=
  if side = s.positive then LocalPower s.current v else v = 1 - s.current

instance (s : Record) (side : Bool) (v : Int) : Decidable (Candidate s side v) :=
  inferInstanceAs (Decidable (if side = s.positive then LocalPower s.current v else v = 1 - s.current))

def offer (s : Record) (j : Fin 4) (forward : Bool) : Int :=
  s.current + if forward then ((7 ^ j.val : Nat) : Int) else -((7 ^ j.val : Nat) : Int)

def Minima (s : Record) (side : Bool) (v : Int) : Prop :=
  (∀ j : Fin 4, ∀ forward : Bool,
    ¬boundaryUsed (s.ray s.positive) (offer s j forward) →
      BoundaryPreferred side v s.positive (offer s j forward)) ∧
  (¬boundaryUsed (s.ray (!s.positive)) (1 - s.current) →
    BoundaryPreferred side v (!s.positive) (1 - s.current))

instance (s : Record) (side : Bool) (v : Int) : Decidable (Minima s side v) :=
  inferInstanceAs (Decidable (
    (∀ j : Fin 4, ∀ forward : Bool,
      ¬boundaryUsed (s.ray s.positive) (offer s j forward) →
        BoundaryPreferred side v s.positive (offer s j forward)) ∧
    (¬boundaryUsed (s.ray (!s.positive)) (1 - s.current) →
      BoundaryPreferred side v (!s.positive) (1 - s.current))))

def ChoiceClaim (s : Record) (side : Bool) (v : Int) : Prop :=
  (-512 ≤ s.current ∧ s.current ≤ 512) ∧ (-512 ≤ v ∧ v ≤ 512) ∧
  (-512 ≤ s.pos.front ∧ s.pos.front ≤ 512) ∧
  (-512 ≤ s.neg.front ∧ s.neg.front ≤ 512) ∧
  ¬boundaryUsed (s.ray side) v ∧ Candidate s side v ∧ Minima s side v

instance (s : Record) (side : Bool) (v : Int) : Decidable (ChoiceClaim s side v) :=
  inferInstanceAs (Decidable (
    (-512 ≤ s.current ∧ s.current ≤ 512) ∧ (-512 ≤ v ∧ v ≤ 512) ∧
    (-512 ≤ s.pos.front ∧ s.pos.front ≤ 512) ∧
    (-512 ≤ s.neg.front ∧ s.neg.front ≤ 512) ∧
    ¬boundaryUsed (s.ray side) v ∧ Candidate s side v ∧ Minima s side v))

theorem ray_used_iff (s : Record) (C x : Int) (side : Bool) (positive : 0 < C + x) :
    (s.toState C).used (embedRay side C x) ↔ boundaryUsed (s.ray side) x := by
  exact boundary_ray_representation C s.pos s.neg side s.current x positive

theorem finite_minimum {s : Record} {side : Bool} {v : Int}
    (claim : ChoiceClaim s side v) (b : Bool) (w : Int)
    (unused : ¬boundaryUsed (s.ray b) w) (allowed : Candidate s b w) :
    BoundaryPreferred side v b w := by
  by_cases same : b = s.positive
  · subst b
    have power : LocalPower s.current w := by simpa [Candidate] using allowed
    obtain ⟨j, distance⟩ := power
    rcases Int.natAbs_eq_iff.mp distance with hp | hn
    · have eq : offer s j true = w := by simp only [offer, ite_true]; omega
      have h := claim.2.2.2.2.2.2.1 j true
      rw [eq] at h
      exact h unused
    · have eq : offer s j false = w := by simp only [offer, Bool.false_eq_true, ite_false]; omega
      have h := claim.2.2.2.2.2.2.1 j false
      rw [eq] at h
      exact h unused
  · have different : b = !s.positive := by
      cases b <;> cases h : s.positive <;> simp_all
    have reflected : w = 1 - s.current := by simpa [Candidate, same] using allowed
    subst w
    rw [different] at unused ⊢
    exact claim.2.2.2.2.2.2.2 unused

theorem choice_sound (s : Record) (side : Bool) (v : Int)
    (claim : ChoiceClaim s side v) (k : Nat) (C : Int)
    (scale : 2 * C + 1 = (7 ^ k : Nat)) (large : 100000 ≤ (7 ^ k : Nat)) :
    SignedGreedy (s.toState C) (embedRay side C v) := by
  have xp : 0 < C + s.current := by have h := claim.1; omega
  have vp : 0 < C + v := by have h := claim.2.1; omega
  have unused : ¬(s.toState C).used (embedRay side C v) :=
    fun h => claim.2.2.2.2.1 ((ray_used_iff s C v side vp).mp h)
  have candidate := claim.2.2.2.2.2.1
  have step : PowerStep (embedRay s.positive C s.current) (embedRay side C v) := by
    by_cases same : side = s.positive
    · subst side
      exact (ray_power s.positive C s.current v).mpr
        (localPower_sound (by simpa [Candidate] using candidate))
    · have different : side = !s.positive := by
        cases side <;> cases h : s.positive <;> simp_all
      have reflected : v = 1 - s.current := by simpa [Candidate, same] using candidate
      rw [different]
      refine ⟨k, ?_⟩
      have h := opposite_ray_distance s.positive C s.current v xp vp
      omega
  apply boundary_rule_sound k C s.current v s.pos s.neg s.positive side
    scale large claim.1 claim.2.1 unused step
  · intro w wp wu ws
    have lower : -512 ≤ w := by
      have low : ¬w < (s.ray s.positive).front := fun h => wu (Or.inl h)
      have hp := claim.2.2.1
      have hn := claim.2.2.2.1
      cases h : s.positive <;> simp [Record.ray, h] at low <;> omega
    by_cases after : v < w
    · exact Or.inl after
    · have bound : (w - s.current).natAbs < 2401 := by
        have xbound := claim.1
        have vbound := claim.2.1
        by_cases nonneg : 0 ≤ w - s.current
        · have a := Int.natAbs_of_nonneg nonneg; omega
        · have a := Int.ofNat_natAbs_of_nonpos (show w - s.current ≤ 0 by omega); omega
      apply finite_minimum claim s.positive w wu
      simp only [Candidate, ite_true]
      exact localPower_complete ws bound
  · intro ru
    have rp : 0 < C + (1 - s.current) := by have h := claim.1; omega
    have unused_ref : ¬boundaryUsed (s.ray (!s.positive)) (1 - s.current) :=
      fun h => ru ((ray_used_iff s C (1 - s.current) (!s.positive) rp).mpr h)
    apply finite_minimum claim (!s.positive) (1 - s.current) unused_ref
    have diff : (!s.positive) ≠ s.positive := by cases s.positive <;> decide
    simp [Candidate, diff]

def FilledClaim (b : RayBoundary) (v g : Int) : Prop :=
  b.front ≤ g ∧ ∀ i : Fin (g - b.front).toNat, b.front + (i.val : Int) ∈ v :: b.extra

instance (b : RayBoundary) (v g : Int) : Decidable (FilledClaim b v g) :=
  inferInstanceAs (Decidable (b.front ≤ g ∧
    ∀ i : Fin (g - b.front).toNat, b.front + (i.val : Int) ∈ v :: b.extra))

def updateRay (b : RayBoundary) (v g : Int) : RayBoundary :=
  ⟨g, (v :: b.extra).filter (fun x => decide (g ≤ x))⟩

theorem updateRay_exact (b : RayBoundary) (v g x : Int) (h : FilledClaim b v g) :
    boundaryUsed (updateRay b v g) x ↔ boundaryUsed b x ∨ x = v := by
  change (x < g ∨ x ∈ (v :: b.extra).filter (fun y => decide (g ≤ y))) ↔ _
  simp only [List.mem_filter, List.mem_cons, decide_eq_true_eq]
  constructor
  · intro hx
    rcases hx with below | ⟨member, _⟩
    · by_cases old : x < b.front
      · exact Or.inl (Or.inl old)
      · have idx : (x - b.front).toNat < (g - b.front).toNat := by omega
        let i : Fin (g - b.front).toNat := ⟨(x - b.front).toNat, idx⟩
        have eq : b.front + (i.val : Int) = x := by dsimp [i]; omega
        have mem := h.2 i
        rw [eq] at mem
        rcases List.mem_cons.mp mem with eq | mem
        · exact Or.inr eq
        · exact Or.inl (Or.inr mem)
    · rcases member with eq | mem
      · exact Or.inr eq
      · exact Or.inl (Or.inr mem)
  · intro hx
    by_cases below : x < g
    · exact Or.inl below
    · right
      refine ⟨?_, by omega⟩
      rcases hx with (old | mem) | eq
      · have lower := h.1
        omega
      · exact Or.inr mem
      · exact Or.inl eq

def Record.update (s : Record) (side : Bool) (v g : Int) : Record :=
  ⟨side, v, if side then updateRay s.pos v g else s.pos,
    if side then s.neg else updateRay s.neg v g⟩

theorem update_exact (s : Record) (side : Bool) (v g C : Int)
    (h : FilledClaim (s.ray side) v g) (vp : 0 < C + v) :
    ((s.update side v g).toState C) = visit (s.toState C) (embedRay side C v) := by
  apply state_ext
  · rfl
  · intro z
    cases side
    · change (z = 0 ∨ (0 < z ∧ boundaryUsed s.pos (z-C)) ∨
        (z < 0 ∧ boundaryUsed (updateRay s.neg v g) (-z-C))) ↔
        (z = 0 ∨ (0 < z ∧ boundaryUsed s.pos (z-C)) ∨
        (z < 0 ∧ boundaryUsed s.neg (-z-C))) ∨ z = -(C+v)
      rw [updateRay_exact s.neg v g (-z-C) h]
      by_cases eq : z = -(C+v)
      · subst z
        have coord : C+v-C = v := by omega
        simp [vp, coord]
      · have coord : -z-C ≠ v := by omega
        simp [eq, coord]
    · change (z = 0 ∨ (0 < z ∧ boundaryUsed (updateRay s.pos v g) (z-C)) ∨
        (z < 0 ∧ boundaryUsed s.neg (-z-C))) ↔
        (z = 0 ∨ (0 < z ∧ boundaryUsed s.pos (z-C)) ∨
        (z < 0 ∧ boundaryUsed s.neg (-z-C))) ∨ z = C+v
      rw [updateRay_exact s.pos v g (z-C) h]
      by_cases eq : z = C+v
      · subst z
        have coord : C+v-C = v := by omega
        simp [vp, coord]
      · have coord : z-C ≠ v := by omega
        simp [eq, coord]

structure Move where
  positive : Bool
  value : Int
  front : Int

def MoveClaim (s : Record) (m : Move) : Prop :=
  ChoiceClaim s m.positive m.value ∧ FilledClaim (s.ray m.positive) m.value m.front

instance (s : Record) (m : Move) : Decidable (MoveClaim s m) :=
  inferInstanceAs (Decidable (ChoiceClaim s m.positive m.value ∧
    FilledClaim (s.ray m.positive) m.value m.front))

def Record.run (s : Record) : List Move → Record
  | [] => s
  | m :: ms => (s.update m.positive m.value m.front).run ms

def wordCheck (s : Record) : List Move → Bool
  | [] => true
  | m :: ms => decide (MoveClaim s m) && wordCheck (s.update m.positive m.value m.front) ms

def physicalWord (C : Int) (word : List Move) : List Int :=
  word.map (fun m => embedRay m.positive C m.value)

theorem wordCheck_sound (s : Record) (word : List Move)
    (check : wordCheck s word = true) (k : Nat) (C : Int)
    (scale : 2 * C + 1 = (7 ^ k : Nat)) (large : 100000 ≤ (7 ^ k : Nat)) :
    SignedValidWord (s.toState C) (physicalWord C word) ∧
      execute (s.toState C) (physicalWord C word) = ((s.run word).toState C) := by
  induction word generalizing s with
  | nil => exact ⟨True.intro, rfl⟩
  | cons m ms ih =>
    have both : decide (MoveClaim s m) = true ∧
        wordCheck (s.update m.positive m.value m.front) ms = true := by
      simpa only [wordCheck, Bool.and_eq_true] using check
    have claim : MoveClaim s m := of_decide_eq_true both.1
    have next := ih (s.update m.positive m.value m.front) both.2
    have vp : 0 < C + m.value := by have bounds := claim.1.2.1; omega
    have updated := update_exact s m.positive m.value m.front C claim.2 vp
    constructor
    · change SignedGreedy (s.toState C) (embedRay m.positive C m.value) ∧ _
      refine ⟨choice_sound s m.positive m.value claim.1 k C scale large, ?_⟩
      rw [← updated]
      exact next.1
    · change execute (visit (s.toState C) (embedRay m.positive C m.value))
        (physicalWord C ms) = _
      rw [← updated]
      exact next.2

def Record.equalityCheck (s t : Record) : Bool :=
  (s.positive == t.positive) && (s.current == t.current) &&
    (FiniteState.mk 0 s.pos.front s.pos.extra).equalityCheck
      (FiniteState.mk 0 t.pos.front t.pos.extra) (-513) 513 &&
    (FiniteState.mk 0 s.neg.front s.neg.extra).equalityCheck
      (FiniteState.mk 0 t.neg.front t.neg.extra) (-513) 513

theorem Record.equalityCheck_sound (s t : Record) (check : s.equalityCheck t = true)
    (C : Int) : s.toState C = t.toState C := by
  have parts : ((s.positive = t.positive ∧ s.current = t.current) ∧
      (FiniteState.mk 0 s.pos.front s.pos.extra).equalityCheck
        (FiniteState.mk 0 t.pos.front t.pos.extra) (-513) 513 = true) ∧
      (FiniteState.mk 0 s.neg.front s.neg.extra).equalityCheck
        (FiniteState.mk 0 t.neg.front t.neg.extra) (-513) 513 = true := by
    simpa only [Record.equalityCheck, Bool.and_eq_true, beq_iff_eq] using check
  have pos_eq := FiniteState.equalityCheck_sound parts.1.2
  have neg_eq := FiniteState.equalityCheck_sound parts.2
  apply state_ext
  · change embedRay s.positive C s.current = embedRay t.positive C t.current
    rw [parts.1.1.1, parts.1.1.2]
  · intro z
    have hp (x : Int) : boundaryUsed s.pos x ↔ boundaryUsed t.pos x := by
      change (FiniteState.mk 0 s.pos.front s.pos.extra).toState.used x ↔
        (FiniteState.mk 0 t.pos.front t.pos.extra).toState.used x
      rw [pos_eq]
    have hn (x : Int) : boundaryUsed s.neg x ↔ boundaryUsed t.neg x := by
      change (FiniteState.mk 0 s.neg.front s.neg.extra).toState.used x ↔
        (FiniteState.mk 0 t.neg.front t.neg.extra).toState.used x
      rw [neg_eq]
    change (z = 0 ∨ (0 < z ∧ boundaryUsed s.pos (z-C)) ∨
      (z < 0 ∧ boundaryUsed s.neg (-z-C))) ↔ _
    rw [hp, hn]
    rfl

def checkedBlock (s t : Record) (word : List Move)
    (valid : wordCheck s word = true) (close : (s.run word).equalityCheck t = true)
    (k : Nat) (C : Int) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat)) : SignedBlock (s.toState C) (t.toState C) where
  word := physicalWord C word
  valid := (wordCheck_sound s word valid k C scale large).1
  endpoint := (wordCheck_sound s word valid k C scale large).2.trans
    ((s.run word).equalityCheck_sound t close C)

theorem checkedBlock_length (s t : Record) (word : List Move)
    (valid : wordCheck s word = true) (close : (s.run word).equalityCheck t = true)
    (k : Nat) (C : Int) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat)) :
    (checkedBlock s t word valid close k C scale large).word.length = word.length := by
  exact List.length_map _

structure CheckedBoundary where
  label : Nat
  outer : Bool
  initial : Record
  final : Record
  moves : List Move
  valid : wordCheck initial moves = true
  closes : (initial.run moves).equalityCheck final = true

def CheckedBoundary.atScale (b : CheckedBoundary) (k : Nat) (C : Int)
    (scale : 2 * C + 1 = (7 ^ k : Nat)) (large : 100000 ≤ (7 ^ k : Nat)) :
    SignedBlock (b.initial.toState C) (b.final.toState C) :=
  checkedBlock b.initial b.final b.moves b.valid b.closes k C scale large

end Heraclitus.SignedCertificate
