-- Generated proof goals; original record updates are checked by Lean.
import BoundaryCore
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperBoundaryPrefix
open SignedBoundaryData

theorem row40_inner_bound : AllGood 39 row40_inner.initial row40_inner.moves := by decide +kernel
#print axioms row40_inner_bound

theorem row40_outer_bound : AllGood 39 row40_outer.initial row40_outer.moves := by decide +kernel
#print axioms row40_outer_bound

theorem row41_inner_bound : AllGood 39 row41_inner.initial row41_inner.moves := by decide +kernel
#print axioms row41_inner_bound

theorem row41_outer_bound : AllGood 39 row41_outer.initial row41_outer.moves := by decide +kernel
#print axioms row41_outer_bound

theorem row42_inner_bound : AllGood 39 row42_inner.initial row42_inner.moves := by decide +kernel
#print axioms row42_inner_bound

theorem row42_outer_bound : AllGood 39 row42_outer.initial row42_outer.moves := by decide +kernel
#print axioms row42_outer_bound

end Heraclitus.UpperBoundaryPrefix
