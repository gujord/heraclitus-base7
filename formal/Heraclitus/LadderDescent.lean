import Heraclitus.LadderLayers

set_option autoImplicit false

/-! Forced half-line descent and its exact endpoint markers. This proves
neither finite bottom words nor the signed return interface. -/

namespace Heraclitus.LadderDescent

open LadderLayers

def height (j : Nat) : Int := ((7 ^ j : Nat) : Int)

theorem height_succ (j : Nat) : height (j + 1) = 7 * height j := by
  simp only [height, Nat.pow_succ, Int.natCast_mul]
  rw [Int.mul_comm]
  rfl

theorem height_large (j : Nat) (bound : 4 ≤ j) : 2401 ≤ height j := by
  have h := Nat.pow_le_pow_right (n := 7) (by decide) bound
  have v : (7 : Nat) ^ 4 = 2401 := by decide
  rw [v] at h
  unfold height
  omega

/-- Exhaustive trichotomy over every allowed exponent, including zero. -/
theorem power_gap (j k : Nat) :
    height k ≤ height j ∨ height k = 7 * height j ∨ 49 * height j ≤ height k := by
  by_cases small : k ≤ j
  · left
    have h := Nat.pow_le_pow_right (n := 7) (by decide) small
    unfold height
    omega
  · by_cases next : k = j + 1
    · right; left; rw [next, height_succ]
    · right; right
      have h := Nat.pow_le_pow_right (n := 7) (by decide) (show j + 2 ≤ k by omega)
      have cast : height (j + 2) ≤ height k := by unfold height; omega
      have eq : height (j + 2) = 49 * height j := by
        rw [show j + 2 = (j + 1) + 1 by omega, height_succ, height_succ]
        omega
      rw [eq] at cast
      exact cast

/-- Subtracting the next lower power beats every other unused candidate.
At the top of a layer, the one-step return to zero must already be used. -/
theorem forced_step (s : State) (j : Nat) (large : 2401 ≤ height j)
    (range : 2 * height j ≤ s.current ∧ s.current ≤ 7 * height j)
    (gap : s.current ≤ 6 * height j ∨ s.current = 7 * height j)
    (filled : ∀ x, x ≤ -200 → s.used x)
    (zero : s.used 0) (fresh : ¬s.used (s.current - height j)) :
    Greedy s (s.current - height j) := by
  refine ⟨fresh, ?_, ?_⟩
  · refine ⟨j, ?_⟩
    have eq : s.current - height j - s.current = -height j := by omega
    rw [eq]
    simp [height]
  · intro w unused step
    obtain ⟨k, distance⟩ := step
    rcases Int.natAbs_eq_iff.mp distance with positive | negative
    · have nonnegative : 0 ≤ height k := by unfold height; omega
      change w - s.current = height k at positive
      omega
    · change w - s.current = -height k at negative
      rcases power_gap j k with small | equal | bigger
      · omega
      · rw [equal] at negative
        rcases gap with below | top
        · exact False.elim (unused (filled w (by omega)))
        · have eq : w = 0 := by omega
          exact False.elim (unused (by simpa only [eq] using zero))
      · exact False.elim (unused (filled w (by omega)))

/-- A deliberately broad local contract, in coordinates relative to the anchor. -/
def Region (old : Int → Prop) : Prop :=
  old 0 ∧ (∀ x, x ≤ -200 → old x) ∧ (∀ x, old x → x < 200)

def start (old : Int → Prop) (h : Int) : State :=
  ⟨h, fun x => old x ∨ x = h⟩

def six (h : Int) : List Int := [6 * h, 5 * h, 4 * h, 3 * h, 2 * h, h]

theorem six_bounds (h : Int) (positive : 0 < h) :
    ∀ x ∈ six h, h ≤ x ∧ x ≤ 6 * h := by
  intro x hx
  simp only [six, List.mem_cons, List.not_mem_nil, or_false] at hx
  omega

