import Heraclitus.OriginalProblem
import Heraclitus.OutgoingWordData
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

/-! A concrete unbounded crossing subsequence of the actual original-rule
walk. The only walk hypothesis is the original rule. -/
namespace Heraclitus.ActualLowerBound
open GlobalWalk

def outgoing42 : OutgoingWord.CertifiedRow :=
  (ScaleScheduleData.entry ⟨0, by decide⟩).checked.link.phase.entrance.outgoing

theorem phase42_checkpoint (a : Nat → Int) (walk : IsWalk a) (t : Nat) :
    stateAt a (7^(6+36*t)) = outgoing42.inner.initial.toState
      (ScaleInduction.radius (6+36*t)) := by
  have ix : ScaleSchedule.index (36*t) = ⟨0, by decide⟩ := by
    apply Fin.ext
    simp [ScaleSchedule.index]
  have reach := Coverage.plan.reaches a walk (36*t)
  change stateAt a (7^(36*t+6)) = ScaleScheduleData.schedule.boundary (36*t) at reach
  have exponent : 36*t+6 = 6+36*t := by omega
  rw [exponent] at reach
  rw [reach]
  unfold ScaleSchedule.Schedule.boundary ScaleSchedule.Schedule.input
  rw [ix, exponent]
  rfl

theorem phase42_data : outgoing42.row.leastExponent=6 ∧
    outgoing42.inner.moves.length=105 ∧ outgoing42.row.phases.size=8 ∧
    outgoing42.row.selected.val=2 ∧ outgoing42.row.winningCycle=44105 ∧
    outgoing42.row.scale=117649 ∧ outgoing42.row.model.period=8 := by decide

theorem phase42_current (k : Nat) (C : Int) (q : Nat) :
    OutgoingWord.crossing (r := outgoing42.row) k C q =
      -(C+6*((7^k : Nat) : Int)+1-(106+8*(q : Int))) := by
  change -(C+(6*((7^k : Nat) : Int)+1-(106+(q : Int)*8+0))) = _
  omega

/-- At all exponents k=6+36t, the literal walk reaches the crossing at
n=4*7^k+1, where 2*a(n)=-7*7^k-3. -/
theorem actual_crossing42 (a : Nat → Int) (walk : IsWalk a) (t : Nat) :
    2*a (4*7^(6+36*t)+1) = -7*((7^(6+36*t) : Nat) : Int)-3 := by
  let k := 6+36*t
  let C := ScaleInduction.radius k
  have scale : 2*C+1=((7^k : Nat) : Int) := ScaleSchedule.radius_exact k
  have initial : stateAt a (7^k)=outgoing42.inner.initial.toState C :=
    phase42_checkpoint a walk t
  have for_row : 2*C+1=((7^(outgoing42.row.leastExponent+36*t) : Nat) : Int) := by
    simpa only [phase42_data.1] using scale
  obtain ⟨q, b, length, d, _nonneg, qeq, shift⟩ := outgoing42.all_exponents t C for_row
  have valid : SignedValidWord (stateAt a (7^k)) b.word := by
    rw [initial]; exact b.valid
  have endpoint := valid_word_endpoint a walk (7^k) b.word valid
  rw [initial, b.endpoint] at endpoint
  have moves : b.word.length=105+q*8+2+1 := by
    simpa only [phase42_data.2.1, phase42_data.2.2.1, phase42_data.2.2.2.1] using length
  have cycle : (q : Int)=44105+3*d := by
    simpa only [phase42_data.2.2.2.2.1] using qeq
  have spacing : ((7^k : Nat) : Int)=117649+8*d := by
    simpa only [phase42_data.1, phase42_data.2.2.2.2.2.1,
      phase42_data.2.2.2.2.2.2] using shift
  have index : 7^k+b.word.length=4*7^k+1 := by omega
  have current := congrArg State.current endpoint
  change OutgoingWord.crossing (r := outgoing42.row)
    (outgoing42.row.leastExponent+36*t) C q = a (7^k+b.word.length) at current
  rw [index] at current
  change OutgoingWord.crossing (r := outgoing42.row) k C q = a (4*7^k+1) at current
  rw [phase42_current] at current
  change -(C+6*((7^k : Nat) : Int)+1-(106+8*(q : Int))) = a (4*7^k+1) at current
  change 2*a (4*7^k+1) = -7*((7^k : Nat) : Int)-3
  omega

theorem original_rule_crossing42 (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (t : Nat) :
    2*a (4*7^(6+36*t)+1) = -7*((7^(6+36*t) : Nat) : Int)-3 :=
  actual_crossing42 a (OriginalProblem.as_walk a rule) t

end Heraclitus.ActualLowerBound
#print axioms Heraclitus.ActualLowerBound.original_rule_crossing42
