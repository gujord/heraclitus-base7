import ReachedLadders
import ActualPhase43

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperPhaseBridge
open GlobalWalk ReturnBridge OutgoingWord

/-- Actual full return-entrance state, precise index and opposite-ray
filled bound, at every exponent in every one of the 36 schedule phases. -/
theorem reached_entrance (a : Nat → Int) (walk : IsWalk a) (i : Fin 36) (t : Nat) :
    let p := phase i
    let k := exponent i t
    let C := ScaleInduction.radius k
    ∃ q base : Nat,
      base = 7^k + (p.entrance.outgoing.inner.moves.length +
        q*p.entrance.outgoing.row.phases.size + p.entrance.outgoing.row.selected.val+3) ∧
      stateAt a base = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q)
        (checkpoint p.entrance.outgoing.geometry.other (7^k : Nat) p.entrance.data.anchor).toState ∧
      3*(7^k : Nat)-200≤(farBoundary p.entrance.outgoing q).front ∧ p.CycleIndex t q := by
  let p := phase i
  let e := p.entrance
  let k := exponent i t
  let C := ScaleInduction.radius k
  have scale := ScaleSchedule.radius_exact k
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
  refine ⟨q, 7^k+first.word.length, ?_, ?_, ?_, index⟩
  · rw [length]
  · simpa only [exp] using firstEnd.symm
  · simpa only [exp] using filled

/-- All 36 complete ladder-or-short route families, coupled to the actual
original-rule walk. The remaining upper-bound task concerns the other
segments of the complete scale transition, not reachability of this route. -/
theorem original_rule_all_phase_routes (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t : Nat) :
    let p := phase i
    let k := exponent i t
    let C := ScaleInduction.radius k
    ∃ q base : Nat, ∃ w : List Int,
      base = 7^k + (p.entrance.outgoing.inner.moves.length +
        q*p.entrance.outgoing.row.phases.size + p.entrance.outgoing.row.selected.val+3) ∧
      stateAt a base = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q)
        (checkpoint p.entrance.outgoing.geometry.other (7^k : Nat) p.entrance.data.anchor).toState ∧
      p.CycleIndex t q ∧
      SignedValidWord (stateAt a base) w ∧
      stateAt a (base+w.length) = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) (p.endpoint t) ∧
      (w.length : Int)=p.route.moves (k-4) ∧
      ∀ j, j≤w.length → ∀ D, PhysicalTail.count a (base+j) D≤55+6*(k-4) := by
  let walk := OriginalProblem.as_walk a rule
  let p := phase i
  let k := exponent i t
  let C := ScaleInduction.radius k
  obtain ⟨q, base, baseIndex, start, filled, cycle⟩ := reached_entrance a walk i t
  have scale : 2*C+1=(7^k : Nat) := ScaleSchedule.radius_exact k
  have height : 2≤k-4 := by
    have h := (phase i).height t
    simpa only [phase_exponent] using h.1
  have scaleEq : LadderLayers.scale (k-4)=(7^k : Nat) := by
    have h := (phase i).height t
    simpa only [phase_exponent] using h.2
  have ladderRadius : 2*C+1=LadderLayers.scale (k-4) := by rw [scaleEq]; exact scale
  have ladderFilled : 3*LadderLayers.scale (k-4)-200≤(farBoundary p.entrance.outgoing q).front := by
    rw [scaleEq]; exact filled
  obtain ⟨block, length⟩ := p.route.signed_path (k-4) height C
    (farBoundary p.entrance.outgoing q) ladderRadius ladderFilled
  have signed : SignedValidWord (stateAt a base) block.word := by
    rw [start]
    simpa only [scaleEq] using block.valid
  have actualEnd := valid_word_endpoint a walk base block.word signed
  rw [start] at actualEnd
  have endpoint : stateAt a (base+block.word.length) = liftRay (!p.entrance.outgoing.row.positive) C
      (farBoundary p.entrance.outgoing q) (p.endpoint t) := by
    rw [← scaleEq, block.endpoint] at actualEnd
    have phaseExponent : p.exponent t=k := phase_exponent i t
    simpa only [SignedLadder.Phase.endpoint, phaseExponent] using actualEnd.symm
  refine ⟨q, base, block.word, baseIndex, start, cycle, signed, endpoint, length, ?_⟩
  intro j hj D
  by_cases ordinary : i.val≠1
  · have aligned := SignedLadder.initial_match p.entrance (ladder i) (phase_match i ordinary) (k-4)
    rw [scaleEq] at aligned
    have startLadder : stateAt a base=liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) ((ladder i).initial (k-4)).toState := by
      rw [← aligned]; exact start
    obtain ⟨w, _valid, _endpoint, count, bound⟩ := UpperLadderPrefix.actual_ladder_tail
      (ladder i) (ladder_member i) (k-4) height (!p.entrance.outgoing.row.positive) C
      (farBoundary p.entrance.outgoing q) ladderRadius ladderFilled a walk base D startLadder
    have moves : p.route.moves (k-4)=(ladder i).moves (k-4) := by
      change (phase i).route.moves (k-4)=_
      rw [phase_route i ordinary]
      rfl
    have sameLength : w.length=block.word.length := by omega
    exact bound j (by omega)
  · have one : i=⟨1, by decide⟩ := by
      apply Fin.ext
      change i.val=1
      omega
    subst i
    have old : p.entrance.outgoing.geometry.other=⟨1, []⟩ := rfl
    have anchor : p.entrance.data.anchor=2 := rfl
    have shortLength : block.word.length=2 := by
      have moves : p.route.moves (k-4)=2 := rfl
      omega
    have canonicalStart : stateAt a base=liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState := by
      have h := start
      change stateAt a base=liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q)
        (checkpoint p.entrance.outgoing.geometry.other (7^k : Nat) p.entrance.data.anchor).toState at h
      rw [old, anchor] at h
      exact h
    have large : 100000≤(7^k : Nat) := by
      have pows := Nat.pow_le_pow_right (n := 7) (by decide) (show 6≤k by dsimp [k, exponent]; omega)
      have num : (7:Nat)^6=117649 := by decide
      omega
    have bound := SignedTail43.actual_walk_tail_count a walk base k
      (!p.entrance.outgoing.row.positive) C (farBoundary p.entrance.outgoing q)
      scale large filled canonicalStart j (by omega) D
    omega

