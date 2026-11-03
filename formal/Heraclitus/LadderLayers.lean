import Heraclitus.TransferCertificate

set_option autoImplicit false

/-! Composition and iteration of certified half-line marker layers.
The initial bottom checkpoint and the premarked ladder are explicit inputs;
neither forced descent nor the signed return interface is assumed proved. -/

namespace Heraclitus.LadderLayers

open TransferCertificate

theorem translate_mark (d : Int) (s : State) (m : Int → Prop) :
    translate d (mark s m) = mark (translate d s) (fun x => m (x - d)) := rfl

theorem translate_mark_shift (d : Int) (s : State) (m : Int → Prop) :
    translate d (mark s (fun x => m (x + d))) = mark (translate d s) m := by
  apply state_ext
  · rfl
  · intro x
    simp only [translate, mark, Int.sub_add_cancel]

/-- n equally spaced pending endpoints, followed by an arbitrary farther set. -/
def pending (h : Int) : Nat → (Int → Prop) → Int → Prop
  | 0, far => far
  | n + 1, far => fun x => x = h ∨ pending h n (fun y => far (y + h)) (x - h)

theorem pending_lower (h : Int) (nonneg : 0 ≤ h) (n : Nat) (far : Int → Prop)
    (far_bound : ∀ x, far x → ((n : Int) + 1) * h ≤ x) :
    ∀ x, pending h n far x → h ≤ x := by
  induction n generalizing far with
  | zero => simpa only [pending, Int.natCast_zero, Int.zero_add, Int.one_mul] using far_bound
  | succ n ih =>
    have tail_bound : ∀ x, far (x + h) → ((n : Int) + 1) * h ≤ x := by
      intro x hx
      have bound := far_bound (x + h) hx
      simp only [Int.natCast_succ, Int.add_mul, Int.one_mul] at bound ⊢
      omega
    intro x hx
    rcases hx with eq | tail
    · omega
    · have bound := ih (fun y => far (y + h)) tail_bound (x - h) tail
      omega

def Linked (s : FiniteState) : List CheckedTransfer → FiniteState → Prop
  | [], out => sameState s out = true
  | c :: cs, out => sameState s c.transfer.initial = true ∧ Linked c.transfer.output cs out

instance linkedDecidable (s : FiniteState) (cs : List CheckedTransfer) (out : FiniteState) :
    Decidable (Linked s cs out) :=
  match cs with
  | [] => inferInstanceAs (Decidable (sameState s out = true))
  | c :: rest =>
    letI := linkedDecidable c.transfer.output rest out
    inferInstanceAs (Decidable (sameState s c.transfer.initial = true ∧ Linked c.transfer.output rest out))

def correction (t : Transfer) : Int :=
  (t.transient.edges.length : Int) + t.phase + t.repair.edges.length - t.target

def corrections : List CheckedTransfer → Int
  | [] => 0
  | c :: cs => correction c.transfer + corrections cs

theorem transfer_length (c : CheckedTransfer) (q : Nat) (h : Int)
    (spacing : h = c.transfer.target + (q : Int) * (c.transfer.modulus : Int)) :
    ((c.transfer.word q h).length : Int) = h + correction c.transfer := by
  have len := c.transfer.word_length c.checked q h
  have cast := congrArg (fun n : Nat => (n : Int)) len
  simp only [Int.natCast_add, Int.natCast_mul] at cast
  rw [Int.mul_comm (c.transfer.modulus : Int) (q : Int)] at cast
  unfold correction
  omega