/-- Adding only points at or above the current position cannot block the descent. -/
theorem step_with_upper_points (old : Int → Prop) (region : Region old)
    (s : State) (j : Nat) (large : 2401 ≤ height j)
    (range : 2 * height j ≤ s.current ∧ s.current ≤ 7 * height j)
    (gap : s.current ≤ 6 * height j ∨ s.current = 7 * height j)
    (contains : ∀ x, old x → s.used x)
    (upper : ∀ x, s.used x → old x ∨ s.current ≤ x) :
    Greedy s (s.current - height j) := by
  apply forced_step s j large range gap
  · intro x hx; exact contains x (region.2.1 x hx)
  · exact contains 0 region.1
  · intro hx
    rcases upper _ hx with ho | hi
    · have bound := region.2.2 _ ho; omega
    · omega

theorem six_valid (old : Int → Prop) (region : Region old) (j : Nat)
    (large : 2401 ≤ height j) :
    ValidWord (start old (7 * height j)) (six (height j)) := by
  let h := height j
  change ValidWord (start old (7 * h)) [6*h, 5*h, 4*h, 3*h, 2*h, h]
  have hlarge : 2401 ≤ h := large
  have one (s : State) (range : 2*h ≤ s.current ∧ s.current ≤ 7*h)
      (gap : s.current ≤ 6*h ∨ s.current = 7*h)
      (contains : ∀ x, old x → s.used x)
      (upper : ∀ x, s.used x → old x ∨ s.current ≤ x) :
      Greedy s (s.current - h) :=
    step_with_upper_points old region s j large range gap contains upper
  have a := one (start old (7*h)) (by simp only [start]; omega)
    (by right; rfl) (by intro x hx; exact Or.inl hx)
    (by intro x hx; by_cases ho : old x; exact Or.inl ho; right; simp only [start] at hx ⊢; simp only [ho, false_or] at hx; omega)
  have b := one (visit (start old (7*h)) (6*h)) (by simp only [visit]; omega)
    (by simp only [visit]; omega) (by intro x hx; exact Or.inl (Or.inl hx))
    (by intro x hx; by_cases ho : old x; exact Or.inl ho; right; simp only [start, visit] at hx ⊢; simp only [ho, false_or] at hx; omega)
  have c := one (visit (visit (start old (7*h)) (6*h)) (5*h))
    (by simp only [visit]; omega) (by simp only [visit]; omega)
    (by intro x hx; exact Or.inl (Or.inl (Or.inl hx)))
    (by intro x hx; by_cases ho : old x; exact Or.inl ho; right; simp only [start, visit] at hx ⊢; simp only [ho, false_or] at hx; omega)
  have d := one (visit (visit (visit (start old (7*h)) (6*h)) (5*h)) (4*h))
    (by simp only [visit]; omega) (by simp only [visit]; omega)
    (by intro x hx; exact Or.inl (Or.inl (Or.inl (Or.inl hx))))
    (by intro x hx; by_cases ho : old x; exact Or.inl ho; right; simp only [start, visit] at hx ⊢; simp only [ho, false_or] at hx; omega)
  have e := one (visit (visit (visit (visit (start old (7*h)) (6*h)) (5*h)) (4*h)) (3*h))
    (by simp only [visit]; omega) (by simp only [visit]; omega)
    (by intro x hx; exact Or.inl (Or.inl (Or.inl (Or.inl (Or.inl hx)))))
    (by intro x hx; by_cases ho : old x; exact Or.inl ho; right; simp only [start, visit] at hx ⊢; simp only [ho, false_or] at hx; omega)
  have f := one (visit (visit (visit (visit (visit (start old (7*h)) (6*h)) (5*h)) (4*h)) (3*h)) (2*h))
    (by simp only [visit]; omega) (by simp only [visit]; omega)
    (by intro x hx; exact Or.inl (Or.inl (Or.inl (Or.inl (Or.inl (Or.inl hx))))))
    (by intro x hx; by_cases ho : old x; exact Or.inl ho; right; simp only [start, visit] at hx ⊢; simp only [ho, false_or] at hx; omega)
  have ea : 7*h-h=6*h := by omega
  have eb : 6*h-h=5*h := by omega
  have ec : 5*h-h=4*h := by omega
  have ed : 4*h-h=3*h := by omega
  have ee : 3*h-h=2*h := by omega
  have ef : 2*h-h=h := by omega
  simpa only [ValidWord, start, visit, ea, eb, ec, ed, ee, ef] using
    (show Greedy (start old (7*h)) ((start old (7*h)).current-h) ∧
      Greedy (visit (start old (7*h)) (6*h)) (6*h-h) ∧
      Greedy (visit (visit (start old (7*h)) (6*h)) (5*h)) (5*h-h) ∧
      Greedy (visit (visit (visit (start old (7*h)) (6*h)) (5*h)) (4*h)) (4*h-h) ∧
      Greedy (visit (visit (visit (visit (start old (7*h)) (6*h)) (5*h)) (4*h)) (3*h)) (3*h-h) ∧
      Greedy (visit (visit (visit (visit (visit (start old (7*h)) (6*h)) (5*h)) (4*h)) (3*h)) (2*h)) (2*h-h) ∧ True
      from ⟨a,b,c,d,e,f,trivial⟩)

