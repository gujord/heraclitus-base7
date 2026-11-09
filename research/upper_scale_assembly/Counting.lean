import research.upper_scale_assembly.Frame
import research.physical_counting.CheckpointExterior
import research.upper_asymptotic.FromScale

set_option autoImplicit false

namespace Heraclitus.UpperScaleAssembly
open UpperMachineAudit

/-- Actual counting at the next checkpoint turns the proved return-time,
radius and same-side-tail inequalities into the required exact defect bound.
This lemma is only the arithmetic interface, not an all-index theorem. -/
theorem return_defect (a : Nat → Int) (rule : OriginalProblem.FollowsRule a)
    (k n : Nat) (large : 6≤k) (before : n≤7^(k+1))
    (time : 4*((7^k : Nat) : Int)-1≤(n : Int))
    (lower : ScaleInduction.radius k-4096≤((a n).natAbs : Int))
    (upper : ((a n).natAbs : Int)≤ScaleInduction.radius (k+1)+4096)
    (tail : PhysicalTail.count a n (ScaleInduction.radius (k+1)).toNat≤55+6*(k-4)) :
    defect a n≤32771+6*((k : Int)-4) := by
  have count := CheckpointExterior.original_rule_count a rule (k+1) n (by omega) before
  have centre := ScaleSchedule.radius_exact k
  have outer := ScaleSchedule.radius_exact (k+1)
  have power : 7^(k+1)=7^k*7 := Nat.pow_succ 7 k
  have radiusNonneg : 0≤ScaleInduction.radius (k+1) := by
    have pos : 0<(7^(k+1) : Nat) := Nat.pow_pos (by decide)
    omega
  have radiusCast := Int.toNat_of_nonneg radiusNonneg
  have powerCast : ((7^(k+1) : Nat) : Int)=((7^k : Nat) : Int)*7 := by
    rw [power, Int.natCast_mul]
    rfl
  have bounds : 8*((a n).natAbs : Int)-7*(n : Int)≤32771 ∧
      (n : Int)-8*((a n).natAbs : Int)≤28737+6*((k : Int)-4) := by omega
  unfold defect twiceDeviation
  dsimp only
  split <;> omega

end Heraclitus.UpperScaleAssembly
