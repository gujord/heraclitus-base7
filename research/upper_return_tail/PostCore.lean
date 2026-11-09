import research.upper_return_tail.Data

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperReturnTail
open UpperPhaseBridge UpperScaleAssembly GlobalWalk OutgoingWord ReturnBridge

def TailInterval (a : Nat → Int) (base length budget : Nat) : Prop :=
  ∀ j, j≤length → ∀ D, PhysicalTail.count a (base+j) D≤budget

theorem tail_enlarge (a : Nat → Int) (base length B K : Nat)
    (bound : TailInterval a base length B) (le : B≤K) : TailInterval a base length K := by
  intro j hj D
  exact Nat.le_trans (bound j hj D) le

theorem tail_join (a : Nat → Int) (base u v B : Nat)
    (first : TailInterval a base u B) (rest : TailInterval a (base+u) v B) :
    TailInterval a base (u+v) B := by
  intro j hj D
  by_cases early : j≤u
  · exact first j early D
  · have late := rest (j-u) (by omega) D
    have index : base+u+(j-u)=base+j := by omega
    rwa [index] at late

/-- The complete reached ordinary core feeds its checked post-ladder
transfer at every exponent, retaining the last outer marker. -/
theorem actual_post (a : Nat → Int) (walk : IsWalk a) (i : Fin 36)
    (ordinary : i.val≠1) (t q base : Nat)
    (start : stateAt a base=liftRay (!(phase i).entrance.outgoing.row.positive)
      (ScaleInduction.radius (exponent i t)) (farBoundary (phase i).entrance.outgoing q)
      ((phase i).endpoint t))
    (filled : 3*(7^(exponent i t) : Nat)-200≤(farBoundary (phase i).entrance.outgoing q).front) :
    ∃ length : Nat,
      stateAt a (base+length)=liftRay (!(phase i).entrance.outgoing.row.positive)
        (ScaleInduction.radius (exponent i t)) (farBoundary (phase i).entrance.outgoing q)
        ((approach i).row.start ((approach i).row.scale t)) ∧
      TailInterval a base length 56 := by
  have input := (post i).input_all t
  rw [post_phase i ordinary,phase_exponent] at input
  have residue := (post i).residue_all t
  rw [post_phase i ordinary,phase_exponent] at residue
  let m : Int := (7^(exponent i t) : Nat)
  let A := (phase i).entrance.data.anchor
  have anchor : -3≤A ∧ A≤3 := (phase i).entrance.checked.1
  have big : 100000≤m := Int.ofNat_le.mpr (scale_large i t)
  have transferred := actual_transfer (post i).input.transfer (post_member i)
    (exponent i t) (ScaleInduction.radius (exponent i t)) (m+A) m [2*m]
    (!(phase i).entrance.outgoing.row.positive) (farBoundary (phase i).entrance.outgoing q)
    (ScaleSchedule.radius_exact _) (scale_large i t) (by omega) residue
    (by intro x hx; simp only [List.mem_singleton] at hx; omega) (by omega) (by omega)
    filled a walk base (by rw [← input]; exact start)
  obtain ⟨r,w,_valid,endpoint,_spacing,_length,bound⟩ := transferred
  have endEq : translate (m+A) (SignedTransfer.endpoint (post i).input.transfer.original.transfer m [2*m])=
      (approach i).row.start ((approach i).row.scale t) := by
    rw [SignedTransfer.after_ladder_endpoint,post_approach i ordinary]
    unfold PostLadder.Input.endpoint
    rw [post_phase i ordinary,phase_exponent]
  rw [endEq] at endpoint
  refine ⟨w.length,endpoint,?_⟩
  intro j hj D
  have h := bound j hj D
  simp only [List.length_singleton] at h
  omega