/-- High levels are traversed before the six moves of the lowest layer. -/
def word (j : Nat) : Nat → List Int
  | 0 => []
  | n + 1 => word (j + 1) n ++ six (height j)

def bottom (old : Int → Prop) (j n : Nat) : State :=
  mark (start old (height j)) (fun x => tower (height j) n (x - height j))

theorem word_length (j n : Nat) : (word j n).length = 6 * n := by
  induction n generalizing j with
  | zero => rfl
  | succ n ih => simp [word, ih, six, Nat.mul_succ]

theorem height_mono (j k : Nat) (bound : j ≤ k) : height j ≤ height k := by
  have h := Nat.pow_le_pow_right (n := 7) (by decide) bound
  unfold height
  omega

theorem word_bounds (j n : Nat) (large : 4 ≤ j) :
    ∀ x ∈ word j n, height j ≤ x ∧ x < height (j + n) := by
  induction n generalizing j with
  | zero => simp [word]
  | succ n ih =>
    intro x hx
    rcases List.mem_append.mp hx with high | low
    · have bounds := ih (j + 1) (by omega) x high
      have next := height_mono j (j + 1) (by omega)
      have eq : j + 1 + n = j + (n + 1) := by omega
      rw [eq] at bounds
      omega
    · have positive := height_large j large
      have bounds := six_bounds (height j) (by omega) x low
      have next := height_mono (j + 1) (j + (n + 1)) (by omega)
      rw [height_succ] at next
      omega

/-- Exact whole-state update: the old set and every higher marker survive. -/
theorem six_endpoint (old : Int → Prop) (h : Int) (n : Nat) :
    execute (mark (start old (7*h)) (fun x => tower (7*h) n (x-7*h))) (six h) =
      mark (start old h) (fun x => tower h (n+1) (x-h)) := by
  apply state_ext
  · rfl
  · intro x
    rw [execute_used_iff]
    simp only [start, mark, six, List.mem_cons, List.not_mem_nil, or_false,
      tower, pending_six]
    have eq : x-h-6*h=x-7*h := by omega
    rw [eq]
    have a : x-h=h ↔ x=2*h := by omega
    have b : x-h=2*h ↔ x=3*h := by omega
    have c : x-h=3*h ↔ x=4*h := by omega
    have d : x-h=4*h ↔ x=5*h := by omega
    have e : x-h=5*h ↔ x=6*h := by omega
    have f : x-h=6*h ↔ x=7*h := by omega
    rw [a,b,c,d,e,f]
    simp only [or_assoc, or_left_comm, or_comm]

