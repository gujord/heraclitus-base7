import ShortTail
import research.physical_tail.PhysicalTail

set_option autoImplicit false

/-! The physical same-ray tail through every prefix of the actual two-move
signed word used in the short phase. Does not prove reachability from zero. -/
namespace Heraclitus.SignedTail43
open Heraclitus.ReturnBridge
open Heraclitus.ShortTail43

/-- Every prefix of the signed word is the physical lift of the corresponding
half-line prefix. -/
theorem lift_short_prefix (side : Bool) (C m : Int) (other : RayBoundary)
    (Cnonneg : 0 ≤ C) (i : Nat) (hi : i ≤ 2) :
    execute (OutgoingWord.liftRay side C other (checkpoint ⟨1, []⟩ m 2).toState)
      (([2,1].map (embedRay side C)).take i) =
    OutgoingWord.liftRay side C other
      (execute (checkpoint ⟨1, []⟩ m 2).toState ([2,1].take i)) := by
  have cases : i = 0 ∨ i = 1 ∨ i = 2 := by omega
  rcases cases with rfl | rfl | rfl
  · rfl
  · simp only [List.map_cons, List.map_nil, List.take_succ_cons, List.take_zero,
      execute]
    exact (OutgoingWord.lift_visit side C other _ 2 (by omega)).symm
  · simp only [List.map_cons, List.map_nil, List.take_succ_cons, List.take_zero,
      execute]
    rw [← OutgoingWord.lift_visit side C other _ 2 (by omega),
        ← OutgoingWord.lift_visit side C other _ 1 (by omega)]

/-- A duplicate-free list of positive physical magnitudes on the active ray,
used and strictly ahead of the current radius, has at most four elements. -/
theorem signed_prefix_tail_count (side : Bool) (C m : Int) (other : RayBoundary)
    (Cnonneg : 0 ≤ C) (large : 1 ≤ m) (i : Nat) (hi : i ≤ 2)
    (xs : List Int) (nodup : xs.Nodup)
    (ahead : ∀ z ∈ xs,
      let half := execute (checkpoint ⟨1, []⟩ m 2).toState ([2,1].take i)
      let physical := execute (OutgoingWord.liftRay side C other (checkpoint ⟨1, []⟩ m 2).toState)
        (([2,1].map (embedRay side C)).take i)
      0 < z ∧ C+half.current < z ∧ physical.used (embedRay side C (z-C))) :
    xs.length ≤ 4 := by
  have sub : xs ⊆ [C+m+2, C+2*m+2, C+3*m+2, C+2] := by
    intro z hz
    have h := ahead z hz
    dsimp only at h
    rw [lift_short_prefix side C m other Cnonneg i hi] at h
    have used := (lifted_ray_used side C other _ (z-C) (by omega)).mp h.2.2
    have cover := prefix_ahead_cover m large i hi (z-C) (by omega) used
    simp only [List.mem_cons, List.not_mem_nil, or_false]
    rcases cover with a | a | a | a <;> omega
  have bound := nodup.length_le_of_subset sub
  simpa only [List.length_cons, List.length_nil] using bound

/-- The complete signed prefix's current radius equals the local radius. -/
theorem signed_prefix_radius (side : Bool) (C m : Int) (other : RayBoundary)
    (Cnonneg : 0 ≤ C) (large : 1 ≤ m) (i : Nat) (hi : i ≤ 2) :
    let half := execute (checkpoint ⟨1, []⟩ m 2).toState ([2,1].take i)
    let physical := execute (OutgoingWord.liftRay side C other (checkpoint ⟨1, []⟩ m 2).toState)
      (([2,1].map (embedRay side C)).take i)
    (physical.current.natAbs : Int) = C + half.current := by
  dsimp only
  rw [lift_short_prefix side C m other Cnonneg i hi]
  have positive : 0 ≤ C + (execute (checkpoint ⟨1, []⟩ m 2).toState ([2,1].take i)).current := by
    have cases : i=0 ∨ i=1 ∨ i=2 := by omega
    rcases cases with rfl | rfl | rfl <;>
      simp [execute, visit, checkpoint, FiniteState.toState] <;> omega
  change ((embedRay side C (execute (checkpoint ⟨1, []⟩ m 2).toState ([2,1].take i)).current).natAbs : Int) = _
  cases side <;> simp [embedRay, ray, Int.natAbs_of_nonneg positive]

