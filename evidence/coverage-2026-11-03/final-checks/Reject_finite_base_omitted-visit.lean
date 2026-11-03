import research.finite_base.Fixtures
open Heraclitus FiniteBase SignedCertificate
example : traceCheck initial [FiniteBaseFixtures.second]=true := by decide
