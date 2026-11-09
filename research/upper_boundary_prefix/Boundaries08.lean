-- Generated proof goals; original record updates are checked by Lean.
import BoundaryCore
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperBoundaryPrefix
open SignedBoundaryData

theorem row64_inner_bound : AllGood 39 row64_inner.initial row64_inner.moves := by decide +kernel
#print axioms row64_inner_bound

theorem row64_outer_bound : AllGood 39 row64_outer.initial row64_outer.moves := by decide +kernel
#print axioms row64_outer_bound

theorem row65_inner_bound : AllGood 39 row65_inner.initial row65_inner.moves := by decide +kernel
#print axioms row65_inner_bound

theorem row65_outer_bound : AllGood 39 row65_outer.initial row65_outer.moves := by decide +kernel
#print axioms row65_outer_bound

theorem row66_inner_bound : AllGood 39 row66_inner.initial row66_inner.moves := by decide +kernel
#print axioms row66_inner_bound

theorem row66_outer_bound : AllGood 39 row66_outer.initial row66_outer.moves := by decide +kernel
#print axioms row66_outer_bound

end Heraclitus.UpperBoundaryPrefix
