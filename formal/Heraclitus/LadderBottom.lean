import Heraclitus.LadderDescent

set_option autoImplicit false

/-! Exact finite bottom-word checking, using an integer bitmap whose
semantics and updates are proved against the physical half-line state. -/

namespace Heraclitus.LadderBottom

open LadderLayers LadderDescent

def bits : List Nat → Nat
  | [] => 0
  | i :: rest => 2^i ||| bits rest

theorem bits_testBit (is : List Nat) (i : Nat) :
    (bits is).testBit i = true ↔ i ∈ is := by
  induction is with
  | nil => simp [bits]
  | cons j rest ih =>
    simp only [bits, Nat.testBit_or, Nat.testBit_two_pow, Bool.or_eq_true,
      decide_eq_true_eq, ih, List.mem_cons]
    rw [eq_comm (a := j) (b := i)]

structure Bitmap where
  current : Int
  lo : Int
  mask : Nat
deriving DecidableEq, Repr

def Bitmap.toState (s : Bitmap) : State :=
  ⟨s.current, fun x => x < s.lo ∨ s.mask.testBit (x-s.lo).toNat = true⟩

instance (s : Bitmap) (x : Int) : Decidable (s.toState.used x) :=
  inferInstanceAs (Decidable (x < s.lo ∨ s.mask.testBit (x-s.lo).toNat = true))

def encode (lo : Int) (s : FiniteState) : Bitmap :=
  ⟨s.current, lo, (2^(s.front-lo).toNat-1) ||| bits (s.points.map (fun x => (x-lo).toNat))⟩

/-- Equality of complete infinite predicates, including outside the bitmap. -/
theorem encode_sound (lo : Int) (s : FiniteState) (front : lo ≤ s.front)
    (points : ∀ x ∈ s.points, lo ≤ x) : (encode lo s).toState = s.toState := by
  apply state_ext
  · rfl
  · intro x
    by_cases below : x < lo
    · have left : (encode lo s).toState.used x := Or.inl below
      have right : s.toState.used x := Or.inl (by omega)
      exact ⟨fun _ => right, fun _ => left⟩
    · have frontIndex : (x-lo).toNat < (s.front-lo).toNat ↔ x < s.front := by omega
      have members : (x-lo).toNat ∈ s.points.map (fun y => (y-lo).toNat) ↔ x ∈ s.points := by
        constructor
        · intro hx
          obtain ⟨y, hy, eq⟩ := List.mem_map.mp hx
          have lower := points y hy
          have same : x = y := by omega
          simpa only [same] using hy
        · intro hx
          exact List.mem_map.mpr ⟨x, hx, rfl⟩
      simp only [encode, Bitmap.toState, FiniteState.toState, Nat.testBit_or,
        Nat.testBit_two_pow_sub_one, Bool.or_eq_true, decide_eq_true_eq,
        bits_testBit, below, false_or, frontIndex, members]

def Bitmap.addVisit (s : Bitmap) (v : Int) : Bitmap :=
  ⟨v, s.lo, s.mask ||| 2^(v-s.lo).toNat⟩

theorem Bitmap.addVisit_sound (s : Bitmap) (v : Int) (lower : s.lo ≤ v) :
    (s.addVisit v).toState = visit s.toState v := by
  apply state_ext
  · rfl
  · intro x
    by_cases below : x < s.lo
    · have left : (s.addVisit v).toState.used x := Or.inl below
      have right : (visit s.toState v).used x := Or.inl (Or.inl below)
      exact ⟨fun _ => right, fun _ => left⟩
    · have index : (v-s.lo).toNat = (x-s.lo).toNat ↔ x=v := by omega
      simp only [Bitmap.addVisit, Bitmap.toState, visit, Nat.testBit_or,
        Nat.testBit_two_pow, Bool.or_eq_true, decide_eq_true_eq, below,
        false_or, index]

def BottomStep (x y : Int) : Prop := ∃ j : Fin 5, (y-x).natAbs = 7^j.val

instance (x y : Int) : Decidable (BottomStep x y) :=
  inferInstanceAs (Decidable (∃ j : Fin 5, (y-x).natAbs = 7^j.val))

theorem bottomStep_sound {x y : Int} (h : BottomStep x y) : PowerStep x y := by
  obtain ⟨j, hj⟩ := h
  exact ⟨j.val, hj⟩

