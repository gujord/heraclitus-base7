import research.physical_counting.PhysicalCounting
import Heraclitus.OriginalProblem
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000

/-! Uniform exterior bound for every actual prefix before any checkpoint.
The finite bound is checked against the existing 36 proved transition
objects, rather than an unconnected copy of the certificate table. -/
namespace Heraclitus.CheckpointExterior
open SignedCertificate PhysicalCounting GlobalWalk

def offsets (b : RayBoundary) : List Int :=
  ((List.range (b.front-1).toNat).map (fun i : Nat => (i : Int)+1)) ++
    b.extra.filter (fun x => decide (0 < x))

theorem offsets_cover (b : RayBoundary) (x : Int)
    (pos : 0 < x) (used : boundaryUsed b x) : x ∈ offsets b := by
  simp only [offsets, List.mem_append]
  rcases used with low | extra
  · left
    apply List.mem_map.mpr
    refine ⟨(x-1).toNat, ?_, ?_⟩
    · apply List.mem_range.mpr; omega
    · omega
  · right
    simp only [List.mem_filter, decide_eq_true_eq]
    exact ⟨extra, pos⟩

def exteriorCover (s : Record) (D : Nat) : List Int :=
  ((offsets s.pos).map (fun x => (D : Int)+x)) ++
    ((offsets s.neg).map (fun x => -((D : Int)+x)))

theorem exteriorCover_length (s : Record) (D : Nat) :
    (exteriorCover s D).length = (offsets s.pos).length+(offsets s.neg).length := by
  simp [exteriorCover]

theorem exteriorCover_covers (s : Record) (D : Nat) (x : Int)
    (used : (s.toState (D : Int)).used x) (far : D < x.natAbs) :
    x ∈ exteriorCover s D := by
  change x=0 ∨ (0<x ∧ boundaryUsed s.pos (x-(D : Int))) ∨
    (x<0 ∧ boundaryUsed s.neg (-x-(D : Int))) at used
  simp only [exteriorCover, List.mem_append, List.mem_map]
  rcases used with zero | ⟨pos, use⟩ | ⟨neg, use⟩
  · simp_all
  · left
    have absx := Int.natAbs_of_nonneg (show 0 ≤ x by omega)
    exact ⟨x-(D : Int), offsets_cover s.pos _ (by omega) use, by omega⟩
  · right
    have absx := Int.natAbs_of_nonneg (show 0 ≤ -x by omega)
    rw [Int.natAbs_neg] at absx
    exact ⟨-x-(D : Int), offsets_cover s.neg _ (by omega) use, by omega⟩

/-- Kernel reduction over exactly the same records used by the complete
coverage schedule. No Python assertion is an assumption of this theorem. -/
theorem all_phase_bounds : ∀ i : Fin 36,
    let s := (ScaleScheduleData.entry i).checked.link.phase.entrance.outgoing.inner.initial
    (offsets s.pos).length+(offsets s.neg).length ≤ 7 := by decide

theorem schedule_bound (n : Nat) (D : Nat) :
    (exteriorCover (ScaleScheduleData.schedule.input n) D).length ≤ 7 := by
  rw [exteriorCover_length]
  exact all_phase_bounds (ScaleSchedule.index n)

theorem actual_checkpoint_cover (a : Nat → Int) (walk : IsWalk a)
    (k : Nat) (large : 6 ≤ k) :
    ∃ cover : List Int, cover.length ≤ 7 ∧ ∀ x,
      (stateAt a (7^k)).used x → (ScaleInduction.radius k).toNat < x.natAbs →
      x ∈ cover := by
  let q := k-6
  have exponent : q+6=k := by dsimp [q]; omega
  have reach := Coverage.plan.reaches a walk q
  change stateAt a (7^(q+6)) = ScaleScheduleData.schedule.boundary q at reach
  rw [exponent] at reach
  let D := (ScaleInduction.radius k).toNat
  refine ⟨exteriorCover (ScaleScheduleData.schedule.input q) D, schedule_bound q D, ?_⟩
  intro x used far
  apply exteriorCover_covers
  · rw [reach] at used
    change ((ScaleScheduleData.schedule.input q).toState
      (ScaleInduction.radius (q+6))).used x at used
    rw [exponent] at used
    have nonneg : 0 ≤ ScaleInduction.radius k := by
      have radius := ScaleSchedule.radius_exact k
      have pow_nonneg : (0 : Int) ≤ ((7^k : Nat) : Int) := Int.natCast_nonneg _
      omega
    simpa only [D, Int.toNat_of_nonneg nonneg] using used
  · exact far

/-- Every original-rule prefix up to 7^k has at most seven visited points
outside the checkpoint interval, uniformly for all k>=6. -/
theorem original_rule_outside_le_seven (a : Nat → Int)
    (rule : OriginalProblem.FollowsRule a) (k n : Nat) (large : 6 ≤ k)
    (before : n ≤ 7^k) :
    outsideCount a n (ScaleInduction.radius k).toNat ≤ 7 := by
  have walk := OriginalProblem.as_walk a rule
  obtain ⟨cover, length, covers⟩ := actual_checkpoint_cover a walk k large
  have bound := outside_le_later_cover a walk n (7^k) _ before cover covers
  omega

/-- The physical counting inequality with its exterior budget discharged
for the literal original rule, at every prefix before every checkpoint. -/
theorem original_rule_count (a : Nat → Int) (rule : OriginalProblem.FollowsRule a)
    (k n : Nat) (large : 6 ≤ k) (before : n ≤ 7^k) :
    n ≤ (ScaleInduction.radius k).toNat + (a n).natAbs +
      PhysicalTail.count a n (ScaleInduction.radius k).toNat + 7 := by
  have bound := walk_count a (OriginalProblem.as_walk a rule) n (ScaleInduction.radius k).toNat
  have exterior := original_rule_outside_le_seven a rule k n large before
  omega

end Heraclitus.CheckpointExterior
#print axioms Heraclitus.CheckpointExterior.all_phase_bounds
#print axioms Heraclitus.CheckpointExterior.original_rule_outside_le_seven
#print axioms Heraclitus.CheckpointExterior.original_rule_count
