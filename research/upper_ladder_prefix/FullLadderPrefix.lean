import LadderBounds
import SignedTransferPrefix

set_option autoImplicit false

namespace Heraclitus.UpperLadderPrefix
open TransferCertificate LadderLayers UpperTransferPrefix UpperKernelCatalogue TailCover

/-- Each prefix may use its own normalized local state and finite marker
cover, but their combined cardinality has the same global budget. -/
def FiniteCover (budget : Nat) (s : State) : Prop :=
  ∃ K : Nat, ∃ M : Int → Prop, ∃ markers : List Int,
    Covered K M s ∧ (∀ x, M x → x∈markers) ∧ K+markers.length ≤ budget

def AllFinite (budget : Nat) (s : State) (w : List Int) : Prop :=
  ∀ i, i≤w.length → FiniteCover budget (execute s (w.take i))

theorem all_finite_cover (K : Nat) (M : Int → Prop) (s : State) (w : List Int)
    (cover : AllCovered K M s w) (markers : List Int) (markerCover : ∀ x, M x → x∈markers)
    (budget : Nat) (bound : K+markers.length≤budget) : AllFinite budget s w := by
  intro i hi
  exact ⟨K,M,markers,cover i hi,markerCover,bound⟩

theorem all_finite_append (budget : Nat) (s : State) (u v : List Int)
    (first : AllFinite budget s u) (rest : AllFinite budget (execute s u) v) :
    AllFinite budget s (u++v) := by
  intro i hi
  by_cases small : i≤u.length
  · rw [List.take_append_of_le_length small]
    exact first i small
  · have low : u.length≤i := by omega
    have high : i-u.length≤v.length := by simp only [List.length_append] at hi; omega
    rw [List.take_append,List.take_of_length_le low,execute_append]
    exact rest (i-u.length) high

theorem all_finite_translate (budget : Nat) (s : State) (w : List Int) (d : Int)
    (cover : AllFinite budget s w) :
    AllFinite budget (translate d s) (w.map (fun x => x+d)) := by
  intro i hi
  rw [← List.map_take,execute_translate]
  obtain ⟨K,M,markers,cover,mem,bound⟩ := cover i (by simpa only [List.length_map] using hi)
  refine ⟨K,(fun x => M (x-d)),markers.map (fun x => x+d),
    covered_translate _ d K M _ cover (fun _ h => h),?_,?_⟩
  · intro x hx
    exact List.mem_map.mpr ⟨x-d,mem (x-d) hx,by omega⟩
  · simpa only [List.length_map] using bound

theorem all_finite_mark (budget : Nat) (s : State) (w : List Int) (N : Int → Prop)
    (marks : List Int) (mem : ∀ x, N x → x∈marks) (cover : AllFinite budget s w) :
    AllFinite (budget+marks.length) (mark s N) w := by
  intro i hi
  rw [execute_mark]
  obtain ⟨K,M,markers,cover,member,bound⟩ := cover i hi
  refine ⟨K,(fun x => M x ∨ N x),markers++marks,covered_mark _ K M N cover,?_,?_⟩
  · intro x hx
    rcases hx with old | added
    · exact List.mem_append.mpr (Or.inl (member x old))
    · exact List.mem_append.mpr (Or.inr (mem x added))
  · simp only [List.length_append]
    omega

theorem allLocal_cover (K : Nat) (s : State) (w : List Int) (localBound : AllLocal K s w) :
    AllCovered K (fun _ => False) s w := by
  intro i hi
  obtain ⟨f,eq,bound⟩ := allLocal_prefix K s w localBound i hi
  rw [eq]
  have result := finite_covered f K bound (fun _ => False)
  simpa only [mark_none] using result

theorem current_lower (s : State) (w : List Int) (lo : Int)
    (initial : lo≤s.current) (choices : ∀ x∈w, lo≤x) : lo≤(execute s w).current := by
  induction w generalizing s with
  | nil => exact initial
  | cons x xs ih =>
    exact ih (visit s x) (choices x (by simp)) (fun y hy => choices y (by simp [hy]))