theorem bottomStep_complete {x y : Int} (h : PowerStep x y)
    (bound : (y-x).natAbs < 16807) : BottomStep x y := by
  obtain ⟨j, hj⟩ := h
  have small : j < 5 := by
    by_cases hs : j < 5
    · exact hs
    · have hp : (7 : Nat)^5 ≤ 7^j := Nat.pow_le_pow_right (by decide) (by omega)
      have value : (7 : Nat)^5 = 16807 := by decide
      rw [value] at hp
      omega
  exact ⟨⟨j, small⟩, hj⟩

def Bitmap.EdgeClaim (s : Bitmap) (v : Int) : Prop :=
  s.lo ≤ v ∧ ¬s.toState.used v ∧ BottomStep s.current v ∧
    s.current.natAbs + s.lo.natAbs + v.natAbs < 16807 ∧
    ∀ j : Fin 5,
      (v ≤ s.current + (7^j.val : Nat) ∨ s.toState.used (s.current + (7^j.val : Nat))) ∧
      (v ≤ s.current - (7^j.val : Nat) ∨ s.toState.used (s.current - (7^j.val : Nat)))

instance (s : Bitmap) (v : Int) : Decidable (s.EdgeClaim v) :=
  inferInstanceAs (Decidable (s.lo ≤ v ∧ ¬s.toState.used v ∧ BottomStep s.current v ∧
    s.current.natAbs + s.lo.natAbs + v.natAbs < 16807 ∧
    ∀ j : Fin 5,
      (v ≤ s.current + (7^j.val : Nat) ∨ s.toState.used (s.current + (7^j.val : Nat))) ∧
      (v ≤ s.current - (7^j.val : Nat) ∨ s.toState.used (s.current - (7^j.val : Nat)))))

theorem Bitmap.edge_sound (s : Bitmap) (v : Int) (checked : s.EdgeClaim v) :
    Greedy s.toState v := by
  obtain ⟨_, unused, step, cutoff, excludes⟩ := checked
  refine ⟨unused, bottomStep_sound step, ?_⟩
  intro w hw hs
  change PowerStep s.current w at hs
  by_cases order : v ≤ w
  · exact order
  · have lower : s.lo ≤ w := by
      by_cases low : s.lo ≤ w
      · exact low
      · exact False.elim (hw (Or.inl (by omega)))
    have magnitude : w.natAbs ≤ s.lo.natAbs + v.natAbs := by omega
    have triangle := Int.natAbs_sub_le w s.current
    have distance : (w-s.current).natAbs < 16807 := by omega
    obtain ⟨j, hj⟩ := bottomStep_complete hs distance
    rcases Int.natAbs_eq_iff.mp hj with hp | hn
    · have eq : w = s.current + (7^j.val : Nat) := by omega
      rcases (excludes j).1 with larger | used
      · omega
      · exact False.elim (hw (by simpa only [eq] using used))
    · have eq : w = s.current - (7^j.val : Nat) := by omega
      rcases (excludes j).2 with larger | used
      · omega
      · exact False.elim (hw (by simpa only [eq] using used))

/-- The endpoint comparison is performed after exactly the supplied moves. -/
def check (s : Bitmap) : List Int → Bitmap → Bool
  | [], out => decide (s=out)
  | v::vs, out => decide (s.EdgeClaim v) && check (s.addVisit v) vs out

theorem check_sound (s out : Bitmap) (w : List Int) (checked : check s w out = true) :
    ValidWord s.toState w ∧ execute s.toState w = out.toState := by
  induction w generalizing s with
  | nil =>
    have eq : s=out := of_decide_eq_true checked
    exact ⟨trivial, congrArg Bitmap.toState eq⟩
  | cons v vs ih =>
    have both : s.EdgeClaim v ∧ check (s.addVisit v) vs out = true := by
      simpa only [check, Bool.and_eq_true, decide_eq_true_eq] using checked
    have rest := ih (s.addVisit v) both.2
    have next := s.addVisit_sound v both.1.1
    refine ⟨⟨s.edge_sound v both.1, ?_⟩, ?_⟩
    · rw [← next]; exact rest.1
    · change execute (visit s.toState v) vs = _
      rw [← next]; exact rest.2

structure Chunk where
  initial : Bitmap
  output : Bitmap
  word : List Int

def Chunk.Claim (c : Chunk) : Prop :=
  check c.initial c.word c.output = true ∧ ∀ x ∈ c.word, -200 ≤ x ∧ x < 4401

