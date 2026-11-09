import research.upper_scale_assembly.Theorem
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
example : ¬(Heraclitus.UpperMachineAudit.defect Heraclitus.GlobalWalk.sequence 470597≤4) := by
  have h := Heraclitus.ActualLowerBound.original_rule_crossing_defect Heraclitus.GlobalWalk.sequence Heraclitus.OriginalProblem.canonical_follows_rule 0
  have eq : 4*7^(6+36*0)+1=470597 := by decide
  rw [eq] at h
  omega
