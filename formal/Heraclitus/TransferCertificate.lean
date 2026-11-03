import Heraclitus.FiniteCertificate

set_option autoImplicit false

/-! Sound normalized routes and transfers with a finite transient.
The certificate preparer supplies data only. Every finite assertion below
is checked by kernel reduction or follows from a proved soundness lemma. -/

namespace Heraclitus.TransferCertificate

def BoundedStep (x y : Int) : Prop :=
  ∃ j : Fin 4, (y - x).natAbs = 7 ^ j.val

instance (x y : Int) : Decidable (BoundedStep x y) :=
  inferInstanceAs (Decidable (∃ j : Fin 4, (y - x).natAbs = 7 ^ j.val))

theorem boundedStep_sound {x y : Int} (h : BoundedStep x y) : PowerStep x y := by
  obtain ⟨j, hj⟩ := h
  exact ⟨j.val, hj⟩

theorem boundedStep_complete {x y : Int} (h : PowerStep x y)
    (bound : (y - x).natAbs < 2401) : BoundedStep x y := by
  obtain ⟨j, hj⟩ := h
  have small : j < 4 := by
    by_cases hn : j < 4
    · exact hn
    · have hp : (7 : Nat) ^ 4 ≤ 7 ^ j := Nat.pow_le_pow_right (by decide) (by omega)
      have value : (7 : Nat) ^ 4 = 2401 := by decide
      rw [value] at hp
      omega
  exact ⟨⟨j, small⟩, hj⟩

structure Node where
  current : Int
  points : List Int
deriving DecidableEq, Repr

def Node.finite (s : Node) : FiniteState := ⟨s.current, 0, s.points⟩
def Node.state (s : Node) : State := s.finite.toState
def Node.at (s : Node) (f : Int) : FiniteState := s.finite.shift f

theorem Node.at_state (s : Node) (f : Int) :
    (s.at f).toState = translate f s.state := FiniteState.shift_toState _ _

structure Edge where
  source : Node
  target : Node
  shift : Int
  choice : Int
deriving Repr

def Edge.Claim (e : Edge) : Prop :=
  0 ≤ e.choice ∧ ¬e.source.finite.toState.used e.choice ∧
    BoundedStep e.source.current e.choice ∧
    e.source.current.natAbs + e.choice.natAbs < 2401 ∧
    (∀ j : Fin 4,
      (e.source.finite.toState.used (e.source.current + (7 ^ j.val : Nat)) ∨
        e.choice ≤ e.source.current + (7 ^ j.val : Nat)) ∧
      (e.source.finite.toState.used (e.source.current - (7 ^ j.val : Nat)) ∨
        e.choice ≤ e.source.current - (7 ^ j.val : Nat))) ∧
    0 ≤ e.shift ∧ e.choice = e.target.current + e.shift ∧
    (∀ i : Fin e.shift.toNat, (e.source.finite.addVisit e.choice).toState.used i.val) ∧
    (∀ x ∈ e.choice :: e.source.points, (e.target.finite.shift e.shift).toState.used x) ∧
    (∀ x ∈ e.target.points, (e.source.finite.addVisit e.choice).toState.used (x + e.shift))

instance (e : Edge) : Decidable e.Claim :=
  inferInstanceAs (Decidable (0 ≤ e.choice ∧ ¬e.source.finite.toState.used e.choice ∧
    BoundedStep e.source.current e.choice ∧
    e.source.current.natAbs + e.choice.natAbs < 2401 ∧
    (∀ j : Fin 4,
      (e.source.finite.toState.used (e.source.current + (7 ^ j.val : Nat)) ∨
        e.choice ≤ e.source.current + (7 ^ j.val : Nat)) ∧
      (e.source.finite.toState.used (e.source.current - (7 ^ j.val : Nat)) ∨
        e.choice ≤ e.source.current - (7 ^ j.val : Nat))) ∧
    0 ≤ e.shift ∧ e.choice = e.target.current + e.shift ∧
    (∀ i : Fin e.shift.toNat, (e.source.finite.addVisit e.choice).toState.used i.val) ∧
    (∀ x ∈ e.choice :: e.source.points, (e.target.finite.shift e.shift).toState.used x) ∧
    (∀ x ∈ e.target.points, (e.source.finite.addVisit e.choice).toState.used (x + e.shift))))

