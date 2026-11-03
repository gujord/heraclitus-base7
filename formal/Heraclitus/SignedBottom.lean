import Heraclitus.ReturnBridge
import Heraclitus.LadderBottom

set_option autoImplicit false

/-! Signed descent and finite bottom, with the whole higher tower and both
outer markers retained. Higher layer envelopes and the approach are separate. -/

namespace Heraclitus.SignedBottom
open OutgoingWord ReturnBridge LadderBottom

def oldCore (old : RayBoundary) : List Int :=
  (List.range (old.front+100).toNat).map (fun i : Nat => (i : Int)-100) ++ old.extra

theorem oldCore_exact (old : RayBoundary) (lower : -100 ≤ old.front) (x : Int) :
    boundaryUsed old x ↔ x < -100 ∨ x ∈ oldCore old := by
  have interval : x ∈ (List.range (old.front+100).toNat).map (fun i : Nat => (i : Int)-100) ↔
      -100 ≤ x ∧ x < old.front := by
    constructor
    · intro member
      obtain ⟨i, hi, eq⟩ := List.mem_map.mp member
      have bound := List.mem_range.mp hi
      omega
    · intro bounds
      refine List.mem_map.mpr ⟨(x+100).toNat, List.mem_range.mpr (by omega), ?_⟩
      omega
  change (x < old.front ∨ x ∈ old.extra) ↔ x < -100 ∨
    x ∈ (List.range (old.front+100).toNat).map (fun i : Nat => (i : Int)-100) ++ old.extra
  rw [List.mem_append, interval]
  by_cases low : x < -100
  · have below : x < old.front := by omega
    simp only [low, below, true_or, iff_self]
  · have above : -100 ≤ x := by omega
    simp only [low, above, false_or, true_and]

def Match (e : CertifiedEntrance) (c : CheckedBottom) : Prop :=
  e.data.anchorUsed = true ∧
  e.data.anchor = c.bottom.entrance.entrance.anchor ∧
  oldCore e.outgoing.geometry.other = c.bottom.entrance.entrance.points

instance (e : CertifiedEntrance) (c : CheckedBottom) : Decidable (Match e c) := by
  unfold Match
  infer_instance

def outerMarkers (m x : Int) : Prop := x=2*m ∨ x=3*m

def halfWord (c : CheckedBottom) (n : Nat) : List Int :=
  (LadderDescent.word 4 n ++ c.bottom.word).map (fun x => x+c.bottom.entrance.entrance.anchor)

def bottomEnd (c : CheckedBottom) (n : Nat) (m : Int) : State :=
  translate c.bottom.entrance.entrance.anchor
    (mark (translate 2401 c.bottom.ladder.ladder.initial.toState)
      (fun x => LadderLayers.tower 2401 n (x-2401) ∨ outerMarkers m x))

theorem bottomEnd_used (c : CheckedBottom) (n : Nat) (m x : Int) :
    (bottomEnd c n m).used x ↔
      c.bottom.ladder.ladder.initial.toState.used (x-(c.bottom.entrance.entrance.anchor+2401)) ∨
      LadderLayers.tower 2401 n (x-(c.bottom.entrance.entrance.anchor+2401)) ∨
      x=2*m+c.bottom.entrance.entrance.anchor ∨ x=3*m+c.bottom.entrance.entrance.anchor := by
  have offset : x-c.bottom.entrance.entrance.anchor-2401 =
      x-(c.bottom.entrance.entrance.anchor+2401) := by omega
  have two : x-c.bottom.entrance.entrance.anchor=2*m ↔
      x=2*m+c.bottom.entrance.entrance.anchor := by omega
  have three : x-c.bottom.entrance.entrance.anchor=3*m ↔
      x=3*m+c.bottom.entrance.entrance.anchor := by omega
  simp only [bottomEnd, translate, mark, outerMarkers, offset, two, three]

