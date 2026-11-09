import PhaseData

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

/-! Reach the actual ladder input for every one of the 35 ordinary phases.
All interface assumptions of the complete-ladder tail theorem are discharged
using the existing exact scale schedule and return-entrance words. -/
namespace Heraclitus.UpperPhaseBridge
open GlobalWalk ReturnBridge OutgoingWord

theorem phase_checkpoint (a : Nat → Int) (walk : IsWalk a)
    (i : Fin 36) (t : Nat) :
    stateAt a (7^(exponent i t)) =
      (phase i).entrance.outgoing.inner.initial.toState
        (ScaleInduction.radius (exponent i t)) := by
  have ix : ScaleSchedule.index (i.val+36*t)=i := by
    apply Fin.ext
    dsimp [ScaleSchedule.index]
    omega
  have reached := Coverage.plan.reaches a walk (i.val+36*t)
  change stateAt a (7^((i.val+36*t)+6)) =
    ScaleScheduleData.schedule.boundary (i.val+36*t) at reached
  have exp : i.val+36*t+6=exponent i t := by unfold exponent; omega
  rw [exp] at reached
  rw [reached]
  unfold ScaleSchedule.Schedule.boundary ScaleSchedule.Schedule.input
  rw [ix, exp]
  rfl

/-- From zero, reach the correct ordinary ladder at every phase exponent.
The exact entrance index, whole start and end states, cycle-index relation,
signed word and every intermediate physical-tail bound are retained. -/
theorem reached_ordinary_ladder (a : Nat → Int) (walk : IsWalk a)
    (i : Fin 36) (ordinary : i.val≠1) (t : Nat) :
    let p := phase i
    let k := exponent i t
    let C := ScaleInduction.radius k
    ∃ q base : Nat, ∃ w : List Int,
      base = 7^k + (p.entrance.outgoing.inner.moves.length +
        q*p.entrance.outgoing.row.phases.size + p.entrance.outgoing.row.selected.val+3) ∧
      stateAt a base = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) ((ladder i).initial (k-4)).toState ∧
      p.CycleIndex t q ∧
      SignedValidWord (stateAt a base) w ∧
      stateAt a (base+w.length) = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) ((ladder i).output (k-4)) ∧
      (w.length : Int)=(ladder i).moves (k-4) ∧
      ∀ j, j≤w.length → ∀ D, PhysicalTail.count a (base+j) D≤55+6*(k-4) := by
  let p := phase i
  let e := p.entrance
  let k := exponent i t
  let C := ScaleInduction.radius k
  have scale : 2*C+1=(7^k : Nat) := ScaleSchedule.radius_exact k
  have exp : e.outgoing.row.leastExponent+36*t=k := by
    change (phase i).entrance.outgoing.row.leastExponent+36*t=exponent i t
    rw [phase_least]
    rfl
  have entry := phase_checkpoint a walk i t
  change stateAt a (7^k)=e.outgoing.inner.initial.toState C at entry
  have rowScale : 2*C+1=(7^(e.outgoing.row.leastExponent+36*t) : Nat) := by
    rw [exp]; exact scale
  obtain ⟨q, first, length, filled, index⟩ := e.all_exponents t C rowScale
  have firstValid : SignedValidWord (stateAt a (7^k)) first.word := by
    rw [entry]; exact first.valid
  have firstEnd := valid_word_endpoint a walk (7^k) first.word firstValid
  rw [entry, first.endpoint] at firstEnd
  let base := 7^k+first.word.length
  have height : 2≤k-4 := by
    have h := (phase i).height t
    simpa only [phase_exponent] using h.1
  have scaleEq : LadderLayers.scale (k-4)=(7^k : Nat) := by
    have h := (phase i).height t
    simpa only [phase_exponent] using h.2
  have start : stateAt a base=liftRay (!e.outgoing.row.positive) C
      (farBoundary e.outgoing q) ((ladder i).initial (k-4)).toState := by
    have aligned := SignedLadder.initial_match e (ladder i) (phase_match i ordinary) (k-4)
    rw [scaleEq] at aligned
    have reached : stateAt a base=liftRay (!e.outgoing.row.positive) C
        (farBoundary e.outgoing q) (checkpoint e.outgoing.geometry.other (7^k : Nat) e.data.anchor).toState := by
      simpa only [exp] using firstEnd.symm
    rw [aligned] at reached
    exact reached
  have ladderRadius : 2*C+1=LadderLayers.scale (k-4) := by rw [scaleEq]; exact scale
  have ladderFilled : 3*LadderLayers.scale (k-4)-200≤(farBoundary e.outgoing q).front := by
    rw [scaleEq]
    simpa only [exp] using filled
  obtain ⟨w, valid, endpoint, count, _⟩ := UpperLadderPrefix.actual_ladder_tail
    (ladder i) (ladder_member i) (k-4) height (!e.outgoing.row.positive) C
    (farBoundary e.outgoing q) ladderRadius ladderFilled a walk base 0 start
  have actualEnd := valid_word_endpoint a walk base w valid
  rw [endpoint] at actualEnd
  refine ⟨q, base, w, ?_, start, index, valid, actualEnd.symm, count, ?_⟩
  · dsimp [base]
    rw [length]
  · intro j hj D
    obtain ⟨v, _valid, _endpoint, vcount, bound⟩ := UpperLadderPrefix.actual_ladder_tail
      (ladder i) (ladder_member i) (k-4) height (!e.outgoing.row.positive) C
      (farBoundary e.outgoing q) ladderRadius ladderFilled a walk base D start
    have sameLength : v.length=w.length := by omega
    exact bound j (by omega)

/-- Literal original-rule theorem for all 35 ordinary phase families.
No ladder start, radius, filled-ray, catalogue, local-score or marker-cover
hypothesis remains. Only the phase parameter excludes the short branch. -/
theorem original_rule_ordinary_ladder (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (ordinary : i.val≠1) (t : Nat) :
    let p := phase i
    let k := exponent i t
    let C := ScaleInduction.radius k
    ∃ q base : Nat, ∃ w : List Int,
      base = 7^k + (p.entrance.outgoing.inner.moves.length +
        q*p.entrance.outgoing.row.phases.size + p.entrance.outgoing.row.selected.val+3) ∧
      stateAt a base = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) ((ladder i).initial (k-4)).toState ∧
      p.CycleIndex t q ∧
      SignedValidWord (stateAt a base) w ∧
      stateAt a (base+w.length) = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) ((ladder i).output (k-4)) ∧
      (w.length : Int)=(ladder i).moves (k-4) ∧
      ∀ j, j≤w.length → ∀ D, PhysicalTail.count a (base+j) D≤55+6*(k-4) :=
  reached_ordinary_ladder a (OriginalProblem.as_walk a rule) i ordinary t

end Heraclitus.UpperPhaseBridge
#print axioms Heraclitus.UpperPhaseBridge.phase_checkpoint
#print axioms Heraclitus.UpperPhaseBridge.reached_ordinary_ladder
#print axioms Heraclitus.UpperPhaseBridge.original_rule_ordinary_ladder
