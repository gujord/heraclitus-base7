import Heraclitus.Refinement

set_option autoImplicit false

/-! Exact cardinality of the complete signed boundary representation.
A valid path and equality of its entire endpoint are explicit premises.
This does not construct the missing long signed segments.
-/
namespace Heraclitus.TransferCounting

def WellFormed (C : Int) (b : RayBoundary) : Prop :=
  0 < C + b.front ∧ b.extra.Nodup ∧ ∀ x ∈ b.extra, b.front ≤ x

def positivePoints (C : Int) (b : RayBoundary) : List Int :=
  ((List.range (C + b.front - 1).toNat).map (fun (i : Nat) => (i : Int) + 1)) ++
    b.extra.map (fun x => C + x)

theorem positivePoints_mem (C : Int) (b : RayBoundary) (wf : WellFormed C b) (z : Int) :
    z ∈ positivePoints C b ↔ 0 < z ∧ boundaryUsed b (z - C) := by
  simp only [positivePoints, List.mem_append, List.mem_map, List.mem_range]
  constructor
  · intro member
    rcases member with ⟨i, hi, rfl⟩ | ⟨x, hx, rfl⟩
    · exact ⟨by omega, Or.inl (by have h := wf.1; omega)⟩
    · have h := wf.2.2 x hx
      have p := wf.1
      have eq : C + x - C = x := by omega
      exact ⟨by omega, Or.inr (by simpa only [eq] using hx)⟩
  · rintro ⟨positive, below | extra⟩
    · left
      refine ⟨(z - 1).toNat, ?_, ?_⟩ <;> have h := wf.1 <;> omega
    · exact Or.inr ⟨z-C, extra, by omega⟩

private theorem map_nodup {α β : Type} (f : α → β)
    (injective : ∀ a b, f a = f b → a = b) (xs : List α) (nd : xs.Nodup) :
    (xs.map f).Nodup := by
  induction xs with
  | nil => simp
  | cons a xs ih =>
    have h := List.nodup_cons.mp nd
    apply List.nodup_cons.mpr
    refine ⟨?_, ih h.2⟩
    intro member
    obtain ⟨b, hb, eq⟩ := List.mem_map.mp member
    have same := injective b a eq
    subst b
    exact h.1 hb

theorem positivePoints_nodup (C : Int) (b : RayBoundary) (wf : WellFormed C b) :
    (positivePoints C b).Nodup := by
  apply List.nodup_append.mpr
  refine ⟨map_nodup _ (by intro a b eq; omega) _ List.nodup_range,
    map_nodup _ (by intro a b eq; omega) _ wf.2.1, ?_⟩
  intro x hx y hy eq
  obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hx
  obtain ⟨v, hv, rfl⟩ := List.mem_map.mp hy
  have bound := List.mem_range.mp hi
  have lower := wf.2.2 v hv
  have front := wf.1
  omega

def history (C : Int) (pos neg : RayBoundary) : List Int :=
  0 :: (positivePoints C pos ++ (positivePoints C neg).map (fun z => -z))

theorem history_mem (C : Int) (pos neg : RayBoundary)
    (wp : WellFormed C pos) (wn : WellFormed C neg)
    (side : Bool) (current z : Int) :
    z ∈ history C pos neg ↔ (signedBoundary C pos neg side current).used z := by
  simp only [history, List.mem_cons, List.mem_append, List.mem_map,
    positivePoints_mem C pos wp, positivePoints_mem C neg wn]
  change (z = 0 ∨ (0 < z ∧ boundaryUsed pos (z-C)) ∨
    ∃ a, (0 < a ∧ boundaryUsed neg (a-C)) ∧ -a = z) ↔ _
  constructor
  · intro member
    rcases member with zero | positive | ⟨a, ⟨ha, used⟩, eq⟩
    · exact Or.inl zero
    · exact Or.inr (Or.inl positive)
    · right; right
      have h : a = -z := by omega
      subst a
      exact ⟨by omega, used⟩
  · intro used
    rcases used with zero | positive | ⟨negative, used⟩
    · exact Or.inl zero
    · exact Or.inr (Or.inl positive)
    · exact Or.inr (Or.inr ⟨-z, ⟨by omega, used⟩, by omega⟩)