/-- All forced-descent prefixes: the old occupied set is strictly below the
current; at most 6*n+1 listed descent points cover every other used point. -/
theorem descent_prefix (old : Int → Prop) (region : LadderDescent.Region old) (n : Nat) :
    AllFinite (53+6*n) (LadderDescent.start old (scale n)) (LadderDescent.word 4 n) := by
  let markers := scale n :: LadderDescent.word 4 n
  let M : Int → Prop := fun x => x∈markers
  have base : LadderDescent.height 4 = 2401 := by decide
  have lower : ∀ x∈LadderDescent.word 4 n, 2401≤x := by
    intro x hx
    have b := LadderDescent.word_bounds 4 n (by decide) x hx
    simpa only [base] using b.1
  intro i hi
  let s := execute (LadderDescent.start old (scale n)) ((LadderDescent.word 4 n).take i)
  have low : 2401≤s.current := current_lower _ _ 2401 (scale_large n)
    (fun x hx => lower x (List.mem_of_mem_take hx))
  have cov : Covered 0 M s := by
    refine ⟨200,s.current-200,[],by omega,?_,?_⟩
    · intro x hx
      have hu := (execute_used_iff _ _ x).mp hx
      rcases hu with (oldPoint | top) | visited
      · exact Or.inl (region.2.2 x oldPoint)
      · exact Or.inr (Or.inr (List.mem_cons.mpr (Or.inl top)))
      · exact Or.inr (Or.inr (List.mem_cons.mpr (Or.inr (List.mem_of_mem_take visited))))
    · simp only [localAhead,List.filter_nil,List.append_nil,List.length_map,List.length_range]
      omega
  refine ⟨0,M,markers,cov,(fun _ hx => hx),?_⟩
  simp only [markers,List.length_cons,LadderDescent.word_length]
  omega

/-- All ascent prefixes for every checked finite ladder and every height,
including an arbitrary start level, have an exact 53+6*levels budget. -/
theorem ascent_prefix (c : CheckedLadder) (member : c∈LadderLayersData.catalogue)
    (n levels : Nat) :
    ∃ w : List Int,
      ValidWord (mark (c.ladder.entry n).toState (LadderLayers.tower (scale n) levels)) w ∧
      execute (mark (c.ladder.entry n).toState (LadderLayers.tower (scale n) levels)) w =
        translate (scale (n+levels)-scale n) (c.ladder.entry (n+levels)).toState ∧
      (w.length : Int)=scale (n+levels)-scale n+c.ladder.cumulative n levels ∧
      AllFinite (53+6*levels)
        (mark (c.ladder.entry n).toState (LadderLayers.tower (scale n) levels)) w := by
  obtain ⟨w,valid,endpoint,count,cover⟩ := tower c.ladder c.checked 53 (all_ladders c member) n levels
  refine ⟨w,valid,endpoint,count,?_⟩
  apply all_finite_cover 53 _ _ w cover (ReturnTailTower.towerPoints (scale n) levels)
  · intro x hx
    exact (ReturnTailTower.towerPoints_exact _ x levels).mp hx
  · rw [ReturnTailTower.towerPoints_length]
    exact Nat.le_refl _

