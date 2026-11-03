import Heraclitus.Refinement
import Heraclitus.FirstCrossing

set_option autoImplicit false

/-!
# The outgoing signed choice from two competing rays

This module discharges the critical-power obligations in the outgoing
envelope. It assumes the explicitly represented current used set and a
valid half-line winner. Reachability of those states and the entire signed
scale transition are not asserted.
-/

namespace Heraclitus.Outgoing

def otherBoundary (side : Bool) (pos neg : RayBoundary) : RayBoundary :=
  if side then neg else pos

def CrossWins (side : Bool) (m x y : Int) : Prop :=
  if side then 6 * m + 1 - x < y else 6 * m + 1 - x ≤ y

theorem wins_coordinates {n : Nat} (c : FirstCrossing.Model n)
    (m q : Int) (i : Fin n) :
    FirstCrossing.Wins c m q i ↔ CrossWins c.positive m
      (c.front + q * c.period + c.current i)
      (c.front + q * c.period + c.choice i) := by rfl

theorem other_representation (C x w : Int) (pos neg : RayBoundary)
    (side : Bool) (wp : 0 < C + w) :
    (signedBoundary C pos neg side x).used (embedRay (!side) C w) ↔
      boundaryUsed (otherBoundary side pos neg) w := by
  have h := boundary_ray_representation C pos neg (!side) x w wp
  cases side <;> simpa [otherBoundary, signedBoundary] using h

theorem crossing_unused (k : Nat) (C x : Int) (pos neg : RayBoundary)
    (side : Bool) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat))
    (upper : x ≤ 3 * (7 ^ k : Nat) + 9)
    (front : (otherBoundary side pos neg).front < 100)
    (extras : ∀ z ∈ (otherBoundary side pos neg).extra, z < 100) :
    ¬(signedBoundary C pos neg side x).used
      (embedRay (!side) C (6 * (7 ^ k : Nat) + 1 - x)) := by
  have wp : 0 < C + (6 * (7 ^ k : Nat) + 1 - x) := by omega
  intro used
  have hu := (other_representation C x _ pos neg side wp).mp used
  rcases hu with hfront | hextra
  · omega
  · have small := extras _ hextra
    omega

theorem crossing_admissible (k : Nat) (C x : Int) (side : Bool)
    (scale : 2 * C + 1 = (7 ^ k : Nat))
    (xp : 0 < C + x) (rp : 0 < C + (6 * (7 ^ k : Nat) + 1 - x)) :
    PowerStep (embedRay side C x)
      (embedRay (!side) C (6 * (7 ^ k : Nat) + 1 - x)) := by
  refine ⟨k + 1, ?_⟩
  have distance := opposite_ray_distance side C x (6 * (7 ^ k : Nat) + 1 - x) xp rp
  rw [Nat.pow_succ]
  omega

theorem crossing_preferred (side : Bool) (m x y : Int)
    (hw : CrossWins side m x y) :
    BoundaryPreferred (!side) (6 * m + 1 - x) side y := by
  cases side <;> simp_all [CrossWins, BoundaryPreferred] <;> omega

theorem local_preferred (side : Bool) (m x y : Int)
    (hw : ¬CrossWins side m x y) :
    BoundaryPreferred side y (!side) (6 * m + 1 - x) := by
  cases side <;> simp_all [CrossWins, BoundaryPreferred] <;> omega

/-- The M reflection hits the opposite filled prefix. The 7M reflection
is compared explicitly. Same-ray competitors use the supplied exact local
minimum. This handles both directions at both critical exponents. -/
theorem critical_comparisons (k : Nat) (C x v : Int) (pos neg : RayBoundary)
    (side destSide : Bool) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (xp : 0 < C + x) (vp : 0 < C + v)
    (reflected_used : 1 - x < (otherBoundary side pos neg).front)
    (same_min : ∀ w, 0 < C + w →
      ¬boundaryUsed (if side then pos else neg) w → PowerStep x w →
      BoundaryPreferred destSide v side w)
    (cross_min : BoundaryPreferred destSide v (!side) (6 * (7 ^ k : Nat) + 1 - x)) :
    ∀ j : Nat, (j = k ∨ j = k + 1) → ∀ z : Int,
      ¬(signedBoundary C pos neg side x).used z →
      (z - embedRay side C x).natAbs = 7 ^ j →
      Preferred (embedRay destSide C v) z := by
  intro j hj z zu step
  by_cases same : OnRay side z
  · obtain ⟨w, wp, rfl⟩ := onRay_coordinates side C z same
    have wu : ¬boundaryUsed (if side then pos else neg) w := by
      intro hu
      exact zu ((boundary_ray_representation C pos neg side x w wp).mpr hu)
    have ws := (ray_power side C x w).mp (show PowerStep _ _ from ⟨j, step⟩)
    exact (boundary_order_exact C v w destSide side vp wp).mp (same_min w wp wu ws)
  · have nz : z ≠ 0 := fun eq => zu (eq ▸ boundary_zero_used C pos neg side x)
    obtain ⟨w, wp, rfl⟩ := onRay_coordinates (!side) C z (opposite_onRay side z nz same)
    have distance := opposite_ray_distance side C x w xp wp
    rw [step] at distance
    rcases hj with rfl | rfl
    · have eq : w = 1 - x := by omega
      have occupied : boundaryUsed (otherBoundary side pos neg) w := Or.inl (by omega)
      exact False.elim (zu ((other_representation C x w pos neg side wp).mpr occupied))
    · have eq : w = 6 * (7 ^ k : Nat) + 1 - x := by
        rw [Nat.pow_succ] at distance
        omega
      subst w
      exact (boundary_order_exact C v _ destSide (!side) vp wp).mp cross_min