/-- Compose arbitrary many adjacent transfers while retaining every future marker. -/
theorem chain_sound (s out : FiniteState) (cs : List CheckedTransfer)
    (linked : Linked s cs out) (h : Int) (large : 2401 ≤ h)
    (residues : ∀ c ∈ cs, h % (c.transfer.modulus : Int) = c.transfer.residue)
    (far : Int → Prop) (far_bound : ∀ x, far x → ((cs.length : Int) + 1) * h ≤ x) :
    ∃ w : List Int,
      ValidWord (mark s.toState (pending h cs.length far)) w ∧
      execute (mark s.toState (pending h cs.length far)) w =
        mark (translate ((cs.length : Int) * h) out.toState) far ∧
      (w.length : Int) = (cs.length : Int) * h + corrections cs := by
  induction cs generalizing s far with
  | nil =>
    have eq := sameState_sound linked
    refine ⟨[], trivial, ?_, ?_⟩
    · simp only [execute, pending, List.length_nil, Int.natCast_zero, Int.zero_mul,
        translate_zero, eq]
    · simp [corrections]
  | cons c cs ih =>
    obtain ⟨entry, linked⟩ := linked
    have entry_eq := sameState_sound entry
    have tail_bound : ∀ x, far (x + h) → ((cs.length : Int) + 1) * h ≤ x := by
      intro x hx
      have bound := far_bound (x + h) hx
      simp only [List.length_cons, Int.natCast_succ, Int.add_mul, Int.one_mul] at bound ⊢
      omega
    have later_bound : ∀ x, pending h cs.length (fun y => far (y + h)) (x - h) → 2 * h ≤ x := by
      intro x hx
      have low := pending_lower h (by omega) cs.length (fun y => far (y + h)) tail_bound (x - h) hx
      omega
    obtain ⟨q, spacing, firstValid, firstEnd⟩ := c.transfer.uniform c.checked h
      (fun x => pending h cs.length (fun y => far (y + h)) (x - h)) large
      (residues c (by simp)) later_bound
    have tail_residues : ∀ d ∈ cs, h % (d.transfer.modulus : Int) = d.transfer.residue := by
      intro d hd
      exact residues d (by simp [hd])
    obtain ⟨tail, tailValid, tailEnd, tailLength⟩ := ih c.transfer.output linked tail_residues
      (fun y => far (y + h)) tail_bound
    let first := c.transfer.word q h
    let translatedTail := tail.map (fun x => x + h)
    have initial_eq : mark s.toState (pending h (c :: cs).length far) =
        mark c.transfer.initial.toState
          (fun x => x = h ∨ pending h cs.length (fun y => far (y + h)) (x - h)) := by
      rw [entry_eq]
      rfl
    have join_eq : execute (mark s.toState (pending h (c :: cs).length far)) first =
        translate h (mark c.transfer.output.toState (pending h cs.length (fun y => far (y + h)))) := by
      rw [initial_eq, translate_mark]
      exact firstEnd
    refine ⟨first ++ translatedTail, ?_, ?_, ?_⟩
    · apply (validWord_append _ _ _).mpr
      constructor
      · rw [initial_eq]
        exact firstValid
      · rw [join_eq]
        exact validWord_translate h tailValid
    · rw [execute_append, join_eq]
      change execute _ (tail.map (fun x => x + h)) = _
      rw [execute_translate, tailEnd, translate_mark_shift, translate_translate]
      have shift : h + (cs.length : Int) * h = ((c :: cs).length : Int) * h := by
        simp only [List.length_cons, Int.natCast_succ, Int.add_mul, Int.one_mul]
        omega
      rw [shift]
    · have firstLength := transfer_length c q h spacing
      change (first.length : Int) = h + correction c.transfer at firstLength
      change ((first ++ tail.map (fun x => x + h)).length : Int) = _
      simp only [List.length_append, List.length_map, Int.natCast_add, List.length_cons,
        Int.natCast_succ, Int.add_mul, Int.one_mul, corrections]
      change (first.length : Int) + (tail.length : Int) = _
      omega

structure Layer where
  entrance : FiniteState
  output : FiniteState
  steps : List CheckedTransfer
  level : Nat
  sampleH : Int
  residue : Int

def Layer.Claim (r : Layer) (m : Int) : Prop :=
  r.steps.length = 6 ∧ Linked r.entrance r.steps r.output ∧
  r.sampleH % m = r.residue ∧
  (∀ c ∈ r.steps,
    m % (c.transfer.modulus : Int) = 0 ∧
      r.residue % (c.transfer.modulus : Int) = c.transfer.residue) ∧
  0 < r.entrance.front ∧ r.entrance.front < 2000 ∧
  ¬r.entrance.toState.used r.entrance.front

instance (r : Layer) (m : Int) : Decidable (r.Claim m) :=
  inferInstanceAs (Decidable (
    r.steps.length = 6 ∧ Linked r.entrance r.steps r.output ∧
    r.sampleH % m = r.residue ∧
    (∀ c ∈ r.steps,
      m % (c.transfer.modulus : Int) = 0 ∧
        r.residue % (c.transfer.modulus : Int) = c.transfer.residue) ∧
    0 < r.entrance.front ∧ r.entrance.front < 2000 ∧
    ¬r.entrance.toState.used r.entrance.front))

theorem Layer.residue_idem (r : Layer) (m : Int) (checked : r.Claim m) :
    r.residue % m = r.residue := by
  rw [← checked.2.2.1, Int.emod_emod]

