import Heraclitus.OuterBoundary
import Heraclitus.ScaleInduction

set_option autoImplicit false

/-! Assemble a full 36-phase family at every successive integer exponent.
Only the concrete signed base is an argument to the resulting Plan. -/

namespace Heraclitus.ScaleSchedule
open OuterBoundary ScaleInduction SignedCertificate

def nextIndex (i : Fin 36) : Fin 36 := ⟨(i.val+1)%36, Nat.mod_lt _ (by decide)⟩
def index (n : Nat) : Fin 36 := ⟨n%36, Nat.mod_lt _ (by decide)⟩

structure Schedule where
  entry : Fin 36 → Transition
  least : ∀ i, (entry i).checked.link.approach.row.leastExponent=i.val+6
  follows : ∀ i, (entry i).checked.link.following=
    (entry (nextIndex i)).checked.link.phase.entrance.outgoing.inner.initial

def Schedule.input (s : Schedule) (n : Nat) : Record :=
  (s.entry (index n)).checked.link.phase.entrance.outgoing.inner.initial

def Schedule.boundary (s : Schedule) (n : Nat) : State := (s.input n).toState (radius (n+6))

theorem Schedule.exponent (s : Schedule) (n : Nat) :
    (s.entry (index n)).checked.link.approach.row.exponent (n/36)=n+6 := by
  unfold ApproachWord.Row.exponent
  rw [s.least]
  simp only [index]
  omega

theorem Schedule.scale (s : Schedule) (n : Nat) :
    (s.entry (index n)).checked.link.approach.row.scale (n/36)=(7^(n+6) : Nat) := by
  unfold ApproachWord.Row.scale
  rw [s.exponent]

theorem radius_exact (k : Nat) : 2*radius k+1=(7^k : Nat) := by
  have odd : 7^k%2=1 := by rw [Nat.pow_mod]; simp
  have div := Nat.mod_add_div (7^k) 2
  rw [odd] at div
  unfold radius
  omega

theorem radius_advance (k : Nat) : radius (k+1)=radius k+3*(7^k : Nat) := by
  have a := radius_exact (k+1)
  have b := next_radius k (radius k) (radius_exact k)
  omega

theorem index_next (n : Nat) : nextIndex (index n)=index (n+1) := by
  apply Fin.ext
  change (n%36+1)%36=(n+1)%36
  omega

theorem Schedule.following (s : Schedule) (n : Nat) :
    (s.entry (index n)).checked.link.following=s.input (n+1) := by
  have h := s.follows (index n)
  rw [index_next] at h
  exact h

theorem Schedule.endpoint (s : Schedule) (n : Nat) :
    (s.entry (index n)).checked.link.following.toState
      (radius (n+6)+3*(s.entry (index n)).checked.link.approach.row.scale (n/36))=
        s.boundary (n+1) := by
  rw [s.following, s.scale, ← radius_advance]
  change (s.input (n+1)).toState (radius (n+6+1))=(s.input (n+1)).toState (radius (n+1+6))
  rw [show n+6+1=n+1+6 by omega]

theorem Schedule.step (s : Schedule) (n : Nat) :
    ∃ b : SignedBlock (s.boundary n) (s.boundary (n+1)), b.word.length=6*7^(n+6) := by
  have rad : 2*radius (n+6)+1=(7^((s.entry (index n)).checked.link.approach.row.exponent (n/36)) : Nat) := by
    rw [s.exponent]
    exact radius_exact (n+6)
  obtain ⟨b, length⟩ := (s.entry (index n)).exact (n/36) (radius (n+6)) rad
  refine ⟨alignOutput b (s.endpoint n), ?_⟩
  change b.word.length=6*7^(n+6)
  rw [s.exponent] at length
  exact length

noncomputable def Schedule.transition (s : Schedule) (n : Nat) :
    SignedBlock (s.boundary n) (s.boundary (n+1)) := Classical.choose (s.step n)

theorem Schedule.transition_length (s : Schedule) (n : Nat) :
    (s.transition n).word.length=6*7^(n+6) := Classical.choose_spec (s.step n)

noncomputable def Schedule.plan (s : Schedule) (base : SignedBlock signedStart (s.boundary 0))
    (length : base.word.length=7^6) : Plan :=
  ⟨s.boundary, base, length, s.transition, s.transition_length⟩

theorem Schedule.filled (s : Schedule) (base : SignedBlock signedStart (s.boundary 0))
    (length : base.word.length=7^6) : Filled (s.plan base length) := by
  intro n x low high
  exact (s.entry (index n)).checked.inner_filled (radius (n+6)) x low high

theorem Schedule.input_period (s : Schedule) (n : Nat) : s.input (n+36)=s.input n := by
  have indices : index (n+36)=index n := by
    apply Fin.ext
    change (n+36)%36=n%36
    omega
  unfold Schedule.input
  rw [indices]

end Heraclitus.ScaleSchedule