/-- For all heights, descent creates exactly the tower used by the layer theorem. -/
theorem descend (old : Int → Prop) (region : Region old) (j n : Nat)
    (large : 4 ≤ j) :
    ValidWord (start old (height (j+n))) (word j n) ∧
      execute (start old (height (j+n))) (word j n) = bottom old j n := by
  induction n generalizing j with
  | zero =>
    constructor
    · trivial
    · simp only [word, execute, Nat.add_zero, bottom, tower, mark_none]
  | succ n ih =>
    have high := ih (j+1) (by omega)
    have eq : j+1+n=j+(n+1) := by omega
    rw [eq] at high
    have hlarge := height_large j large
    have low := six_valid old region j hlarge
    have avoid : ∀ x ∈ six (height j), ¬tower (7*height j) n (x-7*height j) := by
      intro x hx marked
      have bound := six_bounds (height j) (by omega) x hx
      have far := tower_lower (7*height j) (by omega) n (x-7*height j) marked
      omega
    have marked := validWord_mark low avoid
    have join : bottom old (j+1) n =
        mark (start old (7*height j)) (fun x => tower (7*height j) n (x-7*height j)) := by
      simp only [bottom, height_succ]
    constructor
    · apply (validWord_append _ _ _).mpr
      refine ⟨high.1, ?_⟩
      rw [high.2, join]
      exact marked
    · rw [word, execute_append, high.2, join, six_endpoint]
      rfl

/-- Additional already-used outer endpoints are retained without adding moves. -/
theorem descend_with_later (old : Int → Prop) (region : Region old) (j n : Nat)
    (large : 4 ≤ j) (later : Int → Prop)
    (far : ∀ x, later x → height (j+n) ≤ x) :
    ValidWord (mark (start old (height (j+n))) later) (word j n) ∧
      execute (mark (start old (height (j+n))) later) (word j n) =
        mark (bottom old j n) later := by
  have result := descend old region j n large
  constructor
  · apply validWord_mark result.1
    intro x hx hm
    have bounds := word_bounds j n large x hx
    have outer := far x hm
    omega
  · rw [execute_mark, result.2]

/-- The only remaining half-line bridge here is an explicit finite bottom word.
Its validity, endpoint and bound remain hypotheses, not certificate axioms. -/
theorem complete_if_bottom (old : Int → Prop) (region : Region old)
    (c : Ladder) (checked : c.Claim) (b : List Int)
    (valid : ValidWord (start old 2401) b)
    (endpoint : execute (start old 2401) b = translate 2401 c.initial.toState)
    (bound : ∀ x ∈ b, x < 4401) (n : Nat) :
    ∃ w : List Int,
      ValidWord (start old (scale n)) w ∧
      execute (start old (scale n)) w = translate (scale n) (c.entry n).toState ∧
      (w.length : Int) = 6*(n : Int) + b.length + scale n - 2401 + c.cumulative 0 n := by
  have descent := descend old region 4 n (by decide)
  have base : height 4 = 2401 := by decide
  have start_eq : height (4+n) = scale n := rfl
  have descentEnd : execute (start old (scale n)) (word 4 n) =
      mark (start old 2401) (fun x => tower 2401 n (x-2401)) := by
    simpa only [bottom, base, start_eq] using descent.2
  have bottomValid := validWord_mark valid (markers := fun x => tower 2401 n (x-2401)) (by
    intro x hx marked
    have low := tower_lower 2401 (by decide) n (x-2401) marked
    have high := bound x hx
    omega)
  have bottomEnd : execute (mark (start old 2401) (fun x => tower 2401 n (x-2401))) b =
      translate 2401 (mark c.initial.toState (tower 2401 n)) := by
    rw [execute_mark, endpoint, translate_mark]
  obtain ⟨rest, restValid, restEnd, restCount⟩ := c.from_bottom checked 0 n
  simp only [Int.zero_add] at restValid restEnd
  refine ⟨word 4 n ++ b ++ rest, ?_, ?_, ?_⟩
  · apply (validWord_append _ _ _).mpr
    constructor
    · apply (validWord_append _ _ _).mpr
      refine ⟨descent.1, ?_⟩
      rw [descentEnd]
      exact bottomValid
    · rw [execute_append, descentEnd, bottomEnd]
      exact restValid
  · rw [execute_append, execute_append, descentEnd, bottomEnd, restEnd]
  · simp only [List.length_append, word_length, Int.natCast_add, Int.natCast_mul]
    omega

