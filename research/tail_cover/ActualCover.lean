import TailCover
import research.physical_tail.PhysicalTail
set_option autoImplicit false

/-! Conditional bridge from an actual signed walk's finite tail to an active
ray's full-state cover. The signed-ray correspondence and cover remain
explicit hypotheses, not claims about reachability. -/
namespace Heraclitus.ActualTailCover
open Heraclitus TailCover PhysicalTail

def ray (positive : Bool) (x : Int) : Int := if positive then x else -x

theorem ray_injective (p : Bool) {x y : Int} (h : ray p x = ray p y) : x=y := by
  cases p <;> simp [ray] at h <;> omega

theorem actual_tail_from_ray (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (n D : Nat) (p : Bool) (s : State) (F c h shift outer₁ outer₂ : Int)
    (levels : Nat) (B : List Int)
    (side : (p = true ∧ 0 < a n) ∨ (p = false ∧ a n < 0))
    (current : s.current = ray p (a n))
    (ray_current : s.current = F+c)
    (ray_used : ∀ x, (GlobalWalk.stateAt a n).used x → SameSide x (a n) → s.used (ray p x))
    (whole : ∀ x, s.used x →
      x < F ∨ x-F ∈ B ∨ LadderLayers.tower h levels (x-F-shift) ∨
      x-F = outer₁ ∨ x-F = outer₂)
    (local_bound : (localAhead c B).length ≤ 53) :
    count a n D ≤ 55+6*levels := by
  let xs := (points a n D).map (ray p)
  have distinct : xs.Nodup := by
    apply List.pairwise_map.mpr
    apply List.Pairwise.imp _ (points_nodup a walk n D)
    intro x y neq eq
    exact neq (ray_injective p eq)
  have ahead : ∀ x ∈ xs, s.current < x ∧ s.used x := by
    intro x hx
    obtain ⟨y, ym, eq⟩ := List.mem_map.mp hx
    have props := (points_mem a n D y).mp ym
    have hp := props.2.1
    have mag := props.2.2.1
    have use := ray_used y props.1 hp
    subst x
    refine ⟨?_, use⟩
    rw [current]
    cases p with
    | false =>
      have a_neg : a n < 0 := by rcases side with ⟨h,_⟩ | ⟨_,h⟩ <;> simp_all
      have y_neg : y < 0 := by unfold SameSide at hp; omega
      have abs_a := Int.natAbs_of_nonneg (show 0 ≤ -a n by omega)
      have abs_y := Int.natAbs_of_nonneg (show 0 ≤ -y by omega)
      rw [Int.natAbs_neg] at abs_a abs_y
      simp only [ray, Bool.false_eq_true, ↓reduceIte]
      omega
    | true =>
      have a_pos : 0 < a n := by rcases side with ⟨_,h⟩ | ⟨h,_⟩ <;> simp_all
      have y_pos : 0 < y := by unfold SameSide at hp; omega
      have abs_a := Int.natAbs_of_nonneg (show 0 ≤ a n by omega)
      have abs_y := Int.natAbs_of_nonneg (show 0 ≤ y by omega)
      simp only [ray, ↓reduceIte]
      omega
  have hbound := physical_state_tail_53 s F c h shift outer₁ outer₂ levels B xs
    distinct ray_current whole ahead local_bound
  simpa only [xs, List.length_map, count] using hbound

end Heraclitus.ActualTailCover
#print axioms Heraclitus.ActualTailCover.actual_tail_from_ray
