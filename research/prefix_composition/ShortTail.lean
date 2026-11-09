import Heraclitus.SignedBottom

set_option autoImplicit false

/-! Explicit all-prefix used-set cover for the phase-43 short half-line word.
No cardinality theorem or global 3/8 upper bound is claimed. -/
namespace Heraclitus.ShortTail43

open Heraclitus.ReturnBridge

/-- Every used coordinate ahead of the current coordinate at any of the
three states of the short word belongs to this four-element cover. -/
theorem prefix_ahead_cover (m : Int) (large : 1 ≤ m) (i : Nat) (ib : i ≤ 2) :
    let st := execute (checkpoint ⟨1, []⟩ m 2).toState ([2, 1].take i)
    ∀ x, st.current < x → st.used x →
      x = m+2 ∨ x = 2*m+2 ∨ x = 3*m+2 ∨ x = 2 := by
  have cases : i=0 ∨ i=1 ∨ i=2 := by omega
  rcases cases with rfl | rfl | rfl <;>
    simp only [List.take_zero, List.take_succ_cons, List.take_nil,
      execute, visit, checkpoint, FiniteState.toState, List.append_nil,
      List.mem_cons, List.not_mem_nil, or_false] <;>
    intro x ahead used <;> omega

/-- The cover applies to the exact valid phase-43 short half-line path. -/
theorem certified_short_prefix_cover (k : Nat) (large : 100000 ≤ (7^k : Nat)) :
    ValidWord (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState [2, 1] ∧
    ∀ i, i ≤ 2 → ∀ x,
      let st := execute (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState ([2,1].take i)
      st.current < x → st.used x →
        x = (7^k : Nat)+2 ∨ x = 2*(7^k : Nat)+2 ∨
        x = 3*(7^k : Nat)+2 ∨ x = 2 := by
  refine ⟨(SignedBottom.short_half k large).1, ?_⟩
  intro i ib x
  exact prefix_ahead_cover (7^k : Nat) (by omega) i ib x

/-- Any duplicate-free enumeration of used points ahead has at most four
entries. No assumption that such a list is an exhaustive enumeration is
needed for this upper bound. -/
theorem prefix_ahead_count (m : Int) (large : 1 ≤ m) (i : Nat) (ib : i ≤ 2)
    (xs : List Int) (nodup : xs.Nodup)
    (ahead : ∀ x ∈ xs,
      let st := execute (checkpoint ⟨1, []⟩ m 2).toState ([2, 1].take i)
      st.current < x ∧ st.used x) : xs.length ≤ 4 := by
  have sub : xs ⊆ [m+2, 2*m+2, 3*m+2, 2] := by
    intro x hx
    have h := ahead x hx
    have cover := prefix_ahead_cover m large i ib x h.1 h.2
    simp only [List.mem_cons, List.not_mem_nil, or_false]
    exact cover
  have result := nodup.length_le_of_subset sub
  simpa only [List.length_cons, List.length_nil] using result

/-- The physical point on the active ray has exactly the half-line used
status; the opposite ray remains distinct. -/
theorem lifted_ray_used (side : Bool) (C : Int) (other : RayBoundary)
    (s : State) (x : Int) (positive : 0 < C+x) :
    (OutgoingWord.liftRay side C other s).used (embedRay side C x) ↔ s.used x := by
  cases side
  · have hne : -(C+x) ≠ 0 := by omega
    have hn : ¬ C+x < 0 := by omega
    have eq : C+x-C=x := by omega
    change (-(C+x)=0 ∨ (0 < -(C+x) ∧ boundaryUsed other (-(C+x)-C)) ∨
      (-(C+x)<0 ∧ s.used (-(-(C+x))-C))) ↔ s.used x
    simp [hne, hn, positive, eq]
  · have hne : C+x ≠ 0 := by omega
    have hn : ¬ C+x < 0 := by omega
    have eq : C+x-C=x := by omega
    change (C+x=0 ∨ (0<C+x ∧ s.used (C+x-C)) ∨
      (C+x<0 ∧ boundaryUsed other (-(C+x)-C))) ↔ s.used x
    simp [hne, hn, positive, eq]

end Heraclitus.ShortTail43
#print axioms Heraclitus.ShortTail43.prefix_ahead_cover
#print axioms Heraclitus.ShortTail43.certified_short_prefix_cover

#print axioms Heraclitus.ShortTail43.prefix_ahead_count

#print axioms Heraclitus.ShortTail43.lifted_ray_used
