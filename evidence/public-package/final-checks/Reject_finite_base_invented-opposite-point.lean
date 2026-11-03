import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : traceCheck initial [{ FiniteBaseFixtures.first with neg := ⟨1, [3]⟩ }]=true := by decide
