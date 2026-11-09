import CatalogueTransferPrefix
import Heraclitus.LadderEnvelope

set_option autoImplicit false

namespace Heraclitus.UpperLadderPrefix
open TransferCertificate LadderLayers UpperTransferPrefix UpperKernelCatalogue TailCover

def FiniteBound (K : Nat) (s : FiniteState) : Prop :=
  (localAhead (normalized s).current (normalized s).points).length ≤ K

instance (K : Nat) (s : FiniteState) : Decidable (FiniteBound K s) :=
  inferInstanceAs (Decidable ((localAhead (normalized s).current (normalized s).points).length ≤ K))

theorem normalized_state (s : FiniteState) :
    s.toState = translate s.front (normalized s).state := by
  apply state_ext
  · change s.current = s.current-s.front+s.front
    omega
  · intro x
    change (x<s.front ∨ x∈s.points) ↔
      (x-s.front<0 ∨ x-s.front∈s.points.map (fun y => y-s.front))
    constructor
    · intro hx
      rcases hx with low | point
      · exact Or.inl (by omega)
      · exact Or.inr (List.mem_map.mpr ⟨x,point,rfl⟩)
    · intro hx
      rcases hx with low | point
      · exact Or.inl (by omega)
      · obtain ⟨y,hy,eq⟩ := List.mem_map.mp point
        have same : x=y := by omega
        exact Or.inr (same ▸ hy)

theorem finite_covered (s : FiniteState) (K : Nat) (bound : FiniteBound K s)
    (M : Int → Prop) : Covered K M (mark s.toState M) := by
  rw [normalized_state]
  exact covered_node _ _ M M K bound (fun _ h => h)

theorem covered_translate (s : State) (d : Int) (K : Nat) (M N : Int → Prop)
    (cover : Covered K M s) (sub : ∀ x, M (x-d) → N x) :
    Covered K N (translate d s) := by
  obtain ⟨F,c,B,cur,whole,bound⟩ := cover
  refine ⟨F+d,c,B,?_,?_,bound⟩
  · change s.current+d=F+d+c
    omega
  · intro x hx
    rcases whole (x-d) hx with low | point | marker
    · exact Or.inl (by omega)
    · right; left
      have eq : x-(F+d)=x-d-F := by omega
      rw [eq]
      exact point
    · exact Or.inr (Or.inr (sub x marker))

theorem all_translate (s : State) (w : List Int) (d : Int) (K : Nat)
    (M N : Int → Prop) (cover : AllCovered K M s w)
    (sub : ∀ x, M (x-d) → N x) :
    AllCovered K N (translate d s) (w.map (fun x => x+d)) := by
  intro i hi
  rw [← List.map_take, execute_translate]
  apply covered_translate _ d K M N
  · exact cover i (by simpa only [List.length_map] using hi)
  · exact sub

theorem covered_mark (s : State) (K : Nat) (M N : Int → Prop)
    (cover : Covered K M s) : Covered K (fun x => M x ∨ N x) (mark s N) := by
  obtain ⟨F,c,B,cur,whole,bound⟩ := cover
  refine ⟨F,c,B,cur,?_,bound⟩
  intro x hx
  rcases hx with old | added
  · rcases whole x old with low | point | marker
    · exact Or.inl low
    · exact Or.inr (Or.inl point)
    · exact Or.inr (Or.inr (Or.inl marker))
  · exact Or.inr (Or.inr (Or.inr added))

theorem all_mark (s : State) (w : List Int) (K : Nat) (M N : Int → Prop)
    (cover : AllCovered K M s w) :
    AllCovered K (fun x => M x ∨ N x) (mark s N) w := by
  intro i hi
  rw [execute_mark]
  exact covered_mark _ K M N (cover i hi)

theorem transfer_output_bound (t : Transfer) (K : Nat)
    (bound : nodesBound K (transferNodes t)) : FiniteBound K t.output := by
  exact bound _ (by simp [transferNodes])