theorem initial_match (e : CertifiedEntrance) (c : CheckedBottom) (matched : Match e c) (m : Int) :
    (checkpoint e.outgoing.geometry.other m e.data.anchor).toState =
      translate c.bottom.entrance.entrance.anchor
        (mark (LadderDescent.start c.bottom.entrance.entrance.old m) (outerMarkers m)) := by
  apply state_ext
  · change m+e.data.anchor=m+c.bottom.entrance.entrance.anchor
    rw [matched.2.1]
  · intro x
    rw [checkpoint_used, matched.2.1]
    have old := oldCore_exact e.outgoing.geometry.other e.checked.2.1 x
    rw [matched.2.2] at old
    rw [old]
    simp only [translate, mark, LadderDescent.start, LadderDescent.Entrance.old,
      Int.sub_add_cancel, outerMarkers]
    have top : x-c.bottom.entrance.entrance.anchor=m ↔
        x=m+c.bottom.entrance.entrance.anchor := by omega
    have two : x-c.bottom.entrance.entrance.anchor=2*m ↔
        x=2*m+c.bottom.entrance.entrance.anchor := by omega
    have three : x-c.bottom.entrance.entrance.anchor=3*m ↔
        x=3*m+c.bottom.entrance.entrance.anchor := by omega
    rw [top, two, three]
    simp only [or_assoc]

/-- Actual descent and bottom words, preserving every premarked endpoint. -/
theorem half_path (e : CertifiedEntrance) (c : CheckedBottom) (matched : Match e c)
    (n : Nat) (m : Int) (height : LadderLayers.scale n=m) (large : 100000 ≤ m) :
    ValidWord (checkpoint e.outgoing.geometry.other m e.data.anchor).toState (halfWord c n) ∧
      execute (checkpoint e.outgoing.geometry.other m e.data.anchor).toState (halfWord c n) =
        bottomEnd c n m := by
  have top : LadderDescent.height (4+n)=m := height
  have descent := LadderDescent.descend_with_later c.bottom.entrance.entrance.old
    (c.bottom.entrance.entrance.region c.bottom.entrance.checked) 4 n (by decide)
    (outerMarkers m) (by
      intro x hx
      rw [top]
      unfold outerMarkers at hx
      omega)
  have base : LadderDescent.height 4=2401 := by decide
  rw [top] at descent
  have last := c.bottom.with_later c.checked
    (fun x => LadderLayers.tower 2401 n (x-2401) ∨ outerMarkers m x) (by
      intro x hx
      rcases hx with tower | outer
      · have low := LadderLayers.tower_lower 2401 (by decide) n (x-2401) tower
        omega
      · unfold outerMarkers at outer
        omega)
  have join : mark (LadderDescent.bottom c.bottom.entrance.entrance.old 4 n) (outerMarkers m) =
      mark (LadderDescent.start c.bottom.entrance.entrance.old 2401)
        (fun x => LadderLayers.tower 2401 n (x-2401) ∨ outerMarkers m x) := by
    rw [LadderDescent.bottom, base, mark_mark]
  have valid : ValidWord (mark (LadderDescent.start c.bottom.entrance.entrance.old m) (outerMarkers m))
      (LadderDescent.word 4 n ++ c.bottom.word) := by
    apply (validWord_append _ _ _).mpr
    refine ⟨descent.1, ?_⟩
    rw [descent.2, join]
    exact last.1
  have finish : execute (mark (LadderDescent.start c.bottom.entrance.entrance.old m) (outerMarkers m))
      (LadderDescent.word 4 n ++ c.bottom.word) =
        mark (translate 2401 c.bottom.ladder.ladder.initial.toState)
          (fun x => LadderLayers.tower 2401 n (x-2401) ∨ outerMarkers m x) := by
    rw [execute_append, descent.2, join, last.2]
  rw [initial_match e c matched m]
  exact ⟨validWord_translate _ valid, by rw [halfWord, execute_translate, finish]; rfl⟩

