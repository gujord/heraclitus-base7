import research.upper_return_geometry.CrossingTime

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperReturnGeometry
open UpperPhaseBridge UpperScaleAssembly GlobalWalk OutgoingWord ReturnBridge
open UpperLadderPrefix UpperTransferPrefix Outgoing

/-- Exact actual complete state immediately after the first crossing. -/
theorem actual_crossing_start (a : Nat → Int) (walk : IsWalk a)
    (i : Fin 36) (t q : Nat) (index : (phase i).CycleIndex t q) :
    stateAt a (crossingIndex i t q) =
      liftRay (!(phase i).entrance.outgoing.row.positive)
        (ScaleInduction.radius (exponent i t))
        (farBoundary (phase i).entrance.outgoing q)
        (initial (phase i).entrance.outgoing.geometry.other
          (7^(exponent i t) : Nat) (phase i).entrance.data.anchor).toState := by
  let e := (phase i).entrance
  let k := exponent i t
  let C := ScaleInduction.radius k
  obtain ⟨d, nonneg, qeq, shift⟩ := index
  rw [phase_exponent] at shift
  have scale := ScaleSchedule.radius_exact k
  have large := scale_large i t
  obtain ⟨b, length⟩ := e.outgoing.from_inner k C d scale large nonneg shift q qeq
  have checkpoint := phase_checkpoint a walk i t
  change stateAt a (7^k)=e.outgoing.inner.initial.toState C at checkpoint
  have valid : SignedValidWord (stateAt a (7^k)) b.word := by
    rw [checkpoint]; exact b.valid
  have endpoint := valid_word_endpoint a walk (7^k) b.word valid
  rw [checkpoint, b.endpoint] at endpoint
  have time : 7^k+b.word.length=crossingIndex i t q := by
    rw [length]
    rfl
  rw [time] at endpoint
  exact endpoint.symm.trans (crossing_endpoint e.data e.checked k C d q scale large shift qeq)

/-- The explicit two-word, not just an existential endpoint certificate. -/
theorem two_moves_valid (old other : RayBoundary) (side : Bool)
    (k : Nat) (C A : Int) (scale : 2*C+1=(7^k : Nat))
    (large : 100000≤(7^k : Nat)) (anchor : -3≤A ∧ A≤3)
    (front : -100≤old.front ∧ old.front<100)
    (points : ∀ x∈old.extra, x<100)
    (filled : 3*(7^k : Nat)-200≤other.front) :
    SignedValidWord (liftRay side C other (initial old (7^k : Nat) A).toState)
      ([2*(7^k : Nat)+A, (7^k : Nat)+A].map (embedRay side C)) := by
  let m : Int := (7^k : Nat)
  let s := initial old m A
  have hm : 100000≤m := Int.ofNat_le.mpr large
  have half := two_half_steps old k A large anchor front points
  have first : SignedGreedy (liftRay side C other s.toState) (embedRay side C (2*m+A)) := by
    apply lift_choice s other side k C (2*m+A) scale large
      (by change -100≤3*m+A ∧ 3*m+A≤3*m+9; omega) (by omega)
      (by change 1-(3*m+A)<other.front; omega) half.1
    change ¬CrossWins side m (3*m+A) (2*m+A)
    cases side <;> simp only [CrossWins, Bool.false_eq_true, ite_false, ite_true] <;> omega
  have second : SignedGreedy (liftRay side C other (s.addVisit (2*m+A)).toState)
      (embedRay side C (m+A)) := by
    apply return_choice _ other side k C (m+A) scale large
      (by change -100≤2*m+A ∧ 2*m+A≤2*m+4096; omega) (by omega) filled
    rw [FiniteState.addVisit_toState]
    exact half.2.1
  rw [FiniteState.addVisit_toState,
    lift_visit _ _ _ _ _ (show 0<C+(2*m+A) by omega)] at second
  exact ⟨first, second, True.intro⟩

