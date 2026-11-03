import Heraclitus.Signed

set_option autoImplicit false

/-!
# Signed/half-line refinement contracts

The representation uses physical sets, with zero represented exactly once.
The bridge below proves the ordering and distance correspondence; exclusion
of opposite-side competitors is an explicit remaining hypothesis. In
particular this file does not assume a certificate's finite candidate list
is exhaustive, nor assert the full scale transition.
-/

namespace Heraclitus

def ray (positive : Bool) (r : Int) : Int := if positive then r else -r

def embedRay (positive : Bool) (centre x : Int) : Int := ray positive (centre + x)

def OnRay (positive : Bool) (z : Int) : Prop := if positive then 0 < z else z < 0

theorem ray_power (positive : Bool) (centre x y : Int) :
    PowerStep (embedRay positive centre x) (embedRay positive centre y) ↔
      PowerStep x y := by
  cases positive
  · have eq : -(centre + y) - -(centre + x) = -(y - x) := by omega
    simp [embedRay, ray, PowerStep, eq, Int.natAbs_neg]
  · have eq : centre + y - (centre + x) = y - x := by omega
    simp [embedRay, ray, PowerStep, eq]

theorem ray_preferred (positive : Bool) {r t : Int}
    (hr : 0 ≤ r) (ht : 0 ≤ t) (order : r ≤ t) :
    Preferred (ray positive r) (ray positive t) := by
  have ar := Int.natAbs_of_nonneg hr
  have abs_t := Int.natAbs_of_nonneg ht
  by_cases eq : r = t
  · subst t
    exact preferred_refl _
  · left
    have ray_abs (s : Bool) (z : Int) : (ray s z).natAbs = z.natAbs := by
      cases s <;> simp [ray]
    rw [ray_abs, ray_abs]
    omega

theorem onRay_coordinates (positive : Bool) (centre z : Int)
    (onray : OnRay positive z) :
    ∃ x, 0 < centre + x ∧ z = embedRay positive centre x := by
  cases positive
  · refine ⟨-z - centre, ?_, ?_⟩
    · dsimp [OnRay] at onray; omega
    · dsimp [embedRay, ray]; omega
  · refine ⟨z - centre, ?_, ?_⟩
    · dsimp [OnRay] at onray; omega
    · dsimp [embedRay, ray]; omega

/-- Sound embedding of a half-line choice into the signed process.
All opposite-ray/zero competitors must be excluded explicitly. Same-ray
availability, all exponents, and the signed preference are proved here.
-/
theorem signedGreedy_of_halfline (positive : Bool) (centre : Int)
    (half physical : State) (v : Int)
    (current : physical.current = embedRay positive centre half.current)
    (represent : ∀ x, 0 < centre + x →
      (physical.used (embedRay positive centre x) ↔ half.used x))
    (positive_unused : ∀ x, ¬half.used x → 0 < centre + x)
    (greedy : Greedy half v)
    (opposite : ∀ z, ¬OnRay positive z → ¬physical.used z →
      PowerStep physical.current z → Preferred (embedRay positive centre v) z) :
    SignedGreedy physical (embedRay positive centre v) := by
  have vp := positive_unused v greedy.1
  refine ⟨?_, ?_, ?_⟩
  · exact fun hu => greedy.1 ((represent v vp).mp hu)
  · rw [current]
    exact (ray_power positive centre half.current v).mpr greedy.2.1
  · intro z unused step
    by_cases side : OnRay positive z
    · obtain ⟨x, xp, rfl⟩ := onRay_coordinates positive centre z side
      have xu : ¬half.used x := fun hu => unused ((represent x xp).mpr hu)
      have xs : PowerStep half.current x := by
        rw [current] at step
        exact (ray_power positive centre half.current x).mp step
      have le := greedy.2.2 x xu xs
      exact ray_preferred positive (by omega) (by omega) (by omega)
    · exact opposite z side unused step

/-- Absolute offset representation on one ray. Extras have set semantics. -/
structure RayBoundary where
  front : Int
  extra : List Int

def boundaryUsed (b : RayBoundary) (x : Int) : Prop := x < b.front ∨ x ∈ b.extra

def halfBoundary (b : RayBoundary) (current : Int) : State :=
  ⟨current, boundaryUsed b⟩

def signedBoundary (centre : Int) (pos neg : RayBoundary)
    (positive : Bool) (current : Int) : State :=
  ⟨embedRay positive centre current, fun z =>
    z = 0 ∨ (0 < z ∧ boundaryUsed pos (z - centre)) ∨
      (z < 0 ∧ boundaryUsed neg (-z - centre))⟩