/-- Concrete bottom plus every ascent layer, joined to the forced descent.
The only finite premise is the checked bottom-prefix result, supplied for
all 18 concrete bottoms by the separate bitmap catalogue build. -/
theorem complete_prefix (b : LadderBottom.CheckedBottom)
    (member : b∈LadderBottomData.catalogue)
    (bottomBound : AllLocal 53 (LadderDescent.start b.bottom.entrance.entrance.old 2401) b.bottom.word)
    (n : Nat) :
    ∃ w : List Int,
      ValidWord (LadderDescent.start b.bottom.entrance.entrance.old (scale n)) w ∧
      execute (LadderDescent.start b.bottom.entrance.entrance.old (scale n)) w =
        translate (scale n) (b.bottom.ladder.ladder.entry n).toState ∧
      (w.length : Int)=6*(n : Int)+b.bottom.moves+scale n-2401+b.bottom.ladder.ladder.cumulative 0 n ∧
      AllFinite (53+6*n) (LadderDescent.start b.bottom.entrance.entrance.old (scale n)) w := by
  let c := b.bottom.ladder.ladder
  let old := b.bottom.entrance.entrance.old
  have region := b.bottom.entrance.entrance.region b.bottom.entrance.checked
  have descent := LadderDescent.descend old region 4 n (by decide)
  have base : LadderDescent.height 4=2401 := by decide
  have startEq : LadderDescent.height (4+n)=scale n := rfl
  have descentEnd : execute (LadderDescent.start old (scale n)) (LadderDescent.word 4 n) =
      mark (LadderDescent.start old 2401) (fun x => LadderLayers.tower 2401 n (x-2401)) := by
    simpa only [LadderDescent.bottom,base,startEq] using descent.2
  have bottom := b.bottom.sound b.checked
  have bottomValid := validWord_mark bottom.1 (markers := fun x => LadderLayers.tower 2401 n (x-2401)) (by
    intro x hx marked
    have low := tower_lower 2401 (by decide) n (x-2401) marked
    have high := (bottom.2.2.2 x hx).2
    omega)
  have bottomEnd : execute (mark (LadderDescent.start old 2401)
      (fun x => LadderLayers.tower 2401 n (x-2401))) b.bottom.word =
      translate 2401 (mark c.initial.toState (LadderLayers.tower 2401 n)) := by
    rw [execute_mark,bottom.2.1,translate_mark]
  have ladderMember : b.bottom.ladder∈LadderLayersData.catalogue := by
    rw [← LadderBottomData.ladders_agree]
    exact List.mem_map.mpr ⟨b,member,rfl⟩
  obtain ⟨rest,restValid,restEnd,restCount,restCover⟩ := ascent_prefix b.bottom.ladder ladderMember 0 n
  change ValidWord (mark (c.entry 0).toState (LadderLayers.tower (scale 0) n)) rest at restValid
  change execute (mark (c.entry 0).toState (LadderLayers.tower (scale 0) n)) rest = _ at restEnd
  change AllFinite (53+6*n) (mark (c.entry 0).toState (LadderLayers.tower (scale 0) n)) rest at restCover
  rw [← c.initial_eq b.bottom.ladder.checked,scale_zero] at restValid restEnd restCover
  simp only [Nat.zero_add,scale_zero] at restEnd restCount
  have restTranslatedEnd : execute (translate 2401 (mark c.initial.toState (LadderLayers.tower 2401 n)))
      (rest.map (fun x => x+2401)) = translate (scale n) (c.entry n).toState := by
    rw [execute_translate,restEnd,translate_translate]
    have eq : 2401+(scale n-2401)=scale n := by omega
    rw [eq]
  refine ⟨LadderDescent.word 4 n ++ b.bottom.word ++ rest.map (fun x => x+2401),?_,?_,?_,?_⟩
  · apply (validWord_append _ _ _).mpr
    constructor
    · apply (validWord_append _ _ _).mpr
      refine ⟨descent.1,?_⟩
      rw [descentEnd]
      exact bottomValid
    · rw [execute_append,descentEnd,bottomEnd]
      exact validWord_translate 2401 restValid
  · rw [execute_append,execute_append,descentEnd,bottomEnd,restTranslatedEnd]
  · simp only [List.length_append,List.length_map,LadderDescent.word_length,Int.natCast_add,
      Int.natCast_mul,bottom.2.2.1]
    omega
  · apply all_finite_append
    · apply all_finite_append
      · exact descent_prefix old region n
      · rw [descentEnd]
        have localCover := all_mark _ b.bottom.word 53 (fun _ => False)
          (fun x => LadderLayers.tower 2401 n (x-2401)) (allLocal_cover _ _ _ bottomBound)
        apply all_finite_cover 53 _ _ _ localCover
          ((ReturnTailTower.towerPoints 2401 n).map (fun x => x+2401))
        · intro x hx
          rcases hx with no | tw
          · exact False.elim no
          · exact List.mem_map.mpr ⟨x-2401,(ReturnTailTower.towerPoints_exact _ _ n).mp tw,by omega⟩
        · simp only [List.length_map,ReturnTailTower.towerPoints_length]
          exact Nat.le_refl _
    · rw [execute_append,descentEnd,bottomEnd]
      exact all_finite_translate _ _ rest 2401 restCover

end Heraclitus.UpperLadderPrefix

#print axioms Heraclitus.UpperLadderPrefix.descent_prefix
#print axioms Heraclitus.UpperLadderPrefix.ascent_prefix
#print axioms Heraclitus.UpperLadderPrefix.complete_prefix