/-- Before the crossing inequality wins, the half-line winner is the
actual signed winner. Every omitted exponent is excluded by the proved
two-scale envelope theorem; no bounded list of powers is assumed complete. -/
theorem local_choice_sound (k : Nat) (C x y : Int) (pos neg : RayBoundary)
    (side : Bool) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat))
    (xb : -100 ≤ x ∧ x ≤ 3 * (7 ^ k : Nat) + 9)
    (yb : -100 ≤ y ∧ y ≤ 3 * (7 ^ k : Nat) + 9)
    (reflected_used : 1 - x < (otherBoundary side pos neg).front)
    (greedy : Greedy (halfBoundary (if side then pos else neg) x) y)
    (no_cross : ¬CrossWins side (7 ^ k : Nat) x y) :
    SignedGreedy (signedBoundary C pos neg side x) (embedRay side C y) := by
  have xp : 0 < C + x := by omega
  have yp : 0 < C + y := by omega
  have same_min : ∀ w, 0 < C + w →
      ¬boundaryUsed (if side then pos else neg) w → PowerStep x w →
      BoundaryPreferred side y side w := by
    intro w wp wu ws
    have le := greedy.2.2 w wu ws
    apply (boundary_order_exact C y w side side yp wp).mpr
    exact ray_preferred side (by omega) (by omega) (by omega)
  apply two_scale_rule_sound k C x y pos neg side side scale large
    (by omega) (by omega)
  · exact fun hu => greedy.1 ((boundary_ray_representation C pos neg side x y yp).mp hu)
  · exact (ray_power side C x y).mpr greedy.2.1
  · exact same_min
  · exact critical_comparisons k C x y pos neg side side scale xp yp
      reflected_used same_min (local_preferred side _ x y no_cross)

/-- At the winning inequality the opposite 7M candidate is new, legal,
and preferred to every unused power neighbor, including same-ray choices. -/
theorem crossing_choice_sound (k : Nat) (C x y : Int) (pos neg : RayBoundary)
    (side : Bool) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat))
    (xb : -100 ≤ x ∧ x ≤ 3 * (7 ^ k : Nat) + 9)
    (yb : -100 ≤ y ∧ y ≤ 3 * (7 ^ k : Nat) + 9)
    (reflected_used : 1 - x < (otherBoundary side pos neg).front)
    (other_front : (otherBoundary side pos neg).front < 100)
    (other_extras : ∀ z ∈ (otherBoundary side pos neg).extra, z < 100)
    (greedy : Greedy (halfBoundary (if side then pos else neg) x) y)
    (cross : CrossWins side (7 ^ k : Nat) x y) :
    SignedGreedy (signedBoundary C pos neg side x)
      (embedRay (!side) C (6 * (7 ^ k : Nat) + 1 - x)) := by
  let r : Int := 6 * ((7 ^ k : Nat) : Int) + 1 - x
  have hr : r = 6 * ((7 ^ k : Nat) : Int) + 1 - x := rfl
  have rle : r ≤ y := by
    cases side <;> simp only [CrossWins, Bool.false_eq_true, ite_false, ite_true] at cross <;>
      omega
  have xp : 0 < C + x := by omega
  have yp : 0 < C + y := by omega
  have rp : 0 < C + r := by omega
  have rl : -100 ≤ r := by omega
  have dominates : Preferred (embedRay (!side) C r) (embedRay side C y) :=
    (boundary_order_exact C r y (!side) side rp yp).mp (crossing_preferred side _ x y cross)
  have same_min : ∀ w, 0 < C + w →
      ¬boundaryUsed (if side then pos else neg) w → PowerStep x w →
      BoundaryPreferred (!side) r side w := by
    intro w wp wu ws
    have le := greedy.2.2 w wu ws
    apply (boundary_order_exact C r w (!side) side rp wp).mpr
    apply preferred_trans dominates
    exact ray_preferred side (by omega) (by omega) (by omega)
  apply two_scale_rule_sound k C x r pos neg side (!side) scale large
    (by omega) (by omega)
  · exact crossing_unused k C x pos neg side scale large xb.2 other_front other_extras
  · exact crossing_admissible k C x side scale xp rp
  · exact same_min
  · apply critical_comparisons k C x r pos neg side (!side) scale xp rp
      reflected_used same_min
    exact (boundary_order_exact C r r (!side) (!side) rp rp).mpr (preferred_refl _)