theorem Layer.sound (r : Layer) (m h : Int) (checked : r.Claim m)
    (large : 2401 ≤ h) (residue : h % m = r.residue)
    (far : Int → Prop) (far_bound : ∀ x, far x → 7 * h ≤ x) :
    ∃ w : List Int,
      ValidWord (mark r.entrance.toState (pending h 6 far)) w ∧
      execute (mark r.entrance.toState (pending h 6 far)) w =
        mark (translate (6 * h) r.output.toState) far ∧
      (w.length : Int) = 6 * h + corrections r.steps := by
  obtain ⟨length, linked, _, moduli, _, _, _⟩ := checked
  have residues : ∀ c ∈ r.steps, h % (c.transfer.modulus : Int) = c.transfer.residue := by
    intro c hc
    obtain ⟨divides, small_residue⟩ := moduli c hc
    have eq := Int.emod_emod_of_dvd h (Int.dvd_of_emod_eq_zero divides)
    rw [residue] at eq
    exact eq.symm.trans small_residue
  have bound : ∀ x, far x → ((r.steps.length : Int) + 1) * h ≤ x := by
    simpa [length] using far_bound
  simpa [length] using chain_sound r.entrance r.output r.steps linked h large residues far bound

structure Ladder where
  size : Nat
  row : Fin size → Layer
  next : Fin size → Fin size
  start : Fin size
  initial : FiniteState
  modulus : Int
  transient : Nat
  period : Nat

def Ladder.orbit (c : Ladder) : Nat → Fin c.size
  | 0 => c.start
  | n + 1 => c.next (c.orbit n)

def Ladder.Claim (c : Ladder) : Prop :=
  0 < c.modulus ∧ c.start.val = 0 ∧ c.transient ≤ 1 ∧
  (c.period = 2 ∨ c.period = 36) ∧ c.size = c.transient + c.period + 1 ∧
  sameState c.initial (c.row c.start).entrance = true ∧
  2401 % c.modulus = (c.row c.start).residue ∧
  (∀ i : Fin c.size,
    (c.row i).Claim c.modulus ∧
    (c.row i).level = 4 + i.val ∧ (c.row i).sampleH = ((7 ^ (c.row i).level : Nat) : Int) ∧
    sameState (c.row i).output (c.row (c.next i)).entrance = true ∧
    (7 * (c.row i).residue) % c.modulus = (c.row (c.next i)).residue) ∧
  c.orbit (c.transient + c.period) = c.orbit c.transient

instance (c : Ladder) : Decidable c.Claim :=
  inferInstanceAs (Decidable (
    0 < c.modulus ∧ c.start.val = 0 ∧ c.transient ≤ 1 ∧
    (c.period = 2 ∨ c.period = 36) ∧ c.size = c.transient + c.period + 1 ∧
    sameState c.initial (c.row c.start).entrance = true ∧
    2401 % c.modulus = (c.row c.start).residue ∧
    (∀ i : Fin c.size,
      (c.row i).Claim c.modulus ∧
      (c.row i).level = 4 + i.val ∧ (c.row i).sampleH = ((7 ^ (c.row i).level : Nat) : Int) ∧
      sameState (c.row i).output (c.row (c.next i)).entrance = true ∧
      (7 * (c.row i).residue) % c.modulus = (c.row (c.next i)).residue) ∧
    c.orbit (c.transient + c.period) = c.orbit c.transient))

def scale (n : Nat) : Int := ((7 ^ (4 + n) : Nat) : Int)

theorem scale_zero : scale 0 = 2401 := by decide

theorem scale_succ (n : Nat) : scale (n + 1) = 7 * scale n := by
  have exponents : 4 + (n + 1) = (4 + n) + 1 := by omega
  simp only [scale, exponents, Nat.pow_succ, Int.natCast_mul]
  rw [Int.mul_comm]
  rfl

theorem scale_large (n : Nat) : 2401 ≤ scale n := by
  have bound : (7 : Nat) ^ 4 ≤ 7 ^ (4 + n) := Nat.pow_le_pow_right (by decide) (by omega)
  have value : (7 : Nat) ^ 4 = 2401 := by decide
  rw [value] at bound
  unfold scale
  omega

theorem Ladder.rows_checked (c : Ladder) (checked : c.Claim) :
    ∀ i, (c.row i).Claim c.modulus ∧
      (c.row i).level = 4 + i.val ∧ (c.row i).sampleH = ((7 ^ (c.row i).level : Nat) : Int) ∧
      sameState (c.row i).output (c.row (c.next i)).entrance = true ∧
      (7 * (c.row i).residue) % c.modulus = (c.row (c.next i)).residue :=
  checked.2.2.2.2.2.2.2.1

