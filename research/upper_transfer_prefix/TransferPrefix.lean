import RoutePrefix
import CycleCoupling
import TailCover

set_option autoImplicit false

/-! All prefixes of an unbounded checked transfer have a finite local tail
plus the original marker set. No signed reachability or global 3/8 claim is
asserted here. -/
namespace Heraclitus.UpperTransferPrefix
open TransferCertificate TailCover

def RouteBound (r : Route) (K : Nat) : Prop :=
  ∀ i, i ≤ r.edges.length →
    (localAhead (last r.initial (r.edges.take i)).current
      (last r.initial (r.edges.take i)).points).length ≤ K

/-- Complete used-set inclusion; markers are fixed in physical coordinates. -/
def Covered (K : Nat) (M : Int → Prop) (s : State) : Prop :=
  ∃ F c : Int, ∃ B : List Int,
    s.current = F+c ∧
    (∀ x, s.used x → x < F ∨ x-F ∈ B ∨ M x) ∧
    (localAhead c B).length ≤ K

def AllCovered (K : Nat) (M : Int → Prop) (s : State) (w : List Int) : Prop :=
  ∀ i, i ≤ w.length → Covered K M (execute s (w.take i))

theorem covered_node (n : Node) (F : Int) (N M : Int → Prop) (K : Nat)
    (bound : (localAhead n.current n.points).length ≤ K)
    (sub : ∀ x, N x → M x) :
    Covered K M (mark (translate F n.state) N) := by
  refine ⟨F, n.current, n.points, ?_, ?_, bound⟩
  · change n.current + F = F+n.current
    omega
  · intro x hx
    change (x-F < 0 ∨ x-F ∈ n.points) ∨ N x at hx
    rcases hx with (low | point) | marked
    · exact Or.inl (by omega)
    · exact Or.inr (Or.inl point)
    · exact Or.inr (Or.inr (sub x marked))

theorem append (K : Nat) (M : Int → Prop) (s : State) (u v : List Int)
    (hu : AllCovered K M s u)
    (hv : AllCovered K M (execute s u) v) :
    AllCovered K M s (u ++ v) := by
  intro i hi
  by_cases small : i ≤ u.length
  · rw [List.take_append_of_le_length small]
    exact hu i small
  · have left : u.length ≤ i := by omega
    have right : i-u.length ≤ v.length := by simp only [List.length_append] at hi; omega
    rw [List.take_append, List.take_of_length_le left, execute_append]
    exact hv (i-u.length) right

/-- Every translated prefix is controlled by its actual checked route node. -/
theorem route (r : Route) (f d : Int) (N M : Int → Prop) (K : Nat)
    (bound : RouteBound r K) (sub : ∀ x, N x → M x) :
    AllCovered K M (mark (translate d (r.initial.at f).toState) N)
      ((r.word f).map (fun x => x+d)) := by
  intro i hi
  rw [← List.map_take, execute_mark, execute_translate, Node.at_state,
    RoutePrefix.checked_route_prefix, translate_translate]
  apply covered_node _ _ N M K
  · apply bound i
    simpa only [List.length_map, Route.word, word_length] using hi
  · exact sub

theorem cycles (r : Route) (f d : Int) (M : Int → Prop) (K q : Nat)
    (bound : RouteBound r K)
    (closes : execute (r.initial.at f).toState (r.word f) =
      translate d (r.initial.at f).toState) :
    AllCovered K M (mark (r.initial.at f).toState M)
      (repeatedWord (r.word f) d q) := by
  induction q with
  | zero =>
    intro i hi
    have iz : i=0 := by simpa [repeatedWord] using hi
    subst i
    simp only [repeatedWord, List.take_zero, execute, Node.at_state]
    exact covered_node r.initial f M M K (bound 0 (by omega)) (fun _ h => h)
  | succ q ih =>
    change AllCovered K M _ (repeatedWord (r.word f) d q ++ _)
    apply append K M _ _ _ ih
    rw [execute_mark, (translation_cycle (r.sound f).1 closes q).2]
    exact route r f ((q : Int)*d) M M K bound (fun _ h => h)