def cycleCurrent (r : FirstCrossing.Row) (q : Int) (i : Fin r.phases.size) : Int :=
  r.front + q * r.model.period + r.model.current i

def cycleChoice (r : FirstCrossing.Row) (q : Int) (i : Fin r.phases.size) : Int :=
  r.front + q * r.model.period + r.model.choice i

/-- The opposite side is unchanged throughout the outgoing segment.
Transient pairs are physical current/choice offsets relative to C. -/
structure GeometryData (r : FirstCrossing.Row) where
  other : RayBoundary
  transient : Array (Int × Int)

def GeometryData.Checked {r : FirstCrossing.Row} (g : GeometryData r) : Prop :=
  g.other.front < 100 ∧
  (∀ z ∈ g.other.extra, z < 100) ∧
  (∀ i : Fin r.phases.size,
    -100 ≤ r.front + r.model.current i ∧
    -100 ≤ r.front + r.model.choice i ∧
    1 - (r.front + r.model.current i) < g.other.front ∧
    cycleCurrent r r.winningCycle i ≤ 3 * r.scale + 9 ∧
    cycleChoice r r.winningCycle i ≤ 3 * r.scale + 9) ∧
  (∀ i : Fin g.transient.size,
    -100 ≤ g.transient[i].1 ∧ g.transient[i].1 < 2000 ∧
    -100 ≤ g.transient[i].2 ∧ g.transient[i].2 < 2000 ∧
    1 - g.transient[i].1 < g.other.front)

instance {r : FirstCrossing.Row} (g : GeometryData r) : Decidable g.Checked := by
  unfold GeometryData.Checked
  infer_instance

/-- The finite envelope at the least scale controls ALL earlier cycle
phases and all larger scales in the residue class. -/
theorem cycle_geometry {r : FirstCrossing.Row} (g : GeometryData r)
    (hr : r.Checked) (hg : g.Checked) (d q : Int) (i : Fin r.phases.size)
    (hq : 0 ≤ q) (last : q ≤ r.winningCycle + 3 * d) :
    (-100 ≤ cycleCurrent r q i ∧
      cycleCurrent r q i ≤ 3 * (r.scale + r.model.period * d) + 9) ∧
    (-100 ≤ cycleChoice r q i ∧
      cycleChoice r q i ≤ 3 * (r.scale + r.model.period * d) + 9) ∧
    1 - cycleCurrent r q i < g.other.front := by
  have hp : 0 ≤ r.model.period := by have h := hr.1; omega
  have nonneg := Int.mul_nonneg hq hp
  have upper := Int.mul_le_mul_of_nonneg_right last hp
  obtain ⟨ul, wl, reflection, ub, wb⟩ := hg.2.2.1 i
  have ueq := FirstCrossing.normalized_front_shift r.front r.model.period
    (r.model.current i) r.scale r.winningCycle d
  have weq := FirstCrossing.normalized_front_shift r.front r.model.period
    (r.model.choice i) r.scale r.winningCycle d
  simp only [cycleCurrent, cycleChoice] at ub wb ⊢
  omega

/-- During the finite transient, a 7M reflection cannot win. -/
theorem transient_no_cross (side : Bool) (m x y : Int)
    (large : 100000 ≤ m) (xb : x < 2000) (yb : y < 2000) :
    ¬CrossWins side m x y := by
  cases side <;> simp only [CrossWins, Bool.false_eq_true, ite_false, ite_true] <;> omega