/-- Both transfers after the exceptional two-move core, including their
shared endpoint, with every later marker accounted for. -/
theorem actual_short_post (a : Nat → Int) (walk : IsWalk a) (t q base : Nat)
    (start : stateAt a base=liftRay (!(phase ⟨1,by decide⟩).entrance.outgoing.row.positive)
      (ScaleInduction.radius (exponent ⟨1,by decide⟩ t))
      (farBoundary (phase ⟨1,by decide⟩).entrance.outgoing q)
      ((phase ⟨1,by decide⟩).endpoint t))
    (filled : 3*(7^(exponent ⟨1,by decide⟩ t) : Nat)-200≤
      (farBoundary (phase ⟨1,by decide⟩).entrance.outgoing q).front) :
    ∃ length : Nat,
      stateAt a (base+length)=liftRay (!(phase ⟨1,by decide⟩).entrance.outgoing.row.positive)
        (ScaleInduction.radius (exponent ⟨1,by decide⟩ t))
        (farBoundary (phase ⟨1,by decide⟩).entrance.outgoing q)
        ((approach ⟨1,by decide⟩).row.start ((approach ⟨1,by decide⟩).row.scale t)) ∧
      TailInterval a base length 56 := by
  let i : Fin 36 := ⟨1,by decide⟩
  let k := exponent i t
  let m : Int := (7^k : Nat)
  let C := ScaleInduction.radius k
  let side := !(phase i).entrance.outgoing.row.positive
  let other := farBoundary (phase i).entrance.outgoing q
  let chain := ShortReturnData.chain
  have big : 100000≤m := Int.ofNat_le.mpr (scale_large i t)
  have member1 : chain.first.original∈TransferCatalogue.catalogue := by
    change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  have member2 : chain.second.original∈TransferCatalogue.catalogue := by
    change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  have short : (phase i).route.isLadder=false := rfl
  have startShort : stateAt a base=liftRay side C other (SignedBottom.shortEnd m).toState := by
    have h := start
    rw [ShortReturn.short_phase_endpoint (phase i) short t,phase_exponent] at h
    exact h
  have residue8 : m%8=7 := ShortReturnData.residue_all t
  have first := actual_transfer chain.first member1 k C 2 m [2*m,3*m] side other
    (ScaleSchedule.radius_exact k) (scale_large i t) (by omega)
    (by rw [chain.firstShape.2.2.1,chain.firstShape.2.2.2.1];exact residue8)
    (by intro x hx;simp only [List.mem_cons,List.not_mem_nil,or_false] at hx;omega)
    (by decide) (by omega) filled a walk base
    (by rw [chain.first_input m];exact startShort)
  obtain ⟨_r1,w1,_valid1,end1,_spacing1,_length1,tail1⟩ := first
  rw [chain.first_output m] at end1
  have second := actual_transfer chain.second member2 k C (m+2) m [2*m] side other
    (ScaleSchedule.radius_exact k) (scale_large i t) (by omega)
    (by rw [chain.secondShape.2.2.1,chain.secondShape.2.2.2.1];exact Int.emod_one _)
    (by intro x hx;simp only [List.mem_singleton] at hx;omega)
    (by omega) (by omega) filled a walk (base+w1.length)
    (by rw [chain.second_input m];exact end1)
  obtain ⟨_r2,w2,_valid2,end2,_spacing2,_length2,tail2⟩ := second
  rw [SignedTransfer.after_ladder_endpoint,chain.second_output m] at end2
  have target : (ShortReturn.finalState m).toState=
      (approach i).row.start ((approach i).row.scale t) :=
    (ApproachWordData.input43_all t).symm
  rw [target] at end2
  refine ⟨w1.length+w2.length,?_,?_⟩
  · simpa only [Nat.add_assoc] using end2
  · apply tail_join a base w1.length w2.length 56
    · exact tail1
    · intro j hj D
      have h := tail2 j hj D
      simp only [List.length_singleton] at h
      omega

theorem actual_post_core (a : Nat → Int) (walk : IsWalk a) (i : Fin 36) (t q base : Nat)
    (start : stateAt a base=liftRay (!(phase i).entrance.outgoing.row.positive)
      (ScaleInduction.radius (exponent i t)) (farBoundary (phase i).entrance.outgoing q)
      ((phase i).endpoint t))
    (filled : 3*(7^(exponent i t) : Nat)-200≤(farBoundary (phase i).entrance.outgoing q).front) :
    ∃ length : Nat,
      stateAt a (base+length)=liftRay (!(phase i).entrance.outgoing.row.positive)
        (ScaleInduction.radius (exponent i t)) (farBoundary (phase i).entrance.outgoing q)
        ((approach i).row.start ((approach i).row.scale t)) ∧
      TailInterval a base length 56 := by
  by_cases ordinary : i.val≠1
  · exact actual_post a walk i ordinary t q base start filled
  · have one : i=⟨1,by decide⟩ := by
      apply Fin.ext
      change i.val=1
      omega
    subst i
    exact actual_short_post a walk t q base start filled

end Heraclitus.UpperReturnTail
