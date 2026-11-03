import Std

set_option autoImplicit false

/-!
# First-crossing arithmetic at every translated scale

This module formalizes the arithmetic comparison in paper Section 6(ii).
It does not assert that the supplied phases describe the actual signed
walk, that the crossing candidate is unused, or that all other powers lose.
Those are separate semantic obligations. No certificate or Python result
is postulated as an axiom.
-/

namespace Heraclitus.FirstCrossing

/-- One period's current and offered offsets, in cycle-entry coordinates. -/
structure Model (n : Nat) where
  positive : Bool
  front : Int
  period : Int
  current : Fin n → Int
  choice : Fin n → Int

/-- The opposite candidate wins ties precisely when the current side is
negative, so that the opposite destination is positive. -/
def Wins {n : Nat} (c : Model n) (m q : Int) (i : Fin n) : Prop :=
  let current := c.front + q * c.period + c.current i
  let offered := c.front + q * c.period + c.choice i
  let opposite := 6 * m + 1 - current
  if c.positive then opposite < offered else opposite ≤ offered

instance {n : Nat} (c : Model n) (m q : Int) (i : Fin n) :
    Decidable (Wins c m q i) := by unfold Wins; infer_instance

def Before {n : Nat} (r : Int) (j : Fin n) (q : Int) (i : Fin n) : Prop :=
  r < q ∨ (r = q ∧ j.val < i.val)

/-- An arithmetic first winner over integer cycle indices. Negative indices
are included only to make translation exact; they are not physical steps. -/
def First {n : Nat} (c : Model n) (m q : Int) (i : Fin n) : Prop :=
  Wins c m q i ∧ ∀ r j, Before r j q i → ¬Wins c m r j

/-- Restriction to the physical cycle-index domain, starting at zero. -/
def FirstNonnegative {n : Nat} (c : Model n) (m q : Int) (i : Fin n) : Prop :=
  0 ≤ q ∧ Wins c m q i ∧
    ∀ r j, 0 ≤ r → Before r j q i → ¬Wins c m r j

theorem wins_shift {n : Nat} (c : Model n) (m q d : Int) (i : Fin n) :
    Wins c (m + c.period * d) (q + 3 * d) i ↔ Wins c m q i := by
  unfold Wins
  have hmul : (q + 3 * d) * c.period = q * c.period + 3 * (c.period * d) := by
    rw [Int.add_mul, Int.mul_assoc, Int.mul_comm d c.period]
  rw [hmul]
  cases c.positive <;> simp only [Bool.false_eq_true, ↓reduceIte] <;> omega

theorem wins_monotone {n : Nat} (c : Model n) (m r q : Int) (i : Fin n)
    (hp : 0 ≤ c.period) (hrq : r ≤ q) (hw : Wins c m r i) :
    Wins c m q i := by
  have hmul := Int.mul_le_mul_of_nonneg_right hrq hp
  unfold Wins at hw ⊢
  cases hs : c.positive <;>
    simp only [hs, Bool.false_eq_true, ↓reduceIte] at hw ⊢ <;> omega

theorem not_wins_before_threshold {n : Nat} (c : Model n)
    (m r q : Int) (i : Fin n) (hp : 0 ≤ c.period)
    (hlast : ¬Wins c m (q - 1) i) (hrq : r < q) : ¬Wins c m r i := by
  intro hw
  exact hlast (wins_monotone c m r (q - 1) i hp (by omega) hw)

/-- Two adjacent comparisons per phase suffice for all cycle indices.
The lexicographic minimum also checks phases earlier in the winning cycle. -/
theorem first_of_thresholds {n : Nat} (c : Model n) (m : Int)
    (threshold : Fin n → Int) (i : Fin n) (hp : 0 ≤ c.period)
    (thresholds : ∀ j, Wins c m (threshold j) j ∧
      ¬Wins c m (threshold j - 1) j)
    (minimum : ∀ j, threshold i < threshold j ∨
      (threshold i = threshold j ∧ i.val ≤ j.val)) :
    First c m (threshold i) i := by
  refine ⟨(thresholds i).1, ?_⟩
  intro r j hearlier
  have hmin := minimum j
  have hrq : r < threshold j := by
    unfold Before at hearlier
    rcases hmin with hmin | ⟨heq, hindex⟩ <;> omega
  exact not_wins_before_threshold c m r (threshold j) j hp (thresholds j).2 hrq

