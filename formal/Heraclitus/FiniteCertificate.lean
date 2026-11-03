import Heraclitus.Markers

set_option autoImplicit false

/-!
# Sound finite checks for physical half-line records

The Boolean checks below have proved soundness against `Greedy`, `ValidWord`,
and equality of the entire physical state. Kernel reduction of concrete
checks supplies proofs; neither Python output nor native evaluation is an axiom.
This first bridge uses distances below 343 when excluding smaller candidates.
-/

namespace Heraclitus

def SmallStep (x y : Int) : Prop :=
  ∃ j : Fin 3, (y - x).natAbs = 7 ^ j.val

instance (x y : Int) : Decidable (SmallStep x y) :=
  inferInstanceAs (Decidable (∃ j : Fin 3, (y - x).natAbs = 7 ^ j.val))

theorem smallStep_sound {x y : Int} (h : SmallStep x y) : PowerStep x y := by
  obtain ⟨j, hj⟩ := h
  exact ⟨j.val, hj⟩

/-- All higher exponents are excluded by a proved distance bound. -/
theorem smallStep_complete {x y : Int} (h : PowerStep x y)
    (bound : (y - x).natAbs < 343) : SmallStep x y := by
  obtain ⟨j, hj⟩ := h
  have jsmall : j < 3 := by
    by_cases hs : j < 3
    · exact hs
    · have hp : (7 : Nat) ^ 3 ≤ 7 ^ j := Nat.pow_le_pow_right (by decide) (by omega)
      have value : (7 : Nat) ^ 3 = 343 := by decide
      rw [value] at hp
      omega
  exact ⟨⟨j, jsmall⟩, hj⟩

/-- Points use absolute coordinates. The filled front need not be normalized. -/
structure FiniteState where
  current : Int
  front : Int
  points : List Int
deriving Repr

namespace FiniteState

def toState (s : FiniteState) : State :=
  ⟨s.current, fun x => x < s.front ∨ x ∈ s.points⟩

instance (s : FiniteState) (x : Int) : Decidable (s.toState.used x) :=
  inferInstanceAs (Decidable (x < s.front ∨ x ∈ s.points))

def addVisit (s : FiniteState) (v : Int) : FiniteState :=
  ⟨v, s.front, v :: s.points⟩

theorem addVisit_toState (s : FiniteState) (v : Int) :
    (s.addVisit v).toState = visit s.toState v := by
  apply state_ext
  · rfl
  · intro x
    simp [addVisit, toState, visit, or_left_comm, or_comm]

def run (s : FiniteState) : List Int → FiniteState
  | [] => s
  | v :: vs => run (s.addVisit v) vs

theorem run_toState (s : FiniteState) (w : List Int) :
    (s.run w).toState = execute s.toState w := by
  induction w generalizing s with
  | nil => rfl
  | cons v vs ih => simpa only [run, execute, addVisit_toState] using ih (s.addVisit v)

def EdgeClaim (s : FiniteState) (v : Int) : Prop :=
  s.front ≤ v ∧ ¬s.toState.used v ∧ SmallStep s.current v ∧
    ∀ i : Fin (v - s.front).toNat,
      let w := s.front + (i.val : Int)
      (w - s.current).natAbs < 343 ∧ (s.toState.used w ∨ ¬SmallStep s.current w)

instance (s : FiniteState) (v : Int) : Decidable (s.EdgeClaim v) :=
  inferInstanceAs (Decidable (s.front ≤ v ∧ ¬s.toState.used v ∧ SmallStep s.current v ∧
    ∀ i : Fin (v - s.front).toNat,
      (s.front + (i.val : Int) - s.current).natAbs < 343 ∧
      (s.toState.used (s.front + (i.val : Int)) ∨ ¬SmallStep s.current (s.front + (i.val : Int)))))

def edgeCheck (s : FiniteState) (v : Int) : Bool := decide (s.EdgeClaim v)

theorem edgeCheck_sound {s : FiniteState} {v : Int} (h : s.edgeCheck v = true) :
    Greedy s.toState v := by
  have claim : s.EdgeClaim v := of_decide_eq_true h
  obtain ⟨_, unused, step, excludes⟩ := claim
  refine ⟨unused, smallStep_sound step, ?_⟩
  intro w hw hs
  by_cases hvw : v ≤ w
  · exact hvw
  · have lower : s.front ≤ w := by
      by_cases hl : s.front ≤ w
      · exact hl
      · exact False.elim (hw (Or.inl (by omega)))
    have idx : (w - s.front).toNat < (v - s.front).toNat := by omega
    let i : Fin (v - s.front).toNat := ⟨(w - s.front).toNat, idx⟩
    have value : s.front + (i.val : Int) = w := by dsimp [i]; omega
    have check := excludes i
    dsimp only at check
    rw [value] at check
    rcases check.2 with occupied | noStep
    · exact False.elim (hw occupied)
    · exact False.elim (noStep (smallStep_complete hs check.1))

