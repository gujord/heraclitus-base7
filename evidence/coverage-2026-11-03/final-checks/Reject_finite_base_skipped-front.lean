import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : Claim initial (⟨true, 1, 3⟩ : Move) := by decide
