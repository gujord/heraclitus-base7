import BoundaryCatalogue
set_option autoImplicit false

namespace Heraclitus.UpperBoundaryPrefix
open SignedCertificate

/-- All 72 concrete signed boundaries, both inner and outer, at arbitrary
admissible scales and every intermediate actual index. Only the full input
match and scale conditions remain; finite local bounds and signed validity
are supplied by the original checked catalogue. -/
theorem actual_catalogue_boundary_tail (b : CheckedBoundary)
    (member : b ∈ SignedBoundaryData.catalogue)
    (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (base k : Nat) (C : Int)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000≤(7^k : Nat))
    (start : GlobalWalk.stateAt a base=b.initial.toState C)
    (D i : Nat) (hi : i≤b.moves.length) : PhysicalTail.count a (base+i) D≤39 :=
  actual_boundary_tail b 39 (all_boundaries b member) a walk base k C scale large start D i hi

/-- The same boundary word is valid and reaches its exact complete final
state. Its all-prefix physical tail bound is attached to that same word. -/
theorem actual_catalogue_boundary (b : CheckedBoundary)
    (member : b ∈ SignedBoundaryData.catalogue)
    (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (base k : Nat) (C : Int)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000≤(7^k : Nat))
    (start : GlobalWalk.stateAt a base=b.initial.toState C) :
    SignedValidWord (GlobalWalk.stateAt a base) (physicalWord C b.moves) ∧
    GlobalWalk.stateAt a (base+b.moves.length)=b.final.toState C ∧
    ∀ D i, i≤b.moves.length → PhysicalTail.count a (base+i) D≤39 := by
  refine ⟨?_,?_,?_⟩
  · rw [start]
    exact (wordCheck_sound b.initial b.moves b.valid k C scale large).1
  · have state := actual_prefix_state b a walk base k C scale large start b.moves.length (by omega)
    rw [List.take_length] at state
    exact state.trans (Record.equalityCheck_sound _ _ b.closes C)
  · exact fun D i hi => actual_catalogue_boundary_tail b member a walk base k C scale large start D i hi

end Heraclitus.UpperBoundaryPrefix
#print axioms Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary_tail
#print axioms Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary
