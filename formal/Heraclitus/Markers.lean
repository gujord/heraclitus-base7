import Heraclitus.Translation

set_option autoImplicit false

/-!
# Physical-set coupling for marked endpoints

Marking only enlarges the used set; it does not move the current point.
No claim about the signed walk or certificate ingestion is made here.
-/

namespace Heraclitus

def mark (s : State) (markers : Int → Prop) : State :=
  ⟨s.current, fun x => s.used x ∨ markers x⟩

theorem greedy_mark {s : State} {v : Int} {markers : Int → Prop}
    (h : Greedy s v) (hv : ¬markers v) : Greedy (mark s markers) v := by
  refine ⟨?_, h.2.1, ?_⟩
  · exact fun hu => hu.elim h.1 hv
  · intro w hw hs
    exact h.2.2 w (fun hu => hw (Or.inl hu)) hs

theorem mark_visit (s : State) (v : Int) (markers : Int → Prop) :
    mark (visit s v) markers = visit (mark s markers) v := by
  apply state_ext
  · rfl
  · intro x; simp [mark, visit, or_left_comm, or_comm]

theorem mark_mark (s : State) (a b : Int → Prop) :
    mark (mark s a) b = mark s (fun x => a x ∨ b x) := by
  apply state_ext
  · rfl
  · intro x; simp [mark, or_assoc]

theorem execute_mark (s : State) (w : List Int) (markers : Int → Prop) :
    execute (mark s markers) w = mark (execute s w) markers := by
  induction w generalizing s with
  | nil => rfl
  | cons v vs ih =>
    simp only [execute]
    rw [← mark_visit]
    exact ih (visit s v)

/-- Coupling of finite words, even if the marked front advances earlier. -/
theorem validWord_mark {s : State} {w : List Int} {markers : Int → Prop}
    (h : ValidWord s w) (avoid : ∀ x ∈ w, ¬markers x) :
    ValidWord (mark s markers) w := by
  induction w generalizing s with
  | nil => trivial
  | cons v vs ih =>
    refine ⟨greedy_mark h.1 (avoid v (by simp)), ?_⟩
    rw [← mark_visit]
    apply ih h.2
    intro x hx
    exact avoid x (by simp [hx])

theorem execute_used_iff (s : State) (w : List Int) (x : Int) :
    (execute s w).used x ↔ s.used x ∨ x ∈ w := by
  induction w generalizing s with
  | nil => simp [execute]
  | cons v vs ih => simp [execute, ih, visit, or_assoc]

theorem not_mem_before_greedy {s : State} {pre : List Int} {h : Int}
    (next : Greedy (execute s pre) h) : h ∉ pre := by
  intro hm
  exact next.1 ((execute_used_iff s pre h).mpr (Or.inr hm))

/-- The two numerical locality bounds imply separation at every h>=2401. -/
theorem locality_separation {h v t : Int}
    (large : 2401 ≤ h) (local_bound : v < h + 2000) (later : 2 * h ≤ t) : v < t := by
  omega

/-- A precise finite-word version of the marked-endpoint coupling.

`pre` is a genuine unmarked greedy word whose next choice would be h.
`repair` is a genuine word after inserting h into that endpoint state.
Later markers are at least 2h; both words stay below 2h. The conclusion
retains ALL later markers in the physical used set and adds no marker visit.
These are conditional finite-word hypotheses, not unproved global axioms.
-/
theorem marked_endpoint_transfer
    (s : State) (pre repair : List Int) (h : Int) (later : Int → Prop)
    (hp : ValidWord s pre)
    (next : Greedy (execute s pre) h)
    (pre_bound : ∀ x ∈ pre, x < 2 * h)
    (later_bound : ∀ x, later x → 2 * h ≤ x)
    (hr : ValidWord (mark (execute s pre) (fun x => x = h)) repair)
    (repair_bound : ∀ x ∈ repair, x < 2 * h) :
    ValidWord (mark s (fun x => x = h ∨ later x)) (pre ++ repair) ∧
      execute (mark s (fun x => x = h ∨ later x)) (pre ++ repair) =
        mark (execute (mark (execute s pre) (fun x => x = h)) repair) later := by
  have not_h := not_mem_before_greedy next
  have avoid : ∀ x ∈ pre, ¬(x = h ∨ later x) := by
    intro x hx hm
    rcases hm with rfl | hm
    · exact not_h hx
    · have hsmall := pre_bound x hx
      have hlarge := later_bound x hm
      omega
  have marked_pre := validWord_mark hp avoid
  have marked_repair :
      ValidWord (mark (mark (execute s pre) (fun x => x = h)) later) repair := by
    apply validWord_mark hr
    intro x hx hm
    have hsmall := repair_bound x hx
    have hlarge := later_bound x hm
    omega
  constructor
  · apply (validWord_append _ _ _).mpr
    refine ⟨marked_pre, ?_⟩
    rw [execute_mark, ← mark_mark]
    exact marked_repair
  · rw [execute_append, execute_mark, ← mark_mark, execute_mark]

