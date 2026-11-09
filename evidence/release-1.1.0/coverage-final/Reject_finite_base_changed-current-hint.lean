import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : traceCheck initial [{ FiniteBaseFixtures.first with current := 2 }]=true := by decide
