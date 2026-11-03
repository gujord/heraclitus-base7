import Heraclitus.FiniteBase
set_option autoImplicit false

namespace Heraclitus.FiniteBaseFixtures
open FiniteBase SignedCertificate

def first : Record := ⟨true, 1, ⟨2, []⟩, ⟨1, []⟩⟩
def second : Record := ⟨true, 2, ⟨3, []⟩, ⟨1, []⟩⟩

theorem first_two : traceCheck initial [first, second]=true := by decide

theorem positive_tie : Preferred 1 (-1) ∧ ¬Preferred (-1) 1 := positive_wins_tie 1 (by decide)

theorem wrong_sign : ¬Claim initial (⟨false, 1, 2⟩ : Move) := by decide

theorem wrong_front : ¬Claim initial (⟨true, 1, 3⟩ : Move) := by decide

theorem zero_already_used : ¬Claim first (⟨true, 0, 2⟩ : Move) := by decide

theorem far_beyond_cutoff : ¬Claim initial (⟨true, 823543, 1⟩ : Move) := by decide

end Heraclitus.FiniteBaseFixtures
