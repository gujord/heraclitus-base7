-- Generated finite catalogue assembly.
import Boundaries00
import Boundaries01
import Boundaries02
import Boundaries03
import Boundaries04
import Boundaries05
import Boundaries06
import Boundaries07
import Boundaries08
import Boundaries09
import Boundaries10
import Boundaries11
set_option autoImplicit false
namespace Heraclitus.UpperBoundaryPrefix
open SignedCertificate SignedBoundaryData

theorem all_boundaries : ∀ b ∈ SignedBoundaryData.catalogue, AllGood 39 b.initial b.moves := by
  intro b hb
  simp only [SignedBoundaryData.catalogue,List.mem_cons,List.not_mem_nil,or_false] at hb
  rcases hb with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact row40_inner_bound
  · exact row40_outer_bound
  · exact row41_inner_bound
  · exact row41_outer_bound
  · exact row42_inner_bound
  · exact row42_outer_bound
  · exact row43_inner_bound
  · exact row43_outer_bound
  · exact row44_inner_bound
  · exact row44_outer_bound
  · exact row45_inner_bound
  · exact row45_outer_bound
  · exact row46_inner_bound
  · exact row46_outer_bound
  · exact row47_inner_bound
  · exact row47_outer_bound
  · exact row48_inner_bound
  · exact row48_outer_bound
  · exact row49_inner_bound
  · exact row49_outer_bound
  · exact row50_inner_bound
  · exact row50_outer_bound
  · exact row51_inner_bound
  · exact row51_outer_bound
  · exact row52_inner_bound
  · exact row52_outer_bound
  · exact row53_inner_bound
  · exact row53_outer_bound
  · exact row54_inner_bound
  · exact row54_outer_bound
  · exact row55_inner_bound
  · exact row55_outer_bound
  · exact row56_inner_bound
  · exact row56_outer_bound
  · exact row57_inner_bound
  · exact row57_outer_bound
  · exact row58_inner_bound
  · exact row58_outer_bound
  · exact row59_inner_bound
  · exact row59_outer_bound
  · exact row60_inner_bound
  · exact row60_outer_bound
  · exact row61_inner_bound
  · exact row61_outer_bound
  · exact row62_inner_bound
  · exact row62_outer_bound
  · exact row63_inner_bound
  · exact row63_outer_bound
  · exact row64_inner_bound
  · exact row64_outer_bound
  · exact row65_inner_bound
  · exact row65_outer_bound
  · exact row66_inner_bound
  · exact row66_outer_bound
  · exact row67_inner_bound
  · exact row67_outer_bound
  · exact row68_inner_bound
  · exact row68_outer_bound
  · exact row69_inner_bound
  · exact row69_outer_bound
  · exact row70_inner_bound
  · exact row70_outer_bound
  · exact row71_inner_bound
  · exact row71_outer_bound
  · exact row72_inner_bound
  · exact row72_outer_bound
  · exact row73_inner_bound
  · exact row73_outer_bound
  · exact row74_inner_bound
  · exact row74_outer_bound
  · exact row75_inner_bound
  · exact row75_outer_bound

#print axioms all_boundaries
end Heraclitus.UpperBoundaryPrefix
