import Heraclitus.Markers

set_option autoImplicit false

/-!
Whole-state coupling at every phase of a repeated translation cycle.
The markers are part of the initial used set; this file does not establish
that a concrete signed walk reaches that state or supplies a tail bound.
-/
namespace Heraclitus.ReturnTailCycle

open Heraclitus

/-- At each translated phase, the complete used set is exactly the
translated phase state union the original fixed marker set. -/
theorem marked_cycle_phase (s : State) (w pre : List Int) (d : Int)
    (markers : Int → Prop) (q : Nat)
    (valid : ValidWord s w) (closes : execute s w = translate d s) :
    execute (mark s markers)
      (repeatedWord w d q ++ pre.map (fun x => x + (q : Int) * d)) =
      mark (translate ((q : Int) * d) (execute s pre)) markers := by
  rw [execute_mark, execute_append, (translation_cycle valid closes q).2,
      execute_translate]

/-- The exact current and membership assertions expose the two components
needed for physical-set and tail accounting. -/
theorem marked_cycle_phase_components (s : State) (w pre : List Int) (d : Int)
    (markers : Int → Prop) (q : Nat)
    (valid : ValidWord s w) (closes : execute s w = translate d s) :
    let st := execute (mark s markers)
      (repeatedWord w d q ++ pre.map (fun x => x + (q : Int) * d))
    st.current = (execute s pre).current + (q : Int) * d ∧
      ∀ x, st.used x ↔ (execute s pre).used (x - (q : Int) * d) ∨ markers x := by
  dsimp only
  rw [marked_cycle_phase s w pre d markers q valid closes]
  exact ⟨rfl, fun _ => Iff.rfl⟩

/-- If the comparison word avoids the fixed markers, it is also a legal
marked half-line word. The marker avoidance is an explicit hypothesis. -/
theorem marked_cycle_phase_valid (s : State) (w pre : List Int) (d : Int)
    (markers : Int → Prop) (q : Nat)
    (valid : ValidWord s w) (closes : execute s w = translate d s)
    (pre_valid : ValidWord s pre)
    (avoid : ∀ x ∈ repeatedWord w d q ++
      pre.map (fun x => x + (q : Int) * d), ¬ markers x) :
    ValidWord (mark s markers) (repeatedWord w d q ++
      pre.map (fun x => x + (q : Int) * d)) := by
  apply validWord_mark _ avoid
  apply (validWord_append _ _ _).mpr
  refine ⟨(translation_cycle valid closes q).1, ?_⟩
  rw [(translation_cycle valid closes q).2]
  exact validWord_translate _ pre_valid

end Heraclitus.ReturnTailCycle

#print axioms Heraclitus.ReturnTailCycle.marked_cycle_phase
#print axioms Heraclitus.ReturnTailCycle.marked_cycle_phase_components

#print axioms Heraclitus.ReturnTailCycle.marked_cycle_phase_valid
