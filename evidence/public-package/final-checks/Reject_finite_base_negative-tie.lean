import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : Claim initial (⟨false, 1, 2⟩ : Move) := by decide
