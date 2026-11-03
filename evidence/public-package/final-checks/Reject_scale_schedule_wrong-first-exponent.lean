import research.scale_schedule.Fixtures
open Heraclitus ScaleSchedule
example : (ScaleScheduleData.schedule.entry (index 0)).checked.link.approach.row.exponent 0=5 := by decide
