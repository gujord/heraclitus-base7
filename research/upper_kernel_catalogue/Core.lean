import TailCover
import Heraclitus.LadderBottom

set_option autoImplicit false

namespace Heraclitus.UpperKernelCatalogue
open TransferCertificate TailCover LadderBottom

def normalized (s : FiniteState) : Node :=
  ⟨s.current-s.front, s.points.map (fun x => x-s.front)⟩

def routeNodes (r : Route) : List Node :=
  r.initial :: r.edges.flatMap (fun e => [e.edge.source, e.edge.target])

def transferNodes (t : Transfer) : List Node :=
  routeNodes t.transient ++ routeNodes t.cycle ++ routeNodes t.before ++
    routeNodes t.repair ++ [normalized t.output]

def nodesBound (K : Nat) (ns : List Node) : Prop :=
  ∀ n ∈ ns, (localAhead n.current n.points).length ≤ K

instance (K : Nat) (ns : List Node) : Decidable (nodesBound K ns) :=
  inferInstanceAs (Decidable (∀ n ∈ ns, (localAhead n.current n.points).length ≤ K))

theorem transfer_route_bounds (t : Transfer) (K : Nat)
    (h : nodesBound K (transferNodes t)) :
    nodesBound K (routeNodes t.transient) ∧
    nodesBound K (routeNodes t.cycle) ∧
    nodesBound K (routeNodes t.before) ∧
    nodesBound K (routeNodes t.repair) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> intro n hn <;> apply h n <;>
    simp [transferNodes, hn]

def HasLocal (K : Nat) (s : State) : Prop :=
  ∃ f : FiniteState, s = f.toState ∧
    (localAhead (normalized f).current (normalized f).points).length ≤ K

def AllLocal (K : Nat) (s : State) : List Int → Prop
  | [] => HasLocal K s
  | v :: vs => HasLocal K s ∧ AllLocal K (visit s v) vs

def Matches (K : Nat) (s : Bitmap) (f : FiniteState) : Prop :=
  encode s.lo f = s ∧ s.lo ≤ f.front ∧ (∀ x ∈ f.points, s.lo ≤ x) ∧
    (localAhead (normalized f).current (normalized f).points).length ≤ K

instance (K : Nat) (s : Bitmap) (f : FiniteState) : Decidable (Matches K s f) :=
  inferInstanceAs (Decidable (encode s.lo f = s ∧ s.lo ≤ f.front ∧
    (∀ x ∈ f.points, s.lo ≤ x) ∧
    (localAhead (normalized f).current (normalized f).points).length ≤ K))

def CheckLocals (K : Nat) (s : Bitmap) : List Int → List FiniteState → Prop
  | [], [f] => Matches K s f
  | v :: vs, f :: fs => Matches K s f ∧ s.lo ≤ v ∧ CheckLocals K (s.addVisit v) vs fs
  | _, _ => False

instance checkLocalsDecidable (K : Nat) (s : Bitmap) (w : List Int) (fs : List FiniteState) :
    Decidable (CheckLocals K s w fs) :=
  match w, fs with
  | [], [f] => inferInstanceAs (Decidable (Matches K s f))
  | v::vs, f::rest =>
    letI := checkLocalsDecidable K (s.addVisit v) vs rest
    inferInstanceAs (Decidable (Matches K s f ∧ s.lo ≤ v ∧ CheckLocals K (s.addVisit v) vs rest))
  | [], [] | [], _::_::_ | _::_, [] => isFalse (fun h => h)

theorem matches_sound (K : Nat) (s : Bitmap) (f : FiniteState)
    (h : Matches K s f) : HasLocal K s.toState := by
  obtain ⟨eq, lower, points, bound⟩ := h
  refine ⟨f, ?_, bound⟩
  have sound := encode_sound s.lo f lower points
  rw [eq] at sound
  exact sound

theorem checkLocals_sound (K : Nat) (s : Bitmap) (w : List Int) (fs : List FiniteState)
    (h : CheckLocals K s w fs) : AllLocal K s.toState w := by
  induction w generalizing s fs with
  | nil =>
    cases fs with
    | nil => exact False.elim h
    | cons f rest =>
      cases rest with
      | nil => exact matches_sound K s f h
      | cons _ _ => exact False.elim h
  | cons v vs ih =>
    cases fs with
    | nil => exact False.elim h
    | cons f rest =>
      obtain ⟨first, lower, tail⟩ := h
      refine ⟨matches_sound K s f first, ?_⟩
      rw [← Bitmap.addVisit_sound s v lower]
      exact ih (s.addVisit v) rest tail

theorem allLocal_prefix (K : Nat) (s : State) (w : List Int) (h : AllLocal K s w)
    (i : Nat) (hi : i ≤ w.length) : HasLocal K (execute s (w.take i)) := by
  induction w generalizing s i with
  | nil => simpa [AllLocal, execute] using h
  | cons v vs ih =>
    cases i with
    | zero => exact h.1
    | succ i => exact ih (visit s v) h.2 i (by simpa using Nat.le_of_succ_le_succ hi)

theorem allLocal_append (K : Nat) (s : State) (u v : List Int)
    (hu : AllLocal K s u) (hv : AllLocal K (execute s u) v) :
    AllLocal K s (u ++ v) := by
  induction u generalizing s with
  | nil => exact hv
  | cons x xs ih => exact ⟨hu.1, ih (visit s x) hu.2 hv⟩

theorem route_allLocal (K : Nat) (s out : Bitmap) (cs : List CheckedChunk)
    (linked : Linked s cs out) (last : HasLocal K out.toState)
    (bounds : ∀ c ∈ cs, AllLocal K c.chunk.initial.toState c.chunk.word) :
    AllLocal K s.toState (routeWord cs) := by
  induction cs generalizing s with
  | nil => simpa only [Linked] using (linked ▸ last)
  | cons c cs ih =>
    obtain ⟨rfl, links⟩ := linked
    have first := bounds c (by simp)
    have tail := ih c.chunk.output links (fun d hd => bounds d (by simp [hd]))
    have eq := (check_sound c.chunk.initial c.chunk.output c.chunk.word c.checked.1).2
    change AllLocal K c.chunk.initial.toState (c.chunk.word ++ routeWord cs)
    apply allLocal_append K _ _ _ first
    simpa only [eq] using tail

theorem bottom_allLocal (K : Nat) (b : CheckedBottom)
    (outBound : (localAhead (normalized b.bottom.output).current
      (normalized b.bottom.output).points).length ≤ K)
    (bounds : ∀ c ∈ b.bottom.chunks,
      AllLocal K c.chunk.initial.toState c.chunk.word) :
    AllLocal K (LadderDescent.start b.bottom.entrance.entrance.old 2401) b.bottom.word := by
  obtain ⟨_, _, front, points, linked, _⟩ := b.checked
  have startBounds := input_bounds b.bottom.entrance.entrance b.bottom.entrance.checked
  have startEq := encode_sound (-200) (input b.bottom.entrance.entrance) startBounds.1 startBounds.2
  rw [input_sound] at startEq
  have endEq := encode_sound (-200) b.bottom.output front points
  have endpoint : HasLocal K (encode (-200) b.bottom.output).toState :=
    ⟨b.bottom.output, endEq, outBound⟩
  have result := route_allLocal K _ _ b.bottom.chunks linked endpoint bounds
  simpa only [startEq, Bottom.word] using result

end Heraclitus.UpperKernelCatalogue
