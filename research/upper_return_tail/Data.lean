import research.upper_scale_assembly.Frame
import research.upper_return_tail.Generic
import ActualBoundary
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 40000000
namespace Heraclitus.UpperReturnTail
open UpperPhaseBridge

def post (i : Fin 36) : PostLadder.Checked := match i.val with
  | 0 => PostLadderData.checked42
  | 1 => PostLadderData.checked42
  | 2 => PostLadderData.checked44
  | 3 => PostLadderData.checked45
  | 4 => PostLadderData.checked46
  | 5 => PostLadderData.checked47
  | 6 => PostLadderData.checked48
  | 7 => PostLadderData.checked49
  | 8 => PostLadderData.checked50
  | 9 => PostLadderData.checked51
  | 10 => PostLadderData.checked52
  | 11 => PostLadderData.checked53
  | 12 => PostLadderData.checked54
  | 13 => PostLadderData.checked55
  | 14 => PostLadderData.checked56
  | 15 => PostLadderData.checked57
  | 16 => PostLadderData.checked58
  | 17 => PostLadderData.checked59
  | 18 => PostLadderData.checked60
  | 19 => PostLadderData.checked61
  | 20 => PostLadderData.checked62
  | 21 => PostLadderData.checked63
  | 22 => PostLadderData.checked64
  | 23 => PostLadderData.checked65
  | 24 => PostLadderData.checked66
  | 25 => PostLadderData.checked67
  | 26 => PostLadderData.checked68
  | 27 => PostLadderData.checked69
  | 28 => PostLadderData.checked70
  | 29 => PostLadderData.checked71
  | 30 => PostLadderData.checked72
  | 31 => PostLadderData.checked73
  | 32 => PostLadderData.checked74
  | 33 => PostLadderData.checked75
  | 34 => PostLadderData.checked40
  | _ => PostLadderData.checked41

def approach (i : Fin 36) : ApproachWord.Checked := (ScaleScheduleData.entry i).checked.link.approach
def outer (i : Fin 36) : OuterBoundary.Checked := (ScaleScheduleData.entry i).checked

theorem post_phase (i : Fin 36) (ordinary : i.val≠1) : (post i).input.before=phase i := by
  obtain ⟨i, bound⟩ := i
  have cases : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 ∨ i=33 ∨ i=34 ∨ i=35 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · rfl
  · exact False.elim (ordinary rfl)
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl

theorem post_member (i : Fin 36) : (post i).input.transfer.original∈TransferCatalogue.catalogue := by
  obtain ⟨i, bound⟩ := i
  have cases : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 ∨ i=33 ∨ i=34 ∨ i=35 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · change TransferCatalogue.row047∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row047∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row060∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row010∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row010∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row056∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row033∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row072∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row010∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row010∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row010∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row010∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row011∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]
  · change TransferCatalogue.row051∈TransferCatalogue.catalogue
    simp [TransferCatalogue.catalogue]

theorem approach_member (i : Fin 36) : approach i∈ApproachWordData.catalogue := by
  obtain ⟨i, bound⟩ := i
  have cases : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 ∨ i=33 ∨ i=34 ∨ i=35 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · change ApproachWordData.checked42∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked43∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked44∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked45∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked46∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked47∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked48∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked49∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked50∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked51∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked52∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked53∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked54∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked55∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked56∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked57∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked58∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked59∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked60∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked61∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked62∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked63∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked64∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked65∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked66∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked67∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked68∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked69∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked70∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked71∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked72∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked73∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked74∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked75∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked40∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]
  · change ApproachWordData.checked41∈ApproachWordData.catalogue
    simp [ApproachWordData.catalogue]

theorem outer_member (i : Fin 36) : (outer i).link.outer∈SignedBoundaryData.catalogue := by
  obtain ⟨i, bound⟩ := i
  have cases : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 ∨ i=33 ∨ i=34 ∨ i=35 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · change SignedBoundaryData.row42_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row43_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row44_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row45_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row46_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row47_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row48_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row49_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row50_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row51_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row52_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row53_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row54_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row55_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row56_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row57_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row58_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row59_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row60_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row61_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row62_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row63_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row64_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row65_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row66_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row67_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row68_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row69_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row70_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row71_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row72_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row73_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row74_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row75_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row40_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]
  · change SignedBoundaryData.row41_outer∈SignedBoundaryData.catalogue
    simp [SignedBoundaryData.catalogue]

theorem post_approach (i : Fin 36) (ordinary : i.val≠1) (t : Nat) :
    (approach i).row.start ((approach i).row.scale t)=(post i).input.endpoint t := by
  obtain ⟨i, bound⟩ := i
  have cases : i=0 ∨ i=1 ∨ i=2 ∨ i=3 ∨ i=4 ∨ i=5 ∨ i=6 ∨ i=7 ∨ i=8 ∨ i=9 ∨ i=10 ∨ i=11 ∨ i=12 ∨ i=13 ∨ i=14 ∨ i=15 ∨ i=16 ∨ i=17 ∨ i=18 ∨ i=19 ∨ i=20 ∨ i=21 ∨ i=22 ∨ i=23 ∨ i=24 ∨ i=25 ∨ i=26 ∨ i=27 ∨ i=28 ∨ i=29 ∨ i=30 ∨ i=31 ∨ i=32 ∨ i=33 ∨ i=34 ∨ i=35 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact ApproachWordData.input42_all t
  · exact False.elim (ordinary rfl)
  · exact ApproachWordData.input44_all t
  · exact ApproachWordData.input45_all t
  · exact ApproachWordData.input46_all t
  · exact ApproachWordData.input47_all t
  · exact ApproachWordData.input48_all t
  · exact ApproachWordData.input49_all t
  · exact ApproachWordData.input50_all t
  · exact ApproachWordData.input51_all t
  · exact ApproachWordData.input52_all t
  · exact ApproachWordData.input53_all t
  · exact ApproachWordData.input54_all t
  · exact ApproachWordData.input55_all t
  · exact ApproachWordData.input56_all t
  · exact ApproachWordData.input57_all t
  · exact ApproachWordData.input58_all t
  · exact ApproachWordData.input59_all t
  · exact ApproachWordData.input60_all t
  · exact ApproachWordData.input61_all t
  · exact ApproachWordData.input62_all t
  · exact ApproachWordData.input63_all t
  · exact ApproachWordData.input64_all t
  · exact ApproachWordData.input65_all t
  · exact ApproachWordData.input66_all t
  · exact ApproachWordData.input67_all t
  · exact ApproachWordData.input68_all t
  · exact ApproachWordData.input69_all t
  · exact ApproachWordData.input70_all t
  · exact ApproachWordData.input71_all t
  · exact ApproachWordData.input72_all t
  · exact ApproachWordData.input73_all t
  · exact ApproachWordData.input74_all t
  · exact ApproachWordData.input75_all t
  · exact ApproachWordData.input40_all t
  · exact ApproachWordData.input41_all t

theorem approach_exponent (i : Fin 36) (t : Nat) : (approach i).row.exponent t=exponent i t :=
  ((outer i).exponent t).trans (phase_exponent i t)

theorem approach_scale (i : Fin 36) (t : Nat) : (approach i).row.scale t=(7^(exponent i t) : Nat) := by
  unfold ApproachWord.Row.scale
  rw [approach_exponent]

end Heraclitus.UpperReturnTail