instance (c : Chunk) : Decidable c.Claim :=
  inferInstanceAs (Decidable (check c.initial c.word c.output = true ∧
    ∀ x ∈ c.word, -200 ≤ x ∧ x < 4401))

structure CheckedChunk where
  chunk : Chunk
  checked : chunk.Claim

def Linked (s : Bitmap) : List CheckedChunk → Bitmap → Prop
  | [], out => s=out
  | c::cs, out => s=c.chunk.initial ∧ Linked c.chunk.output cs out

instance linkedDecidable (s : Bitmap) (cs : List CheckedChunk) (out : Bitmap) :
    Decidable (Linked s cs out) :=
  match cs with
  | [] => inferInstanceAs (Decidable (s=out))
  | c::rest =>
    letI := linkedDecidable c.chunk.output rest out
    inferInstanceAs (Decidable (s=c.chunk.initial ∧ Linked c.chunk.output rest out))

def routeWord : List CheckedChunk → List Int
  | [] => []
  | c::cs => c.chunk.word ++ routeWord cs

theorem route_sound (s out : Bitmap) (cs : List CheckedChunk) (linked : Linked s cs out) :
    ValidWord s.toState (routeWord cs) ∧ execute s.toState (routeWord cs) = out.toState := by
  induction cs generalizing s with
  | nil => exact ⟨trivial, congrArg Bitmap.toState linked⟩
  | cons c cs ih =>
    obtain ⟨rfl, links⟩ := linked
    have first := check_sound c.chunk.initial c.chunk.output c.chunk.word c.checked.1
    have rest := ih c.chunk.output links
    constructor
    · apply (validWord_append _ _ _).mpr
      refine ⟨first.1, ?_⟩
      rw [first.2]; exact rest.1
    · rw [routeWord, execute_append, first.2, rest.2]

theorem route_bounds (cs : List CheckedChunk) :
    ∀ x ∈ routeWord cs, -200 ≤ x ∧ x < 4401 := by
  induction cs with
  | nil => simp [routeWord]
  | cons c cs ih =>
    intro x hx
    rcases List.mem_append.mp hx with first | rest
    · exact c.checked.2 x first
    · exact ih x rest

def input (e : Entrance) : FiniteState :=
  ⟨2401, -100-e.anchor, 2401 :: e.points.map (fun x => x-e.anchor)⟩

theorem input_bounds (e : Entrance) (checked : e.Claim) :
    -200 ≤ (input e).front ∧ ∀ x ∈ (input e).points, -200 ≤ x := by
  obtain ⟨lower, upper, _, bounded⟩ := checked
  constructor
  · change -200 ≤ -100-e.anchor; omega
  · intro x hx
    rcases List.mem_cons.mp hx with top | old
    · omega
    · obtain ⟨y, hy, eq⟩ := List.mem_map.mp old
      have bound := bounded y hy
      omega

theorem input_sound (e : Entrance) : (input e).toState = start e.old 2401 := by
  apply state_ext
  · rfl
  · intro x
    have front : x < -100-e.anchor ↔ x+e.anchor < -100 := by omega
    have points : x ∈ e.points.map (fun y => y-e.anchor) ↔ x+e.anchor ∈ e.points := by
      constructor
      · intro hx
        obtain ⟨y, hy, eq⟩ := List.mem_map.mp hx
        have same : x+e.anchor=y := by omega
        simpa only [same] using hy
      · intro hx
        exact List.mem_map.mpr ⟨x+e.anchor, hx, by omega⟩
    simp only [input, FiniteState.toState, start, Entrance.old, List.mem_cons, front, points]
    simp only [or_assoc, or_left_comm, or_comm]

structure Bottom where
  entrance : CheckedEntrance
  ladder : CheckedLadder
  chunks : List CheckedChunk
  moves : Nat
  maxCoordinate : Int
  level : Nat
  endCoordinate : Int

def Bottom.output (c : Bottom) : FiniteState := c.ladder.ladder.initial.shift 2401
def Bottom.word (c : Bottom) : List Int := routeWord c.chunks