theorem mark_singleton_translate (h : Int) (s : State) :
    mark (translate h s) (fun x => x = h) =
      translate h (mark s (fun x => x = 0)) := by
  apply state_ext
  · rfl
  · intro x
    change (s.used (x - h) ∨ x = h) ↔ (s.used (x - h) ∨ x - h = 0)
    have heq : x = h ↔ x - h = 0 := by omega
    rw [heq]

/-- A uniform repair law with explicit phase/locality hypotheses.

The translated phase identity and the pre-word's locality are hypotheses,
not inferred from two sampled spacings. The repair is a fixed finite word
in coordinates relative to h, and its result is independent of h in those
coordinates. Residue-class reachability is a separate remaining obligation.
-/
theorem uniform_marker_repair
    (s phase : State) (pre repair : List Int) (h : Int) (later : Int → Prop)
    (large : 2401 ≤ h)
    (hp : ValidWord s pre)
    (phase_at_h : execute s pre = translate h phase)
    (next_zero : Greedy phase 0)
    (pre_bound : ∀ x ∈ pre, x < 2 * h)
    (later_bound : ∀ x, later x → 2 * h ≤ x)
    (hr : ValidWord (mark phase (fun x => x = 0)) repair)
    (repair_bound : ∀ x ∈ repair, x < 2000) :
    ValidWord (mark s (fun x => x = h ∨ later x))
        (pre ++ repair.map (fun x => x + h)) ∧
      execute (mark s (fun x => x = h ∨ later x))
        (pre ++ repair.map (fun x => x + h)) =
        mark (translate h (execute (mark phase (fun x => x = 0)) repair)) later := by
  have next_h : Greedy (execute s pre) h := by
    rw [phase_at_h]
    simpa using greedy_translate h next_zero
  have repair_at_h : ValidWord (mark (execute s pre) (fun x => x = h))
      (repair.map (fun x => x + h)) := by
    rw [phase_at_h, mark_singleton_translate]
    exact validWord_translate h hr
  have repair_below : ∀ x ∈ repair.map (fun x => x + h), x < 2 * h := by
    intro x hx
    rcases List.mem_map.mp hx with ⟨v, hv, rfl⟩
    have hvb := repair_bound v hv
    omega
  have result := marked_endpoint_transfer s pre (repair.map (fun x => x + h)) h later
    hp next_h pre_bound later_bound repair_at_h repair_below
  refine ⟨result.1, ?_⟩
  simpa only [phase_at_h, mark_singleton_translate, execute_translate] using result.2

/-- A finite coordinate bound controls every repeated block. -/
theorem repeatedWord_bound (w : List Int) (d target : Int)
    (nonneg : 0 ≤ d) (bound : ∀ x ∈ w, x < target + 2000) :
    ∀ q : Nat, ∀ x ∈ repeatedWord w d q, x < target + (q : Int) * d + 2000 := by
  intro q
  induction q with
  | zero => simp [repeatedWord]
  | succ q ih =>
    intro x hx
    have hd : ((q + 1 : Nat) : Int) * d = (q : Int) * d + d := by
      simp [Int.add_mul]
    change x ∈ repeatedWord w d q ++ w.map (fun y => y + (q : Int) * d) at hx
    rcases List.mem_append.mp hx with hx | hx
    · have hb := ih x hx
      rw [hd]
      omega
    · rcases List.mem_map.mp hx with ⟨v, hv, rfl⟩
      have hb := bound v hv
      rw [hd]
      omega

/-- Uniform marked transfer on a whole phase progression h = target + q*P.

