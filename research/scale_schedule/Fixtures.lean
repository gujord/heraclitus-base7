import Heraclitus.ScaleScheduleData
set_option autoImplicit false

namespace Heraclitus.ScaleScheduleFixtures
open ScaleSchedule ScaleScheduleData ScaleInduction

theorem initial_exponent : (schedule.entry (index 0)).checked.link.approach.row.exponent (0/36)=6 := by decide

theorem last_before_wrap : (schedule.entry (index 35)).checked.link.approach.row.exponent (35/36)=41 := by decide

theorem first_after_wrap : (schedule.entry (index 36)).checked.link.approach.row.exponent (36/36)=42 := by decide

theorem exponent_after_two_periods : (schedule.entry (index 72)).checked.link.approach.row.exponent (72/36)=78 := by decide

theorem first_transition : ∃ b : SignedBlock (schedule.boundary 0) (schedule.boundary 1),
    b.word.length=705894 := schedule.step 0

theorem first_radius : radius 6=58824 ∧ radius 7=411771 := by decide

end Heraclitus.ScaleScheduleFixtures