def Bottom.Claim (c : Bottom) : Prop :=
  c.level = 4 ∧ c.endCoordinate = c.entrance.entrance.anchor+2401 ∧
  -200 ≤ c.output.front ∧ (∀ x ∈ c.output.points, -200 ≤ x) ∧
    Linked (encode (-200) (input c.entrance.entrance)) c.chunks (encode (-200) c.output) ∧
    c.word.length = c.moves ∧ c.word.foldl max 2401 = c.maxCoordinate ∧
    c.maxCoordinate < 4401 ∧
    ∀ x ∈ c.word, -100 ≤ x+c.entrance.entrance.anchor ∧ x ≤ c.maxCoordinate

instance (c : Bottom) : Decidable c.Claim :=
  inferInstanceAs (Decidable (c.level = 4 ∧ c.endCoordinate = c.entrance.entrance.anchor+2401 ∧
    -200 ≤ c.output.front ∧ (∀ x ∈ c.output.points, -200 ≤ x) ∧
    Linked (encode (-200) (input c.entrance.entrance)) c.chunks (encode (-200) c.output) ∧
    c.word.length = c.moves ∧ c.word.foldl max 2401 = c.maxCoordinate ∧
    c.maxCoordinate < 4401 ∧
    ∀ x ∈ c.word, -100 ≤ x+c.entrance.entrance.anchor ∧ x ≤ c.maxCoordinate))

/-- The actual finite bottom word, with its complete endpoint and locality. -/
theorem Bottom.sound (c : Bottom) (checked : c.Claim) :
    ValidWord (start c.entrance.entrance.old 2401) c.word ∧
      execute (start c.entrance.entrance.old 2401) c.word =
        translate 2401 c.ladder.ladder.initial.toState ∧
      c.word.length = c.moves ∧
      (∀ x ∈ c.word, -100 ≤ x+c.entrance.entrance.anchor ∧ x < 4401) := by
  obtain ⟨_, _, front, points, linked, count, _, maxBound, bounds⟩ := checked
  have startBounds := input_bounds c.entrance.entrance c.entrance.checked
  have startEq := encode_sound (-200) (input c.entrance.entrance) startBounds.1 startBounds.2
  rw [input_sound] at startEq
  have endEq := encode_sound (-200) c.output front points
  have path := route_sound _ _ c.chunks linked
  rw [startEq, endEq] at path
  refine ⟨path.1, ?_, count, ?_⟩
  · exact path.2.trans (FiniteState.shift_toState _ _)
  · intro x hx
    have range := bounds x hx
    exact ⟨range.1, by omega⟩

/-- Concrete bottoms discharge the previously explicit finite-word hypotheses. -/
theorem Bottom.all_heights (c : Bottom) (checked : c.Claim) (n : Nat) :
    ∃ w : List Int,
      ValidWord (c.entrance.entrance.initial n) w ∧
      execute (c.entrance.entrance.initial n) w =
        translate (c.entrance.entrance.anchor+scale n) (c.ladder.ladder.entry n).toState ∧
      (w.length : Int) = 6*(n : Int) + c.moves + scale n - 2401 + c.ladder.ladder.cumulative 0 n := by
  have bottomProof := c.sound checked
  obtain ⟨w, valid, endpoint, count⟩ := complete_if_bottom c.entrance.entrance.old
    (c.entrance.entrance.region c.entrance.checked) c.ladder.ladder c.ladder.checked
    c.word bottomProof.1 bottomProof.2.1 (fun x hx => (bottomProof.2.2.2 x hx).2) n
  refine ⟨w.map (fun x => x+c.entrance.entrance.anchor), ?_, ?_, ?_⟩
  · rw [Entrance.initial_eq]
    exact validWord_translate _ valid
  · rw [Entrance.initial_eq, execute_translate, endpoint, translate_translate]
  · simpa only [List.length_map, bottomProof.2.2.1] using count

/-- Higher markers are carried through the finite bottom word exactly. -/
theorem Bottom.with_later (c : Bottom) (checked : c.Claim) (later : Int → Prop)
    (far : ∀ x, later x → 4401 ≤ x) :
    ValidWord (mark (start c.entrance.entrance.old 2401) later) c.word ∧
      execute (mark (start c.entrance.entrance.old 2401) later) c.word =
        mark (translate 2401 c.ladder.ladder.initial.toState) later := by
  have result := c.sound checked
  constructor
  · apply validWord_mark result.1
    intro x hx marked
    have low := far x marked
    have high := (result.2.2.2 x hx).2
    omega
  · rw [execute_mark, result.2.1]

structure CheckedBottom where
  bottom : Bottom
  checked : bottom.Claim

end Heraclitus.LadderBottom
