import Heraclitus.Certificate74Data

set_option autoImplicit false
set_option maxRecDepth 10000
set_option maxHeartbeats 2000000

/-!
# One concrete 74-step cycle and uniform marked-endpoint transfer

Every finite hypothesis is proved below by kernel-checked reduction and the
soundness lemmas. No Python PASS, finite route, or endpoint is assumed.
-/

namespace Heraclitus.Certificate74

open Certificate74Data

theorem metadata_matches : period = 74 ∧ residue = 1 ∧ phase = 69 ∧
    beforeWord.length = phase ∧ cycleWord.length = period ∧
    target % (period : Int) = residue := by decide

theorem cycle_length : cycleWord.length = 74 := by decide

theorem cycle_split : cycleWord = beforeWord ++ target :: afterWord := by decide

theorem cycle_valid : ValidWord initial.toState cycleWord := by
  apply FiniteState.wordCheck_sound
  decide

theorem cycle_closes : execute initial.toState cycleWord = translate 74 initial.toState := by
  have checked := FiniteState.equalityCheck_sound
    (s := initial.run cycleWord) (t := initial.shift 74) (lo := 0) (hi := 100)
    (by decide)
  simpa only [FiniteState.run_toState, FiniteState.shift_toState] using checked

theorem cycle_repeats : ∀ q : Nat,
    ValidWord initial.toState (repeatedWord cycleWord 74 q) ∧
      execute initial.toState (repeatedWord cycleWord 74 q) =
        translate ((q : Int) * 74) initial.toState :=
  translation_cycle cycle_valid cycle_closes

theorem repair_start_eq :
    mark (translate (-target) (execute initial.toState beforeWord)) (fun x => x = 0) =
      repairInitial.toState := by
  have checked := FiniteState.equalityCheck_sound
    (s := ((initial.run beforeWord).shift (-target)).markPoint 0)
    (t := repairInitial) (lo := -100) (hi := 100) (by decide)
  simpa only [FiniteState.run_toState, FiniteState.shift_toState,
    FiniteState.markPoint_toState] using checked

theorem repair_valid :
    ValidWord (mark (translate (-target) (execute initial.toState beforeWord))
      (fun x => x = 0)) repairWord := by
  rw [repair_start_eq]
  apply FiniteState.wordCheck_sound
  decide

theorem repair_endpoint : execute repairInitial.toState repairWord = output.toState := by
  have checked := FiniteState.equalityCheck_sound
    (s := repairInitial.run repairWord) (t := output) (lo := -100) (hi := 100)
    (by decide)
  simpa only [FiniteState.run_toState] using checked

theorem cycle_bound : ∀ x ∈ cycleWord, x < target + 2000 := by decide

theorem repair_bound : ∀ x ∈ repairWord, x < 2000 := by decide

def transferWord (q : Nat) (h : Int) : List Int :=
  (repeatedWord cycleWord 74 q ++ beforeWord.map (fun x => x + (q : Int) * 74)) ++
    repairWord.map (fun x => x + h)

theorem transferWord_length (q : Nat) (h : Int) :
    (transferWord q h).length = 74 * q + 74 := by
  have lb : beforeWord.length = 69 := by decide
  have lr : repairWord.length = 5 := by decide
  simp only [transferWord, List.length_append, List.length_map,
    repeatedWord_length, cycle_length, lb, lr]
  omega

/-- Concrete uniform transfer: only h and the positions of later markers are hypotheses. -/
theorem uniform_transfer (h : Int) (later : Int → Prop)
    (large : 2401 ≤ h) (residue : h % 74 = 1)
    (later_bound : ∀ x, later x → 2 * h ≤ x) :
    ∃ q : Nat, h = 75 + (q : Int) * 74 ∧
      ValidWord (mark initial.toState (fun x => x = h ∨ later x)) (transferWord q h) ∧
        execute (mark initial.toState (fun x => x = h ∨ later x)) (transferWord q h) =
          mark (translate h output.toState) later := by
  have close : execute initial.toState cycleWord =
      translate (cycleWord.length : Int) initial.toState := by
    simpa [cycle_length] using cycle_closes
  have congruence : h % (cycleWord.length : Int) = target % (cycleWord.length : Int) := by
    simpa [cycle_length, target] using residue
  have law := residue_marker_transfer initial.toState cycleWord beforeWord afterWord
    repairWord target h later cycle_split cycle_valid close (by decide) cycle_bound
    large congruence later_bound repair_valid repair_bound
  rw [repair_start_eq, repair_endpoint] at law
  simpa [cycle_length, target, transferWord] using law

theorem checkpoint_filled (h : Int) (later : Int → Prop) :
    ∀ x, x ≤ h → (mark (translate h output.toState) later).used x := by
  intro x hx
  left
  left
  change x - h < 4
  omega

theorem checkpoint_front_unused (h : Int) (later : Int → Prop)
    (large : 2401 ≤ h) (later_bound : ∀ x, later x → 2 * h ≤ x) :
    ¬(mark (translate h output.toState) later).used (h + 4) := by
  intro used
  rcases used with old | extra
  · have value : h + 4 - h = 4 := by omega
    change output.toState.used (h + 4 - h) at old
    rw [value] at old
    exact (by decide : ¬output.toState.used 4) old
  · have bound := later_bound (h + 4) extra
    omega

/-- The selected certificate reaches its stated complete checkpoint for every spacing. -/
theorem complete_transfer (h : Int) (later : Int → Prop)
    (large : 2401 ≤ h) (residue : h % 74 = 1)
    (later_bound : ∀ x, later x → 2 * h ≤ x) :
    ∃ q : Nat, h = 75 + (q : Int) * 74 ∧
      ValidWord (mark initial.toState (fun x => x = h ∨ later x)) (transferWord q h) ∧
        execute (mark initial.toState (fun x => x = h ∨ later x)) (transferWord q h) =
          mark (translate h output.toState) later ∧
        (∀ x, x ≤ h → (execute (mark initial.toState (fun x => x = h ∨ later x))
          (transferWord q h)).used x) ∧
        ¬(execute (mark initial.toState (fun x => x = h ∨ later x))
          (transferWord q h)).used (h + 4) := by
  obtain ⟨q, spacing, valid, endpoint⟩ := uniform_transfer h later large residue later_bound
  refine ⟨q, spacing, valid, endpoint, ?_, ?_⟩
  · rw [endpoint]
    exact checkpoint_filled h later
  · rw [endpoint]
    exact checkpoint_front_unused h later large later_bound

end Heraclitus.Certificate74
