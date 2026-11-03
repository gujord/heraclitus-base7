# Fresh public-package reproduction and release audit

All results here were executed within Roger Gujord's AI-assisted project.
They are not independent human review or independently performed reproduction.

- `formal/run.json`: fresh isolated compilation of all 244 modules, 21
  source bindings, 4,998 axiom audits; 272 source hashes and 244 object hashes.
- `final-checks/run.json`: checked reuse of those objects, two fresh fixtures,
  24 audits, 14 mathematical and five receipt rejection cases.
- `python/`: exact certificates, direct base, rational corollary calculations,
  reduction premises and all 14 Python tests.
- `regeneration.json`: three byte-identical regenerated certificates and
  hashes of every Python verification/generation input.
- `commands.json`: actual command scope and initial ZIP identity; all 272
  Lean inputs matched the freshly extracted ZIP, which contained no objects.
- `editorial-qa.json`: all 16 PDF pages accounted for, including the accepted
  side-conversation wording edits; current PDF hash and required link targets.
- `metadata-validation.json`: official CFF schema validation and DOI/version/
  creator/license consistency. No Zenodo API deposit was performed.
- `distribution-tests.txt`, `export-rejections.json`: seven distribution
  boundary tests and two final export-gate rejection cases.
- `summary.json`: scope, counts and final manuscript identities.

Raw diagnostics are preserved, including expected errors from rejection
tests. Original `.log` bytes use a `.log.txt` suffix where needed. Absolute
paths describe the actual local execution and are not required locations
on another machine. Compiled project objects are deliberately not shipped;
reproduction rebuilds them. The full `protected-files.json` inventory is
retained only in the private development audit; the public export omits it
because it lists unrelated private archive/history paths.

The final export is checked against this receipt's source and manuscript
hashes. Editing presentation files while Lean ran did not change the proof
inputs. `formal/` in the development tree is unchanged since commit 56095df;
the public `formal/README.md` is a documented documentation overlay.