/-- Uniform phase law, including chronological minimality, not just a
comparison at two sampled scales. -/
theorem first_shift {n : Nat} (c : Model n) (m q d : Int) (i : Fin n)
    (hf : First c m q i) :
    First c (m + c.period * d) (q + 3 * d) i := by
  refine ⟨(wins_shift c m q d i).mpr hf.1, ?_⟩
  intro r j hearlier hw
  have hbefore : Before (r - 3 * d) j q i := by
    unfold Before at hearlier ⊢
    omega
  have hwin : Wins c m (r - 3 * d) j := by
    apply (wins_shift c m (r - 3 * d) d j).mp
    simpa only [Int.sub_add_cancel] using hw
  exact hf.2 (r - 3 * d) j hbefore hwin

theorem first_nonnegative {n : Nat} (c : Model n) (m q : Int) (i : Fin n)
    (hf : First c m q i) (hq : 0 ≤ q) : FirstNonnegative c m q i := by
  exact ⟨hq, hf.1, fun r j _ hearlier => hf.2 r j hearlier⟩

theorem first_nonnegative_shift {n : Nat} (c : Model n)
    (m q d : Int) (i : Fin n) (hf : First c m q i)
    (hq : 0 ≤ q) (hd : 0 ≤ d) :
    FirstNonnegative c (m + c.period * d) (q + 3 * d) i := by
  exact first_nonnegative c _ _ i (first_shift c m q d i hf) (by omega)

/-- The front relative to the new outer origin is unchanged. Together with
unchanged phase data this gives identical local offsets, conditionally on
the separately established full-state representation. -/
theorem normalized_front_shift (f p b m q d : Int) :
    f + (q + 3 * d) * p + b - 3 * (m + p * d) =
      f + q * p + b - 3 * m := by
  have hmul : (q + 3 * d) * p = q * p + 3 * (p * d) := by
    rw [Int.add_mul, Int.mul_assoc, Int.mul_comm d p]
  rw [hmul]
  omega

theorem positive_tie_loses {n : Nat} (c : Model n) (m q : Int) (i : Fin n)
    (hs : c.positive = true)
    (heq : 6 * m + 1 - (c.front + q * c.period + c.current i) =
      c.front + q * c.period + c.choice i) : ¬Wins c m q i := by
  simp [Wins, hs, heq]

theorem negative_tie_wins {n : Nat} (c : Model n) (m q : Int) (i : Fin n)
    (hs : c.positive = false)
    (heq : 6 * m + 1 - (c.front + q * c.period + c.current i) =
      c.front + q * c.period + c.choice i) : Wins c m q i := by
  simp [Wins, hs, heq]

/-- Includes period one: modular identity is `1 % p`, not literal `1`. -/
theorem exponent_residue (p k t : Nat) (h : 7 ^ 36 % p = 1 % p) :
    7 ^ (k + 36 * t) % p = 7 ^ k % p := by
  induction t with
  | zero => simp
  | succ t ih =>
    rw [Nat.mul_succ, ← Nat.add_assoc, Nat.pow_add, Nat.mul_mod, h,
      ← Nat.mul_mod, Nat.mul_one]
    exact ih

theorem nonnegative_period_shift (a b p : Int) (hp : 0 < p)
    (hab : a ≤ b) (hmod : b % p = a % p) :
    ∃ d : Int, 0 ≤ d ∧ b = a + p * d := by
  refine ⟨b / p - a / p, ?_, ?_⟩
  · have hdiv := Int.ediv_le_ediv hp hab
    omega
  · rw [Int.mul_sub]
    have ha := Int.emod_add_mul_ediv a p
    have hb := Int.emod_add_mul_ediv b p
    omega

/-- Extracted arithmetic data; validity as a greedy route is not asserted. -/
structure PhaseData where
  current : Int
  choice : Int
  front : Int
  threshold : Int

structure Row where
  label : Nat
  leastExponent : Nat
  positive : Bool
  front : Int
  phases : Array PhaseData
  selected : Fin phases.size
  expectedFront : Int
  expectedEntry : Int

def Row.model (r : Row) : Model r.phases.size where
  positive := r.positive
  front := r.front
  period := r.phases.size
  current := fun i => r.phases[i].current
  choice := fun i => r.phases[i].choice

