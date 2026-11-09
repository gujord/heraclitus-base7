import research.scale_schedule.Fixtures
open Heraclitus ScaleSchedule
example : ScaleInduction.radius 7=ScaleInduction.radius 6+3*7^6+1 := by decide