structure Entrance where
  anchor : Int
  points : List Int
deriving Repr

def Entrance.Claim (c : Entrance) : Prop :=
  -100 ≤ c.anchor ∧ c.anchor < 100 ∧ c.anchor ∈ c.points ∧
    ∀ x ∈ c.points, -100 ≤ x ∧ x < 100

instance (c : Entrance) : Decidable c.Claim :=
  inferInstanceAs (Decidable (-100 ≤ c.anchor ∧ c.anchor < 100 ∧ c.anchor ∈ c.points ∧
    ∀ x ∈ c.points, -100 ≤ x ∧ x < 100))

def Entrance.old (c : Entrance) (x : Int) : Prop :=
  x+c.anchor < -100 ∨ x+c.anchor ∈ c.points

theorem Entrance.region (c : Entrance) (checked : c.Claim) : Region c.old := by
  obtain ⟨lower, upper, used, bounded⟩ := checked
  refine ⟨?_, ?_, ?_⟩
  · right; simpa only [Int.zero_add] using used
  · intro x hx; left; omega
  · intro x hx
    rcases hx with below | point
    · omega
    · have b := bounded _ point; omega

/-- Absolute old-region coordinates; the top is already visited at entry. -/
def Entrance.initial (c : Entrance) (n : Nat) : State :=
  ⟨c.anchor+scale n, fun x => (x < -100 ∨ x ∈ c.points) ∨ x=c.anchor+scale n⟩

def Entrance.endpoint (c : Entrance) (n : Nat) : State :=
  ⟨c.anchor+2401, fun x => ((x < -100 ∨ x ∈ c.points) ∨ x=c.anchor+2401) ∨
    tower 2401 n (x-(c.anchor+2401))⟩

theorem Entrance.initial_eq (c : Entrance) (n : Nat) :
    c.initial n = translate c.anchor (start c.old (scale n)) := by
  apply state_ext
  · simp only [Entrance.initial, translate, start]; omega
  · intro x
    simp only [Entrance.initial, translate, start, Entrance.old, Int.sub_add_cancel]
    have eq : x=c.anchor+scale n ↔ x-c.anchor=scale n := by omega
    rw [eq]

theorem Entrance.endpoint_eq (c : Entrance) (n : Nat) :
    c.endpoint n = translate c.anchor (bottom c.old 4 n) := by
  apply state_ext
  · change c.anchor+2401=height 4+c.anchor
    have base : height 4 = 2401 := by decide
    rw [base]; omega
  · intro x
    have base : height 4 = 2401 := by decide
    simp only [Entrance.endpoint, translate, bottom, start, mark, Entrance.old,
      base, Int.sub_add_cancel]
    have eq : x=c.anchor+2401 ↔ x-c.anchor=2401 := by omega
    have arg : x-(c.anchor+2401)=x-c.anchor-2401 := by omega
    rw [eq, arg]

theorem Entrance.descend (c : Entrance) (checked : c.Claim) (n : Nat) :
    ValidWord (c.initial n) ((word 4 n).map (fun x => x+c.anchor)) ∧
      execute (c.initial n) ((word 4 n).map (fun x => x+c.anchor)) = c.endpoint n ∧
      ((word 4 n).map (fun x => x+c.anchor)).length = 6*n := by
  have result := LadderDescent.descend c.old (c.region checked) 4 n (by decide)
  rw [c.initial_eq, c.endpoint_eq]
  refine ⟨validWord_translate c.anchor result.1, ?_, ?_⟩
  · rw [execute_translate]
    exact congrArg (translate c.anchor) result.2
  · simp only [List.length_map, word_length]

structure CheckedEntrance where
  entrance : Entrance
  checked : entrance.Claim

end Heraclitus.LadderDescent