/-- Physical version: the ahead condition uses the current physical radius
and the actual signed used set; no half-line data are exposed in its input. -/
theorem physical_prefix_tail_count (side : Bool) (C m : Int) (other : RayBoundary)
    (Cnonneg : 0 ≤ C) (large : 1 ≤ m) (i : Nat) (hi : i ≤ 2)
    (xs : List Int) (nodup : xs.Nodup)
    (ahead : ∀ z ∈ xs,
      let physical := execute (OutgoingWord.liftRay side C other (checkpoint ⟨1, []⟩ m 2).toState)
        (([2,1].map (embedRay side C)).take i)
      0 < z ∧ (physical.current.natAbs : Int) < z ∧ physical.used (ray side z)) :
    xs.length ≤ 4 := by
  apply signed_prefix_tail_count side C m other Cnonneg large i hi xs nodup
  intro z hz
  have h := ahead z hz
  dsimp only at h ⊢
  rw [signed_prefix_radius side C m other Cnonneg large i hi] at h
  have e : embedRay side C (z-C) = ray side z := by simp only [embedRay]; congr 1; omega
  rw [e]
  exact h

/-- Exact physical same-ray cover, with current radius from the signed state. -/
theorem physical_prefix_tail_cover (side : Bool) (C m : Int) (other : RayBoundary)
    (Cnonneg : 0 ≤ C) (large : 1 ≤ m) (i : Nat) (hi : i ≤ 2)
    (z : Int) (positive : 0 < z)
    (ahead : ((execute (OutgoingWord.liftRay side C other
      (checkpoint ⟨1, []⟩ m 2).toState)
      (([2,1].map (embedRay side C)).take i)).current.natAbs : Int) < z)
    (used : (execute (OutgoingWord.liftRay side C other
      (checkpoint ⟨1, []⟩ m 2).toState)
      (([2,1].map (embedRay side C)).take i)).used (ray side z)) :
    z ∈ [C+m+2, C+2*m+2, C+3*m+2, C+2] := by
  have rad := signed_prefix_radius side C m other Cnonneg large i hi
  dsimp only at rad
  rw [rad] at ahead
  rw [lift_short_prefix side C m other Cnonneg i hi] at used
  have e : embedRay side C (z-C) = ray side z := by simp only [embedRay]; congr 1; omega
  rw [← e] at used
  have hl := (lifted_ray_used side C other _ (z-C) (by omega)).mp used
  have cover := prefix_ahead_cover m large i hi (z-C) (by omega) hl
  simp only [List.mem_cons, List.not_mem_nil, or_false]
  rcases cover with a | a | a | a <;> omega