theorem boundary_zero_used (centre : Int) (pos neg : RayBoundary)
    (positive : Bool) (current : Int) :
    (signedBoundary centre pos neg positive current).used 0 := by
  exact Or.inl rfl

/-- The full signed set, not a finite sample, agrees with the selected ray. -/
theorem boundary_ray_representation (centre : Int) (pos neg : RayBoundary)
    (positive : Bool) (current x : Int) (xp : 0 < centre + x) :
    (signedBoundary centre pos neg positive current).used (embedRay positive centre x) ↔
      boundaryUsed (if positive then pos else neg) x := by
  cases positive
  · have eq : - -(centre + x) - centre = x := by omega
    have hn : -(centre + x) < 0 := by omega
    have hn0 : -(centre + x) ≠ 0 := by omega
    have hnp : ¬0 < -(centre + x) := by omega
    change (-(centre + x) = 0 ∨
      (0 < -(centre + x) ∧ boundaryUsed pos (-(centre + x) - centre)) ∨
      (-(centre + x) < 0 ∧ boundaryUsed neg (- -(centre + x) - centre))) ↔ boundaryUsed neg x
    rw [eq]
    simp only [hn0, hnp, hn, false_or, false_and, true_and]
  · have eq : centre + x - centre = x := by omega
    have hp0 : centre + x ≠ 0 := by omega
    have hpn : ¬centre + x < 0 := by omega
    simp [signedBoundary, embedRay, ray, xp, hp0, hpn, eq]

/-- Formal interface for the paper's outgoing/return half-line segments.
The scale-specific exclusion of other-ray candidates is NOT hidden in the
encoding; it is the final hypothesis to discharge for each segment family.
-/
theorem boundary_halfline_bridge (centre : Int) (pos neg : RayBoundary)
    (positive : Bool) (current v : Int)
    (front_positive : 0 < centre + (if positive then pos else neg).front)
    (greedy : Greedy (halfBoundary (if positive then pos else neg) current) v)
    (opposite : ∀ z, ¬OnRay positive z →
      ¬(signedBoundary centre pos neg positive current).used z →
      PowerStep (embedRay positive centre current) z →
      Preferred (embedRay positive centre v) z) :
    SignedGreedy (signedBoundary centre pos neg positive current)
      (embedRay positive centre v) := by
  apply signedGreedy_of_halfline positive centre
    (halfBoundary (if positive then pos else neg) current) _ v rfl
  · exact boundary_ray_representation centre pos neg positive current
  · intro x unused
    have bound : ¬x < (if positive then pos else neg).front :=
      fun h => unused (Or.inl h)
    omega
  · exact greedy
  · exact opposite

/-- Exact block simulation, carrying both legality and the entire endpoint. -/
structure SignedBlock (s t : State) where
  word : List Int
  valid : SignedValidWord s word
  endpoint : execute s word = t

def SignedBlock.then {s t u : State} (first : SignedBlock s t)
    (second : SignedBlock t u) : SignedBlock s u where
  word := first.word ++ second.word
  valid := (signedValidWord_append _ _ _).mpr
    ⟨first.valid, by simpa [first.endpoint] using second.valid⟩
  endpoint := by rw [execute_append, first.endpoint, second.endpoint]

theorem signedBlock_length {s t u : State} (first : SignedBlock s t)
    (second : SignedBlock t u) :
    (first.then second).word.length = first.word.length + second.word.length := by
  exact List.length_append

/-- Every base-seven power lies below, at, or above a chosen scale;
the neighbouring scales differ by a factor of seven. -/
theorem power_scale_trichotomy (j k : Nat) :
    7 * (7 ^ j) ≤ 7 ^ k ∨ j = k ∨ 7 * (7 ^ k) ≤ 7 ^ j := by
  by_cases small : j < k
  · left
    have le := Nat.pow_le_pow_right (n := 7) (by decide) (show j + 1 ≤ k by omega)
    simpa [Nat.pow_succ, Nat.mul_comm] using le
  · by_cases eq : j = k
    · exact Or.inr (Or.inl eq)
    · right; right
      have le := Nat.pow_le_pow_right (n := 7) (by decide) (show k + 1 ≤ j by omega)
      simpa [Nat.pow_succ, Nat.mul_comm] using le

def BoundaryPreferred (a : Bool) (x : Int) (b : Bool) (y : Int) : Prop :=
  x < y ∨ (x = y ∧ (if b then (1 : Int) else -1) ≤ (if a then 1 else -1))

