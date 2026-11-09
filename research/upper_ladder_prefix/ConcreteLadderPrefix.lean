import FullLadderPrefix
import Bottoms
import Heraclitus.LadderEnvelopeData

set_option autoImplicit false

namespace Heraclitus.UpperLadderPrefix
open TransferCertificate LadderLayers UpperTransferPrefix UpperKernelCatalogue TailCover

/-- All 18 concrete complete ladders, every height, with both outer markers.
Finite local bounds and marker cardinality are discharged, not hypotheses. -/
theorem halfline_all_prefixes (c : LadderEnvelope.Checked)
    (member : c∈LadderEnvelopeData.catalogue) (n : Nat) :
    ∃ w : List Int,
      ValidWord (c.initial n).toState w ∧
      execute (c.initial n).toState w = c.output n ∧
      (w.length : Int)=c.moves n ∧
      ReturnBridge.Envelope (scale n) (c.initial n).toState w ∧
      (∀ x∈w, -100≤x) ∧
      AllFinite (55+6*n) (c.initial n).toState w := by
  have bottomMember : c.original∈LadderBottomData.catalogue := by
    rw [← LadderEnvelopeData.catalogue_agrees]
    exact List.mem_map.mpr ⟨c,member,rfl⟩
  obtain ⟨w,valid,endpoint,count,cover⟩ := complete_prefix c.original bottomMember
    (all_bottoms c.original bottomMember) n
  let A := c.original.bottom.entrance.entrance.anchor
  let initial := c.original.bottom.entrance.entrance.initial n
  let absoluteW := w.map (fun x => x+A)
  have absoluteValid : ValidWord initial absoluteW := by
    dsimp only [initial,absoluteW]
    rw [LadderDescent.Entrance.initial_eq]
    exact validWord_translate A valid
  have absoluteEnd : execute initial absoluteW =
      translate (A+scale n) (c.original.bottom.ladder.ladder.entry n).toState := by
    dsimp only [initial,absoluteW]
    rw [LadderDescent.Entrance.initial_eq,execute_translate,endpoint,translate_translate]
  have absoluteCover : AllFinite (53+6*n) initial absoluteW := by
    dsimp only [initial,absoluteW]
    rw [LadderDescent.Entrance.initial_eq]
    exact all_finite_translate _ _ w A cover
  have upper := LadderEnvelope.word_upper_of_endpoint initial _ absoluteW (A+scale n+2000)
    absoluteEnd (by
      intro x hx
      change (c.original.bottom.ladder.ladder.entry n).toState.used (x-(A+scale n)) at hx
      have bound := LadderEnvelope.outputBound_sound
        (c.bounded (c.original.bottom.ladder.ladder.orbit n)) hx
      omega)
  have lower := LadderEnvelope.word_lower_of_valid initial absoluteW (-100)
    (fun _ hx => Or.inl (Or.inl hx)) absoluteValid
  let outer := LadderEnvelope.outer A (scale n)
  have markedValid : ValidWord (mark initial outer) absoluteW := by
    apply validWord_mark absoluteValid
    intro x hx marked
    have low := LadderEnvelope.outer_far A n x marked
    have high := upper x hx
    omega
  have markedCover : AllFinite (55+6*n) (mark initial outer) absoluteW := by
    have result := all_finite_mark (53+6*n) initial absoluteW outer
      [A+2*scale n,A+3*scale n] (by
        intro x hx
        rcases hx with one | two
        · simp only [List.mem_cons,List.not_mem_nil,or_false]
          exact Or.inl one
        · simp only [List.mem_cons,List.not_mem_nil,or_false]
          exact Or.inr two) absoluteCover
    have budget : 53+6*n+[A+2*scale n,A+3*scale n].length=55+6*n := by simp; omega
    rw [budget] at result
    exact result
  have initialEq : (c.initial n).toState=mark initial outer := c.initial_eq n
  refine ⟨absoluteW,?_,?_,?_,?_,lower,?_⟩
  · rw [initialEq]
    exact markedValid
  · rw [initialEq,execute_mark,absoluteEnd]
    rfl
  · simpa only [absoluteW,List.length_map,LadderEnvelope.Checked.moves] using count
  · rw [initialEq]
    apply LadderEnvelope.envelope_of_choices
    · change -100≤A+scale n ∧ A+scale n≤2*scale n+4096
      have a := c.original.bottom.entrance.checked.1
      have b := c.original.bottom.entrance.checked.2.1
      have size := scale_large n
      change -100≤A at a
      change A<100 at b
      omega
    · intro x hx
      have high := upper x hx
      have a := c.original.bottom.entrance.checked.2.1
      change A<100 at a
      have size := scale_large n
      exact ⟨lower x hx,by omega⟩
  · rw [initialEq]
    exact markedCover