/-- Every prefix, including arbitrary repetitions and the repair seam, is
covered by a finite local node and the *original* marker set. Repair absorbs
the target marker into its local state; no extra marker visit is counted. -/
theorem transfer (t : Transfer) (checked : t.Claim) (K q : Nat)
    (h : Int) (later : Int → Prop)
    (spacing : h = t.target + (q : Int)*(t.modulus : Int))
    (transientBound : RouteBound t.transient K)
    (cycleBound : RouteBound t.cycle K)
    (beforeBound : RouteBound t.before K)
    (repairBound : RouteBound t.repair K) :
    AllCovered K (fun x => x=h ∨ later x)
      (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) := by
  let M : Int → Prop := fun x => x=h ∨ later x
  obtain ⟨entryNode, beforeNode, closeNode, cycleAdvance, _, _, _, _, _, _, _, _,
    repairStart, _, _, _, _⟩ := checked
  have preEnd : execute t.initial.toState (t.transient.word t.initialFront) =
      t.entry.toState := by
    simpa only [entryNode, Transfer.initial, Transfer.entry, Transfer.entryFront]
      using (t.transient.sound t.initialFront).2
  have beforeEnd : execute t.entry.toState (t.before.word t.entryFront) =
      t.phaseState.toState := by
    simpa only [beforeNode, Transfer.entry, Transfer.phaseState]
      using (t.before.sound t.entryFront).2
  have closes : execute t.entry.toState (t.cycle.word t.entryFront) =
      translate (t.modulus : Int) t.entry.toState := by
    simpa only [Transfer.entry, Node.at_state, closeNode, cycleAdvance,
      translate_translate, Int.add_comm t.entryFront (t.modulus : Int)]
      using (t.cycle.sound t.entryFront).2
  have inserted : mark (translate (-t.target) t.phaseState.toState) (fun x => x=0) =
      (t.repair.initial.at t.repairFront).toState := by
    simpa only [FiniteState.markPoint_toState, FiniteState.shift_toState]
      using sameState_sound repairStart
  have repeatedEnd : execute t.entry.toState
      (repeatedWord (t.cycle.word t.entryFront) (t.modulus : Int) q) =
      translate ((q : Int)*(t.modulus : Int)) t.entry.toState :=
    (translation_cycle (t.cycle.sound t.entryFront).1 closes q).2
  have seam : mark (translate ((q : Int)*(t.modulus : Int)) t.phaseState.toState) M =
      mark (translate h (t.repair.initial.at t.repairFront).toState) later := by
    rw [← inserted, ← mark_singleton_translate, translate_translate, mark_mark]
    have shift : h + -t.target = (q : Int)*(t.modulus : Int) := by omega
    rw [shift]
  change AllCovered K M _ (t.transient.word t.initialFront ++ _)
  apply append K M _ _ _
  · have first := route t.transient t.initialFront 0 M M K transientBound (fun _ hx => hx)
    simpa [translate_zero, Transfer.initial, M] using first
  · rw [execute_mark, preEnd]
    apply append K M _ _ _
    · apply append K M _ _ _
      · exact cycles t.cycle t.entryFront (t.modulus : Int) M K q cycleBound closes
      · rw [execute_mark, repeatedEnd]
        have part := route t.before t.entryFront ((q : Int)*(t.modulus : Int)) M M K
          beforeBound (fun _ hx => hx)
        simpa only [beforeNode, Transfer.entry] using part
    · rw [ReturnTailCycle.marked_cycle_phase t.entry.toState _ _ (t.modulus : Int)
        M q (t.cycle.sound t.entryFront).1 closes, beforeEnd, seam]
      exact route t.repair t.repairFront h later M K repairBound (fun _ hx => Or.inr hx)

/-- A finite list covering the original markers gives a numerical bound,
with duplicate markers allowed and with no assertion they are new visits. -/
theorem covered_tail (s : State) (M : Int → Prop) (K : Nat) (markers xs : List Int)
    (cover : Covered K M s) (markerCover : ∀ x, M x → x ∈ markers)
    (distinct : xs.Nodup) (ahead : ∀ x ∈ xs, s.current < x ∧ s.used x) :
    xs.length ≤ K + markers.length := by
  obtain ⟨F,c,B,current,whole,bound⟩ := cover
  let localPoints := (localAhead c B).map (fun x => x+F)
  have sub : xs ⊆ localPoints ++ markers := by
    intro x hx
    have ha := ahead x hx
    rcases whole x ha.2 with low | extra | marked
    · apply List.mem_append.mpr; left
      apply List.mem_map.mpr
      exact ⟨x-F, localAhead_mem c (x-F) B (by omega) (Or.inl (by omega)), by omega⟩
    · apply List.mem_append.mpr; left
      apply List.mem_map.mpr
      exact ⟨x-F, localAhead_mem c (x-F) B (by omega) (Or.inr extra), by omega⟩
    · exact List.mem_append.mpr (Or.inr (markerCover x marked))
  have result := distinct.length_le_of_subset sub
  simp only [List.length_append, localPoints, List.length_map] at result
  omega