/-- All three entrance states are covered by the same three new marker
points; the complete old ray lies strictly behind every current. -/
theorem entrance_prefix_cover (old : RayBoundary) (m A : Int)
    (large : 100000≤m) (anchor : -3≤A ∧ A≤3)
    (front : old.front<100) (points : ∀ x∈old.extra, x<100) :
    AllFinite 3 (initial old m A).toState [2*m+A,m+A] := by
  let markers : List Int := [m+A,2*m+A,3*m+A]
  let M : Int → Prop := fun x => x∈markers
  intro j hj
  let s := execute (initial old m A).toState ([2*m+A,m+A].take j)
  have currents : 100≤s.current := by
    apply current_lower (initial old m A).toState _ 100
    · change 100≤3*m+A; omega
    · intro x hx
      have mem := List.mem_of_mem_take hx
      simp only [List.mem_cons, List.mem_nil_iff, or_false] at mem
      rcases mem with h | h <;> subst x <;> omega
  have cover : Covered 0 M s := by
    refine ⟨s.current, 0, [], by omega, ?_, by decide⟩
    intro x hx
    have used := (execute_used_iff (initial old m A).toState _ x).mp hx
    rcases used with oldUsed | newPoint
    · change x<old.front ∨ x∈(3*m+A)::old.extra at oldUsed
      rcases oldUsed with low | marked
      · exact Or.inl (by omega)
      · simp only [List.mem_cons] at marked
        rcases marked with equal | oldPoint
        · exact Or.inr (Or.inr (by simp [M,markers,equal]))
        · have below := points x oldPoint
          exact Or.inl (by omega)
    · have member := List.mem_of_mem_take newPoint
      simp only [List.mem_cons, List.mem_nil_iff, or_false] at member
      exact Or.inr (Or.inr (by rcases member with h | h <;> simp [M,markers,h]))
  exact ⟨0,M,markers,cover,fun _ h => h,by simp [markers]⟩

/-- The first crossing and its two following entrance moves have physical
tail at most three, uniformly for the actual original-rule walk. -/
theorem original_rule_entrance_tail (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (i : Fin 36) (t q j D : Nat)
    (index : (phase i).CycleIndex t q) (hj : j≤2) :
    PhysicalTail.count a (crossingIndex i t q+j) D≤3 := by
  let e := (phase i).entrance
  let k := exponent i t
  let C := ScaleInduction.radius k
  let m : Int := (7^k : Nat)
  let other := farBoundary e.outgoing q
  let side := !e.outgoing.row.positive
  have walk := OriginalProblem.as_walk a rule
  have scale := ScaleSchedule.radius_exact k
  have large := scale_large i t
  have hm : 100000≤m := Int.ofNat_le.mpr large
  have anchor := e.checked.1
  have start := actual_crossing_start a walk i t q index
  have filled := (actual_core_start a walk i t q index).2
  have valid := two_moves_valid e.outgoing.geometry.other other side k C e.data.anchor
    scale large anchor ⟨e.checked.2.1,e.outgoing.bounds.1⟩ e.outgoing.bounds.2.1 filled
  rw [← start] at valid
  apply actual_prefix_bound a walk (crossingIndex i t q) D side C other
    (initial e.outgoing.geometry.other m e.data.anchor).toState [2*m+e.data.anchor,m+e.data.anchor]
    start valid _ _ 3 (entrance_prefix_cover _ m _ hm anchor
      e.outgoing.bounds.1 e.outgoing.bounds.2.1) j (by simpa only [List.length_cons,List.length_nil] using hj)
  · change 0<C+(3*m+e.data.anchor); omega
  · intro x hx
    simp only [List.mem_cons,List.mem_nil_iff,or_false] at hx
    rcases hx with h | h <;> subst x <;> omega

end Heraclitus.UpperReturnGeometry
#print axioms Heraclitus.UpperReturnGeometry.original_rule_entrance_tail
