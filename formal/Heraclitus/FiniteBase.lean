import Heraclitus.SignedCertificate

set_option autoImplicit false

/-! A finite signed-word checker at centre zero. Every choice checks all
powers below 7^7; a proved radius inequality excludes every higher power.
No coverage claim or simulated prefix is assumed. -/

namespace Heraclitus.FiniteBase
open SignedCertificate

instance (v w : Int) : Decidable (Preferred v w) :=
  inferInstanceAs (Decidable (v.natAbs < w.natAbs ∨ (v.natAbs=w.natAbs ∧ w≤v)))

instance (s : Record) (x : Int) : Decidable ((s.toState 0).used x) :=
  inferInstanceAs (Decidable (x=0 ∨ (0<x ∧ boundaryUsed s.pos (x-0)) ∨
    (x<0 ∧ boundaryUsed s.neg (-x-0))))

def offer (s : Record) (j : Fin 7) (forward : Bool) : Int :=
  (s.toState 0).current + if forward then ((7^j.val : Nat) : Int) else -((7^j.val : Nat) : Int)

def Claim (s : Record) (m : Move) : Prop :=
  0<m.value ∧
  ¬(s.toState 0).used (embedRay m.positive 0 m.value) ∧
  (∃ j : Fin 7, (embedRay m.positive 0 m.value-(s.toState 0).current).natAbs=7^j.val) ∧
  (s.toState 0).current.natAbs+(embedRay m.positive 0 m.value).natAbs<7^7 ∧
  (∀ j : Fin 7, ∀ forward : Bool,
    Preferred (embedRay m.positive 0 m.value) (offer s j forward) ∨ (s.toState 0).used (offer s j forward)) ∧
  FilledClaim (s.ray m.positive) m.value m.front

instance (s : Record) (m : Move) : Decidable (Claim s m) := by
  unfold Claim
  infer_instance

theorem choice (s : Record) (m : Move) (h : Claim s m) :
    SignedGreedy (s.toState 0) (embedRay m.positive 0 m.value) := by
  obtain ⟨_positive, unused, ⟨j, step⟩, cutoff, minima, _filled⟩ := h
  apply signedGreedy_finite_cutoff (s.toState 0) (embedRay m.positive 0 m.value) 7
    unused ⟨j.val, step⟩ cutoff
  intro j small z distance zu
  rcases distance with plus | minus
  · have eq : offer s ⟨j, small⟩ true=z := by simp only [offer, ite_true]; omega
    have h := minima ⟨j, small⟩ true
    rw [eq] at h
    exact h.resolve_right zu
  · have eq : offer s ⟨j, small⟩ false=z := by simp only [offer, Bool.false_eq_true, ite_false]; omega
    have h := minima ⟨j, small⟩ false
    rw [eq] at h
    exact h.resolve_right zu

def check (s : Record) : List Move → Bool
  | [] => true
  | m :: ms => decide (Claim s m) && check (s.update m.positive m.value m.front) ms

theorem check_sound (s : Record) (moves : List Move) (checked : check s moves=true) :
    SignedValidWord (s.toState 0) (physicalWord 0 moves) ∧
    execute (s.toState 0) (physicalWord 0 moves)=(s.run moves).toState 0 := by
  induction moves generalizing s with
  | nil => exact ⟨True.intro, rfl⟩
  | cons m ms ih =>
    have both : decide (Claim s m)=true ∧ check (s.update m.positive m.value m.front) ms=true := by
      simpa only [check, Bool.and_eq_true] using checked
    have claim : Claim s m := of_decide_eq_true both.1
    have updated := update_exact s m.positive m.value m.front 0 claim.2.2.2.2.2 (by have h := claim.1; omega)
    obtain ⟨valid, endpoint⟩ := ih _ both.2
    constructor
    · change SignedGreedy (s.toState 0) (embedRay m.positive 0 m.value) ∧
        SignedValidWord (visit (s.toState 0) (embedRay m.positive 0 m.value)) (physicalWord 0 ms)
      rw [← updated]
      exact ⟨choice s m claim, valid⟩
    · change execute (visit (s.toState 0) (embedRay m.positive 0 m.value)) (physicalWord 0 ms)=_
      rw [← updated]
      exact endpoint

def block (s : Record) (moves : List Move) (checked : check s moves=true) :
    SignedBlock (s.toState 0) ((s.run moves).toState 0) :=
  ⟨physicalWord 0 moves, (check_sound s moves checked).1, (check_sound s moves checked).2⟩

theorem block_length (s : Record) (moves : List Move) (checked : check s moves=true) :
    (block s moves checked).word.length=moves.length := List.length_map _

def initial : Record := ⟨true, 0, ⟨1, []⟩, ⟨1, []⟩⟩

