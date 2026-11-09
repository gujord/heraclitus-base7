import Heraclitus.GlobalWalk
set_option autoImplicit false

/-! Finite, duplicate-free enumeration of the actual same-side tail.
No bound on its length is assumed or proved here. -/
namespace Heraclitus.PhysicalTail

def SameSide (x y : Int) : Prop := (0 < x ∧ 0 < y) ∨ (x < 0 ∧ y < 0)
instance (x y : Int) : Decidable (SameSide x y) := by unfold SameSide; infer_instance

def points (a : Nat → Int) (n D : Nat) : List Int :=
  ((List.range (n+1)).map a).filter (fun x =>
    decide (SameSide x (a n) ∧ (a n).natAbs < x.natAbs ∧ x.natAbs ≤ D))

def count (a : Nat → Int) (n D : Nat) : Nat := (points a n D).length

theorem points_mem (a : Nat → Int) (n D : Nat) (x : Int) :
    x ∈ points a n D ↔ (GlobalWalk.stateAt a n).used x ∧
      SameSide x (a n) ∧ (a n).natAbs < x.natAbs ∧ x.natAbs ≤ D := by
  simp [points, GlobalWalk.stateAt, List.mem_filter, List.mem_map,
    List.mem_range, Nat.lt_succ_iff]

theorem points_nodup (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (n D : Nat) :
    (points a n D).Nodup := by
  unfold points
  apply List.Pairwise.filter
  exact List.Pairwise.map a (fun _ _ ne equal => ne (GlobalWalk.walk_injective a walk equal))
    List.nodup_range

/-- A finite cover of the actual tail implies the corresponding numerical
bound. The cover itself is a separate hypothesis. -/
theorem count_le_cover (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (n D : Nat)
    (cover : List Int) (bound : ∀ x, x ∈ points a n D → x ∈ cover) :
    count a n D ≤ cover.length := by
  exact (points_nodup a walk n D).length_le_of_subset bound

end Heraclitus.PhysicalTail
#print axioms Heraclitus.PhysicalTail.points_mem
#print axioms Heraclitus.PhysicalTail.points_nodup
#print axioms Heraclitus.PhysicalTail.count_le_cover
