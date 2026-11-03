import Heraclitus.Markers

set_option autoImplicit false

namespace Heraclitus

/-- A genuine base-seven entrance, not an assumed abstract transition. -/
def cleanEntrance : LocalState where
  current := -1
  extra := []
  positive := by simp
  current_used := Or.inl (by omega)

theorem clean_first_choice : Greedy (decode 0 cleanEntrance) 0 := by
  refine ⟨decode_front_unused 0 cleanEntrance, ?_, ?_⟩
  · refine ⟨0, ?_⟩
    rfl
  · intro w hw _
    have hn : ¬w < 0 := fun h => hw (Or.inl h)
    omega

theorem clean_cycle_closes : execute (decode 0 cleanEntrance) [0] =
    decode 1 cleanEntrance := by
  apply state_ext
  · rfl
  · intro x
    simp only [execute, visit, decode, cleanEntrance, List.not_mem_nil,
      or_false]
    omega

/-- Instantiates the cycle theorem with a proved one-step, shift-one cycle. -/
theorem clean_cycle_repeats :
    ∀ q : Nat, ValidWord (decode 0 cleanEntrance) (repeatedWord [0] 1 q) ∧
      execute (decode 0 cleanEntrance) (repeatedWord [0] 1 q) =
        decode (q : Int) cleanEntrance := by
  intro q
  have valid : ValidWord (decode 0 cleanEntrance) [0] := ⟨clean_first_choice, True.intro⟩
  simpa using normalized_cycle_repeats cleanEntrance [0] valid clean_cycle_closes q

end Heraclitus
