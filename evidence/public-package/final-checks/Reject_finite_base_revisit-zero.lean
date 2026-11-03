import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : Claim FiniteBaseFixtures.first (⟨true, 0, 2⟩ : Move) := by decide
