import SignedTransferPrefix
import Heraclitus.SignedBoundaryData
set_option autoImplicit false

/-! Whole-state signed boundary prefix tails. The finite checker operates
directly on the original formal record and its exact update operation. -/
namespace Heraclitus.UpperBoundaryPrefix
open SignedCertificate UpperTransferPrefix TailCover PhysicalTail

def active (s : Record) : RayBoundary := s.ray s.positive
def localPoints (s : Record) : List Int :=
  (active s).extra.map (fun x => x-(active s).front)
def score (s : Record) : Nat :=
  (localAhead (s.current-(active s).front) (localPoints s)).length

def Good (K : Nat) (s : Record) : Prop := -512 ≤ s.current ∧ score s ≤ K
instance (K : Nat) (s : Record) : Decidable (Good K s) :=
  inferInstanceAs (Decidable (-512 ≤ s.current ∧ score s ≤ K))

def AllGood (K : Nat) (s : Record) : List Move → Prop
  | [] => Good K s
  | m::ms => Good K s ∧ AllGood K (s.update m.positive m.value m.front) ms

instance allGoodDecidable (K : Nat) (s : Record) (ms : List Move) : Decidable (AllGood K s ms) :=
  match ms with
  | [] => inferInstanceAs (Decidable (Good K s))
  | m::ms =>
    letI := allGoodDecidable K (s.update m.positive m.value m.front) ms
    inferInstanceAs (Decidable (Good K s ∧ AllGood K (s.update m.positive m.value m.front) ms))

theorem allGood_prefix (K : Nat) (s : Record) (ms : List Move)
    (good : AllGood K s ms) (i : Nat) (hi : i ≤ ms.length) :
    Good K (s.run (ms.take i)) := by
  induction ms generalizing s i with
  | nil => simpa only [List.take_nil, Record.run, AllGood] using good
  | cons m ms ih =>
    cases i with
    | zero => exact good.1
    | succ i =>
      exact ih (s.update m.positive m.value m.front) good.2 i (by simpa using Nat.le_of_succ_le_succ hi)

theorem wordCheck_take (s : Record) (ms : List Move) (valid : wordCheck s ms=true)
    (i : Nat) : wordCheck s (ms.take i)=true := by
  induction ms generalizing s i with
  | nil => simp only [List.take_nil, wordCheck]
  | cons m ms ih =>
    cases i with
    | zero => rfl
    | succ i =>
      have parts : decide (MoveClaim s m)=true ∧ wordCheck (s.update m.positive m.value m.front) ms=true := by
        simpa only [wordCheck,Bool.and_eq_true] using valid
      simp only [List.take_succ_cons,wordCheck,Bool.and_eq_true]
      exact ⟨parts.1,ih _ parts.2 i⟩

theorem record_lift (s : Record) (C : Int) :
    s.toState C = OutgoingWord.liftRay s.positive C (s.ray (!s.positive))
      (halfBoundary (active s) s.current) := by
  cases s with
  | mk side c p n => cases side <;> rfl

theorem record_cover (K : Nat) (s : Record) (bound : score s ≤ K) :
    Covered K (fun _ => False) (halfBoundary (active s) s.current) := by
  refine ⟨(active s).front,s.current-(active s).front,localPoints s,?_,?_,bound⟩
  · change s.current=(active s).front+(s.current-(active s).front)
    omega
  · intro x used
    rcases used with low | extra
    · exact Or.inl low
    · exact Or.inr (Or.inl (List.mem_map.mpr ⟨x,extra,rfl⟩))

theorem actual_record_tail (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (n D : Nat) (s : Record) (C : Int) (K : Nat)
    (state : GlobalWalk.stateAt a n=s.toState C)
    (positive : 0<C+s.current) (bound : score s≤K) :
    count a n D≤K := by
  rw [record_lift] at state
  have result := actual_tail a walk n D s.positive C (s.ray (!s.positive))
    (halfBoundary (active s) s.current) state positive K (fun _ => False) []
    (record_cover K s bound) (fun _ h => False.elim h)
  simpa only [List.length_nil,Nat.add_zero] using result

/-- Every prefix is the exact original record update, at its actual index.
Signed validity at all scales follows from the existing boundary checker. -/
theorem actual_prefix_state (b : CheckedBoundary) (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base k : Nat) (C : Int) (scale : 2*C+1=(7^k : Nat))
    (large : 100000≤(7^k : Nat)) (start : GlobalWalk.stateAt a base=b.initial.toState C)
    (i : Nat) (hi : i≤b.moves.length) :
    GlobalWalk.stateAt a (base+i)=(b.initial.run (b.moves.take i)).toState C := by
  have part := wordCheck_sound b.initial (b.moves.take i) (wordCheck_take _ _ b.valid i) k C scale large
  have valid : SignedValidWord (GlobalWalk.stateAt a base) (physicalWord C (b.moves.take i)) := by
    rw [start]; exact part.1
  have endpoint := GlobalWalk.valid_word_endpoint a walk base _ valid
  have length : (physicalWord C (b.moves.take i)).length=i := by
    simp only [physicalWord,List.length_map,List.length_take,Nat.min_eq_left hi]
  rw [length,start,part.2] at endpoint
  exact endpoint.symm

theorem actual_boundary_tail (b : CheckedBoundary) (K : Nat)
    (bound : AllGood K b.initial b.moves) (a : Nat → Int) (walk : GlobalWalk.IsWalk a)
    (base k : Nat) (C : Int) (scale : 2*C+1=(7^k : Nat))
    (large : 100000≤(7^k : Nat)) (start : GlobalWalk.stateAt a base=b.initial.toState C)
    (D i : Nat) (hi : i≤b.moves.length) : count a (base+i) D≤K := by
  have state := actual_prefix_state b a walk base k C scale large start i hi
  have good := allGood_prefix K b.initial b.moves bound i hi
  apply actual_record_tail a walk (base+i) D _ C K state
  · have low := good.1; omega
  · exact good.2

end Heraclitus.UpperBoundaryPrefix
#print axioms Heraclitus.UpperBoundaryPrefix.actual_boundary_tail