/-- The signed two-move word is valid under the existing phase-43 radius and
opposite-ray hypotheses. -/
theorem signed_short_valid (side : Bool) (C : Int) (other : RayBoundary)
    (k : Nat) (scale : 2*C+1=(7^k : Nat))
    (large : 100000 ≤ (7^k : Nat))
    (filled : 3*(7^k : Nat)-200 ≤ other.front) :
    SignedValidWord (OutgoingWord.liftRay side C other
      (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState)
      ([2,1].map (embedRay side C)) := by
  have big : (100000 : Int) ≤ (7^k : Nat) := Int.ofNat_le.mpr large
  have valid := (SignedBottom.short_half k large).1
  have env := SignedBottom.envelope_of_bounds (7^k : Nat)
    (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState [2,1]
    (by change (-100 : Int) ≤ ((7^k : Nat) : Int)+2 ∧
      ((7^k : Nat) : Int)+2 ≤ 2*((7^k : Nat) : Int)+4096; omega)
    (by intro x hx; simp only [List.mem_cons, List.not_mem_nil, or_false] at hx; omega)
  exact (ReturnBridge.return_word _ other side k C [2,1] scale large filled valid env).1

/-- At each prefix the current point lies on the selected physical ray. -/
theorem physical_prefix_onRay (side : Bool) (C m : Int) (other : RayBoundary)
    (Cnonneg : 0 ≤ C) (large : 1 ≤ m) (i : Nat) (hi : i ≤ 2) :
    OnRay side (execute (OutgoingWord.liftRay side C other
      (checkpoint ⟨1, []⟩ m 2).toState)
      (([2,1].map (embedRay side C)).take i)).current := by
  rw [lift_short_prefix side C m other Cnonneg i hi]
  have positive : 0 < C + (execute (checkpoint ⟨1, []⟩ m 2).toState ([2,1].take i)).current := by
    have cases : i=0 ∨ i=1 ∨ i=2 := by omega
    rcases cases with rfl | rfl | rfl <;>
      simp [execute, visit, checkpoint, FiniteState.toState] <;> omega
  change OnRay side (embedRay side C _)
  cases side <;> simp [OnRay, embedRay, ray, positive]

/-- A real original-rule walk which reaches the exact phase-43 short-word
input has at most four actual visited points in its same-side tail at each
prefix. Start-state matching is an explicit hypothesis, not reachability. -/
theorem actual_walk_tail_count (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base k : Nat) (side : Bool) (C : Int) (other : RayBoundary)
    (scale : 2*C+1=(7^k : Nat)) (large : 100000 ≤ (7^k : Nat))
    (filled : 3*(7^k : Nat)-200 ≤ other.front)
    (start : GlobalWalk.stateAt a base = OutgoingWord.liftRay side C other
      (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState)
    (i : Nat) (hi : i ≤ 2) (D : Nat) :
    PhysicalTail.count a (base+i) D ≤ 4 := by
  have Cnonneg : 0 ≤ C := by omega
  have mlarge : (1 : Int) ≤ (7^k : Nat) := by omega
  let w := [2,1].map (embedRay side C)
  have wlen : w.length = 2 := by simp [w]
  have valid : SignedValidWord (GlobalWalk.stateAt a base) w := by
    rw [start]
    exact signed_short_valid side C other k scale large filled
  have prefixValid : SignedValidWord (GlobalWalk.stateAt a base) (w.take i) := by
    have v : SignedValidWord (GlobalWalk.stateAt a base) (w.take i ++ w.drop i) := by
      simpa only [List.take_append_drop] using valid
    exact ((signedValidWord_append _ _ _).mp v).1
  have len : (w.take i).length = i := by simp [List.length_take, wlen, Nat.min_eq_left hi]
  have endpoint := GlobalWalk.valid_word_endpoint a walk base (w.take i) prefixValid
  rw [len, start] at endpoint
  let s := execute (OutgoingWord.liftRay side C other
    (checkpoint ⟨1, []⟩ (7^k : Nat) 2).toState) (w.take i)
  have physical : s = GlobalWalk.stateAt a (base+i) := endpoint
  have current : s.current = a (base+i) := by rw [physical]; rfl
  have onray : OnRay side (a (base+i)) := by
    have p := physical_prefix_onRay side C (7^k : Nat) other Cnonneg mlarge i hi
    change OnRay side s.current at p
    rw [current] at p
    exact p
  let cover := [C+(7^k : Nat)+2, C+2*(7^k : Nat)+2,
    C+3*(7^k : Nat)+2, C+2].map (ray side)
  have subset : ∀ x, x ∈ PhysicalTail.points a (base+i) D → x ∈ cover := by
    intro x hx
    have h := (PhysicalTail.points_mem a (base+i) D x).mp hx
    have used : s.used x := by rw [physical]; exact h.1
    have xa : x = ray side (x.natAbs : Int) := by
      have same := h.2.1
      cases side with
      | false =>
        change a (base+i) < 0 at onray
        have neg : x < 0 := by unfold PhysicalTail.SameSide at same; omega
        have hneg := Int.natAbs_of_nonneg (show 0 ≤ -x by omega)
        rw [Int.natAbs_neg] at hneg
        simp only [ray, Bool.false_eq_true, ite_false]
        omega
      | true =>
        change 0 < a (base+i) at onray
        have pos : 0 < x := by unfold PhysicalTail.SameSide at same; omega
        simp [ray, Int.natAbs_of_nonneg (by omega : 0 ≤ x)]
    have pos : (0 : Int) < x.natAbs := by
      have same := h.2.1
      unfold PhysicalTail.SameSide at same
      have ne : x ≠ 0 := by omega
      have p := Int.natAbs_pos.mpr ne
      omega
    have ahead : (s.current.natAbs : Int) < (x.natAbs : Int) := by
      rw [current]
      exact Int.ofNat_lt.mpr h.2.2.1
    have usedray : s.used (ray side (x.natAbs : Int)) := by simpa [← xa] using used
    have covered := physical_prefix_tail_cover side C (7^k : Nat) other Cnonneg mlarge i hi
      (x.natAbs : Int) pos ahead usedray
    apply List.mem_map.mpr
    exact ⟨(x.natAbs : Int), covered, xa.symm⟩
  have result := PhysicalTail.count_le_cover a walk (base+i) D cover subset
  simpa [cover] using result

end Heraclitus.SignedTail43
#print axioms Heraclitus.SignedTail43.lift_short_prefix
#print axioms Heraclitus.SignedTail43.signed_prefix_tail_count

#print axioms Heraclitus.SignedTail43.signed_prefix_radius
#print axioms Heraclitus.SignedTail43.physical_prefix_tail_count

#print axioms Heraclitus.SignedTail43.physical_prefix_tail_cover
#print axioms Heraclitus.SignedTail43.signed_short_valid

#print axioms Heraclitus.SignedTail43.physical_prefix_onRay
#print axioms Heraclitus.SignedTail43.actual_walk_tail_count