theorem Edge.sound (e : Edge) (checked : e.Claim) :
    Greedy e.source.state e.choice ∧
      visit e.source.state e.choice = translate e.shift e.target.state := by
  obtain ⟨nonnegative, unused, step, cutoff, excludes, shiftNonneg, current,
    filled, forward, backward⟩ := checked
  constructor
  · refine ⟨unused, boundedStep_sound step, ?_⟩
    intro w hw hs
    change PowerStep e.source.current w at hs
    change ¬e.source.finite.toState.used w at hw
    by_cases le : e.choice ≤ w
    · exact le
    · have nonneg : 0 ≤ w := by
        by_cases hn : 0 ≤ w
        · exact hn
        · exact False.elim (hw (Or.inl (by change w < 0; omega)))
      have wb : w.natAbs ≤ e.choice.natAbs := by omega
      have triangle := Int.natAbs_sub_le w e.source.current
      have distance : (w - e.source.current).natAbs < 2401 := by omega
      obtain ⟨j, hj⟩ := boundedStep_complete hs distance
      rcases Int.natAbs_eq_iff.mp hj with hp | hn
      · have eq : w = e.source.current + (7 ^ j.val : Nat) := by omega
        rcases (excludes j).1 with occupied | larger
        · exact False.elim (hw (by simpa only [eq] using occupied))
        · omega
      · have eq : w = e.source.current - (7 ^ j.val : Nat) := by omega
        rcases (excludes j).2 with occupied | larger
        · exact False.elim (hw (by simpa only [eq] using occupied))
        · omega
  · have equality : (e.source.finite.addVisit e.choice).toState =
        (e.target.finite.shift e.shift).toState := by
      apply state_ext current
      intro x
      constructor
      · intro hx
        rcases hx with old | point
        · left
          change x < 0 + e.shift
          change x < 0 at old
          omega
        · exact forward x point
      · intro hx
        rcases hx with front | point
        · change x < 0 + e.shift at front
          by_cases neg : x < 0
          · exact Or.inl neg
          · have index : x.toNat < e.shift.toNat := by omega
            have value : (x.toNat : Int) = x := by omega
            simpa only [value] using filled ⟨x.toNat, index⟩
        · obtain ⟨y, hy, eq⟩ := List.mem_map.mp point
          rw [← eq]
          exact backward y hy
    simpa only [FiniteState.addVisit_toState, FiniteState.shift_toState, Node.state] using equality

structure CheckedEdge where
  edge : Edge
  checked : edge.Claim

def Connected (s : Node) : List CheckedEdge → Prop
  | [] => True
  | e :: es => s = e.edge.source ∧ Connected e.edge.target es

instance connectedDecidable (s : Node) (es : List CheckedEdge) : Decidable (Connected s es) :=
  match es with
  | [] => isTrue trivial
  | e :: rest =>
    letI := connectedDecidable e.edge.target rest
    inferInstanceAs (Decidable (s = e.edge.source ∧ Connected e.edge.target rest))

def word (f : Int) : List CheckedEdge → List Int
  | [] => []
  | e :: es => (f + e.edge.choice) :: word (f + e.edge.shift) es

def advance : List CheckedEdge → Int
  | [] => 0
  | e :: es => e.edge.shift + advance es

def last (s : Node) : List CheckedEdge → Node
  | [] => s
  | e :: es => last e.edge.target es

theorem word_length (f : Int) (es : List CheckedEdge) : (word f es).length = es.length := by
  induction es generalizing f with
  | nil => rfl
  | cons e es ih => simp only [word, List.length_cons, ih]

