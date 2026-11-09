import TransferPrefix
import research.physical_tail.PhysicalTail

set_option autoImplicit false

namespace Heraclitus.UpperTransferPrefix
open TransferCertificate TailCover PhysicalTail

/-- A half-line cover bounds the exact signed walk tail whenever its complete
physical state is the lifted ray. No separate used-set implication is assumed. -/
theorem actual_tail (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (n D : Nat)
    (side : Bool) (C : Int) (other : RayBoundary) (s : State)
    (state : GlobalWalk.stateAt a n = OutgoingWord.liftRay side C other s)
    (positive : 0 < C+s.current) (K : Nat) (M : Int → Prop) (markers : List Int)
    (cover : Covered K M s) (markerCover : ∀ x, M x → x ∈ markers) :
    count a n D ≤ K+markers.length := by
  let project : Int → Int := fun x => if side then x-C else -x-C
  let xs := (points a n D).map project
  have distinct : xs.Nodup := by
    apply List.pairwise_map.mpr
    apply List.Pairwise.imp _ (points_nodup a walk n D)
    intro x y neq eq
    apply neq
    cases side <;> simp only [project, Bool.false_eq_true, ↓reduceIte] at eq <;> omega
  have current : a n = embedRay side C s.current := congrArg State.current state
  have ahead : ∀ x ∈ xs, s.current < x ∧ s.used x := by
    intro x hx
    obtain ⟨y,hy,eq⟩ := List.mem_map.mp hx
    have props := (points_mem a n D y).mp hy
    have same := props.2.1
    have mag := props.2.2.1
    have used : (OutgoingWord.liftRay side C other s).used y := by
      rw [← state]
      exact props.1
    subst x
    cases side with
    | false =>
      have cur : a n = -(C+s.current) := current
      have yn : y < 0 := by unfold SameSide at same; omega
      have absA := Int.natAbs_of_nonneg (show 0 ≤ -a n by omega)
      have absY := Int.natAbs_of_nonneg (show 0 ≤ -y by omega)
      rw [Int.natAbs_neg] at absA absY
      simp only [project, Bool.false_eq_true, ↓reduceIte]
      constructor
      · omega
      · change y=0 ∨ (0<y ∧ boundaryUsed other (y-C)) ∨ (y<0 ∧ s.used (-y-C)) at used
        rcases used with z | p | m
        · omega
        · omega
        · exact m.2
    | true =>
      have cur : a n = C+s.current := current
      have yp : 0 < y := by unfold SameSide at same; omega
      have absA := Int.natAbs_of_nonneg (show 0 ≤ a n by omega)
      have absY := Int.natAbs_of_nonneg (show 0 ≤ y by omega)
      simp only [project, ↓reduceIte]
      constructor
      · omega
      · change y=0 ∨ (0<y ∧ s.used (y-C)) ∨ (y<0 ∧ boundaryUsed other (-y-C)) at used
        rcases used with z | p | m
        · omega
        · exact p.2
        · omega
  have result := covered_tail s M K markers xs cover markerCover distinct ahead
  simpa only [xs,List.length_map,count] using result

theorem execute_current_positive (s : State) (w : List Int) (C : Int)
    (initial : 0 < C+s.current) (positive : ∀ x ∈ w, 0 < C+x) :
    0 < C+(execute s w).current := by
  induction w generalizing s with
  | nil => exact initial
  | cons x xs ih =>
    exact ih (visit s x) (positive x (by simp)) (fun y hy => positive y (by simp [hy]))

/-- The finite marker bound applies at every actual signed transfer prefix.
The complete initial state, signed validity and ray positivity are explicit
reachability premises; local score and all repeated-cycle prefixes are proved. -/
theorem actual_transfer_tail (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base D : Nat) (side : Bool) (C : Int) (other : RayBoundary)
    (t : Transfer) (checked : t.Claim) (K q : Nat) (h : Int) (later : Int → Prop)
    (spacing : h=t.target+(q : Int)*(t.modulus : Int))
    (transientBound : RouteBound t.transient K) (cycleBound : RouteBound t.cycle K)
    (beforeBound : RouteBound t.before K) (repairBound : RouteBound t.repair K)
    (start : GlobalWalk.stateAt a base = OutgoingWord.liftRay side C other
      (mark t.initial.toState (fun x => x=h ∨ later x)))
    (valid : SignedValidWord (GlobalWalk.stateAt a base)
      ((t.word q h).map (embedRay side C)))
    (initialPositive : 0 < C+t.initial.toState.current)
    (positive : ∀ x ∈ t.word q h, 0 < C+x)
    (markers : List Int) (markerCover : ∀ x, x=h ∨ later x → x ∈ markers)
    (i : Nat) (hi : i ≤ (t.word q h).length) :
    count a (base+i) D ≤ K+markers.length := by
  let s := mark t.initial.toState (fun x => x=h ∨ later x)
  let w := (t.word q h).map (embedRay side C)
  have pv : SignedValidWord (GlobalWalk.stateAt a base) (w.take i) := by
    have hv : SignedValidWord (GlobalWalk.stateAt a base) (w.take i ++ w.drop i) := by
      simpa only [List.take_append_drop] using valid
    exact ((signedValidWord_append _ _ _).mp hv).1
  have endpoint := GlobalWalk.valid_word_endpoint a walk base (w.take i) pv
  have len : (w.take i).length=i := by
    simp only [w,List.length_take,List.length_map,Nat.min_eq_left hi]
  have pos : ∀ x ∈ (t.word q h).take i, 0 < C+x := by
    intro x hx
    exact positive x (List.mem_of_mem_take hx)
  rw [len,start] at endpoint
  have takeEq : w.take i = ((t.word q h).take i).map (embedRay side C) := by
    simp only [w,List.map_take]
  rw [takeEq, RoutePrefix.execute_lift_ray side C other _ _ pos] at endpoint
  exact actual_tail a walk (base+i) D side C other
    (execute s ((t.word q h).take i)) endpoint.symm
    (execute_current_positive s _ C initialPositive pos) K _ markers
    (transfer t checked K q h later spacing transientBound cycleBound beforeBound repairBound i hi)
    markerCover

end Heraclitus.UpperTransferPrefix

#print axioms Heraclitus.UpperTransferPrefix.actual_tail
#print axioms Heraclitus.UpperTransferPrefix.actual_transfer_tail