theorem halfWord_length (c : CheckedBottom) (n : Nat) :
    (halfWord c n).length = 6*n+c.bottom.moves := by
  rw [halfWord, List.length_map, List.length_append, LadderDescent.word_length,
    (c.bottom.sound c.checked).2.2.1]

/-- Membership bounds imply bounds at every intermediate current as well. -/
theorem envelope_of_bounds (m : Int) (s : State) (w : List Int)
    (current : -100 ≤ s.current ∧ s.current ≤ 2*m+4096)
    (bounds : ∀ x ∈ w, -100 ≤ x ∧ x ≤ 2*m+4096) : Envelope m s w := by
  induction w generalizing s with
  | nil => trivial
  | cons v vs ih =>
    have first := bounds v (by simp)
    exact ⟨current, first, ih (visit s v) first (fun x hx => bounds x (by simp [hx]))⟩

theorem halfWord_bounds (e : CertifiedEntrance) (c : CheckedBottom) (matched : Match e c)
    (n : Nat) (m : Int) (height : LadderLayers.scale n=m) (large : 100000 ≤ m) :
    ∀ x ∈ halfWord c n, -100 ≤ x ∧ x ≤ 2*m+4096 := by
  have anchor := e.checked.1
  rw [matched.2.1] at anchor
  intro x member
  obtain ⟨y, member, eq⟩ := List.mem_map.mp member
  rcases List.mem_append.mp member with descent | bottom
  · have bounds := LadderDescent.word_bounds 4 n (by decide) y descent
    have base : LadderDescent.height 4=2401 := by decide
    have top : LadderDescent.height (4+n)=m := height
    rw [base, top] at bounds
    omega
  · have bounds := (c.bottom.sound c.checked).2.2.2 y bottom
    omega

theorem signed_path (e : CertifiedEntrance) (c : CheckedBottom) (matched : Match e c)
    (n k : Nat) (C : Int) (far : RayBoundary)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (height : LadderLayers.scale n=(7^k : Nat))
    (filled : 3*(7^k : Nat)-200 ≤ far.front) :
    ∃ b : SignedBlock
      (liftRay (!e.outgoing.row.positive) C far
        (checkpoint e.outgoing.geometry.other (7^k : Nat) e.data.anchor).toState)
      (liftRay (!e.outgoing.row.positive) C far (bottomEnd c n (7^k : Nat))),
      b.word.length = 6*n+c.bottom.moves := by
  have big : (100000 : Int) ≤ (7^k : Nat) := Int.ofNat_le.mpr large
  have half := half_path e c matched n _ height big
  have envelope := envelope_of_bounds (7^k : Nat)
    (checkpoint e.outgoing.geometry.other (7^k : Nat) e.data.anchor).toState (halfWord c n)
    (by change -100 ≤ (7^k : Nat)+e.data.anchor ∧ (7^k : Nat)+e.data.anchor ≤ 2*(7^k : Nat)+4096
        have h := e.checked.1; omega)
    (halfWord_bounds e c matched n _ height big)
  have signed := return_word _ far (!e.outgoing.row.positive) k C (halfWord c n)
    scale large filled half.1 envelope
  rw [half.2] at signed
  exact ⟨⟨(halfWord c n).map (embedRay (!e.outgoing.row.positive) C), signed.1, signed.2⟩,
    by rw [List.length_map, halfWord_length]⟩

structure CheckedCase where
  entrance : CertifiedEntrance
  bottom : CheckedBottom
  matched : Match entrance bottom

