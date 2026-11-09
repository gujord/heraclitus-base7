import CatalogueTransferPrefix
import SignedTransferPrefix
import Catalogue

set_option autoImplicit false

namespace Heraclitus.UpperTransferPrefix
open TransferCertificate UpperKernelCatalogue

/-- No local-score premise remains for a member of the checked 119-row
catalogue. The number of repeated cycles is arbitrary. -/
theorem catalogue_prefixes (c : CheckedTransfer) (member : c ∈ TransferCatalogue.catalogue)
    (q : Nat) (h : Int) (later : Int → Prop)
    (spacing : h=c.transfer.target+(q : Int)*(c.transfer.modulus : Int)) :
    AllCovered 53 (fun x => x=h ∨ later x)
      (mark c.transfer.initial.toState (fun x => x=h ∨ later x)) (c.transfer.word q h) :=
  transfer_from_nodes c.transfer c.checked 53 q h later spacing (all_transfers c member)

theorem catalogue_uniform (c : CheckedTransfer) (member : c ∈ TransferCatalogue.catalogue)
    (h : Int) (later : Int → Prop) (large : 2401 ≤ h)
    (residue : h % (c.transfer.modulus : Int) = c.transfer.residue)
    (laterBound : ∀ x, later x → 2*h ≤ x) :
    ∃ q : Nat, h = c.transfer.target + (q : Int)*(c.transfer.modulus : Int) ∧
      ValidWord (mark c.transfer.initial.toState (fun x => x=h ∨ later x)) (c.transfer.word q h) ∧
      execute (mark c.transfer.initial.toState (fun x => x=h ∨ later x)) (c.transfer.word q h) =
        mark (translate h c.transfer.output.toState) later ∧
      AllCovered 53 (fun x => x=h ∨ later x)
        (mark c.transfer.initial.toState (fun x => x=h ∨ later x)) (c.transfer.word q h) :=
  uniform_from_nodes c.transfer c.checked 53 h later large residue laterBound (all_transfers c member)

theorem actual_catalogue_tail (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base D : Nat) (side : Bool) (C : Int) (other : RayBoundary)
    (c : CheckedTransfer) (member : c ∈ TransferCatalogue.catalogue)
    (q : Nat) (h : Int) (later : Int → Prop)
    (spacing : h=c.transfer.target+(q : Int)*(c.transfer.modulus : Int))
    (start : GlobalWalk.stateAt a base = OutgoingWord.liftRay side C other
      (mark c.transfer.initial.toState (fun x => x=h ∨ later x)))
    (valid : SignedValidWord (GlobalWalk.stateAt a base)
      ((c.transfer.word q h).map (embedRay side C)))
    (initialPositive : 0 < C+c.transfer.initial.toState.current)
    (positive : ∀ x ∈ c.transfer.word q h, 0 < C+x)
    (markers : List Int) (markerCover : ∀ x, x=h ∨ later x → x ∈ markers)
    (i : Nat) (hi : i ≤ (c.transfer.word q h).length) :
    PhysicalTail.count a (base+i) D ≤ 53+markers.length := by
  obtain ⟨b₁,b₂,b₃,b₄⟩ := transfer_route_bounds c.transfer 53 (all_transfers c member)
  exact actual_transfer_tail a walk base D side C other c.transfer c.checked 53 q h later
    spacing (route_bound _ _ b₁) (route_bound _ _ b₂) (route_bound _ _ b₃) (route_bound _ _ b₄)
    start valid initialPositive positive markers markerCover i hi

end Heraclitus.UpperTransferPrefix

#print axioms Heraclitus.UpperTransferPrefix.catalogue_prefixes
#print axioms Heraclitus.UpperTransferPrefix.catalogue_uniform
#print axioms Heraclitus.UpperTransferPrefix.actual_catalogue_tail
