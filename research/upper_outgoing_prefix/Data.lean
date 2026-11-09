import AllPhases
import ActualInner
import research.upper_machine_audit.TargetContract

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperOutgoingPrefix
open OutgoingWord UpperPhaseBridge

def RowBounds (r : CertifiedRow) : Prop :=
  r.inner.moves.length ≤ 512 ∧ r.row.phases.size ≤ 512 ∧
  (-512 ≤ r.inner.initial.current ∧ r.inner.initial.current ≤ 512) ∧
  ∀ j : Fin r.row.phases.size, r.row.front+r.row.model.current j ≤ 2000
instance (r : CertifiedRow) : Decidable (RowBounds r) := by
  unfold RowBounds
  infer_instance

theorem all_row_bounds : ∀ i : Fin 36, RowBounds (phase i).entrance.outgoing := by decide

end Heraclitus.UpperOutgoingPrefix
#print axioms Heraclitus.UpperOutgoingPrefix.all_row_bounds