/-- Each extracted transient step is signed-greedy, conditional only on
the exact current boundary representation and a genuine half-line choice. -/
theorem transient_choice_sound {r : FirstCrossing.Row} (g : GeometryData r)
    (hg : g.Checked) (i : Fin g.transient.size) (k : Nat) (C : Int)
    (pos neg : RayBoundary) (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat))
    (other : otherBoundary r.positive pos neg = g.other)
    (greedy : Greedy (halfBoundary (if r.positive then pos else neg) g.transient[i].1)
      g.transient[i].2) :
    SignedGreedy (signedBoundary C pos neg r.positive g.transient[i].1)
      (embedRay r.positive C g.transient[i].2) := by
  obtain ⟨xl, xu, yl, yu, reflection⟩ := hg.2.2.2 i
  apply local_choice_sound k C _ _ pos neg r.positive scale large
    (by omega) (by omega) (by rw [other]; exact reflection) greedy
  exact transient_no_cross r.positive _ _ _ (by omega) xu yu

/-- Before the arithmetic first winner, discharge the signed choice at
any represented cycle phase. Establishing that all these states are reached
is a separate word/representation induction. -/
theorem before_first_choice {r : FirstCrossing.Row} (g : GeometryData r)
    (hr : r.Checked) (hg : g.Checked) (k : Nat) (C : Int)
    (pos neg : RayBoundary) (d q : Int) (i : Fin r.phases.size)
    (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat)) (hq : 0 ≤ q)
    (scale_shift : (7 ^ k : Nat) = r.scale + r.model.period * d)
    (other : otherBoundary r.positive pos neg = g.other)
    (earlier : FirstCrossing.Before q i (r.winningCycle + 3 * d) r.selected)
    (greedy : Greedy (halfBoundary (if r.positive then pos else neg) (cycleCurrent r q i))
      (cycleChoice r q i)) :
    SignedGreedy (signedBoundary C pos neg r.positive (cycleCurrent r q i))
      (embedRay r.positive C (cycleChoice r q i)) := by
  have last : q ≤ r.winningCycle + 3 * d := by unfold FirstCrossing.Before at earlier; omega
  obtain ⟨xb, yb, reflection⟩ := cycle_geometry g hr hg d q i hq last
  rw [← scale_shift] at xb yb
  have first := FirstCrossing.first_shift r.model r.scale r.winningCycle d r.selected (r.first hr)
  have nw := first.2 q i earlier
  rw [← scale_shift] at nw
  apply local_choice_sound k C _ _ pos neg r.positive scale large xb yb
    (by rw [other]; exact reflection) greedy
  exact fun hw => nw ((wins_coordinates r.model _ q i).mpr hw)

/-- At the certified first phase, the previously only arithmetic opposite
candidate is proved unused, admissible, and signed-greedy in the supplied
physical boundary state. -/
theorem at_first_crossing {r : FirstCrossing.Row} (g : GeometryData r)
    (hr : r.Checked) (hg : g.Checked) (k : Nat) (C : Int)
    (pos neg : RayBoundary) (d : Int)
    (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat)) (hd : 0 ≤ d)
    (scale_shift : (7 ^ k : Nat) = r.scale + r.model.period * d)
    (other : otherBoundary r.positive pos neg = g.other)
    (greedy : Greedy (halfBoundary (if r.positive then pos else neg)
      (cycleCurrent r (r.winningCycle + 3 * d) r.selected))
      (cycleChoice r (r.winningCycle + 3 * d) r.selected)) :
    SignedGreedy (signedBoundary C pos neg r.positive
      (cycleCurrent r (r.winningCycle + 3 * d) r.selected))
      (embedRay (!r.positive) C (6 * (7 ^ k : Nat) + 1 -
        cycleCurrent r (r.winningCycle + 3 * d) r.selected)) := by
  have hq : 0 ≤ r.winningCycle + 3 * d := by have h := hr.2.2.2.1; omega
  obtain ⟨xb, yb, reflection⟩ := cycle_geometry g hr hg d
    (r.winningCycle + 3 * d) r.selected hq (Int.le_refl _)
  rw [← scale_shift] at xb yb
  have first := FirstCrossing.first_shift r.model r.scale r.winningCycle d r.selected (r.first hr)
  have hw := first.1
  rw [← scale_shift] at hw
  apply crossing_choice_sound k C _ _ pos neg r.positive scale large xb yb
    (by rw [other]; exact reflection)
    (by rw [other]; exact hg.1) (by rw [other]; exact hg.2.1) greedy
  exact (wins_coordinates r.model _ _ r.selected).mp hw

structure CertifiedGeometry where
  row : FirstCrossing.Row
  geometry : GeometryData row
  arithmetic : row.Checked
  bounds : geometry.Checked

end Heraclitus.Outgoing