theorem boundary_order_exact (C x y : Int) (a b : Bool)
    (xp : 0 < C + x) (yp : 0 < C + y) :
    BoundaryPreferred a x b y ↔ Preferred (embedRay a C x) (embedRay b C y) := by
  have ax := Int.natAbs_of_nonneg (show 0 ≤ C + x by omega)
  have ay := Int.natAbs_of_nonneg (show 0 ≤ C + y by omega)
  cases a <;> cases b <;>
    simp only [BoundaryPreferred, Preferred, embedRay, ray, Bool.false_eq_true,
      ite_false, ite_true, Int.natAbs_neg]
  all_goals omega

theorem opposite_ray_distance (side : Bool) (C x y : Int)
    (xp : 0 < C + x) (yp : 0 < C + y) :
    ((embedRay (!side) C y - embedRay side C x).natAbs : Int) = 2 * C + x + y := by
  cases side
  · have h : 0 ≤ (C + y) - -(C + x) := by omega
    have eq := Int.natAbs_of_nonneg h
    simpa only [embedRay, ray, Bool.not_false, Bool.false_eq_true, ite_false, ite_true] using
      (show (((C + y) - -(C + x)).natAbs : Int) = 2 * C + x + y by omega)
  · have h : -(C + y) - (C + x) ≤ 0 := by omega
    have eq := Int.ofNat_natAbs_of_nonpos h
    simpa only [embedRay, ray, Bool.not_true, Bool.false_eq_true, ite_false, ite_true] using
      (show ((-(C + y) - (C + x)).natAbs : Int) = 2 * C + x + y by omega)

theorem opposite_onRay (side : Bool) (z : Int) (nonzero : z ≠ 0)
    (other : ¬OnRay side z) : OnRay (!side) z := by
  cases side <;> simp only [OnRay, Bool.false_eq_true, ite_false, ite_true,
    Bool.not_false, Bool.not_true] at * <;> omega

theorem embedRay_magnitude (side : Bool) (C x : Int) (positive : 0 ≤ C + x) :
    ((embedRay side C x).natAbs : Int) = C + x := by
  cases side <;> simp only [embedRay, ray, Bool.false_eq_true, ite_false,
    ite_true, Int.natAbs_neg] <;> exact Int.natAbs_of_nonneg positive

/-- Paper Section 5: the same-ray power candidates and the single reflected
candidate suffice throughout a bounded boundary word, at EVERY scale.

There is no omitted-power hypothesis: powers below M cannot cross zero,
the M jump is exactly the reflection, and all powers >=7M lose by magnitude.
The supplied local minima and chosen-move admissibility remain finite
certificate obligations; this theorem does not claim to ingest those rows.
-/
theorem boundary_rule_sound (k : Nat) (C x y : Int) (pos neg : RayBoundary)
    (side destinationSide : Bool)
    (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat))
    (current_bound : -512 ≤ x ∧ x ≤ 512)
    (destination_bound : -512 ≤ y ∧ y ≤ 512)
    (unused : ¬(signedBoundary C pos neg side x).used (embedRay destinationSide C y))
    (admissible : PowerStep (embedRay side C x) (embedRay destinationSide C y))
    (same_min : ∀ w, 0 < C + w →
      ¬boundaryUsed (if side then pos else neg) w → PowerStep x w →
      BoundaryPreferred destinationSide y side w)
    (reflection_min : ¬(signedBoundary C pos neg side x).used
      (embedRay (!side) C (1 - x)) →
      BoundaryPreferred destinationSide y (!side) (1 - x)) :
    SignedGreedy (signedBoundary C pos neg side x) (embedRay destinationSide C y) := by
  have Cbound : 49999 ≤ C := by omega
  have xp : 0 < C + x := by omega
  have yp : 0 < C + y := by omega
  refine ⟨unused, admissible, ?_⟩
  intro z zu step
  by_cases same : OnRay side z
  · obtain ⟨w, wp, rfl⟩ := onRay_coordinates side C z same
    have wu : ¬boundaryUsed (if side then pos else neg) w := by
      intro hw
      exact zu ((boundary_ray_representation C pos neg side x w wp).mpr hw)
    have ws : PowerStep x w := (ray_power side C x w).mp step
    exact (boundary_order_exact C y w destinationSide side yp wp).mp (same_min w wp wu ws)
  · have nz : z ≠ 0 := fun eq => zu (eq ▸ boundary_zero_used C pos neg side x)
    obtain ⟨w, wp, rfl⟩ := onRay_coordinates (!side) C z (opposite_onRay side z nz same)
    obtain ⟨j, distance⟩ := step
    have distance_int := opposite_ray_distance side C x w xp wp
    change ((embedRay (!side) C w - embedRay side C x).natAbs : Int) = _ at distance_int
    change (embedRay (!side) C w - embedRay side C x).natAbs = 7 ^ j at distance
    rw [distance] at distance_int
    rcases power_scale_trichotomy j k with below | equal | above
    · omega
    · subst j
      have reflected : w = 1 - x := by omega
      subst w
      exact (boundary_order_exact C y (1 - x) destinationSide (!side) yp wp).mp
        (reflection_min zu)
    · have winner_radius := embedRay_magnitude destinationSide C y (by omega)
      have other_radius := embedRay_magnitude (!side) C w (by omega)
      left
      omega