theorem history_nodup (C : Int) (pos neg : RayBoundary)
    (wp : WellFormed C pos) (wn : WellFormed C neg) :
    (history C pos neg).Nodup := by
  apply List.nodup_cons.mpr
  constructor
  · intro member
    rcases List.mem_append.mp member with positive | negative
    · have h := (positivePoints_mem C pos wp 0).mp positive
      omega
    · obtain ⟨a, ha, eq⟩ := List.mem_map.mp negative
      have h := (positivePoints_mem C neg wn a).mp ha
      omega
  · apply List.nodup_append.mpr
    refine ⟨positivePoints_nodup C pos wp,
      map_nodup _ (by intro a b eq; omega) _ (positivePoints_nodup C neg wn), ?_⟩
    intro x hx y hy eq
    have hp := (positivePoints_mem C pos wp x).mp hx
    obtain ⟨a, ha, same⟩ := List.mem_map.mp hy
    have hn := (positivePoints_mem C neg wn a).mp ha
    omega

theorem history_length (C : Int) (pos neg : RayBoundary)
    (wp : WellFormed C pos) (wn : WellFormed C neg) :
    ((history C pos neg).length : Int) =
      2*C + pos.front + neg.front - 1 + pos.extra.length + neg.extra.length := by
  simp only [history, positivePoints, List.length_cons, List.length_append,
    List.length_map, List.length_range]
  have hp := wp.1
  have hn := wn.1
  omega

theorem exact_index (w : List Int) (valid : SignedValidWord signedStart w)
    (C : Int) (pos neg : RayBoundary) (side : Bool) (current : Int)
    (wp : WellFormed C pos) (wn : WellFormed C neg)
    (endpoint : execute signedStart w = signedBoundary C pos neg side current) :
    (w.length : Int) =
      2*C + pos.front + neg.front - 2 + pos.extra.length + neg.extra.length := by
  have accounting := signed_start_accounting w valid
  have perm : (0 :: w).Perm (history C pos neg) :=
    (List.perm_ext_iff_of_nodup accounting.1 (history_nodup C pos neg wp wn)).mpr (by
      intro z
      rw [← accounting.2.1 z, endpoint]
      exact (history_mem C pos neg wp wn side current z).symm)
  have same := perm.length_eq
  have count := history_length C pos neg wp wn
  simp only [List.length_cons] at same
  omega

theorem weight_three_index (w : List Int) (valid : SignedValidWord signedStart w)
    (C : Int) (pos neg : RayBoundary) (side : Bool) (current : Int)
    (wp : WellFormed C pos) (wn : WellFormed C neg)
    (endpoint : execute signedStart w = signedBoundary C pos neg side current)
    (weight : pos.front + neg.front + pos.extra.length + neg.extra.length = 3) :
    (w.length : Int) = 2*C + 1 := by
  have count := exact_index w valid C pos neg side current wp wn endpoint
  omega

structure Checkpoint where
  label : Nat
  output : Bool
  positive : Bool
  current : Int
  pos : RayBoundary
  neg : RayBoundary

def Checkpoint.Claim (r : Checkpoint) : Prop :=
  (-512 ≤ r.pos.front ∧ -512 ≤ r.neg.front) ∧
  (r.pos.extra.Nodup ∧ ∀ x ∈ r.pos.extra, r.pos.front ≤ x) ∧
  (r.neg.extra.Nodup ∧ ∀ x ∈ r.neg.extra, r.neg.front ≤ x) ∧
  r.pos.front + r.neg.front + r.pos.extra.length + r.neg.extra.length = 3

instance (r : Checkpoint) : Decidable r.Claim := by
  unfold Checkpoint.Claim
  infer_instance

/-- Weight three gives index 7^k once the actual signed path has been
shown to end at this entire physical state. Reaching that state is not
postulated as a certificate axiom. -/
theorem Checkpoint.exact_scale (r : Checkpoint) (checked : r.Claim)
    (k : Nat) (C : Int) (scale : 2*C+1 = (7^k : Nat))
    (large : 100000 ≤ (7^k : Nat))
    (w : List Int) (valid : SignedValidWord signedStart w)
    (endpoint : execute signedStart w = signedBoundary C r.pos r.neg r.positive r.current) :
    w.length = 7^k := by
  have wp : WellFormed C r.pos := ⟨by have h := checked.1.1; omega, checked.2.1⟩
  have wn : WellFormed C r.neg := ⟨by have h := checked.1.2; omega, checked.2.2.1⟩
  have count := weight_three_index w valid C r.pos r.neg r.positive r.current
    wp wn endpoint checked.2.2.2
  omega

structure CheckedCheckpoint where
  checkpoint : Checkpoint
  checked : checkpoint.Claim

end Heraclitus.TransferCounting