def wordCheck (s : FiniteState) : List Int → Bool
  | [] => true
  | v :: vs => s.edgeCheck v && wordCheck (s.addVisit v) vs

theorem wordCheck_sound {s : FiniteState} {w : List Int} (h : s.wordCheck w = true) :
    ValidWord s.toState w := by
  induction w generalizing s with
  | nil => trivial
  | cons v vs ih =>
    have both : s.edgeCheck v = true ∧ (s.addVisit v).wordCheck vs = true := by
      simpa only [wordCheck, Bool.and_eq_true] using h
    refine ⟨edgeCheck_sound both.1, ?_⟩
    rw [← addVisit_toState]
    exact ih both.2

/-- Outside the finite comparison window both predicates are determined. -/
def EqualityClaim (s t : FiniteState) (lo hi : Int) : Prop :=
  s.current = t.current ∧ lo ≤ s.front ∧ lo ≤ t.front ∧
    s.front ≤ hi ∧ t.front ≤ hi ∧
    (∀ x ∈ s.points, x < hi) ∧ (∀ x ∈ t.points, x < hi) ∧
    ∀ i : Fin (hi - lo).toNat,
      s.toState.used (lo + (i.val : Int)) ↔ t.toState.used (lo + (i.val : Int))

instance (s t : FiniteState) (lo hi : Int) : Decidable (s.EqualityClaim t lo hi) :=
  inferInstanceAs (Decidable (s.current = t.current ∧ lo ≤ s.front ∧ lo ≤ t.front ∧
    s.front ≤ hi ∧ t.front ≤ hi ∧
    (∀ x ∈ s.points, x < hi) ∧ (∀ x ∈ t.points, x < hi) ∧
    ∀ i : Fin (hi - lo).toNat,
      s.toState.used (lo + (i.val : Int)) ↔ t.toState.used (lo + (i.val : Int))))

def equalityCheck (s t : FiniteState) (lo hi : Int) : Bool :=
  decide (s.EqualityClaim t lo hi)

theorem equalityCheck_sound {s t : FiniteState} {lo hi : Int}
    (h : s.equalityCheck t lo hi = true) : s.toState = t.toState := by
  have claim : s.EqualityClaim t lo hi := of_decide_eq_true h
  obtain ⟨cur, slo, tlo, shi, thi, sp, tp, eqs⟩ := claim
  apply state_ext cur
  intro x
  by_cases below : x < lo
  · have su : s.toState.used x := Or.inl (by omega)
    have tu : t.toState.used x := Or.inl (by omega)
    exact ⟨fun _ => tu, fun _ => su⟩
  · by_cases inside : x < hi
    · have idx : (x - lo).toNat < (hi - lo).toNat := by omega
      let i : Fin (hi - lo).toNat := ⟨(x - lo).toNat, idx⟩
      have value : lo + (i.val : Int) = x := by dsimp [i]; omega
      simpa only [value] using eqs i
    · have ns : ¬s.toState.used x := by
        intro used
        rcases used with hfront | hpoint
        · omega
        · have bound := sp x hpoint; omega
      have nt : ¬t.toState.used x := by
        intro used
        rcases used with hfront | hpoint
        · omega
        · have bound := tp x hpoint; omega
      simp [ns, nt]

def shift (s : FiniteState) (d : Int) : FiniteState :=
  ⟨s.current + d, s.front + d, s.points.map (fun x => x + d)⟩

theorem shift_toState (s : FiniteState) (d : Int) :
    (s.shift d).toState = translate d s.toState := by
  apply state_ext
  · rfl
  · intro x
    change (x < s.front + d ∨ x ∈ s.points.map (fun y => y + d)) ↔
      (x - d < s.front ∨ x - d ∈ s.points)
    constructor
    · intro hx
      rcases hx with hfront | hpoint
      · left; omega
      · right
        obtain ⟨y, hy, heq⟩ := List.mem_map.mp hpoint
        have value : x - d = y := by omega
        rw [value]; exact hy
    · intro hx
      rcases hx with hfront | hpoint
      · left; omega
      · right
        exact List.mem_map.mpr ⟨x - d, hpoint, by omega⟩

def markPoint (s : FiniteState) (p : Int) : FiniteState :=
  ⟨s.current, s.front, p :: s.points⟩

theorem markPoint_toState (s : FiniteState) (p : Int) :
    (s.markPoint p).toState = mark s.toState (fun x => x = p) := by
  apply state_ext
  · rfl
  · intro x
    simp [markPoint, toState, mark, or_left_comm, or_comm]

end FiniteState
end Heraclitus
