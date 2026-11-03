import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : traceCheck { initial with neg := ⟨1, [3]⟩ } [FiniteBaseFixtures.first]=true := by decide