theorem route_sound (s : Node) (es : List CheckedEdge) (f : Int)
    (linked : Connected s es) :
    ValidWord (translate f s.state) (word f es) ∧
      execute (translate f s.state) (word f es) =
        translate (f + advance es) (last s es).state := by
  induction es generalizing s f with
  | nil => simp [word, advance, last, ValidWord, execute]
  | cons e es ih =>
    obtain ⟨rfl, linked⟩ := linked
    have edge := e.edge.sound e.checked
    have visit_eq : visit (translate f e.edge.source.state) (f + e.edge.choice) =
        translate (f + e.edge.shift) e.edge.target.state := by
      rw [Int.add_comm f e.edge.choice, ← translate_visit, edge.2, translate_translate]
    have rest := ih e.edge.target (f + e.edge.shift) linked
    constructor
    · refine ⟨?_, ?_⟩
      · simpa only [Int.add_comm f e.edge.choice] using greedy_translate f edge.1
      · change ValidWord (visit (translate f e.edge.source.state) (f + e.edge.choice)) _
        rw [visit_eq]
        exact rest.1
    · change execute (visit (translate f e.edge.source.state) (f + e.edge.choice)) _ = _
      rw [visit_eq, rest.2]
      simp only [advance, last, Int.add_assoc]

structure Route where
  initial : Node
  edges : List CheckedEdge
  linked : Connected initial edges

def Route.word (r : Route) (f : Int) : List Int := TransferCertificate.word f r.edges
def Route.advance (r : Route) : Int := TransferCertificate.advance r.edges
def Route.last (r : Route) : Node := TransferCertificate.last r.initial r.edges

theorem Route.sound (r : Route) (f : Int) :
    ValidWord (r.initial.at f).toState (r.word f) ∧
      execute (r.initial.at f).toState (r.word f) =
        (r.last.at (f + r.advance)).toState := by
  simpa only [Node.at_state, Route.word, Route.advance, Route.last] using
    route_sound r.initial r.edges f r.linked

def sameState (s t : FiniteState) : Bool :=
  s.equalityCheck t (min s.front t.front)
    (1 + ([s.front, t.front] ++ s.points ++ t.points).foldl max 0)

theorem sameState_sound {s t : FiniteState} (checked : sameState s t = true) :
    s.toState = t.toState := FiniteState.equalityCheck_sound checked

structure Transfer where
  initialFront : Int
  transient : Route
  cycle : Route
  before : Route
  phase : Nat
  target : Int
  after : List Int
  modulus : Nat
  residue : Int
  repairFront : Int
  repair : Route
  output : FiniteState

def Transfer.entryFront (t : Transfer) : Int := t.initialFront + t.transient.advance
def Transfer.initial (t : Transfer) : FiniteState := t.transient.initial.at t.initialFront
def Transfer.entry (t : Transfer) : FiniteState := t.cycle.initial.at t.entryFront
def Transfer.phaseState (t : Transfer) : FiniteState :=
  t.before.last.at (t.entryFront + t.before.advance)

def Transfer.Claim (t : Transfer) : Prop :=
  t.transient.last = t.cycle.initial ∧
  t.before.initial = t.cycle.initial ∧
  t.cycle.last = t.cycle.initial ∧
  t.cycle.advance = (t.modulus : Int) ∧
  t.cycle.edges.length = t.modulus ∧
  t.before.edges.length = t.phase ∧
  t.cycle.word t.entryFront = t.before.word t.entryFront ++ t.target :: t.after ∧
  t.target % (t.modulus : Int) = t.residue ∧
  t.target < 2000 ∧
  (∀ x ∈ t.transient.word t.initialFront, x < 2000) ∧
  (∀ x ∈ t.cycle.word t.entryFront, x < t.target + 2000) ∧
  (∀ x ∈ t.repair.word t.repairFront, x < 2000) ∧
  sameState ((t.phaseState.shift (-t.target)).markPoint 0)
    (t.repair.initial.at t.repairFront) = true ∧
  sameState (t.repair.last.at (t.repairFront + t.repair.advance)) t.output = true ∧
  0 < t.output.front ∧ t.output.front < 2000 ∧ ¬t.output.toState.used t.output.front

