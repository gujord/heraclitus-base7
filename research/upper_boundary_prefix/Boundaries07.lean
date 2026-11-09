-- Generated proof goals; original record updates are checked by Lean.
import BoundaryCore
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperBoundaryPrefix
open SignedBoundaryData

theorem row61_inner_bound : AllGood 39 row61_inner.initial row61_inner.moves := by decide +kernel
#print axioms row61_inner_bound

theorem row61_outer_bound : AllGood 39 row61_outer.initial row61_outer.moves := by decide +kernel
#print axioms row61_outer_bound

theorem row62_inner_bound : AllGood 39 row62_inner.initial row62_inner.moves := by decide +kernel
#print axioms row62_inner_bound

theorem row62_outer_bound : AllGood 39 row62_outer.initial row62_outer.moves := by decide +kernel
#print axioms row62_outer_bound

theorem row63_inner_bound : AllGood 39 row63_inner.initial row63_inner.moves := by decide +kernel
#print axioms row63_inner_bound

theorem row63_outer_bound : AllGood 39 row63_outer.initial row63_outer.moves := by decide +kernel
#print axioms row63_outer_bound

end Heraclitus.UpperBoundaryPrefix
