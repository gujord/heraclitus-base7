import Heraclitus.LadderEnvelope

set_option autoImplicit false

/-! Uniform marked-endpoint transfers in the signed return band.
The later-marker set is retained exactly; bounds concern new choices. -/

namespace Heraclitus.SignedTransfer
open TransferCertificate OutgoingWord

def Bounds (t : Transfer) : Prop :=
  (-100 ≤ t.initial.current ∧ t.initial.current ≤ 2000) ∧
  -100 ≤ t.initial.front ∧ LadderEnvelope.OutputBound t.output 2000

instance (t : Transfer) : Decidable (Bounds t) := by
  unfold Bounds
  infer_instance

structure Checked where
  original : CheckedTransfer
  bounds : Bounds original.transfer

def start (t : Transfer) (h : Int) (later : List Int) : FiniteState :=
  ⟨t.initial.current, t.initial.front, h :: (later ++ t.initial.points)⟩

def endpoint (t : Transfer) (h : Int) (later : List Int) : State :=
  mark (translate h t.output.toState) (fun x => x ∈ later)

theorem start_eq (t : Transfer) (h : Int) (later : List Int) :
    (start t h later).toState = mark t.initial.toState (fun x => x=h ∨ x ∈ later) := by
  apply state_ext
  · rfl
  · intro x
    simp [start, FiniteState.toState, mark, or_assoc, or_left_comm, or_comm]

/-- A point already used initially cannot be chosen anywhere in a valid word. -/
theorem word_fresh {s : State} {w : List Int} (valid : ValidWord s w) :
    ∀ x ∈ w, ¬s.used x := by
  induction w generalizing s with
  | nil => simp
  | cons v vs ih =>
    intro x member
    rcases List.mem_cons.mp member with eq | rest
    · subst x; exact valid.1.1
    · intro old
      exact ih valid.2 x rest (Or.inl old)

/-- The complete endpoint bounds every newly chosen point, even when
farther premarked points lie beyond the choice bound. -/
theorem choice_bounds (c : Checked) (h : Int) (later : List Int) (w : List Int)
    (valid : ValidWord (start c.original.transfer h later).toState w)
    (finish : execute (start c.original.transfer h later).toState w =
      endpoint c.original.transfer h later) :
    ∀ x ∈ w, -100 ≤ x ∧ x < h+2000 := by
  have lower := LadderEnvelope.word_lower_of_valid _ w (-100)
    (by intro x hx
        exact Or.inl (by change x < c.original.transfer.initial.front
                         have bound := c.bounds.2.1; omega)) valid
  intro x member
  refine ⟨lower x member, ?_⟩
  have used : (endpoint c.original.transfer h later).used x := by
    rw [← finish]
    exact (execute_used_iff _ w x).mpr (Or.inr member)
  rcases used with base | far
  · have bound := LadderEnvelope.outputBound_sound c.bounds.2.2 base
    change x-h < 2000 at bound
    omega
  · have fresh := word_fresh valid x member
    rw [start_eq] at fresh
    exact False.elim (fresh (Or.inr (Or.inr far)))

theorem Checked.halfline (c : Checked) (h : Int) (later : List Int)
    (large : 2401 ≤ h)
    (residue : h % (c.original.transfer.modulus : Int) = c.original.transfer.residue)
    (far : ∀ x ∈ later, 2*h ≤ x) :
    ∃ q : Nat, h=c.original.transfer.target+(q : Int)*c.original.transfer.modulus ∧
      ValidWord (start c.original.transfer h later).toState (c.original.transfer.word q h) ∧
      execute (start c.original.transfer h later).toState (c.original.transfer.word q h) =
        endpoint c.original.transfer h later ∧
      (c.original.transfer.word q h).length = c.original.transfer.transient.edges.length+
        c.original.transfer.modulus*q+c.original.transfer.phase+c.original.transfer.repair.edges.length ∧
      (∀ x ∈ c.original.transfer.word q h, -100 ≤ x ∧ x < h+2000) := by
  obtain ⟨q, spacing, valid, finish⟩ := c.original.transfer.uniform c.original.checked h
    (fun x => x ∈ later) large residue far
  rw [← start_eq] at valid finish
  exact ⟨q, spacing, valid, finish, c.original.transfer.word_length c.original.checked q h,
    choice_bounds c h later _ valid finish⟩

