import research.physical_tail.PhysicalTail
set_option autoImplicit false

/-! Exact counting of the actual walk, including every visited point beyond
the cutoff. No hypothesis about return geometry or tail size is used. -/
namespace Heraclitus.PhysicalCounting
open PhysicalTail GlobalWalk

def history (a : Nat → Int) (n : Nat) : List Int :=
  (List.range (n+1)).map a

def outside (a : Nat → Int) (n D : Nat) : List Int :=
  (history a n).filter (fun x => decide (D < x.natAbs))

def outsideCount (a : Nat → Int) (n D : Nat) : Nat :=
  (outside a n D).length

theorem history_mem (a : Nat → Int) (n : Nat) (x : Int) :
    x ∈ history a n ↔ (stateAt a n).used x := by
  simp [history, stateAt, List.mem_map, List.mem_range, Nat.lt_succ_iff]

theorem history_nodup (a : Nat → Int) (walk : IsWalk a) (n : Nat) :
    (history a n).Nodup := by
  exact List.Pairwise.map a (fun _ _ ne eq => ne (walk_injective a walk eq))
    List.nodup_range

theorem outside_mem (a : Nat → Int) (n D : Nat) (x : Int) :
    x ∈ outside a n D ↔ (stateAt a n).used x ∧ D < x.natAbs := by
  simp [outside, history_mem]

theorem outside_nodup (a : Nat → Int) (walk : IsWalk a) (n D : Nat) :
    (outside a n D).Nodup :=
  List.Pairwise.filter _ (history_nodup a walk n)

/-- A cover at a later checkpoint bounds the outside count at every earlier
index. This uses complete used-set membership, not just the current point. -/
theorem outside_le_later_cover (a : Nat → Int) (walk : IsWalk a)
    (n N D : Nat) (before : n ≤ N) (cover : List Int)
    (covers : ∀ x, (stateAt a N).used x → D < x.natAbs → x ∈ cover) :
    outsideCount a n D ≤ cover.length := by
  apply (outside_nodup a walk n D).length_le_of_subset
  intro x hx
  obtain ⟨⟨i, hi, hx⟩, far⟩ := (outside_mem a n D x).mp hx
  exact covers x ⟨i, by omega, hx⟩ far

/-- Capacity of the opposite ray through D, zero, and the current ray
through radius r. Duplicate entries would only weaken this upper bound. -/
def centralCover (positive : Bool) (D r : Nat) : List Int :=
  ((List.range (D+1)).map (fun i : Nat =>
    if positive then -(i : Int) else (i : Int))) ++
  ((List.range r).map (fun i : Nat =>
    if positive then (i : Int)+1 else -((i : Int)+1)))

theorem centralCover_length (p : Bool) (D r : Nat) :
    (centralCover p D r).length = D+r+1 := by
  simp [centralCover]; omega

theorem centralCover_mem (p : Bool) (D r : Nat) (x : Int)
    (inside : x.natAbs ≤ D)
    (near : (p = true → x ≤ (r : Int)) ∧
      (p = false → -(r : Int) ≤ x)) :
    x ∈ centralCover p D r := by
  cases p with
  | false =>
    simp only [centralCover, Bool.false_eq_true, ↓reduceIte, List.mem_append,
      List.mem_map, List.mem_range]
    by_cases pos : 0 ≤ x
    · left
      refine ⟨x.natAbs, by omega, ?_⟩
      exact Int.natAbs_of_nonneg pos
    · right
      refine ⟨(-x-1).toNat, ?_, ?_⟩
      · have h := near.2 rfl; omega
      · omega
  | true =>
    simp only [centralCover, ↓reduceIte, List.mem_append,
      List.mem_map, List.mem_range]
    by_cases neg : x ≤ 0
    · left
      refine ⟨x.natAbs, by omega, ?_⟩
      have h := Int.natAbs_of_nonneg (show 0 ≤ -x by omega)
      rw [Int.natAbs_neg] at h
      omega
    · right
      refine ⟨(x-1).toNat, ?_, ?_⟩
      · have h := near.1 rfl; omega
      · omega

/-- Exact physical counting inequality. All n+1 distinct visited points
are covered by D+|a(n)|+1 central points, the actual same-side tail, and
the actual outside points. It includes the origin case n=0. -/
theorem walk_count (a : Nat → Int) (walk : IsWalk a) (n D : Nat) :
    n ≤ D + (a n).natAbs + count a n D + outsideCount a n D := by
  by_cases zero : a n = 0
  · have hn : n = 0 := walk_injective a walk (zero.trans walk.1.symm)
    omega
  let p : Bool := decide (0 < a n)
  let cover := centralCover p D (a n).natAbs ++ points a n D ++ outside a n D
  have sub : history a n ⊆ cover := by
    intro x hx
    have used := (history_mem a n x).mp hx
    simp only [cover, List.mem_append]
    by_cases far : D < x.natAbs
    · exact Or.inr ((outside_mem a n D x).mpr ⟨used, far⟩)
    by_cases tail : SameSide x (a n) ∧ (a n).natAbs < x.natAbs
    · exact Or.inl (Or.inr ((points_mem a n D x).mpr ⟨used, tail.1, tail.2, by omega⟩))
    apply Or.inl; apply Or.inl
    apply centralCover_mem p D (a n).natAbs x (by omega)
    constructor
    · intro hp
      have apos : 0 < a n := by simpa [p] using hp
      by_cases xpos : 0 < x
      · have same : SameSide x (a n) := Or.inl ⟨xpos, apos⟩
        have small : x.natAbs ≤ (a n).natAbs := Nat.le_of_not_gt (fun h => tail ⟨same, h⟩)
        have absx := Int.natAbs_of_nonneg (show 0 ≤ x by omega)
        omega
      · omega
    · intro hp
      have aneg : a n < 0 := by
        have h : ¬0 < a n := by simpa [p] using hp
        omega
      by_cases xneg : x < 0
      · have same : SameSide x (a n) := Or.inr ⟨xneg, aneg⟩
        have small : x.natAbs ≤ (a n).natAbs := Nat.le_of_not_gt (fun h => tail ⟨same, h⟩)
        have absx := Int.natAbs_of_nonneg (show 0 ≤ -x by omega)
        rw [Int.natAbs_neg] at absx
        omega
      · omega
  have bound := (history_nodup a walk n).length_le_of_subset sub
  simp only [history, List.length_map, List.length_range, cover,
    List.length_append, centralCover_length] at bound
  unfold count outsideCount
  omega

theorem walk_count_later_cover (a : Nat → Int) (walk : IsWalk a)
    (n N D : Nat) (before : n ≤ N) (cover : List Int)
    (covers : ∀ x, (stateAt a N).used x → D < x.natAbs → x ∈ cover) :
    n ≤ D + (a n).natAbs + count a n D + cover.length := by
  have h := walk_count a walk n D
  have q := outside_le_later_cover a walk n N D before cover covers
  omega

end Heraclitus.PhysicalCounting
#print axioms Heraclitus.PhysicalCounting.outside_le_later_cover
#print axioms Heraclitus.PhysicalCounting.walk_count
#print axioms Heraclitus.PhysicalCounting.walk_count_later_cover