/-- Compose the already proved return entrance with descent and the checked
finite bottom at every exponent, including the exact segment length. -/
theorem CheckedCase.all_exponents (c : CheckedCase) (t : Nat) (C : Int)
    (scale : 2*C+1=(7^(c.entrance.outgoing.row.leastExponent+36*t) : Nat)) :
    ∃ q : Nat, ∃ b : SignedBlock (c.entrance.outgoing.inner.initial.toState C)
      (liftRay (!c.entrance.outgoing.row.positive) C (farBoundary c.entrance.outgoing q)
        (bottomEnd c.bottom (c.entrance.outgoing.row.leastExponent+36*t-4)
          (7^(c.entrance.outgoing.row.leastExponent+36*t) : Nat))),
      b.word.length = c.entrance.outgoing.inner.moves.length+q*c.entrance.outgoing.row.phases.size+
        c.entrance.outgoing.row.selected.val+3+
        6*(c.entrance.outgoing.row.leastExponent+36*t-4)+c.bottom.bottom.moves ∧
      3*(7^(c.entrance.outgoing.row.leastExponent+36*t) : Nat)-200 ≤
        (farBoundary c.entrance.outgoing q).front := by
  let e := c.entrance
  let k := e.outgoing.row.leastExponent+36*t
  obtain ⟨q, first, firstLen, filled, _⟩ := e.all_exponents t C scale
  have expbound : 6 ≤ k := by
    have h := e.outgoing.arithmetic.2.2.2.2.2.2.2.2.1
    dsimp [k]
    omega
  have large : 100000 ≤ (7^k : Nat) := by
    have h := Nat.pow_le_pow_right (n := 7) (by decide) expbound
    have num : (7 : Nat)^6=117649 := by decide
    omega
  have height : LadderLayers.scale (k-4)=(7^k : Nat) := by
    change ((7^(4+(k-4)) : Nat) : Int)=(7^k : Nat)
    rw [show 4+(k-4)=k by omega]
  obtain ⟨last, lastLen⟩ := signed_path e c.bottom c.matched (k-4) k C
    (farBoundary e.outgoing q) scale large height filled
  refine ⟨q, first.then last, ?_, filled⟩
  change (first.word ++ last.word).length = _
  rw [List.length_append, firstLen, lastLen]
  dsimp [e, k] at *
  omega

def ShortMatch (e : CertifiedEntrance) : Prop :=
  e.data.anchorUsed = false ∧ e.data.anchor = 2 ∧
  e.outgoing.geometry.other.front = 1 ∧ e.outgoing.geometry.other.extra = []

instance (e : CertifiedEntrance) : Decidable (ShortMatch e) := by
  unfold ShortMatch
  infer_instance

def shortEnd (m : Int) : FiniteState := ⟨1, 3, [m+2, 2*m+2, 3*m+2]⟩

