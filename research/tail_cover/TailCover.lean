import TowerCardinality
set_option autoImplicit false

/-! A normalized physical used-set cover implies a numeric tail bound.
Actual signed path reachability and the cover hypothesis remain separate. -/
namespace Heraclitus.TailCover
open Heraclitus LadderLayers ReturnTailTower

def localAhead (c : Int) (B : List Int) : List Int :=
  (List.range ((-c-1).toNat)).map (fun i : Nat => c+1+(i : Int)) ++
    B.filter (fun b => decide (c < b))

theorem localAhead_mem (c x : Int) (B : List Int)
    (ahead : c < x) (local_used : x < 0 ∨ x ∈ B) :
    x ∈ localAhead c B := by
  unfold localAhead
  rw [List.mem_append]
  rcases local_used with low | extra
  · left
    apply List.mem_map.mpr
    refine ⟨(x-c-1).toNat, ?_, ?_⟩
    · apply List.mem_range.mpr
      omega
    · omega
  · right
    simp only [List.mem_filter, decide_eq_true_eq]
    exact ⟨extra, ahead⟩

theorem localAhead_length (c : Int) (B : List Int) :
    (localAhead c B).length = (-c-1).toNat + (B.filter (fun b => decide (c < b))).length := by
  simp [localAhead]

/-- If the physical occupied ray is contained in a local prefix with extras,
plus a translated tower and two further marked points, every distinct list
of points ahead has the displayed upper bound. All overlap is harmless. -/
theorem physical_tail_cover (c h shift outer₁ outer₂ : Int)
    (levels : Nat) (B xs : List Int) (distinct : xs.Nodup)
    (physical : ∀ x ∈ xs, c < x ∧
       (x < 0 ∨ x ∈ B ∨ tower h levels (x-shift) ∨ x = outer₁ ∨ x = outer₂)) :
    xs.length ≤ (localAhead c B).length + 6*levels + 2 := by
  let cover := localAhead c B ++ (towerPoints h levels).map (fun x => x+shift) ++ [outer₁,outer₂]
  have subset : xs ⊆ cover := by
    intro x hx
    obtain ⟨ahead, used⟩ := physical x hx
    simp only [cover, List.mem_append, List.mem_map, List.mem_cons, List.not_mem_nil, or_false]
    rcases used with low | extra | tw | one | two
    · exact Or.inl (Or.inl (localAhead_mem c x B ahead (Or.inl low)))
    · exact Or.inl (Or.inl (localAhead_mem c x B ahead (Or.inr extra)))
    · apply Or.inl; apply Or.inr
      exact ⟨x-shift, (towerPoints_exact h (x-shift) levels).mp tw, by omega⟩
    · exact Or.inr (Or.inl one)
    · exact Or.inr (Or.inr two)
  have bound := distinct.length_le_of_subset subset
  simp only [cover, List.length_append, List.length_map, towerPoints_length,
    List.length_cons, List.length_nil] at bound
  omega

/-- Concrete whole-state form, for a half-line state already expressed in
physical ray coordinates. The whole-state cover and the identification of
this ray with the signed walk are explicit hypotheses, not proved here. -/
theorem physical_state_tail_cover (s : State) (F c h shift outer₁ outer₂ : Int)
    (levels : Nat) (B xs : List Int) (distinct : xs.Nodup)
    (current : s.current = F+c)
    (whole : ∀ x, s.used x →
      x < F ∨ x-F ∈ B ∨ tower h levels (x-F-shift) ∨
      x-F = outer₁ ∨ x-F = outer₂)
    (ahead : ∀ x ∈ xs, s.current < x ∧ s.used x) :
    xs.length ≤ (localAhead c B).length + 6*levels + 2 := by
  let ys := xs.map (fun x => x-F)
  have nd : ys.Nodup := by
    apply List.pairwise_map.mpr
    apply List.Pairwise.imp _ distinct
    intro a b neq eq
    apply neq
    omega
  have hp : ∀ x ∈ ys, c < x ∧
      (x < 0 ∨ x ∈ B ∨ tower h levels (x-shift) ∨ x=outer₁ ∨ x=outer₂) := by
    intro x hx
    obtain ⟨y, ym, eq⟩ := List.mem_map.mp hx
    have hy := ahead y ym
    have hu := whole y hy.2
    subst x
    constructor
    · rw [current] at hy
      omega
    · rcases hu with low | extra | towered | one | two
      · exact Or.inl (by omega)
      · exact Or.inr (Or.inl extra)
      · exact Or.inr (Or.inr (Or.inl towered))
      · exact Or.inr (Or.inr (Or.inr (Or.inl one)))
      · exact Or.inr (Or.inr (Or.inr (Or.inr two)))
  have bound := physical_tail_cover c h shift outer₁ outer₂ levels B ys nd hp
  simpa only [ys, List.length_map] using bound

/-- Explicit instance with the finite local bound found in the scanned
catalogue. The numerical catalogue bound is a hypothesis. -/
theorem physical_state_tail_53 (s : State) (F c h shift outer₁ outer₂ : Int)
    (levels : Nat) (B xs : List Int) (distinct : xs.Nodup)
    (current : s.current = F+c)
    (whole : ∀ x, s.used x →
      x < F ∨ x-F ∈ B ∨ tower h levels (x-F-shift) ∨
      x-F = outer₁ ∨ x-F = outer₂)
    (ahead : ∀ x ∈ xs, s.current < x ∧ s.used x)
    (local_bound : (localAhead c B).length ≤ 53) :
    xs.length ≤ 55 + 6*levels := by
  have h := physical_state_tail_cover s F c h shift outer₁ outer₂ levels B xs
    distinct current whole ahead
  omega

end Heraclitus.TailCover
#print axioms Heraclitus.TailCover.localAhead_mem
#print axioms Heraclitus.TailCover.physical_tail_cover

#print axioms Heraclitus.TailCover.physical_state_tail_cover

#print axioms Heraclitus.TailCover.physical_state_tail_53