instance (t : Transfer) : Decidable t.Claim :=
  inferInstanceAs (Decidable (
    t.transient.last = t.cycle.initial ∧
    t.before.initial = t.cycle.initial ∧
    t.cycle.last = t.cycle.initial ∧
    t.cycle.advance = (t.modulus : Int) ∧
    t.cycle.edges.length = t.modulus ∧
    t.before.edges.length = t.phase ∧
    t.cycle.word t.entryFront = t.before.word t.entryFront ++ t.target :: t.after ∧
    t.target % (t.modulus : Int) = t.residue ∧
    t.target < 2000 ∧
    (∀ x ∈ t.transient.word t.initialFront, x < 2000) ∧
    (∀ x ∈ t.cycle.word t.entryFront, x < t.target + 2000) ∧
    (∀ x ∈ t.repair.word t.repairFront, x < 2000) ∧
    sameState ((t.phaseState.shift (-t.target)).markPoint 0)
      (t.repair.initial.at t.repairFront) = true ∧
    sameState (t.repair.last.at (t.repairFront + t.repair.advance)) t.output = true ∧
    0 < t.output.front ∧ t.output.front < 2000 ∧ ¬t.output.toState.used t.output.front))

def Transfer.word (t : Transfer) (q : Nat) (h : Int) : List Int :=
  t.transient.word t.initialFront ++
    ((repeatedWord (t.cycle.word t.entryFront) (t.modulus : Int) q ++
      (t.before.word t.entryFront).map (fun x => x + (q : Int) * (t.modulus : Int))) ++
      (t.repair.word t.repairFront).map (fun x => x + h))

theorem Transfer.word_length (t : Transfer) (checked : t.Claim) (q : Nat) (h : Int) :
    (t.word q h).length = t.transient.edges.length + t.modulus * q + t.phase + t.repair.edges.length := by
  have lc := checked.2.2.2.2.1
  have lb := checked.2.2.2.2.2.1
  simp only [Transfer.word, List.length_append, List.length_map, repeatedWord_length,
    Route.word, TransferCertificate.word_length, lc, lb]
  rw [Nat.mul_comm q t.modulus]
  omega

/-- A nonempty transient is coupled before the all-spacing cycle law. -/
theorem Transfer.uniform (t : Transfer) (checked : t.Claim)
    (h : Int) (later : Int → Prop) (large : 2401 ≤ h)
    (residue : h % (t.modulus : Int) = t.residue)
    (later_bound : ∀ x, later x → 2 * h ≤ x) :
    ∃ q : Nat, h = t.target + (q : Int) * (t.modulus : Int) ∧
      ValidWord (mark t.initial.toState (fun x => x = h ∨ later x)) (t.word q h) ∧
      execute (mark t.initial.toState (fun x => x = h ∨ later x)) (t.word q h) =
        mark (translate h t.output.toState) later := by
  obtain ⟨entryNode, beforeNode, closeNode, cycleAdvance, cycleLength, _, split,
    targetResidue, targetBound, transientBound, cycleBound, repairBound,
    repairStart, repairEnd, _, _, _⟩ := checked
  have pre := t.transient.sound t.initialFront
  have cyc := t.cycle.sound t.entryFront
  have bef := t.before.sound t.entryFront
  have rep := t.repair.sound t.repairFront
  have preEnd : execute t.initial.toState (t.transient.word t.initialFront) = t.entry.toState := by
    simpa only [entryNode, Transfer.initial, Transfer.entry, Transfer.entryFront] using pre.2
  have beforeEnd : execute t.entry.toState (t.before.word t.entryFront) = t.phaseState.toState := by
    simpa only [beforeNode, Transfer.entry, Transfer.phaseState] using bef.2
  have length : (t.cycle.word t.entryFront).length = t.modulus := by
    simpa only [Route.word, TransferCertificate.word_length] using cycleLength
  have closes : execute t.entry.toState (t.cycle.word t.entryFront) =
      translate ((t.cycle.word t.entryFront).length : Int) t.entry.toState := by
    rw [length]
    simpa only [Transfer.entry, Node.at_state, closeNode, cycleAdvance,
      translate_translate, Int.add_comm t.entryFront (t.modulus : Int)] using cyc.2
  have inserted : mark (translate (-t.target)
      (execute t.entry.toState (t.before.word t.entryFront))) (fun x => x = 0) =
      (t.repair.initial.at t.repairFront).toState := by
    have eq := sameState_sound repairStart
    simpa only [beforeEnd, FiniteState.markPoint_toState, FiniteState.shift_toState] using eq
  have fixedRepair : ValidWord (mark (translate (-t.target)
      (execute t.entry.toState (t.before.word t.entryFront))) (fun x => x = 0))
      (t.repair.word t.repairFront) := by
    rw [inserted]
    exact rep.1
  have endRepair : execute (t.repair.initial.at t.repairFront).toState
      (t.repair.word t.repairFront) = t.output.toState :=
    rep.2.trans (sameState_sound repairEnd)
  have congruence : h % ((t.cycle.word t.entryFront).length : Int) =
      t.target % ((t.cycle.word t.entryFront).length : Int) := by
    simpa only [length, targetResidue] using residue
  obtain ⟨q, spacing, valid, endpoint⟩ := residue_marker_transfer t.entry.toState
    (t.cycle.word t.entryFront) (t.before.word t.entryFront) t.after
    (t.repair.word t.repairFront) t.target h later split cyc.1 closes
    targetBound cycleBound large congruence later_bound fixedRepair repairBound
  rw [inserted, endRepair] at endpoint
  have avoid : ∀ x ∈ t.transient.word t.initialFront, ¬(x = h ∨ later x) := by
    intro x hx marked
    have bound := transientBound x hx
    rcases marked with equal | next
    · omega
    · have lb := later_bound x next
      omega
  have markedPre := validWord_mark pre.1 avoid
  have markedEnd : execute (mark t.initial.toState (fun x => x = h ∨ later x))
      (t.transient.word t.initialFront) = mark t.entry.toState (fun x => x = h ∨ later x) := by
    rw [execute_mark, preEnd]
  refine ⟨q, by simpa only [length] using spacing, ?_, ?_⟩
  · apply (validWord_append _ _ _).mpr
    refine ⟨markedPre, ?_⟩
    rw [markedEnd]
    simpa only [length] using valid
  · change execute _ (t.transient.word t.initialFront ++ _) = _
    rw [execute_append, markedEnd]
    simpa only [length] using endpoint