theorem initial_exact : initial.toState 0=signedStart := by
  apply state_ext
  · rfl
  · intro x
    change (x=0 ∨ (0<x ∧ (x-0<1 ∨ x-0 ∈ ([] : List Int))) ∨
      (x<0 ∧ (-x-0<1 ∨ -x-0 ∈ ([] : List Int)))) ↔ x=0
    simp only [List.not_mem_nil, or_false]
    omega

/-- Explicit state hints avoid repeatedly reducing the preceding history.
Every hint is checked against the exact proved update, including list order. -/
def EqClaim (s t : Record) : Prop :=
  s.positive=t.positive ∧ s.current=t.current ∧
  s.pos.front=t.pos.front ∧ s.pos.extra=t.pos.extra ∧
  s.neg.front=t.neg.front ∧ s.neg.extra=t.neg.extra

instance (s t : Record) : Decidable (EqClaim s t) := by unfold EqClaim; infer_instance

theorem ray_eq (s t : RayBoundary) (front : s.front=t.front) (extra : s.extra=t.extra) : s=t := by
  cases s
  cases t
  simp_all

theorem eq_sound (s t : Record) (h : EqClaim s t) : s=t := by
  obtain ⟨side, current, pf, pe, nf, ne⟩ := h
  have pos := ray_eq s.pos t.pos pf pe
  have neg := ray_eq s.neg t.neg nf ne
  cases s
  cases t
  simp_all

def toMove (t : Record) : Move := ⟨t.positive, t.current, (t.ray t.positive).front⟩

def traceCheck (s : Record) : List Record → Bool
  | [] => true
  | t :: ts => decide (Claim s (toMove t)) &&
      decide (EqClaim (s.update t.positive t.current (t.ray t.positive).front) t) && traceCheck t ts

def traceWord (ts : List Record) : List Int := ts.map (fun t => (t.toState 0).current)

def traceEnd (s : Record) : List Record → Record
  | [] => s
  | t :: ts => traceEnd t ts

theorem traceCheck_sound (s : Record) (ts : List Record) (checked : traceCheck s ts=true) :
    SignedValidWord (s.toState 0) (traceWord ts) ∧
    execute (s.toState 0) (traceWord ts)=(traceEnd s ts).toState 0 := by
  induction ts generalizing s with
  | nil => exact ⟨True.intro, rfl⟩
  | cons t ts ih =>
    have both : (decide (Claim s (toMove t))=true ∧
        decide (EqClaim (s.update t.positive t.current (t.ray t.positive).front) t)=true) ∧
        traceCheck t ts=true := by simpa only [traceCheck, Bool.and_eq_true] using checked
    have claim : Claim s (toMove t) := of_decide_eq_true both.1.1
    have record := eq_sound _ _ (of_decide_eq_true both.1.2)
    have updated := update_exact s t.positive t.current (t.ray t.positive).front 0
      claim.2.2.2.2.2 (by have h := claim.1; exact Int.add_pos_of_nonneg_of_pos (by decide) h)
    have state : t.toState 0=visit (s.toState 0) (t.toState 0).current := by
      rw [record] at updated
      exact updated
    obtain ⟨valid, endpoint⟩ := ih t both.2
    constructor
    · change SignedGreedy (s.toState 0) (t.toState 0).current ∧
        SignedValidWord (visit (s.toState 0) (t.toState 0).current) (traceWord ts)
      rw [← state]
      exact ⟨choice s (toMove t) claim, valid⟩
    · change execute (visit (s.toState 0) (t.toState 0).current) (traceWord ts)=_
      rw [← state]
      exact endpoint

def traceBlock (s : Record) (ts : List Record) (checked : traceCheck s ts=true) :
    SignedBlock (s.toState 0) ((traceEnd s ts).toState 0) :=
  ⟨traceWord ts, (traceCheck_sound s ts checked).1, (traceCheck_sound s ts checked).2⟩

theorem traceBlock_length (s : Record) (ts : List Record) (checked : traceCheck s ts=true) :
    (traceBlock s ts checked).word.length=ts.length := List.length_map _

structure CheckedTrace where
  initial : Record
  final : Record
  states : List Record
  checked : traceCheck initial states=true
  closed : traceEnd initial states=final

def CheckedTrace.block (c : CheckedTrace) : SignedBlock (c.initial.toState 0) (c.final.toState 0) :=
  let b := traceBlock c.initial c.states c.checked
  ⟨b.word, b.valid, b.endpoint.trans (congrArg (fun s => s.toState 0) c.closed)⟩

theorem CheckedTrace.length (c : CheckedTrace) : c.block.word.length=c.states.length := List.length_map _

end Heraclitus.FiniteBase