theorem scale_parameters (k : Nat) (large : 6≤k) :
    exponent (ScaleSchedule.index (k-6)) ((k-6)/36)=k := by
  unfold exponent ScaleSchedule.index
  change (k-6)%36+6+36*((k-6)/36)=k
  omega

/-- Every integer exponent, with its schedule phase and repetition index
computed explicitly. No all-phase coverage hypothesis is required. -/
theorem original_rule_all_scales (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (k : Nat) (large : 6≤k) :
    let i := ScaleSchedule.index (k-6)
    let t := (k-6)/36
    let p := phase i
    let C := ScaleInduction.radius k
    ∃ q base : Nat, ∃ w : List Int,
      base = 7^k + (p.entrance.outgoing.inner.moves.length +
        q*p.entrance.outgoing.row.phases.size + p.entrance.outgoing.row.selected.val+3) ∧
      stateAt a base = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q)
        (checkpoint p.entrance.outgoing.geometry.other (7^k : Nat) p.entrance.data.anchor).toState ∧
      p.CycleIndex t q ∧
      SignedValidWord (stateAt a base) w ∧
      stateAt a (base+w.length) = liftRay (!p.entrance.outgoing.row.positive) C
        (farBoundary p.entrance.outgoing q) (p.endpoint t) ∧
      (w.length : Int)=p.route.moves (k-4) ∧
      ∀ j, j≤w.length → ∀ D, PhysicalTail.count a (base+j) D≤55+6*(k-4) := by
  simpa only [scale_parameters k large] using
    original_rule_all_phase_routes a rule (ScaleSchedule.index (k-6)) ((k-6)/36)

end Heraclitus.UpperPhaseBridge
#print axioms Heraclitus.UpperPhaseBridge.reached_entrance
#print axioms Heraclitus.UpperPhaseBridge.original_rule_all_phase_routes
#print axioms Heraclitus.UpperPhaseBridge.original_rule_all_scales