theorem Transfer.checkpoint (t : Transfer) (checked : t.Claim)
    (h : Int) (later : Int → Prop) (large : 2401 ≤ h)
    (later_bound : ∀ x, later x → 2 * h ≤ x) :
    (∀ x, x ≤ h → (mark (translate h t.output.toState) later).used x) ∧
      ¬(mark (translate h t.output.toState) later).used (h + t.output.front) := by
  obtain ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, positive, small, fresh⟩ := checked
  constructor
  · intro x hx
    left
    left
    change x - h < t.output.front
    omega
  · intro used
    rcases used with old | laterUsed
    · have eq : h + t.output.front - h = t.output.front := by omega
      change t.output.toState.used (h + t.output.front - h) at old
      rw [eq] at old
      exact fresh old
    · have bound := later_bound (h + t.output.front) laterUsed
      omega

structure CheckedTransfer where
  transfer : Transfer
  checked : transfer.Claim

def Transfer.Result (t : Transfer) (h : Int) (later : Int → Prop) : Prop :=
  ∃ q : Nat, h = t.target + (q : Int) * (t.modulus : Int) ∧
    ValidWord (mark t.initial.toState (fun x => x = h ∨ later x)) (t.word q h) ∧
    execute (mark t.initial.toState (fun x => x = h ∨ later x)) (t.word q h) =
      mark (translate h t.output.toState) later ∧
    (t.word q h).length = t.transient.edges.length + t.modulus * q + t.phase + t.repair.edges.length ∧
    (∀ x, x ≤ h → (execute (mark t.initial.toState (fun x => x = h ∨ later x))
      (t.word q h)).used x) ∧
    ¬(execute (mark t.initial.toState (fun x => x = h ∨ later x))
      (t.word q h)).used (h + t.output.front)

theorem Transfer.complete (t : Transfer) (checked : t.Claim)
    (h : Int) (later : Int → Prop) (large : 2401 ≤ h)
    (residue : h % (t.modulus : Int) = t.residue)
    (later_bound : ∀ x, later x → 2 * h ≤ x) : t.Result h later := by
  obtain ⟨q, spacing, valid, endpoint⟩ := t.uniform checked h later large residue later_bound
  have checkpoint := t.checkpoint checked h later large later_bound
  refine ⟨q, spacing, valid, endpoint, t.word_length checked q h, ?_, ?_⟩
  · rw [endpoint]
    exact checkpoint.1
  · rw [endpoint]
    exact checkpoint.2

end Heraclitus.TransferCertificate
