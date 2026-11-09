import TransferPrefix
import Core

set_option autoImplicit false

namespace Heraclitus.UpperTransferPrefix
open TransferCertificate TailCover UpperKernelCatalogue

/-- Every prefix endpoint belongs to the concrete finite route node list. -/
theorem prefix_node_mem (s : Node) (es : List CheckedEdge) (i : Nat) :
    last s (es.take i) ∈ s :: es.flatMap (fun e => [e.edge.source,e.edge.target]) := by
  induction es generalizing s i with
  | nil => simp [last]
  | cons e es ih =>
    cases i with
    | zero => simp [last]
    | succ i =>
      have h := ih e.edge.target i
      simp only [List.take_succ_cons, last]
      rcases List.mem_cons.mp h with equal | tail
      · simp [equal]
      · simp only [List.flatMap_cons, List.cons_append, List.nil_append, List.mem_cons]
        exact Or.inr (Or.inr (Or.inr tail))

theorem route_bound (r : Route) (K : Nat) (h : nodesBound K (routeNodes r)) :
    RouteBound r K := by
  intro i _
  exact h _ (prefix_node_mem r.initial r.edges i)

/-- The finite, computable catalogue condition controls all prefixes of the
infinite family of transfer words. -/
theorem transfer_from_nodes (t : Transfer) (checked : t.Claim) (K q : Nat)
    (h : Int) (later : Int → Prop)
    (spacing : h = t.target + (q : Int)*(t.modulus : Int))
    (bound : nodesBound K (transferNodes t)) :
    AllCovered K (fun x => x=h ∨ later x)
      (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) := by
  obtain ⟨a,b,c,d⟩ := transfer_route_bounds t K bound
  exact transfer t checked K q h later spacing (route_bound _ K a)
    (route_bound _ K b) (route_bound _ K c) (route_bound _ K d)

theorem uniform_from_nodes (t : Transfer) (checked : t.Claim) (K : Nat)
    (h : Int) (later : Int → Prop) (large : 2401 ≤ h)
    (residue : h % (t.modulus : Int) = t.residue)
    (laterBound : ∀ x, later x → 2*h ≤ x)
    (bound : nodesBound K (transferNodes t)) :
    ∃ q : Nat, h = t.target + (q : Int)*(t.modulus : Int) ∧
      ValidWord (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) ∧
      execute (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) =
        mark (translate h t.output.toState) later ∧
      AllCovered K (fun x => x=h ∨ later x)
        (mark t.initial.toState (fun x => x=h ∨ later x)) (t.word q h) := by
  obtain ⟨a,b,c,d⟩ := transfer_route_bounds t K bound
  exact uniform t checked K h later large residue laterBound (route_bound _ K a)
    (route_bound _ K b) (route_bound _ K c) (route_bound _ K d)

end Heraclitus.UpperTransferPrefix

#print axioms Heraclitus.UpperTransferPrefix.prefix_node_mem
#print axioms Heraclitus.UpperTransferPrefix.transfer_from_nodes
#print axioms Heraclitus.UpperTransferPrefix.uniform_from_nodes