/-- The unused-anchor branch consists of two actual moves, retaining all
three distant markers. This is a different endpoint from the ladder bottom. -/
theorem short_half (k : Nat) (large : 100000 ≤ (7^k : Nat)) :
    ValidWord (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState [2, 1] ∧
      execute (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState [2, 1] =
        (shortEnd (7^k : Nat)).toState := by
  let m : Int := (7^k : Nat)
  have big : 100000 ≤ m := Int.ofNat_le.mpr large
  let s := (checkpoint ⟨1, []⟩ m 2).toState
  have first := subtract_scale s k large
    (by change m+2 ≤ 3*m+3; omega)
    (by intro x hx; exact Or.inl (by change x < 1; omega))
    (by change ¬((m+2-m < 1) ∨ m+2-m ∈ [m+2, 2*m+2, 3*m+2] ++ [])
        simp only [List.append_nil, List.mem_cons, List.not_mem_nil, or_false]; omega)
  change Greedy s (m+2-m) at first
  rw [show m+2-m=2 by omega] at first
  have second : Greedy (visit s 2) 1 := by
    refine ⟨?_, ⟨0, by change ((1-2 : Int).natAbs = (7 : Nat)^0); decide⟩, ?_⟩
    · change ¬((1 < 1 ∨ 1 ∈ [m+2, 2*m+2, 3*m+2] ++ []) ∨ 1=2)
      simp only [List.append_nil, List.mem_cons, List.not_mem_nil, or_false]
      omega
    · intro x fresh _step
      by_cases h : 1 ≤ x
      · exact h
      · exact False.elim (fresh (Or.inl (Or.inl (by change x < 1; omega))))
  refine ⟨⟨first, second, True.intro⟩, ?_⟩
  apply state_ext
  · rfl
  · intro x
    change (((x < 1 ∨ x ∈ [m+2, 2*m+2, 3*m+2] ++ []) ∨ x=2) ∨ x=1) ↔
      (x < 3 ∨ x ∈ [m+2, 2*m+2, 3*m+2])
    simp only [List.append_nil, List.mem_cons, List.not_mem_nil, or_false]
    omega

theorem short_signed (e : CertifiedEntrance) (matched : ShortMatch e)
    (k : Nat) (C : Int) (far : RayBoundary)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (filled : 3*(7^k : Nat)-200 ≤ far.front) :
    ∃ b : SignedBlock
      (liftRay (!e.outgoing.row.positive) C far
        (checkpoint e.outgoing.geometry.other (7^k : Nat) e.data.anchor).toState)
      (liftRay (!e.outgoing.row.positive) C far (shortEnd (7^k : Nat)).toState),
      b.word.length=2 := by
  have old : e.outgoing.geometry.other = ⟨1, []⟩ := by
    cases h : e.outgoing.geometry.other
    have front := matched.2.2.1
    have extra := matched.2.2.2
    simp only [h] at front extra
    simp only [front, extra]
  rw [matched.2.1, old]
  have big : (100000 : Int) ≤ (7^k : Nat) := Int.ofNat_le.mpr large
  have half := short_half k large
  have envelope := envelope_of_bounds (7^k : Nat)
    (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState [2, 1]
    (by change (-100 : Int) ≤ ((7^k : Nat) : Int)+2 ∧
          ((7^k : Nat) : Int)+2 ≤ 2*((7^k : Nat) : Int)+4096
        omega)
    (by intro x hx; simp only [List.mem_cons, List.not_mem_nil, or_false] at hx; omega)
  have signed := return_word _ far (!e.outgoing.row.positive) k C [2, 1]
    scale large filled half.1 envelope
  rw [half.2] at signed
  exact ⟨⟨[2, 1].map (embedRay (!e.outgoing.row.positive) C), signed.1, signed.2⟩, rfl⟩

theorem short_all_exponents (e : CertifiedEntrance) (matched : ShortMatch e)
    (t : Nat) (C : Int) (scale : 2*C+1=(7^(e.outgoing.row.leastExponent+36*t) : Nat)) :
    ∃ q : Nat, ∃ b : SignedBlock (e.outgoing.inner.initial.toState C)
      (liftRay (!e.outgoing.row.positive) C (farBoundary e.outgoing q)
        (shortEnd (7^(e.outgoing.row.leastExponent+36*t) : Nat)).toState),
      b.word.length=e.outgoing.inner.moves.length+q*e.outgoing.row.phases.size+
        e.outgoing.row.selected.val+5 ∧
      3*(7^(e.outgoing.row.leastExponent+36*t) : Nat)-200 ≤ (farBoundary e.outgoing q).front := by
  let k := e.outgoing.row.leastExponent+36*t
  obtain ⟨q, first, firstLen, filled, _⟩ := e.all_exponents t C scale
  have expbound : 6 ≤ k := by
    have h := e.outgoing.arithmetic.2.2.2.2.2.2.2.2.1
    dsimp [k]
    omega
  have large : 100000 ≤ (7^k : Nat) := by
    have h := Nat.pow_le_pow_right (n := 7) (by decide) expbound
    have num : (7 : Nat)^6=117649 := by decide
    omega
  obtain ⟨last, lastLen⟩ := short_signed e matched k C (farBoundary e.outgoing q) scale large filled
  refine ⟨q, first.then last, ?_, filled⟩
  change (first.word ++ last.word).length = _
  rw [List.length_append, firstLen, lastLen]

end Heraclitus.SignedBottom
