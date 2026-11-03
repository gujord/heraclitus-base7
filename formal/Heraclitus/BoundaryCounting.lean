import Heraclitus.SignedCertificate

set_option autoImplicit false

/-! Exact cardinality of the complete signed boundary representation.
The history/cardinality lemmas are promoted from research/transfer/Counting.lean
without changing their proofs. Exact block lengths follow from whole-state
endpoints and freshness; premarked points are never counted twice.
-/
namespace Heraclitus.BoundaryCounting

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


def Proper (r : SignedCertificate.Record) : Prop :=
  (-512 ≤ r.pos.front ∧ -512 ≤ r.neg.front) ∧
  (r.pos.extra.Nodup ∧ ∀ x ∈ r.pos.extra, r.pos.front ≤ x) ∧
  (r.neg.extra.Nodup ∧ ∀ x ∈ r.neg.extra, r.neg.front ≤ x) ∧
  r.pos.front+r.neg.front+r.pos.extra.length+r.neg.extra.length=3

instance (r : SignedCertificate.Record) : Decidable (Proper r) := by
  unfold Proper
  infer_instance

theorem proper_wellFormed (r : SignedCertificate.Record) (proper : Proper r)
    (C : Int) (large : 512<C) : WellFormed C r.pos ∧ WellFormed C r.neg := by
  exact ⟨⟨by have h := proper.1.1; omega, proper.2.1⟩,
    ⟨by have h := proper.1.2; omega, proper.2.2.1⟩⟩

/-- Exact cardinality difference for a valid complete boundary-to-boundary block.
This theorem does not assume the initial state is already reached from zero. -/
theorem block_length (r s : SignedCertificate.Record) (rp : Proper r) (sp : Proper s)
    (C D : Int) (cb : 512<C) (db : 512<D)
    (b : SignedBlock (r.toState C) (s.toState D)) : (b.word.length : Int)=2*(D-C) := by
  obtain ⟨rpos, rneg⟩ := proper_wellFormed r rp C cb
  obtain ⟨spos, sneg⟩ := proper_wellFormed s sp D db
  have accounting := signed_history_accounting (r.toState C) (history C r.pos r.neg) b.word
    (fun x => (history_mem C r.pos r.neg rpos rneg r.positive r.current x).symm)
    (history_nodup C r.pos r.neg rpos rneg) b.valid
  have perm : (history C r.pos r.neg ++ b.word).Perm (history D s.pos s.neg) :=
    (List.perm_ext_iff_of_nodup accounting.1 (history_nodup D s.pos s.neg spos sneg)).mpr (by
      intro x
      rw [← accounting.2.1 x, b.endpoint]
      exact (history_mem D s.pos s.neg spos sneg s.positive s.current x).symm)
  have length := perm.length_eq
  rw [List.length_append] at length
  have before := history_length C r.pos r.neg rpos rneg
  have after := history_length D s.pos s.neg spos sneg
  have rwgt := rp.2.2.2
  have swgt := sp.2.2.2
  omega

theorem scale_block_length (r s : SignedCertificate.Record) (rp : Proper r) (sp : Proper s)
    (k : Nat) (C : Int) (radius : 2*C+1=(7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (b : SignedBlock (r.toState C) (s.toState (C+3*(7^k : Nat)))) :
    b.word.length=6*7^k := by
  have count := block_length r s rp sp C (C+3*(7^k : Nat)) (by omega) (by omega) b
  omega

end Heraclitus.BoundaryCounting