theorem Ladder.residue_invariant (c : Ladder) (checked : c.Claim) :
    ∀ n, scale n % c.modulus = (c.row (c.orbit n)).residue := by
  intro n
  induction n with
  | zero => simpa only [scale_zero, Ladder.orbit] using checked.2.2.2.2.2.2.1
  | succ n ih =>
    have row := c.rows_checked checked (c.orbit n)
    have idem := (c.row (c.orbit n)).residue_idem c.modulus row.1
    calc
      scale (n + 1) % c.modulus = (7 * scale n) % c.modulus := by rw [scale_succ]
      _ = (7 % c.modulus * (scale n % c.modulus)) % c.modulus := Int.mul_emod _ _ _
      _ = (7 % c.modulus * (c.row (c.orbit n)).residue) % c.modulus := by rw [ih]
      _ = (7 * (c.row (c.orbit n)).residue) % c.modulus := by
        symm
        rw [Int.mul_emod, idem]
      _ = (c.row (c.orbit (n + 1))).residue := row.2.2.2.2

theorem Ladder.periodic (c : Ladder) (checked : c.Claim) :
    ∀ n, c.orbit (c.transient + n + c.period) = c.orbit (c.transient + n) := by
  intro n
  induction n with
  | zero => simpa only [Nat.add_zero] using checked.2.2.2.2.2.2.2.2
  | succ n ih =>
    have left : c.transient + (n + 1) + c.period = (c.transient + n + c.period) + 1 := by omega
    have right : c.transient + (n + 1) = (c.transient + n) + 1 := by omega
    rw [left, right, Ladder.orbit, Ladder.orbit, ih]

def Ladder.entry (c : Ladder) (n : Nat) : FiniteState := (c.row (c.orbit n)).entrance
def Ladder.layerCorrection (c : Ladder) (n : Nat) : Int := corrections (c.row (c.orbit n)).steps

theorem Ladder.one_layer (c : Ladder) (checked : c.Claim) (n : Nat)
    (far : Int → Prop) (far_bound : ∀ x, far x → 7 * scale n ≤ x) :
    ∃ w : List Int,
      ValidWord (mark (c.entry n).toState (pending (scale n) 6 far)) w ∧
      execute (mark (c.entry n).toState (pending (scale n) 6 far)) w =
        mark (translate (6 * scale n) (c.entry (n + 1)).toState) far ∧
      (w.length : Int) = 6 * scale n + c.layerCorrection n := by
  have row := c.rows_checked checked (c.orbit n)
  have closing := sameState_sound row.2.2.2.1
  have result := (c.row (c.orbit n)).sound c.modulus (scale n) row.1 (scale_large n)
    (c.residue_invariant checked n) far far_bound
  simpa only [Ladder.entry, Ladder.orbit, Ladder.layerCorrection, closing] using result

theorem pending_six (h x : Int) (far : Int → Prop) :
    pending h 6 far x ↔
      x = h ∨ x = 2 * h ∨ x = 3 * h ∨ x = 4 * h ∨ x = 5 * h ∨ x = 6 * h ∨ far x := by
  simp only [pending, Int.sub_add_cancel]
  by_cases hf : far x
  · simp only [hf, or_true]
  · simp only [hf, or_false]
    omega

/-- All still-premarked endpoints above a completed endpoint, for finitely many layers. -/
def tower (h : Int) : Nat → Int → Prop
  | 0 => fun _ => False
  | n + 1 => pending h 6 (fun x => tower (7 * h) n (x - 6 * h))

theorem tower_lower (h : Int) (nonneg : 0 ≤ h) (n : Nat) :
    ∀ x, tower h n x → h ≤ x := by
  induction n generalizing h with
  | zero => intro x hx; exact False.elim hx
  | succ n ih =>
    apply pending_lower h nonneg 6
    intro x hx
    have bound := ih (7 * h) (by omega) (x - 6 * h) hx
    change 7 * h ≤ x
    omega

theorem mark_none (s : State) : mark s (fun _ => False) = s := by
  apply state_ext
  · rfl
  · intro x; simp [mark]

def Ladder.cumulative (c : Ladder) (n : Nat) : Nat → Int
  | 0 => 0
  | levels + 1 => c.layerCorrection n + c.cumulative (n + 1) levels

