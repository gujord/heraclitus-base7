import research.upper_return_tail.PostCore

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperReturnTail
open UpperPhaseBridge UpperScaleAssembly GlobalWalk OutgoingWord ReturnBridge

theorem following_checkpoint (a : Nat → Int) (walk : IsWalk a) (i : Fin 36) (t : Nat) :
    stateAt a (7^(exponent i t+1))=(outer i).link.following.toState
      (ScaleInduction.radius (exponent i t)+3*(approach i).row.scale t) := by
  have ix : ScaleSchedule.index (i.val+36*t)=i := by
    apply Fin.ext
    dsimp [ScaleSchedule.index]
    omega
  have quotient : (i.val+36*t)/36=t := by omega
  have exp : i.val+36*t+6=exponent i t := by unfold exponent;omega
  have endpoint := ScaleScheduleData.schedule.endpoint (i.val+36*t)
  rw [ix,quotient,exp] at endpoint
  have reached := Coverage.plan.reaches a walk (i.val+36*t+1)
  have expNext : i.val+36*t+1+6=exponent i t+1 := by unfold exponent;omega
  rw [expNext] at reached
  exact reached.trans endpoint.symm

/-- The actual post-core transfers, marked approach and outer boundary
compose to the next checkpoint. Injectivity identifies the exact endpoint
time, rather than inferring it from a sampled or approximate word count. -/
theorem after_core_to_checkpoint (a : Nat → Int) (walk : IsWalk a)
    (i : Fin 36) (t q base : Nat) (cycle : (phase i).CycleIndex t q)
    (start : stateAt a base=liftRay (!(phase i).entrance.outgoing.row.positive)
      (ScaleInduction.radius (exponent i t)) (farBoundary (phase i).entrance.outgoing q)
      ((phase i).endpoint t))
    (filled : 3*(7^(exponent i t) : Nat)-200≤(farBoundary (phase i).entrance.outgoing q).front) :
    ∃ length : Nat, base+length=7^(exponent i t+1) ∧ TailInterval a base length 56 := by
  let C := ScaleInduction.radius (exponent i t)
  let side := !(phase i).entrance.outgoing.row.positive
  let other := farBoundary (phase i).entrance.outgoing q
  obtain ⟨postLength,postEnd,postTail⟩ := actual_post_core a walk i t q base start filled
  have radius : 2*C+1=(7^((approach i).row.exponent t) : Nat) := by
    rw [approach_exponent];exact ScaleSchedule.radius_exact _
  have approachFilled : 3*(approach i).row.scale t-200≤other.front := by
    rw [approach_scale];exact filled
  obtain ⟨w,_valid,approachEnd,_count,approachTail⟩ := actual_approach (approach i)
    (approach_member i) t C side other radius approachFilled a walk (base+postLength) postEnd
  have input := (outer i).input_all t q C cycle
  have outerStart : stateAt a (base+postLength+w.length)=
      (outer i).link.outer.initial.toState (C+3*(approach i).row.scale t) := approachEnd.trans input
  have outerRadius : 2*(C+3*(approach i).row.scale t)+1=(7^(exponent i t+1) : Nat) := by
    rw [approach_scale]
    exact OuterBoundary.next_radius _ C (ScaleSchedule.radius_exact _)
  obtain ⟨_boundaryValid,outerEnd,outerTail⟩ := UpperBoundaryPrefix.actual_catalogue_boundary
    (outer i).link.outer (outer_member i) a walk (base+postLength+w.length) (exponent i t+1)
    (C+3*(approach i).row.scale t) outerRadius (OuterBoundary.next_large _ (scale_large i t)) outerStart
  have outerFinish := outerEnd.trans ((outer i).closure _)
  have checkpoint := following_checkpoint a walk i t
  have sameState := outerFinish.trans checkpoint.symm
  have exactTime := walk_injective a walk (congrArg State.current sameState)
  refine ⟨postLength+(w.length+(outer i).link.outer.moves.length),?_,?_⟩
  · simpa only [Nat.add_assoc] using exactTime
  · apply tail_join a base postLength _ 56 postTail
    apply tail_join a (base+postLength) w.length _ 56
    · intro j hj D
      have bound := approachTail j hj D
      omega
    · intro j hj D
      have bound := outerTail D j hj
      omega

theorem original_rule_core_to_checkpoint (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t q : Nat)
    (cycle : (phase i).CycleIndex t q) (n : Nat)
    (low : crossingIndex i t q+2≤n) (high : n≤7^(exponent i t+1)) (D : Nat) :
    PhysicalTail.count a n D≤55+6*(exponent i t-4) := by
  let walk := OriginalProblem.as_walk a rule
  obtain ⟨r,base,w,baseIndex,_initial,index,_valid,endpoint,_length,coreTail⟩ :=
    original_rule_all_phase_routes a rule i t
  have same : r=q := cycle_index_unique (phase i) t r q index cycle
  subst r
  have baseEq : base=crossingIndex i t q+2 := by
    unfold crossingIndex
    omega
  rw [baseEq] at endpoint coreTail
  have filled := (actual_core_start a walk i t q cycle).2
  obtain ⟨rest,exactTime,restTail⟩ := after_core_to_checkpoint a walk i t q
    (crossingIndex i t q+2+w.length) cycle endpoint filled
  have joined := tail_join a (crossingIndex i t q+2) w.length rest
    (55+6*(exponent i t-4)) coreTail (tail_enlarge _ _ _ 56 _ restTail (by
      have large := exponent_large i t
      omega))
  have jbound : n-(crossingIndex i t q+2)≤w.length+rest := by omega
  have bound := joined (n-(crossingIndex i t q+2)) jbound D
  have eq : crossingIndex i t q+2+(n-(crossingIndex i t q+2))=n := by omega
  rwa [eq] at bound

end Heraclitus.UpperReturnTail