def Row.scale (r : Row) : Int := 7 ^ r.leastExponent
def Row.threshold (r : Row) (i : Fin r.phases.size) : Int := r.phases[i].threshold
def Row.winningCycle (r : Row) : Int := r.threshold r.selected

/-- All arithmetic premises are finite and decidable. Each concrete row's
proof uses kernel reduction, not a trusted external verifier. -/
def Row.Checked (r : Row) : Prop :=
  0 < r.model.period ∧
  (∀ j, Wins r.model r.scale (r.threshold j) j ∧
    ¬Wins r.model r.scale (r.threshold j - 1) j) ∧
  (∀ j, r.winningCycle < r.threshold j ∨
    (r.winningCycle = r.threshold j ∧ r.selected.val ≤ j.val)) ∧
  0 ≤ r.winningCycle ∧
  r.expectedFront = r.front + r.winningCycle * r.model.period +
    r.phases[r.selected].front - 3 * r.scale ∧
  r.expectedEntry = 1 - r.expectedFront -
    (r.phases[r.selected].current - r.phases[r.selected].front) ∧
  40 ≤ r.label ∧ r.label < 76 ∧
  r.leastExponent = 6 + (r.label - 6) % 36 ∧
  7 ^ 36 % r.phases.size = 1 % r.phases.size

instance (r : Row) : Decidable r.Checked := by unfold Row.Checked; infer_instance

theorem Row.first (r : Row) (h : r.Checked) :
    First r.model r.scale r.winningCycle r.selected := by
  exact first_of_thresholds r.model r.scale r.threshold r.selected
    (by have hp := h.1; omega) h.2.1 h.2.2.1

/-- Every nonnegative period-multiple increase, with the same selected
phase and the same front/entry offsets. This is an arithmetic result;
physical-path validity and full used-set correspondence remain external. -/
theorem Row.all_larger_scales (r : Row) (h : r.Checked) (d : Int) (hd : 0 ≤ d) :
    FirstNonnegative r.model (r.scale + r.model.period * d)
      (r.winningCycle + 3 * d) r.selected ∧
    r.expectedFront = r.front + (r.winningCycle + 3 * d) * r.model.period +
      r.phases[r.selected].front - 3 * (r.scale + r.model.period * d) := by
  refine ⟨first_nonnegative_shift r.model r.scale r.winningCycle d r.selected
    (r.first h) h.2.2.2.1 hd, ?_⟩
  rw [normalized_front_shift]
  exact h.2.2.2.2.1

/-- Every exponent in the row's class, not only arbitrary supplied scale
increments. The existential cycle shift is nonnegative by integer division. -/
theorem Row.all_exponents (r : Row) (h : r.Checked) (t : Nat) :
    ∃ d : Int, 0 ≤ d ∧
      (7 : Int) ^ (r.leastExponent + 36 * t) = r.scale + r.model.period * d ∧
      FirstNonnegative r.model ((7 : Int) ^ (r.leastExponent + 36 * t))
        (r.winningCycle + 3 * d) r.selected ∧
      r.expectedFront = r.front + (r.winningCycle + 3 * d) * r.model.period +
        r.phases[r.selected].front - 3 * (7 : Int) ^ (r.leastExponent + 36 * t) := by
  have hres := exponent_residue r.phases.size r.leastExponent t h.2.2.2.2.2.2.2.2.2
  have hmod : ((7 : Int) ^ (r.leastExponent + 36 * t)) % r.model.period =
      r.scale % r.model.period := by
    exact congrArg (fun x : Nat => (x : Int)) hres
  have hnat : (7 : Nat) ^ r.leastExponent ≤ 7 ^ (r.leastExponent + 36 * t) :=
    Nat.pow_le_pow_right (by decide) (by omega)
  have hle : r.scale ≤ (7 : Int) ^ (r.leastExponent + 36 * t) :=
    Int.ofNat_le.mpr hnat
  obtain ⟨d, hd, heq⟩ := nonnegative_period_shift r.scale
    ((7 : Int) ^ (r.leastExponent + 36 * t)) r.model.period h.1 hle hmod
  refine ⟨d, hd, heq, ?_⟩
  rw [heq]
  exact r.all_larger_scales h d hd

end Heraclitus.FirstCrossing