theorem actual_finite_tail (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (n D : Nat)
    (side : Bool) (C : Int) (other : RayBoundary) (s : State)
    (state : GlobalWalk.stateAt a n=OutgoingWord.liftRay side C other s)
    (positive : 0<C+s.current) (budget : Nat) (cover : FiniteCover budget s) :
    PhysicalTail.count a n D≤budget := by
  obtain ⟨K,M,markers,cover,mem,bound⟩ := cover
  have result := actual_tail a walk n D side C other s state positive K M markers cover mem
  omega

theorem actual_prefix_bound (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base D : Nat) (side : Bool) (C : Int) (other : RayBoundary) (s : State) (w : List Int)
    (start : GlobalWalk.stateAt a base=OutgoingWord.liftRay side C other s)
    (valid : SignedValidWord (GlobalWalk.stateAt a base) (w.map (embedRay side C)))
    (initialPositive : 0<C+s.current) (positive : ∀ x∈w,0<C+x)
    (budget : Nat) (cover : AllFinite budget s w) :
    ∀ i, i≤w.length → PhysicalTail.count a (base+i) D≤budget := by
  intro i hi
  let physical := w.map (embedRay side C)
  have pv : SignedValidWord (GlobalWalk.stateAt a base) (physical.take i) := by
    have hv : SignedValidWord (GlobalWalk.stateAt a base) (physical.take i++physical.drop i) := by
      simpa only [List.take_append_drop] using valid
    exact ((signedValidWord_append _ _ _).mp hv).1
  have endpoint := GlobalWalk.valid_word_endpoint a walk base (physical.take i) pv
  have len : (physical.take i).length=i := by
    simp only [physical,List.length_take,List.length_map,Nat.min_eq_left hi]
  have pos : ∀ x∈w.take i,0<C+x := fun x hx => positive x (List.mem_of_mem_take hx)
  rw [len,start] at endpoint
  have takeEq : physical.take i=(w.take i).map (embedRay side C) := by
    simp only [physical,List.map_take]
  rw [takeEq,RoutePrefix.execute_lift_ray side C other _ _ pos] at endpoint
  exact actual_finite_tail a walk (base+i) D side C other (execute s (w.take i)) endpoint.symm
    (execute_current_positive s _ C initialPositive pos) budget (cover i hi)

/-- A concrete complete signed ladder in the actual walk, from forced
descent through bottom and every higher layer, has tail <=55+6*n at EVERY
intermediate index. No local score, tower cover, or word-validity premise
remains. The full input-state match is the scale-schedule interface. -/
theorem actual_ladder_tail (c : LadderEnvelope.Checked)
    (member : c∈LadderEnvelopeData.catalogue) (n : Nat) (height : 2≤n)
    (side : Bool) (C : Int) (other : RayBoundary)
    (radius : 2*C+1=scale n) (filled : 3*scale n-200≤other.front)
    (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (base D : Nat)
    (start : GlobalWalk.stateAt a base=OutgoingWord.liftRay side C other (c.initial n).toState) :
    ∃ w : List Int,
      SignedValidWord (GlobalWalk.stateAt a base) w ∧
      execute (GlobalWalk.stateAt a base) w=OutgoingWord.liftRay side C other (c.output n) ∧
      (w.length : Int)=c.moves n ∧
      ∀ i, i≤w.length → PhysicalTail.count a (base+i) D≤55+6*n := by
  obtain ⟨w,valid,endpoint,count,envelope,lower,cover⟩ := halfline_all_prefixes c member n
  have large := LadderEnvelope.scale_sufficient n height
  have lifted := ReturnBridge.return_word (c.initial n) other side (4+n) C w
    radius large filled valid envelope
  have signed : SignedValidWord (GlobalWalk.stateAt a base) (w.map (embedRay side C)) := by
    rw [start]
    exact lifted.1
  have scaleLarge : 100000≤scale n := by change 100000≤((7^(4+n) : Nat) : Int); omega
  have initialPositive : 0<C+(c.initial n).toState.current := by
    change 0<C+(scale n+c.original.bottom.entrance.entrance.anchor)
    have anchor := c.original.bottom.entrance.checked.1
    omega
  have positive : ∀ x∈w,0<C+x := by
    intro x hx
    have low := lower x hx
    omega
  refine ⟨w.map (embedRay side C),signed,?_,?_,?_⟩
  · rw [start,lifted.2,endpoint]
  · simpa only [List.length_map] using count
  · intro i hi
    exact actual_prefix_bound a walk base D side C other (c.initial n).toState w start signed
      initialPositive positive (55+6*n) cover i (by simpa only [List.length_map] using hi)

end Heraclitus.UpperLadderPrefix

#print axioms Heraclitus.UpperLadderPrefix.halfline_all_prefixes
#print axioms Heraclitus.UpperLadderPrefix.actual_ladder_tail
