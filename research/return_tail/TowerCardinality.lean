import Heraclitus.LadderLayers

set_option autoImplicit false

/-! Finite cover for the tower of already marked points. This theorem does
not identify a tower with the used points of any actual signed walk. -/
namespace Heraclitus.ReturnTailTower
open Heraclitus LadderLayers

def towerPoints (h : Int) : Nat → List Int
  | 0 => []
  | n+1 => [h, 2*h, 3*h, 4*h, 5*h, 6*h] ++
      (towerPoints (7*h) n).map (fun x => x + 6*h)

theorem towerPoints_length (h : Int) (n : Nat) :
    (towerPoints h n).length = 6*n := by
  induction n generalizing h with
  | zero => simp [towerPoints]
  | succ n ih => simp [towerPoints, ih, Nat.mul_succ]

theorem towerPoints_exact (h x : Int) (n : Nat) :
    tower h n x ↔ x ∈ towerPoints h n := by
  induction n generalizing h x with
  | zero => simp [tower, towerPoints]
  | succ n ih =>
    rw [tower, pending_six, towerPoints, List.mem_append]
    simp only [List.mem_cons, List.not_mem_nil, or_false, List.mem_map]
    rw [ih]
    constructor
    · intro hh
      rcases hh with a | a | a | a | a | a | a
      · exact Or.inl (by simp [a])
      · exact Or.inl (by simp [a])
      · exact Or.inl (by simp [a])
      · exact Or.inl (by simp [a])
      · exact Or.inl (by simp [a])
      · exact Or.inl (by simp [a])
      · exact Or.inr ⟨x-6*h, a, by omega⟩
    · intro hh
      rcases hh with a | ⟨y, hy, eq⟩
      · rcases a with a | a | a | a | a | a <;> simp [a]
      · right; right; right; right; right; right
        have e : x - 6*h = y := by omega
        simpa [e] using hy

/-- Any duplicate-free list of positions drawn from the tower has at most
six entries per layer, even if the complete tower list contains duplicates. -/
theorem tower_count_bound (h : Int) (n : Nat) (xs : List Int)
    (distinct : xs.Nodup) (inside : ∀ x ∈ xs, tower h n x) :
    xs.length ≤ 6*n := by
  have subset : xs ⊆ towerPoints h n := by
    intro x hx
    exact (towerPoints_exact h x n).mp (inside x hx)
  have hlen := distinct.length_le_of_subset subset
  simpa only [towerPoints_length] using hlen

end Heraclitus.ReturnTailTower
#print axioms Heraclitus.ReturnTailTower.towerPoints_length
#print axioms Heraclitus.ReturnTailTower.towerPoints_exact

#print axioms Heraclitus.ReturnTailTower.tower_count_bound