/-- Annotated version of the exact chain construction. Remaining marker sets
shrink by absorption; translated tail prefixes are covered by the original
pending set. Neither the number of transfers nor their cycle counts is bounded. -/
theorem chain (s out : FiniteState) (cs : List CheckedTransfer)
    (linked : LadderLayers.Linked s cs out) (h : Int) (large : 2401 ≤ h)
    (residues : ∀ c ∈ cs, h % (c.transfer.modulus : Int) = c.transfer.residue)
    (far : Int → Prop) (farBound : ∀ x, far x → ((cs.length : Int)+1)*h ≤ x)
    (K : Nat) (initialBound : FiniteBound K s)
    (bounds : ∀ c ∈ cs, nodesBound K (transferNodes c.transfer)) :
    ∃ w : List Int,
      ValidWord (mark s.toState (pending h cs.length far)) w ∧
      execute (mark s.toState (pending h cs.length far)) w =
        mark (translate ((cs.length : Int)*h) out.toState) far ∧
      (w.length : Int) = (cs.length : Int)*h+corrections cs ∧
      AllCovered K (pending h cs.length far)
        (mark s.toState (pending h cs.length far)) w := by
  induction cs generalizing s far with
  | nil =>
    have eq := sameState_sound linked
    refine ⟨[],trivial,?_,?_,?_⟩
    · simp only [execute,pending,List.length_nil,Int.natCast_zero,Int.zero_mul,translate_zero,eq]
    · simp [corrections]
    · intro i hi
      have iz : i=0 := by simpa using hi
      subst i
      exact finite_covered s K initialBound far
  | cons c cs ih =>
    obtain ⟨entry,linked⟩ := linked
    have entryEq := sameState_sound entry
    have tailBound : ∀ x, far (x+h) → ((cs.length : Int)+1)*h ≤ x := by
      intro x hx
      have bound := farBound (x+h) hx
      simp only [List.length_cons,Int.natCast_succ,Int.add_mul,Int.one_mul] at bound ⊢
      omega
    have laterBound : ∀ x, pending h cs.length (fun y => far (y+h)) (x-h) → 2*h ≤ x := by
      intro x hx
      have low := pending_lower h (by omega) cs.length (fun y => far (y+h)) tailBound (x-h) hx
      omega
    obtain ⟨q,spacing,firstValid,firstEnd,firstCover⟩ := uniform_from_nodes c.transfer c.checked K h
      (fun x => pending h cs.length (fun y => far (y+h)) (x-h)) large
      (residues c (by simp)) laterBound (bounds c (by simp))
    obtain ⟨tail,tailValid,tailEnd,tailLength,tailCover⟩ := ih c.transfer.output linked
      (fun d hd => residues d (by simp [hd])) (fun y => far (y+h)) tailBound
      (transfer_output_bound _ K (bounds c (by simp))) (fun d hd => bounds d (by simp [hd]))
    let first := c.transfer.word q h
    have initialEq : mark s.toState (pending h (c::cs).length far) =
        mark c.transfer.initial.toState
          (fun x => x=h ∨ pending h cs.length (fun y => far (y+h)) (x-h)) := by
      rw [entryEq]
      rfl
    have joinEq : execute (mark s.toState (pending h (c::cs).length far)) first =
        translate h (mark c.transfer.output.toState (pending h cs.length (fun y => far (y+h)))) := by
      rw [initialEq,translate_mark]
      exact firstEnd
    refine ⟨first ++ tail.map (fun x => x+h),?_,?_,?_,?_⟩
    · apply (validWord_append _ _ _).mpr
      constructor
      · rw [initialEq]; exact firstValid
      · rw [joinEq]; exact validWord_translate h tailValid
    · rw [execute_append,joinEq,execute_translate,tailEnd,translate_mark_shift,translate_translate]
      have shift : h+(cs.length : Int)*h=((c::cs).length : Int)*h := by
        simp only [List.length_cons,Int.natCast_succ,Int.add_mul,Int.one_mul]
        omega
      rw [shift]
    · have firstLength := transfer_length c q h spacing
      change (first.length : Int)=h+correction c.transfer at firstLength
      simp only [List.length_append,List.length_map,Int.natCast_add,List.length_cons,
        Int.natCast_succ,Int.add_mul,Int.one_mul,corrections]
      change (first.length : Int)+(tail.length : Int)=_
      omega
    · apply UpperTransferPrefix.append K _ _ _ _
      · rw [initialEq]
        exact firstCover
      · rw [joinEq]
        apply all_translate _ tail h K _ _ tailCover
        intro x hx
        exact Or.inr hx

def LadderBound (K : Nat) (c : Ladder) : Prop :=
  ∀ i : Fin c.size, FiniteBound K (c.row i).entrance ∧
    ∀ t ∈ (c.row i).steps, nodesBound K (transferNodes t.transfer)