/-- Every finite number of increasing-spacing layers, with exact full-state evolution. -/
theorem Ladder.tower_sound (c : Ladder) (checked : c.Claim) (n levels : Nat) :
    ∃ w : List Int,
      ValidWord (mark (c.entry n).toState (tower (scale n) levels)) w ∧
      execute (mark (c.entry n).toState (tower (scale n) levels)) w =
        translate (scale (n + levels) - scale n) (c.entry (n + levels)).toState ∧
      (w.length : Int) = scale (n + levels) - scale n + c.cumulative n levels := by
  induction levels generalizing n with
  | zero =>
    refine ⟨[], trivial, ?_, ?_⟩
    · simp [execute, tower, mark_none, translate_zero]
    · simp [Ladder.cumulative]
  | succ levels ih =>
    have large := scale_large n
    have nextLarge := scale_large (n + 1)
    have firstBound : ∀ x, tower (scale (n + 1)) levels (x - 6 * scale n) → 7 * scale n ≤ x := by
      intro x hx
      have low := tower_lower (scale (n + 1)) (by omega) levels (x - 6 * scale n) hx
      rw [scale_succ] at low
      omega
    obtain ⟨first, firstValid, firstEnd, firstLength⟩ := c.one_layer checked n
      (fun x => tower (scale (n + 1)) levels (x - 6 * scale n)) firstBound
    obtain ⟨rest, restValid, restEnd, restLength⟩ := ih (n + 1)
    have markers : tower (scale n) (levels + 1) =
        pending (scale n) 6 (fun x => tower (scale (n + 1)) levels (x - 6 * scale n)) := by
      rw [scale_succ]
      rfl
    have join : execute (mark (c.entry n).toState (tower (scale n) (levels + 1))) first =
        translate (6 * scale n) (mark (c.entry (n + 1)).toState (tower (scale (n + 1)) levels)) := by
      rw [markers, translate_mark]
      exact firstEnd
    have index : n + 1 + levels = n + (levels + 1) := by omega
    have displacement : 6 * scale n + (scale (n + 1 + levels) - scale (n + 1)) =
        scale (n + (levels + 1)) - scale n := by
      rw [index, scale_succ]
      omega
    refine ⟨first ++ rest.map (fun x => x + 6 * scale n), ?_, ?_, ?_⟩
    · apply (validWord_append _ _ _).mpr
      constructor
      · rw [markers]
        exact firstValid
      · rw [join]
        exact validWord_translate (6 * scale n) restValid
    · rw [execute_append, join, execute_translate, restEnd, translate_translate,
        displacement, index]
    · simp only [List.length_append, List.length_map, Int.natCast_add, Ladder.cumulative]
      omega

theorem Ladder.initial_eq (c : Ladder) (checked : c.Claim) :
    c.initial.toState = (c.entry 0).toState :=
  sameState_sound checked.2.2.2.2.2.1

/-- Translate the supplied completed bottom to A+2401; finish at A+7^(4+levels). -/
theorem Ladder.from_bottom (c : Ladder) (checked : c.Claim) (anchor : Int) (levels : Nat) :
    ∃ w : List Int,
      ValidWord (translate (anchor + 2401) (mark c.initial.toState (tower 2401 levels))) w ∧
      execute (translate (anchor + 2401) (mark c.initial.toState (tower 2401 levels))) w =
        translate (anchor + scale levels) (c.entry levels).toState ∧
      (w.length : Int) = scale levels - 2401 + c.cumulative 0 levels := by
  obtain ⟨w, valid, endpoint, count⟩ := c.tower_sound checked 0 levels
  have initial := c.initial_eq checked
  have offset : anchor + scale 0 + (scale (0 + levels) - scale 0) = anchor + scale levels := by
    simp only [Nat.zero_add]
    omega
  refine ⟨w.map (fun x => x + (anchor + 2401)), ?_, ?_, ?_⟩
  · apply validWord_translate
    simpa only [initial, scale_zero] using valid
  · rw [execute_translate, initial, ← scale_zero, endpoint, translate_translate, offset]
    simp only [Nat.zero_add]
  · simpa only [List.length_map, Nat.zero_add, scale_zero] using count

structure CheckedLadder where
  ladder : Ladder
  checked : ladder.Claim

theorem Ladder.checkpoint (c : Ladder) (checked : c.Claim) (n : Nat) (d : Int) :
    (∀ x, x ≤ d → (translate d (c.entry n).toState).used x) ∧
      ¬(translate d (c.entry n).toState).used (d + (c.entry n).front) := by
  have row := (c.rows_checked checked (c.orbit n)).1
  obtain ⟨_, _, _, _, positive, _, fresh⟩ := row
  constructor
  · intro x hx
    left
    change x - d < (c.entry n).front
    change 0 < (c.entry n).front at positive
    omega
  · intro used
    change (c.entry n).toState.used (d + (c.entry n).front - d) at used
    have eq : d + (c.entry n).front - d = (c.entry n).front := by omega
    rw [eq] at used
    exact fresh used

end Heraclitus.LadderLayers
