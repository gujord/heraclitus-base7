import Heraclitus.TransferCertificate
import Heraclitus.OutgoingWord
import Heraclitus.GlobalWalk

set_option autoImplicit false

/-! Exact full-state semantics for every prefix of a checked route.
These generic results do not verify a particular return route, marker count,
signed lifting, or any all-scale deviation bound. -/
namespace Heraclitus.RoutePrefix
open Heraclitus.TransferCertificate

/-- The first i route choices are exactly the choices of the first i edges. -/
theorem word_take (es : List CheckedEdge) (f : Int) (i : Nat) :
    (word f es).take i = word f (es.take i) := by
  induction es generalizing f i with
  | nil => simp [word]
  | cons e es ih =>
    cases i with
    | zero => rfl
    | succ i => simp only [word, List.take_succ_cons, ih]

/-- Every initial part of a connected route is itself connected. -/
theorem connected_take (s : Node) (es : List CheckedEdge) (i : Nat)
    (h : Connected s es) : Connected s (es.take i) := by
  induction es generalizing s i with
  | nil => simp [Connected]
  | cons e es ih =>
    cases i with
    | zero => trivial
    | succ i =>
      change s=e.edge.source ∧ Connected e.edge.target es at h
      change s=e.edge.source ∧ Connected e.edge.target (es.take i)
      exact ⟨h.1, ih e.edge.target i h.2⟩

/-- Exact state, current and all occupied points, after any edge prefix. -/
theorem checked_route_prefix (r : Route) (f : Int) (i : Nat) :
    execute (translate f r.initial.state) ((r.word f).take i) =
      translate (f + advance (r.edges.take i)) (last r.initial (r.edges.take i)).state := by
  change execute (translate f r.initial.state) ((word f r.edges).take i) = _
  rw [word_take]
  exact (route_sound r.initial (r.edges.take i) f (connected_take r.initial r.edges i r.linked)).2

/-- Fixed additional markers are retained exactly at each prefix. This is an
identity of complete sets; it does not imply marked-word greediness. -/
theorem marked_checked_route_prefix (r : Route) (f : Int) (i : Nat)
    (markers : Int → Prop) :
    execute (mark (translate f r.initial.state) markers) ((r.word f).take i) =
      mark (translate (f + advance (r.edges.take i))
        (last r.initial (r.edges.take i)).state) markers := by
  rw [execute_mark, checked_route_prefix]

/-- Execution on one signed ray agrees with half-line execution, preserving
all points on the other ray, if each chosen physical magnitude is positive. -/
theorem execute_lift_ray (side : Bool) (C : Int) (other : RayBoundary)
    (s : State) (w : List Int) (positive : ∀ x ∈ w, 0 < C+x) :
    execute (OutgoingWord.liftRay side C other s) (w.map (embedRay side C)) =
      OutgoingWord.liftRay side C other (execute s w) := by
  induction w generalizing s with
  | nil => rfl
  | cons x xs ih =>
    have hx : 0 < C+x := positive x (by simp)
    have rest : ∀ y ∈ xs, 0 < C+y := by
      intro y hy
      exact positive y (by simp [hy])
    simp only [List.map_cons, execute]
    rw [← OutgoingWord.lift_visit side C other s x hx]
    exact ih (visit s x) rest

/-- Physical signed form: at every checked route prefix the active ray is
the current normalized node union the original markers, and the opposite
ray is retained. Positivity is explicit and must be checked for each route. -/
theorem signed_marked_route_prefix (r : Route) (f C : Int) (i : Nat)
    (markers : Int → Prop) (side : Bool) (other : RayBoundary)
    (positive : ∀ x ∈ (r.word f).take i, 0 < C+x) :
    execute (OutgoingWord.liftRay side C other
      (mark (translate f r.initial.state) markers))
      (((r.word f).take i).map (embedRay side C)) =
    OutgoingWord.liftRay side C other
      (mark (translate (f + advance (r.edges.take i))
        (last r.initial (r.edges.take i)).state) markers) := by
  rw [execute_lift_ray side C other _ _ positive, marked_checked_route_prefix]

/-- A checked route prefix equals the actual greedy walk at the corresponding
index when the physical start state and signed validity are provided. -/
theorem actual_signed_route_prefix (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base : Nat) (r : Route) (f C : Int) (i : Nat)
    (markers : Int → Prop) (side : Bool) (other : RayBoundary)
    (start : GlobalWalk.stateAt a base = OutgoingWord.liftRay side C other
      (mark (translate f r.initial.state) markers))
    (valid : SignedValidWord (GlobalWalk.stateAt a base)
      ((r.word f).map (embedRay side C)))
    (bound : i ≤ (r.word f).length)
    (positive : ∀ x ∈ (r.word f).take i, 0 < C+x) :
    GlobalWalk.stateAt a (base+i) = OutgoingWord.liftRay side C other
      (mark (translate (f + advance (r.edges.take i))
        (last r.initial (r.edges.take i)).state) markers) := by
  let w := (r.word f).map (embedRay side C)
  have part : SignedValidWord (GlobalWalk.stateAt a base) (w.take i) := by
    have h : SignedValidWord (GlobalWalk.stateAt a base) (w.take i ++ w.drop i) := by
      simpa only [List.take_append_drop] using valid
    exact ((signedValidWord_append _ _ _).mp h).1
  have finish := GlobalWalk.valid_word_endpoint a walk base (w.take i) part
  have len : (w.take i).length=i := by
    simp only [w, List.length_take, List.length_map, Nat.min_eq_left bound]
  rw [len, start] at finish
  have trans : (w.take i) = ((r.word f).take i).map (embedRay side C) := by
    simp only [w, List.map_take]
  rw [trans, signed_marked_route_prefix r f C i markers side other positive] at finish
  exact finish.symm

end Heraclitus.RoutePrefix
#print axioms Heraclitus.RoutePrefix.word_take
#print axioms Heraclitus.RoutePrefix.connected_take
#print axioms Heraclitus.RoutePrefix.checked_route_prefix
#print axioms Heraclitus.RoutePrefix.marked_checked_route_prefix

#print axioms Heraclitus.RoutePrefix.execute_lift_ray
#print axioms Heraclitus.RoutePrefix.signed_marked_route_prefix

#print axioms Heraclitus.RoutePrefix.actual_signed_route_prefix
