import ConcreteLadderPrefix
import CatalogueInstance
import Heraclitus.SignedApproach

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

namespace Heraclitus.UpperReturnTail
open TransferCertificate OutgoingWord UpperLadderPrefix UpperTransferPrefix UpperKernelCatalogue

/-- A signed marked transfer with its complete endpoint and all actual
prefix tails. Every later marker is retained in the finite cover. -/
theorem actual_transfer (c : SignedTransfer.Checked)
    (member : c.original ∈ TransferCatalogue.catalogue)
    (k : Nat) (C d h : Int) (later : List Int) (side : Bool) (other : RayBoundary)
    (radius : 2*C+1=(7^k : Nat)) (large : 100000≤(7^k : Nat))
    (spacingLarge : 2401≤h)
    (residue : h % c.original.transfer.modulus=c.original.transfer.residue)
    (far : ∀ x∈later, 2*h≤x) (nonnegative : 0≤d)
    (targetBound : d+h≤2*((7^k : Nat) : Int)+3)
    (filled : 3*(7^k : Nat)-200≤other.front)
    (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (base : Nat)
    (start : GlobalWalk.stateAt a base=liftRay side C other
      ((SignedTransfer.start c.original.transfer h later).shift d).toState) :
    ∃ q : Nat, ∃ w : List Int,
      SignedValidWord (GlobalWalk.stateAt a base) w ∧
      GlobalWalk.stateAt a (base+w.length)=liftRay side C other
        (translate d (SignedTransfer.endpoint c.original.transfer h later)) ∧
      h=c.original.transfer.target+(q : Int)*c.original.transfer.modulus ∧
      w.length=c.original.transfer.transient.edges.length+
        c.original.transfer.modulus*q+c.original.transfer.phase+c.original.transfer.repair.edges.length ∧
      ∀ i, i≤w.length → ∀ D, PhysicalTail.count a (base+i) D≤54+later.length := by
  obtain ⟨q, spacing, valid, finish, count, bounds⟩ := c.halfline h later spacingLarge residue far
  let s := ((SignedTransfer.start c.original.transfer h later).shift d).toState
  let u := (c.original.transfer.word q h).map (fun x => x+d)
  have shifted : ValidWord s u := by
    dsimp only [s,u]
    rw [FiniteState.shift_toState]
    exact validWord_translate d valid
  have envelope : ReturnBridge.Envelope (7^k : Nat) s u := by
    apply LadderEnvelope.envelope_of_choices
    · change -100≤c.original.transfer.initial.current+d ∧
        c.original.transfer.initial.current+d≤2*((7^k : Nat) : Int)+4096
      have initial := c.bounds.1
      omega
    · intro x hx
      obtain ⟨y,hy,eq⟩ := List.mem_map.mp hx
      have bound := bounds y hy
      omega
  have lifted := ReturnBridge.return_word _ other side k C u radius large filled shifted envelope
  have signed : SignedValidWord (GlobalWalk.stateAt a base) (u.map (embedRay side C)) := by
    rw [start]; exact lifted.1
  have endpoint : execute s u=translate d (SignedTransfer.endpoint c.original.transfer h later) := by
    dsimp only [s,u]
    rw [FiniteState.shift_toState,execute_translate,finish]
  have reached := GlobalWalk.valid_word_endpoint a walk base _ signed
  rw [start,lifted.2,endpoint] at reached
  have rawCover := catalogue_prefixes c.original member q h (fun x => x∈later) spacing
  have finite : AllFinite (54+later.length)
      (SignedTransfer.start c.original.transfer h later).toState (c.original.transfer.word q h) := by
    rw [SignedTransfer.start_eq]
    apply all_finite_cover 53 _ _ _ rawCover (h::later)
    · intro x hx
      exact List.mem_cons.mpr hx
    · simp only [List.length_cons]; omega
  have cover : AllFinite (54+later.length) s u := by
    dsimp only [s,u]
    rw [FiniteState.shift_toState]
    exact all_finite_translate _ _ _ d finite
  have initialPositive : 0<C+s.current := by
    change 0<C+(c.original.transfer.initial.current+d)
    have initial := c.bounds.1
    have big : (100000 : Int)≤(7^k : Nat) := Int.ofNat_le.mpr large
    omega
  have positive : ∀ x∈u,0<C+x := by
    intro x hx
    obtain ⟨y,hy,eq⟩ := List.mem_map.mp hx
    have bound := bounds y hy
    have big : (100000 : Int)≤(7^k : Nat) := Int.ofNat_le.mpr large
    omega
  refine ⟨q,u.map (embedRay side C),signed,reached.symm,spacing,?_,?_⟩
  · simpa only [List.length_map,u] using count
  · intro i hi D
    exact actual_prefix_bound a walk base D side C other s u start signed initialPositive positive
      (54+later.length) cover i (by simpa only [List.length_map] using hi)

theorem approach_local_cover (c : ApproachWord.Checked)
    (member : c∈ApproachWordData.catalogue) (q : Nat) :
    AllFinite 43 c.row.initial.toState (c.row.localWord q) := by
  let s := c.row.original.transfer
  have checked := c.row.original.checked
  have all := all_approaches c member
  have preBound : nodesBound 43 (routeNodes s.transient) := by
    intro x hx
    apply all x
    simp only [approachNodes,List.mem_append]
    exact Or.inl (Or.inl hx)
  have cycBound : nodesBound 43 (routeNodes s.cycle) := by
    intro x hx
    apply all x
    simp only [approachNodes,List.mem_append]
    exact Or.inl (Or.inr hx)
  have preEnd : execute s.initial.toState (s.transient.word s.initialFront)=s.entry.toState := by
    simpa only [s,Transfer.initial,Transfer.entry,Transfer.entryFront,checked.1]
      using (s.transient.sound s.initialFront).2
  have closes : execute s.entry.toState (s.cycle.word s.entryFront)=
      translate s.modulus s.entry.toState := by
    simpa only [s,Transfer.entry,Node.at_state,checked.2.2.1,
      checked.2.2.2.1,translate_translate,Int.add_comm c.row.original.transfer.entryFront
        (c.row.original.transfer.modulus : Int)] using (s.cycle.sound s.entryFront).2
  have same := sameState_sound c.checked.2.2.2.2.2.1
  have cover : AllCovered 43 (fun _ => False) (mark s.initial.toState (fun _ => False))
      (c.row.localWord q) := by
    apply UpperTransferPrefix.append
    · have first := route s.transient s.initialFront 0 (fun _ => False) (fun _ => False) 43
        (route_bound _ _ preBound) (fun _ h => h)
      simpa [translate_zero,Transfer.initial] using first
    · rw [execute_mark,preEnd]
      exact cycles s.cycle s.entryFront s.modulus (fun _ => False) 43 q
        (route_bound _ _ cycBound) closes
  rw [LadderLayers.mark_none] at cover
  change AllCovered 43 (fun _ => False) c.row.original.transfer.initial.toState _ at cover
  rw [same] at cover
  exact all_finite_cover 43 _ _ _ cover [] (fun _ h => False.elim h) 43 (by decide)

/-- Marked approach prefixes, including arbitrary translated cycle repeats,
have at most 43 local ahead points plus the one retained outer marker. -/
theorem approach_cover (c : ApproachWord.Checked)
    (member : c∈ApproachWordData.catalogue) (t : Nat) :
    AllFinite 44 (c.row.start (c.row.scale t)) (c.row.word (c.row.scale t)) := by
  have localCover := approach_local_cover c member (c.row.quotient (c.row.scale t))
  have shifted := all_finite_translate 43 _ _ (2*c.row.scale t+c.row.offset) localCover
  have marked := all_finite_mark 43 _ _ (fun x => x=3*c.row.scale t+c.row.offset)
    [3*c.row.scale t+c.row.offset] (by intro x hx; simp only [List.mem_singleton]; exact hx) shifted
  exact marked

theorem actual_approach (c : ApproachWord.Checked)
    (member : c∈ApproachWordData.catalogue) (t : Nat) (C : Int) (side : Bool) (other : RayBoundary)
    (scale : 2*C+1=(7^(c.row.exponent t) : Nat))
    (filled : 3*c.row.scale t-200≤other.front)
    (a : Nat → Int) (walk : GlobalWalk.IsWalk a) (base : Nat)
    (start : GlobalWalk.stateAt a base=liftRay side C other (c.row.start (c.row.scale t))) :
    ∃ w : List Int,
      SignedValidWord (GlobalWalk.stateAt a base) w ∧
      GlobalWalk.stateAt a (base+w.length)=liftRay side C other (c.row.finish (c.row.scale t)) ∧
      (w.length : Int)=c.row.moves (c.row.scale t) ∧
      ∀ i, i≤w.length → ∀ D, PhysicalTail.count a (base+i) D≤44 := by
  obtain ⟨block,word,count⟩ := SignedApproach.all_exponents c t C side other scale filled
  have signed : SignedValidWord (GlobalWalk.stateAt a base) block.word := by
    rw [start]; exact block.valid
  have endpoint := GlobalWalk.valid_word_endpoint a walk base block.word signed
  rw [start,block.endpoint] at endpoint
  obtain ⟨choices,initial⟩ := c.bounds t
  have large := c.large t
  have initialPositive : 0<C+(c.row.start (c.row.scale t)).current := by
    change 2*C+1=c.row.scale t at scale
    omega
  have positive : ∀ x∈c.row.word (c.row.scale t),0<C+x := by
    intro x hx
    have lower := (choices x hx).1
    change 2*C+1=c.row.scale t at scale
    omega
  refine ⟨block.word,signed,endpoint.symm,count,?_⟩
  intro i hi D
  rw [word] at signed hi
  exact actual_prefix_bound a walk base D side C other _ _ start signed initialPositive positive
    44 (approach_cover c member t) i (by simpa only [List.length_map] using hi)

end Heraclitus.UpperReturnTail