Only a single finite cycle, its full-state return, a finite coordinate
bound, and one finite repair word are assumed. The unbounded pre-word
validity, its locality, and its translated phase identity are PROVED here.
No sampled-exponent equality is assumed. The finite certificate bridge,
the transient before cycle entry, and coverage of all phase residues remain
separate from this theorem.
-/
theorem cycle_marker_transfer
    (s : State) (w before after repair : List Int) (target h : Int)
    (q : Nat) (later : Int → Prop)
    (split : w = before ++ target :: after)
    (valid : ValidWord s w)
    (closes : execute s w = translate (w.length : Int) s)
    (cycle_bound : ∀ x ∈ w, x < target + 2000)
    (spacing : h = target + (q : Int) * (w.length : Int))
    (large : 2401 ≤ h)
    (later_bound : ∀ x, later x → 2 * h ≤ x)
    (repair_valid : ValidWord
      (mark (translate (-target) (execute s before)) (fun x => x = 0)) repair)
    (repair_bound : ∀ x ∈ repair, x < 2000) :
    let pre := repeatedWord w (w.length : Int) q ++
      before.map (fun x => x + (q : Int) * (w.length : Int))
    ValidWord (mark s (fun x => x = h ∨ later x))
        (pre ++ repair.map (fun x => x + h)) ∧
      execute (mark s (fun x => x = h ∨ later x))
        (pre ++ repair.map (fun x => x + h)) =
        mark (translate h (execute
          (mark (translate (-target) (execute s before)) (fun x => x = 0)) repair)) later := by
  dsimp only
  have parts : ValidWord s before ∧ Greedy (execute s before) target ∧
      ValidWord (visit (execute s before) target) after := by
    have hv : ValidWord s (before ++ target :: after) := by simpa only [← split] using valid
    exact (validWord_append s before (target :: after)).mp hv
  have repeats := translation_cycle valid closes q
  have prefix_valid : ValidWord s (repeatedWord w (w.length : Int) q ++
      before.map (fun x => x + (q : Int) * (w.length : Int))) := by
    apply (validWord_append _ _ _).mpr
    refine ⟨repeats.1, ?_⟩
    rw [repeats.2]
    exact validWord_translate _ parts.1
  have phase_identity : execute s (repeatedWord w (w.length : Int) q ++
      before.map (fun x => x + (q : Int) * (w.length : Int))) =
      translate h (translate (-target) (execute s before)) := by
    rw [execute_append, repeats.2, execute_translate, translate_translate]
    have heq : h + -target = (q : Int) * (w.length : Int) := by omega
    rw [heq]
  have next_zero : Greedy (translate (-target) (execute s before)) 0 := by
    have zero : target + -target = 0 := by omega
    simpa only [zero] using greedy_translate (-target) parts.2.1
  have prefix_bound : ∀ x ∈ (repeatedWord w (w.length : Int) q ++
      before.map (fun x => x + (q : Int) * (w.length : Int))), x < 2 * h := by
    intro x hx
    rcases List.mem_append.mp hx with hx | hx
    · have hb := repeatedWord_bound w (w.length : Int) target (by omega) cycle_bound q x hx
      omega
    · rcases List.mem_map.mp hx with ⟨v, hv, rfl⟩
      have hvw : v ∈ w := by rw [split]; exact List.mem_append.mpr (Or.inl hv)
      have hb := cycle_bound v hvw
      omega
  exact uniform_marker_repair s (translate (-target) (execute s before)) _ repair h later
    large prefix_valid phase_identity next_zero prefix_bound later_bound repair_valid repair_bound

/-- Every sufficiently large spacing in the phase residue has q>=0. -/
theorem spacing_of_residue (h target p : Int) (positive : 0 < p)
    (target_bound : target < 2000) (large : 2401 ≤ h)
    (residue : h % p = target % p) :
    ∃ q : Nat, h = target + (q : Int) * p := by
  have rem_zero : (h - target) % p = 0 :=
    Int.emod_eq_emod_iff_emod_sub_eq_zero.mp residue
  have nonneg : 0 ≤ (h - target) / p :=
    (Int.ediv_nonneg_iff_of_pos positive).mpr (by omega)
  refine ⟨((h - target) / p).toNat, ?_⟩
  rw [Int.toNat_of_nonneg nonneg]
  have division := Int.ediv_mul_add_emod (h - target) p
  rw [rem_zero] at division
  omega

/-- The phase-transfer law for EVERY h>=2401 in its residue class.

The assumptions are finite: one valid closed cycle with a specified
phase, coordinate bounds, and one fixed repair word. The conclusion
constructs a valid marked path for any matching spacing, keeping later
markers in the final used set. It does not assert that every residue or
every signed entrance occurs in the committed certificate catalogue.
-/
theorem residue_marker_transfer
    (s : State) (w before after repair : List Int) (target h : Int)
    (later : Int → Prop)
    (split : w = before ++ target :: after)
    (valid : ValidWord s w)
    (closes : execute s w = translate (w.length : Int) s)
    (target_bound : target < 2000)
    (cycle_bound : ∀ x ∈ w, x < target + 2000)
    (large : 2401 ≤ h)
    (residue : h % (w.length : Int) = target % (w.length : Int))
    (later_bound : ∀ x, later x → 2 * h ≤ x)
    (repair_valid : ValidWord
      (mark (translate (-target) (execute s before)) (fun x => x = 0)) repair)
    (repair_bound : ∀ x ∈ repair, x < 2000) :
    ∃ q : Nat, h = target + (q : Int) * (w.length : Int) ∧
      let pre := repeatedWord w (w.length : Int) q ++
        before.map (fun x => x + (q : Int) * (w.length : Int))
      ValidWord (mark s (fun x => x = h ∨ later x))
          (pre ++ repair.map (fun x => x + h)) ∧
        execute (mark s (fun x => x = h ∨ later x))
          (pre ++ repair.map (fun x => x + h)) =
          mark (translate h (execute
            (mark (translate (-target) (execute s before)) (fun x => x = 0)) repair)) later := by
  have positive : 0 < (w.length : Int) := by
    have length : w.length = before.length + (after.length + 1) := by
      simp [split]
    omega
  obtain ⟨q, spacing⟩ := spacing_of_residue h target (w.length : Int)
    positive target_bound large residue
  exact ⟨q, spacing, cycle_marker_transfer s w before after repair target h q later
    split valid closes cycle_bound spacing large later_bound repair_valid repair_bound⟩

/-- A finite repaired endpoint with positive front has filled through h. -/
theorem translated_checkpoint_filled (out : LocalState) (h f : Int)
    (front_positive : 0 < f) (later : Int → Prop) :
    ∀ x, x ≤ h → (mark (translate h (decode f out)) later).used x := by
  intro x hx
  left
  left
  change x - h < f
  omega

end Heraclitus