/-- Translate a transfer into the return band. Every intermediate current
and choice satisfies the signed bridge; neither validity nor bounds are assumed. -/
theorem Checked.signed (c : Checked) (k : Nat) (C d h : Int) (later : List Int)
    (side : Bool) (other : RayBoundary)
    (radius : 2*C+1=(7^k : Nat)) (scaleLarge : 100000 ≤ (7^k : Nat))
    (spacingLarge : 2401 ≤ h)
    (residue : h % (c.original.transfer.modulus : Int) = c.original.transfer.residue)
    (far : ∀ x ∈ later, 2*h ≤ x) (nonnegative : 0 ≤ d)
    (targetBound : d+h ≤ 2*((7^k : Nat) : Int)+3)
    (filled : 3*(7^k : Nat)-200 ≤ other.front) :
    ∃ q : Nat, ∃ b : SignedBlock
      (liftRay side C other ((start c.original.transfer h later).shift d).toState)
      (liftRay side C other (translate d (endpoint c.original.transfer h later))),
      h=c.original.transfer.target+(q : Int)*c.original.transfer.modulus ∧
      b.word.length = c.original.transfer.transient.edges.length+
        c.original.transfer.modulus*q+c.original.transfer.phase+c.original.transfer.repair.edges.length := by
  obtain ⟨q, spacing, valid, finish, count, bounds⟩ := c.halfline h later spacingLarge residue far
  let w := (c.original.transfer.word q h).map (fun x => x+d)
  have shifted : ValidWord ((start c.original.transfer h later).shift d).toState w := by
    rw [FiniteState.shift_toState]
    exact validWord_translate d valid
  have envelope : ReturnBridge.Envelope (7^k : Nat)
      ((start c.original.transfer h later).shift d).toState w := by
    apply LadderEnvelope.envelope_of_choices
    · change -100 ≤ c.original.transfer.initial.current+d ∧
        c.original.transfer.initial.current+d ≤ 2*((7^k : Nat) : Int)+4096
      have initial := c.bounds.1
      omega
    · intro x member
      obtain ⟨y, member, eq⟩ := List.mem_map.mp member
      have bound := bounds y member
      omega
  have signed := ReturnBridge.return_word _ other side k C w radius scaleLarge filled shifted envelope
  have endState : execute ((start c.original.transfer h later).shift d).toState w =
      translate d (endpoint c.original.transfer h later) := by
    rw [FiniteState.shift_toState, execute_translate, finish]
  rw [endState] at signed
  refine ⟨q, ⟨w.map (embedRay side C), signed.1, signed.2⟩, spacing, ?_⟩
  simp only [List.length_map, w, count]

theorem endpoint_used (t : Transfer) (d h x : Int) (later : List Int) :
    (translate d (endpoint t h later)).used x ↔
      t.output.toState.used (x-(d+h)) ∨ x-d ∈ later := by
  change (t.output.toState.used (x-d-h) ∨ x-d ∈ later) ↔ _
  rw [show x-d-h=x-(d+h) by omega]

theorem endpoint_current (t : Transfer) (d h : Int) (later : List Int) :
    (translate d (endpoint t h later)).current=t.output.current+h+d := rfl

theorem endpoint_retains (t : Transfer) (d h : Int) (later : List Int) :
    ∀ x ∈ later, (translate d (endpoint t h later)).used (x+d) := by
  intro x member
  change t.output.toState.used (x+d-d-h) ∨ x+d-d ∈ later
  exact Or.inr (by simpa only [Int.add_sub_cancel] using member)

theorem after_ladder_endpoint (t : Transfer) (m A : Int) :
    translate (m+A) (endpoint t m [2*m]) =
      mark (translate (2*m+A) t.output.toState) (fun x => x=3*m+A) := by
  apply state_ext
  · change t.output.current+m+(m+A)=t.output.current+(2*m+A)
    omega
  · intro x
    rw [endpoint_used]
    change (t.output.toState.used (x-(m+A+m)) ∨ x-(m+A) ∈ [2*m]) ↔
      (t.output.toState.used (x-(2*m+A)) ∨ x=3*m+A)
    rw [List.mem_singleton, show m+A+m=2*m+A by omega]
    have eq : x-(m+A)=2*m ↔ x=3*m+A := by omega
    rw [eq]

/-- Ready-to-match post-ladder transfer: target 2m+A, later marker 3m+A.
The concrete ladder-output/transfer-input identification is still required. -/
theorem Checked.after_ladder (c : Checked) (k : Nat) (C A : Int)
    (side : Bool) (other : RayBoundary)
    (radius : 2*C+1=(7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (anchor : -3 ≤ A ∧ A ≤ 3)
    (residue : ((7^k : Nat) : Int) % c.original.transfer.modulus=c.original.transfer.residue)
    (filled : 3*(7^k : Nat)-200 ≤ other.front) :
    ∃ q : Nat, ∃ b : SignedBlock
      (liftRay side C other
        ((start c.original.transfer (7^k : Nat) [2*(7^k : Nat)]).shift ((7^k : Nat)+A)).toState)
      (liftRay side C other
        (mark (translate (2*(7^k : Nat)+A) c.original.transfer.output.toState)
          (fun x => x=3*(7^k : Nat)+A))),
      (7^k : Nat)=c.original.transfer.target+(q : Int)*c.original.transfer.modulus ∧
      b.word.length=c.original.transfer.transient.edges.length+c.original.transfer.modulus*q+
        c.original.transfer.phase+c.original.transfer.repair.edges.length := by
  have big : (100000 : Int) ≤ (7^k : Nat) := Int.ofNat_le.mpr large
  have transfer := c.signed k C ((7^k : Nat)+A) (7^k : Nat) [2*(7^k : Nat)] side other
    radius large (by omega) residue
    (by intro x hx; have eq := List.mem_singleton.mp hx; omega)
    (by omega) (by omega) filled
  rw [after_ladder_endpoint] at transfer
  exact transfer

end Heraclitus.SignedTransfer
