import Heraclitus.FiniteBaseData
import Heraclitus.ScaleScheduleData

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

/-! Unconditional coverage of the exact base-seven signed greedy walk.
The base and every phase transition are concrete proved blocks. -/

namespace Heraclitus.Coverage
open GlobalWalk ScaleInduction

def base : SignedBlock signedStart (ScaleScheduleData.schedule.boundary 0) where
  word := FiniteBaseData.base.word
  valid := FiniteBaseData.base.valid
  endpoint := FiniteBaseData.base.endpoint.trans ScaleScheduleData.initial_boundary.symm

theorem base_length : base.word.length=7^6 := FiniteBaseData.base_length

noncomputable def plan : Plan := ScaleScheduleData.schedule.plan base base_length

theorem filled : Filled plan := ScaleScheduleData.schedule.filled base base_length

/-- The canonical exact walk visits every integer exactly once. -/
theorem canonical_coverage : ∀ x : Int, ∃ i : Nat,
    sequence i=x ∧ ∀ j, sequence j=x → j=i := plan.canonical_coverage filled

/-- The statement applies to any sequence satisfying the original exact rule. -/
theorem all_walks (a : Nat → Int) (walk : IsWalk a) :
    ∀ x : Int, ∃ i : Nat, a i=x ∧ ∀ j, a j=x → j=i := plan.exactly_once filled a walk

theorem canonical_checkpoint (n : Nat) : stateAt sequence (7^(n+6))=
    ScaleScheduleData.schedule.boundary n := plan.reaches sequence sequence_isWalk n

theorem visited_interval (n : Nat) (x : Int)
    (low : -radius (n+6)+37 ≤ x) (high : x ≤ radius (n+6)-37) :
    ∃ i : Nat, i ≤ 7^(n+6) ∧ sequence i=x :=
  (plan.visited_iff sequence sequence_isWalk n x).mp (filled n x low high)

end Heraclitus.Coverage