/-- The six-marker layer has a prefix cover with exactly its initial pending
set. This is an actual composition of the checked transfer words. -/
theorem one_layer (c : Ladder) (checked : c.Claim) (K : Nat) (bounds : LadderBound K c)
    (n : Nat) (far : Int → Prop) (farBound : ∀ x, far x → 7*scale n ≤ x) :
    ∃ w : List Int,
      ValidWord (mark (c.entry n).toState (pending (scale n) 6 far)) w ∧
      execute (mark (c.entry n).toState (pending (scale n) 6 far)) w =
        mark (translate (6*scale n) (c.entry (n+1)).toState) far ∧
      (w.length : Int)=6*scale n+c.layerCorrection n ∧
      AllCovered K (pending (scale n) 6 far)
        (mark (c.entry n).toState (pending (scale n) 6 far)) w := by
  have row := c.rows_checked checked (c.orbit n)
  have closing := sameState_sound row.2.2.2.1
  obtain ⟨length,linked,_,moduli,_,_,_⟩ := row.1
  have residues : ∀ t ∈ (c.row (c.orbit n)).steps,
      scale n % (t.transfer.modulus : Int)=t.transfer.residue := by
    intro t ht
    obtain ⟨divides,residue⟩ := moduli t ht
    have eq := Int.emod_emod_of_dvd (scale n) (Int.dvd_of_emod_eq_zero divides)
    rw [c.residue_invariant checked n] at eq
    exact eq.symm.trans residue
  have farBound' : ∀ x, far x → (((c.row (c.orbit n)).steps.length : Int)+1)*scale n ≤ x := by
    simpa [length] using farBound
  have result := chain _ _ _ linked (scale n) (scale_large n) residues far farBound' K
    (bounds (c.orbit n)).1 (bounds (c.orbit n)).2
  simpa [length,Ladder.entry,Ladder.orbit,Ladder.layerCorrection,closing] using result

/-- Unbounded induction through all increasing-spacing six-marker layers.
Every prefix retains a cover by its local node and the ORIGINAL tower. -/
theorem tower (c : Ladder) (checked : c.Claim) (K : Nat) (bounds : LadderBound K c)
    (n levels : Nat) :
    ∃ w : List Int,
      ValidWord (mark (c.entry n).toState (LadderLayers.tower (scale n) levels)) w ∧
      execute (mark (c.entry n).toState (LadderLayers.tower (scale n) levels)) w =
        translate (scale (n+levels)-scale n) (c.entry (n+levels)).toState ∧
      (w.length : Int)=scale (n+levels)-scale n+c.cumulative n levels ∧
      AllCovered K (LadderLayers.tower (scale n) levels)
        (mark (c.entry n).toState (LadderLayers.tower (scale n) levels)) w := by
  induction levels generalizing n with
  | zero =>
    refine ⟨[],trivial,?_,?_,?_⟩
    · simp [execute,LadderLayers.tower,mark_none,translate_zero]
    · simp [Ladder.cumulative]
    · intro i hi
      have iz : i=0 := by simpa using hi
      subst i
      exact finite_covered _ K (bounds (c.orbit n)).1 _
  | succ levels ih =>
    have large := scale_large n
    have nextLarge := scale_large (n+1)
    have firstBound : ∀ x, LadderLayers.tower (scale (n+1)) levels (x-6*scale n) → 7*scale n ≤ x := by
      intro x hx
      have low := tower_lower (scale (n+1)) (by omega) levels (x-6*scale n) hx
      rw [scale_succ] at low
      omega
    obtain ⟨first,firstValid,firstEnd,firstLength,firstCover⟩ := one_layer c checked K bounds n
      (fun x => LadderLayers.tower (scale (n+1)) levels (x-6*scale n)) firstBound
    obtain ⟨rest,restValid,restEnd,restLength,restCover⟩ := ih (n+1)
    have markers : LadderLayers.tower (scale n) (levels+1) =
        pending (scale n) 6 (fun x => LadderLayers.tower (scale (n+1)) levels (x-6*scale n)) := by
      rw [scale_succ]; rfl
    have join : execute (mark (c.entry n).toState (LadderLayers.tower (scale n) (levels+1))) first =
        translate (6*scale n) (mark (c.entry (n+1)).toState (LadderLayers.tower (scale (n+1)) levels)) := by
      rw [markers,translate_mark]
      exact firstEnd
    have index : n+1+levels=n+(levels+1) := by omega
    have displacement : 6*scale n+(scale (n+1+levels)-scale (n+1)) = scale (n+(levels+1))-scale n := by
      rw [index,scale_succ]; omega
    refine ⟨first ++ rest.map (fun x => x+6*scale n),?_,?_,?_,?_⟩
    · apply (validWord_append _ _ _).mpr
      constructor
      · rw [markers]; exact firstValid
      · rw [join]; exact validWord_translate _ restValid
    · rw [execute_append,join,execute_translate,restEnd,translate_translate,displacement,index]
    · simp only [List.length_append,List.length_map,Int.natCast_add,Ladder.cumulative]
      omega
    · apply UpperTransferPrefix.append K _ _ _ _
      · rw [markers]; exact firstCover
      · rw [join]
        apply all_translate _ rest (6*scale n) K _ _ restCover
        intro x hx
        rw [markers,pending_six]
        exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr hx)))))

end Heraclitus.UpperLadderPrefix

#print axioms Heraclitus.UpperLadderPrefix.chain
#print axioms Heraclitus.UpperLadderPrefix.one_layer
#print axioms Heraclitus.UpperLadderPrefix.tower