/-- Outgoing/return envelope: only the opposite candidates at powers M and
7M can compete. The two explicit critical-power obligations include actual
availability and the positive tie preference. All other powers are excluded
universally. Their discharge along each reachable segment remains separate.
-/
theorem two_scale_rule_sound (k : Nat) (C x y : Int) (pos neg : RayBoundary)
    (side destinationSide : Bool)
    (scale : 2 * C + 1 = (7 ^ k : Nat))
    (large : 100000 ≤ (7 ^ k : Nat))
    (current_bound : -4096 ≤ x ∧ x ≤ 3 * (7 ^ k : Nat) + 4096)
    (destination_bound : -4096 ≤ y ∧ y ≤ 3 * (7 ^ k : Nat) + 4096)
    (unused : ¬(signedBoundary C pos neg side x).used (embedRay destinationSide C y))
    (admissible : PowerStep (embedRay side C x) (embedRay destinationSide C y))
    (same_min : ∀ w, 0 < C + w →
      ¬boundaryUsed (if side then pos else neg) w → PowerStep x w →
      BoundaryPreferred destinationSide y side w)
    (critical : ∀ j : Nat, (j = k ∨ j = k + 1) → ∀ z : Int,
      ¬(signedBoundary C pos neg side x).used z →
      (z - embedRay side C x).natAbs = 7 ^ j →
      Preferred (embedRay destinationSide C y) z) :
    SignedGreedy (signedBoundary C pos neg side x) (embedRay destinationSide C y) := by
  have Cbound : 49999 ≤ C := by omega
  have xp : 0 < C + x := by omega
  have yp : 0 < C + y := by omega
  refine ⟨unused, admissible, ?_⟩
  intro z zu step
  by_cases same : OnRay side z
  · obtain ⟨w, wp, rfl⟩ := onRay_coordinates side C z same
    have wu : ¬boundaryUsed (if side then pos else neg) w := by
      intro hw
      exact zu ((boundary_ray_representation C pos neg side x w wp).mpr hw)
    have ws : PowerStep x w := (ray_power side C x w).mp step
    exact (boundary_order_exact C y w destinationSide side yp wp).mp (same_min w wp wu ws)
  · have nz : z ≠ 0 := fun eq => zu (eq ▸ boundary_zero_used C pos neg side x)
    obtain ⟨w, wp, rfl⟩ := onRay_coordinates (!side) C z (opposite_onRay side z nz same)
    obtain ⟨j, distance⟩ := step
    change (embedRay (!side) C w - embedRay side C x).natAbs = 7 ^ j at distance
    by_cases selected : j = k ∨ j = k + 1
    · exact critical j selected _ zu distance
    · have distance_int := opposite_ray_distance side C x w xp wp
      rw [distance] at distance_int
      by_cases below : j < k
      · have le := Nat.pow_le_pow_right (n := 7) (by decide) (show j + 1 ≤ k by omega)
        have small : 7 * (7 ^ j) ≤ 7 ^ k := by
          simpa [Nat.pow_succ, Nat.mul_comm] using le
        omega
      · have le := Nat.pow_le_pow_right (n := 7) (by decide) (show k + 2 ≤ j by omega)
        have big : 49 * (7 ^ k) ≤ 7 ^ j := by
          have eq : 7 ^ (k + 2) = 49 * (7 ^ k) := by
            simp only [Nat.pow_succ]
            omega
          rw [eq] at le
          exact le
        have winner_radius := embedRay_magnitude destinationSide C y (by omega)
        have other_radius := embedRay_magnitude (!side) C w (by omega)
        left
        omega

end Heraclitus