theorem transfer_tail (t : Transfer) (checked : t.Claim) (K q : Nat)
    (h : Int) (later : Int → Prop)
    (spacing : h = t.target + (q : Int)*(t.modulus : Int))
    (transientBound : RouteBound t.transient K) (cycleBound : RouteBound t.cycle K)
    (beforeBound : RouteBound t.before K) (repairBound : RouteBound t.repair K)
    (markers : List Int) (markerCover : ∀ x, x=h ∨ later x → x ∈ markers)
    (i : Nat) (hi : i ≤ (t.word q h).length) (xs : List Int) (distinct : xs.Nodup)
    (ahead : ∀ x ∈ xs,
      (execute (mark t.initial.toState (fun x => x=h ∨ later x))
        ((t.word q h).take i)).current < x ∧
      (execute (mark t.initial.toState (fun x => x=h ∨ later x))
        ((t.word q h).take i)).used x) :
    xs.length ≤ K + markers.length :=
  covered_tail _ _ K markers xs
    (transfer t checked K q h later spacing transientBound cycleBound beforeBound repairBound i hi)
    markerCover distinct ahead

/-- The existing uniform-spacing transfer produces the same witness q for
greedy validity, the exact complete endpoint, and all prefix covers. -/
theorem uniform (t : Transfer) (checked : t.Claim) (K : Nat)
    (h : Int) (later : Int → Prop) (large : 2401 ≤ h)
    (residue : h % (t.modulus : Int) = t.residue)
    (laterBound : ∀ x, later x → 2*h ≤ x)
    (transientBound : RouteBound t.transient K) (cycleBound : RouteBound t.cycle K)
    (beforeBound : RouteBound t.before K) (repairBound : RouteBound t.repair K) :
    ∃ q : Nat, h = t.target + (q : Int)*(t.modulus : Int) ∧
      ValidWord (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) ∧
      execute (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) =
        mark (translate h t.output.toState) later ∧
      AllCovered K (fun x => x=h ∨ later x)
        (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) := by
  obtain ⟨q,spacing,valid,endpoint⟩ := t.uniform checked h later large residue laterBound
  exact ⟨q,spacing,valid,endpoint,
    transfer t checked K q h later spacing transientBound cycleBound beforeBound repairBound⟩

/-- Pending markers can be covered by a tower plus two outer points. The
target is included in that same cover, rather than counted once again. -/
theorem transfer_tower_tail (t : Transfer) (checked : t.Claim) (q : Nat)
    (h : Int) (later : Int → Prop)
    (spacing : h = t.target + (q : Int)*(t.modulus : Int))
    (transientBound : RouteBound t.transient 53) (cycleBound : RouteBound t.cycle 53)
    (beforeBound : RouteBound t.before 53) (repairBound : RouteBound t.repair 53)
    (H shift outer₁ outer₂ : Int) (levels : Nat)
    (markerCover : ∀ x, x=h ∨ later x →
      LadderLayers.tower H levels (x-shift) ∨ x=outer₁ ∨ x=outer₂)
    (i : Nat) (hi : i ≤ (t.word q h).length) (xs : List Int) (distinct : xs.Nodup)
    (ahead : ∀ x ∈ xs,
      (execute (mark t.initial.toState (fun x => x=h ∨ later x))
        ((t.word q h).take i)).current < x ∧
      (execute (mark t.initial.toState (fun x => x=h ∨ later x))
        ((t.word q h).take i)).used x) :
    xs.length ≤ 55 + 6*levels := by
  let markers := (ReturnTailTower.towerPoints H levels).map (fun x => x+shift) ++ [outer₁,outer₂]
  have cover : ∀ x, x=h ∨ later x → x ∈ markers := by
    intro x hx
    rcases markerCover x hx with tw | one | two
    · apply List.mem_append.mpr; left
      apply List.mem_map.mpr
      exact ⟨x-shift, (ReturnTailTower.towerPoints_exact H (x-shift) levels).mp tw, by omega⟩
    · simp [markers, one]
    · simp [markers, two]
  have result := transfer_tail t checked 53 q h later spacing transientBound cycleBound
    beforeBound repairBound markers cover i hi xs distinct ahead
  simp only [markers, List.length_append, List.length_map,
    ReturnTailTower.towerPoints_length, List.length_cons, List.length_nil] at result
  omega

end Heraclitus.UpperTransferPrefix

#print axioms Heraclitus.UpperTransferPrefix.transfer
#print axioms Heraclitus.UpperTransferPrefix.transfer_tail
#print axioms Heraclitus.UpperTransferPrefix.uniform
#print axioms Heraclitus.UpperTransferPrefix.transfer_tower_tail
