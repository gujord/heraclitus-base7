import ActualBoundary
import ActualCover
import ActualInner
import ActualPhase43
import AllPhases
import Audit
import BottomChunks00
import BottomChunks01
import BottomChunks02
import BottomChunks03
import BottomChunks04
import BottomChunks05
import BottomChunks06
import BottomChunks07
import BottomChunks08
import BottomChunks09
import BottomChunks10
import BottomChunks11
import BottomChunks12
import BottomChunks13
import BottomChunks14
import BottomChunks15
import BottomChunks16
import BottomChunks17
import BottomChunks18
import BottomChunks19
import BottomChunks20
import BottomChunks21
import BottomChunks22
import BottomChunks23
import BottomChunks24
import BottomChunks25
import BottomChunks26
import BottomChunks27
import Bottoms
import Boundaries00
import Boundaries01
import Boundaries02
import Boundaries03
import Boundaries04
import Boundaries05
import Boundaries06
import Boundaries07
import Boundaries08
import Boundaries09
import Boundaries10
import Boundaries11
import BoundaryCatalogue
import BoundaryCore
import Catalogue
import CatalogueInstance
import CatalogueTransferPrefix
import ConcreteLadderPrefix
import Core
import Counting
import CountingData
import Crossing
import CycleCoupling
import DescentBottomArithmetic
import DescentDefectArithmetic
import FullLadderPrefix
import LadderBounds
import LadderPrefix
import PhaseData
import Potential
import PrefixAssembly
import ReachedLadders
import ReturnEnvelopeArithmetic
import RoutePrefix
import ShortTail
import SignedTail
import SignedTransferPrefix
import TailCover
import TowerCardinality
import TransferPrefix
import Transfers00
import Transfers01
import Transfers02
import Transfers03
import Transfers04
import Transfers05
import Transfers06
import Transfers07
import Transfers08
import Transfers09
import Transfers10
import Transfers11
import research.actual_lower_bound.ActualCrossing
import research.actual_lower_bound.LowerBound
import research.physical_counting.CheckpointExterior
import research.physical_counting.PhysicalCounting
import research.physical_tail.PhysicalTail
import research.upper_asymptotic.FromScale
import research.upper_machine_audit.TargetContract
import research.upper_outgoing_prefix.Actual
import research.upper_outgoing_prefix.Core
import research.upper_outgoing_prefix.Data
import research.upper_return_geometry.CheckpointRadius
import research.upper_return_geometry.CrossingTime
import research.upper_return_geometry.EntranceTail
import research.upper_return_tail.Data
import research.upper_return_tail.End
import research.upper_return_tail.Generic
import research.upper_return_tail.PostCore
import research.upper_scale_assembly.Counting
import research.upper_scale_assembly.Frame
import research.upper_scale_assembly.Theorem
set_option pp.fullNames true
set_option pp.maxSteps 1000000
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.actual_crossing42"
#check @Heraclitus.ActualLowerBound.actual_crossing42
#print axioms Heraclitus.ActualLowerBound.actual_crossing42
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.original_rule_crossing42"
#check @Heraclitus.ActualLowerBound.original_rule_crossing42
#print axioms Heraclitus.ActualLowerBound.original_rule_crossing42
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.original_rule_crossing_defect"
#check @Heraclitus.ActualLowerBound.original_rule_crossing_defect
#print axioms Heraclitus.ActualLowerBound.original_rule_crossing_defect
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.original_rule_frequent_lower"
#check @Heraclitus.ActualLowerBound.original_rule_frequent_lower
#print axioms Heraclitus.ActualLowerBound.original_rule_frequent_lower
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.phase42_checkpoint"
#check @Heraclitus.ActualLowerBound.phase42_checkpoint
#print axioms Heraclitus.ActualLowerBound.phase42_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.phase42_current"
#check @Heraclitus.ActualLowerBound.phase42_current
#print axioms Heraclitus.ActualLowerBound.phase42_current
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualLowerBound.phase42_data"
#check @Heraclitus.ActualLowerBound.phase42_data
#print axioms Heraclitus.ActualLowerBound.phase42_data
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualTailCover.actual_tail_from_ray"
#check @Heraclitus.ActualTailCover.actual_tail_from_ray
#print axioms Heraclitus.ActualTailCover.actual_tail_from_ray
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ActualTailCover.ray_injective"
#check @Heraclitus.ActualTailCover.ray_injective
#print axioms Heraclitus.ActualTailCover.ray_injective
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.actual_checkpoint_cover"
#check @Heraclitus.CheckpointExterior.actual_checkpoint_cover
#print axioms Heraclitus.CheckpointExterior.actual_checkpoint_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.all_phase_bounds"
#check @Heraclitus.CheckpointExterior.all_phase_bounds
#print axioms Heraclitus.CheckpointExterior.all_phase_bounds
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.exteriorCover_covers"
#check @Heraclitus.CheckpointExterior.exteriorCover_covers
#print axioms Heraclitus.CheckpointExterior.exteriorCover_covers
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.exteriorCover_length"
#check @Heraclitus.CheckpointExterior.exteriorCover_length
#print axioms Heraclitus.CheckpointExterior.exteriorCover_length
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.offsets_cover"
#check @Heraclitus.CheckpointExterior.offsets_cover
#print axioms Heraclitus.CheckpointExterior.offsets_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.original_rule_count"
#check @Heraclitus.CheckpointExterior.original_rule_count
#print axioms Heraclitus.CheckpointExterior.original_rule_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.original_rule_outside_le_seven"
#check @Heraclitus.CheckpointExterior.original_rule_outside_le_seven
#print axioms Heraclitus.CheckpointExterior.original_rule_outside_le_seven
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CheckpointExterior.schedule_bound"
#check @Heraclitus.CheckpointExterior.schedule_bound
#print axioms Heraclitus.CheckpointExterior.schedule_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CrossingArithmetic.crossing_error_bounds"
#check @Heraclitus.CrossingArithmetic.crossing_error_bounds
#print axioms Heraclitus.CrossingArithmetic.crossing_error_bounds
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.CrossingArithmetic.crossing_identity"
#check @Heraclitus.CrossingArithmetic.crossing_identity
#print axioms Heraclitus.CrossingArithmetic.crossing_identity
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.DescentBottomBound.defects"
#check @Heraclitus.DescentBottomBound.defects
#print axioms Heraclitus.DescentBottomBound.defects
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.DescentBottomBound.short_defects"
#check @Heraclitus.DescentBottomBound.short_defects
#print axioms Heraclitus.DescentBottomBound.short_defects
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.DescentDefect.exceeds_constant"
#check @Heraclitus.DescentDefect.exceeds_constant
#print axioms Heraclitus.DescentDefect.exceeds_constant
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.DescentDefect.phase42_defect"
#check @Heraclitus.DescentDefect.phase42_defect
#print axioms Heraclitus.DescentDefect.phase42_defect
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.centralCover_length"
#check @Heraclitus.PhysicalCounting.centralCover_length
#print axioms Heraclitus.PhysicalCounting.centralCover_length
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.centralCover_mem"
#check @Heraclitus.PhysicalCounting.centralCover_mem
#print axioms Heraclitus.PhysicalCounting.centralCover_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.history_mem"
#check @Heraclitus.PhysicalCounting.history_mem
#print axioms Heraclitus.PhysicalCounting.history_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.history_nodup"
#check @Heraclitus.PhysicalCounting.history_nodup
#print axioms Heraclitus.PhysicalCounting.history_nodup
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.outside_le_later_cover"
#check @Heraclitus.PhysicalCounting.outside_le_later_cover
#print axioms Heraclitus.PhysicalCounting.outside_le_later_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.outside_mem"
#check @Heraclitus.PhysicalCounting.outside_mem
#print axioms Heraclitus.PhysicalCounting.outside_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.outside_nodup"
#check @Heraclitus.PhysicalCounting.outside_nodup
#print axioms Heraclitus.PhysicalCounting.outside_nodup
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.walk_count"
#check @Heraclitus.PhysicalCounting.walk_count
#print axioms Heraclitus.PhysicalCounting.walk_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalCounting.walk_count_later_cover"
#check @Heraclitus.PhysicalCounting.walk_count_later_cover
#print axioms Heraclitus.PhysicalCounting.walk_count_later_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalTail.count_le_cover"
#check @Heraclitus.PhysicalTail.count_le_cover
#print axioms Heraclitus.PhysicalTail.count_le_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalTail.points_mem"
#check @Heraclitus.PhysicalTail.points_mem
#print axioms Heraclitus.PhysicalTail.points_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.PhysicalTail.points_nodup"
#check @Heraclitus.PhysicalTail.points_nodup
#print axioms Heraclitus.PhysicalTail.points_nodup
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnEnvelopeArithmetic.conditional_defects"
#check @Heraclitus.ReturnEnvelopeArithmetic.conditional_defects
#print axioms Heraclitus.ReturnEnvelopeArithmetic.conditional_defects
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnEnvelopeArithmetic.conditional_deviation"
#check @Heraclitus.ReturnEnvelopeArithmetic.conditional_deviation
#print axioms Heraclitus.ReturnEnvelopeArithmetic.conditional_deviation
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnEnvelopeArithmetic.conditional_simple_bound"
#check @Heraclitus.ReturnEnvelopeArithmetic.conditional_simple_bound
#print axioms Heraclitus.ReturnEnvelopeArithmetic.conditional_simple_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnPrefix.actual_walk"
#check @Heraclitus.ReturnPrefix.actual_walk
#print axioms Heraclitus.ReturnPrefix.actual_walk
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnPrefix.append"
#check @Heraclitus.ReturnPrefix.append
#print axioms Heraclitus.ReturnPrefix.append
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnPrefix.blocks"
#check @Heraclitus.ReturnPrefix.blocks
#print axioms Heraclitus.ReturnPrefix.blocks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnPrefix.valid_words_unique"
#check @Heraclitus.ReturnPrefix.valid_words_unique
#print axioms Heraclitus.ReturnPrefix.valid_words_unique
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnTailCycle.marked_cycle_phase"
#check @Heraclitus.ReturnTailCycle.marked_cycle_phase
#print axioms Heraclitus.ReturnTailCycle.marked_cycle_phase
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnTailCycle.marked_cycle_phase_components"
#check @Heraclitus.ReturnTailCycle.marked_cycle_phase_components
#print axioms Heraclitus.ReturnTailCycle.marked_cycle_phase_components
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnTailCycle.marked_cycle_phase_valid"
#check @Heraclitus.ReturnTailCycle.marked_cycle_phase_valid
#print axioms Heraclitus.ReturnTailCycle.marked_cycle_phase_valid
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnTailTower.towerPoints_exact"
#check @Heraclitus.ReturnTailTower.towerPoints_exact
#print axioms Heraclitus.ReturnTailTower.towerPoints_exact
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnTailTower.towerPoints_length"
#check @Heraclitus.ReturnTailTower.towerPoints_length
#print axioms Heraclitus.ReturnTailTower.towerPoints_length
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ReturnTailTower.tower_count_bound"
#check @Heraclitus.ReturnTailTower.tower_count_bound
#print axioms Heraclitus.ReturnTailTower.tower_count_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.actual_signed_route_prefix"
#check @Heraclitus.RoutePrefix.actual_signed_route_prefix
#print axioms Heraclitus.RoutePrefix.actual_signed_route_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.checked_route_prefix"
#check @Heraclitus.RoutePrefix.checked_route_prefix
#print axioms Heraclitus.RoutePrefix.checked_route_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.connected_take"
#check @Heraclitus.RoutePrefix.connected_take
#print axioms Heraclitus.RoutePrefix.connected_take
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.execute_lift_ray"
#check @Heraclitus.RoutePrefix.execute_lift_ray
#print axioms Heraclitus.RoutePrefix.execute_lift_ray
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.marked_checked_route_prefix"
#check @Heraclitus.RoutePrefix.marked_checked_route_prefix
#print axioms Heraclitus.RoutePrefix.marked_checked_route_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.signed_marked_route_prefix"
#check @Heraclitus.RoutePrefix.signed_marked_route_prefix
#print axioms Heraclitus.RoutePrefix.signed_marked_route_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.RoutePrefix.word_take"
#check @Heraclitus.RoutePrefix.word_take
#print axioms Heraclitus.RoutePrefix.word_take
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ShortTail43.certified_short_prefix_cover"
#check @Heraclitus.ShortTail43.certified_short_prefix_cover
#print axioms Heraclitus.ShortTail43.certified_short_prefix_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ShortTail43.lifted_ray_used"
#check @Heraclitus.ShortTail43.lifted_ray_used
#print axioms Heraclitus.ShortTail43.lifted_ray_used
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ShortTail43.prefix_ahead_count"
#check @Heraclitus.ShortTail43.prefix_ahead_count
#print axioms Heraclitus.ShortTail43.prefix_ahead_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.ShortTail43.prefix_ahead_cover"
#check @Heraclitus.ShortTail43.prefix_ahead_cover
#print axioms Heraclitus.ShortTail43.prefix_ahead_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.actual_phase43_short_tail"
#check @Heraclitus.SignedTail43.actual_phase43_short_tail
#print axioms Heraclitus.SignedTail43.actual_phase43_short_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.actual_walk_tail_count"
#check @Heraclitus.SignedTail43.actual_walk_tail_count
#print axioms Heraclitus.SignedTail43.actual_walk_tail_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.lift_short_prefix"
#check @Heraclitus.SignedTail43.lift_short_prefix
#print axioms Heraclitus.SignedTail43.lift_short_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.original_rule_phase43_short_tail"
#check @Heraclitus.SignedTail43.original_rule_phase43_short_tail
#print axioms Heraclitus.SignedTail43.original_rule_phase43_short_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.phase43_checkpoint"
#check @Heraclitus.SignedTail43.phase43_checkpoint
#print axioms Heraclitus.SignedTail43.phase43_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.physical_prefix_onRay"
#check @Heraclitus.SignedTail43.physical_prefix_onRay
#print axioms Heraclitus.SignedTail43.physical_prefix_onRay
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.physical_prefix_tail_count"
#check @Heraclitus.SignedTail43.physical_prefix_tail_count
#print axioms Heraclitus.SignedTail43.physical_prefix_tail_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.physical_prefix_tail_cover"
#check @Heraclitus.SignedTail43.physical_prefix_tail_cover
#print axioms Heraclitus.SignedTail43.physical_prefix_tail_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.signed_prefix_radius"
#check @Heraclitus.SignedTail43.signed_prefix_radius
#print axioms Heraclitus.SignedTail43.signed_prefix_radius
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.signed_prefix_tail_count"
#check @Heraclitus.SignedTail43.signed_prefix_tail_count
#print axioms Heraclitus.SignedTail43.signed_prefix_tail_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.SignedTail43.signed_short_valid"
#check @Heraclitus.SignedTail43.signed_short_valid
#print axioms Heraclitus.SignedTail43.signed_short_valid
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TailCover.localAhead_length"
#check @Heraclitus.TailCover.localAhead_length
#print axioms Heraclitus.TailCover.localAhead_length
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TailCover.localAhead_mem"
#check @Heraclitus.TailCover.localAhead_mem
#print axioms Heraclitus.TailCover.localAhead_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TailCover.physical_state_tail_53"
#check @Heraclitus.TailCover.physical_state_tail_53
#print axioms Heraclitus.TailCover.physical_state_tail_53
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TailCover.physical_state_tail_cover"
#check @Heraclitus.TailCover.physical_state_tail_cover
#print axioms Heraclitus.TailCover.physical_state_tail_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TailCover.physical_tail_cover"
#check @Heraclitus.TailCover.physical_tail_cover
#print axioms Heraclitus.TailCover.physical_tail_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.base_power_translation"
#check @Heraclitus.Transfer.base_power_translation
#print axioms Heraclitus.Transfer.base_power_translation
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.cycle_extrema"
#check @Heraclitus.Transfer.cycle_extrema
#print axioms Heraclitus.Transfer.cycle_extrema
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.defect_bound_iff"
#check @Heraclitus.Transfer.defect_bound_iff
#print axioms Heraclitus.Transfer.defect_bound_iff
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.inward_cycle_increment"
#check @Heraclitus.Transfer.inward_cycle_increment
#print axioms Heraclitus.Transfer.inward_cycle_increment
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.outward_cycle_increment"
#check @Heraclitus.Transfer.outward_cycle_increment
#print axioms Heraclitus.Transfer.outward_cycle_increment
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.phase_only_obstruction"
#check @Heraclitus.Transfer.phase_only_obstruction
#print axioms Heraclitus.Transfer.phase_only_obstruction
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.Transfer.return_envelope"
#check @Heraclitus.Transfer.return_envelope
#print axioms Heraclitus.Transfer.return_envelope
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.Checkpoint.exact_scale"
#check @Heraclitus.TransferCounting.Checkpoint.exact_scale
#print axioms Heraclitus.TransferCounting.Checkpoint.exact_scale
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.exact_index"
#check @Heraclitus.TransferCounting.exact_index
#print axioms Heraclitus.TransferCounting.exact_index
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.history_length"
#check @Heraclitus.TransferCounting.history_length
#print axioms Heraclitus.TransferCounting.history_length
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.history_mem"
#check @Heraclitus.TransferCounting.history_mem
#print axioms Heraclitus.TransferCounting.history_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.history_nodup"
#check @Heraclitus.TransferCounting.history_nodup
#print axioms Heraclitus.TransferCounting.history_nodup
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.positivePoints_mem"
#check @Heraclitus.TransferCounting.positivePoints_mem
#print axioms Heraclitus.TransferCounting.positivePoints_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.positivePoints_nodup"
#check @Heraclitus.TransferCounting.positivePoints_nodup
#print axioms Heraclitus.TransferCounting.positivePoints_nodup
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCounting.weight_three_index"
#check @Heraclitus.TransferCounting.weight_three_index
#print axioms Heraclitus.TransferCounting.weight_three_index
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.labels_complete"
#check @Heraclitus.TransferCountingData.labels_complete
#print axioms Heraclitus.TransferCountingData.labels_complete
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row40_initial_checked"
#check @Heraclitus.TransferCountingData.row40_initial_checked
#print axioms Heraclitus.TransferCountingData.row40_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row40_output_checked"
#check @Heraclitus.TransferCountingData.row40_output_checked
#print axioms Heraclitus.TransferCountingData.row40_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row41_initial_checked"
#check @Heraclitus.TransferCountingData.row41_initial_checked
#print axioms Heraclitus.TransferCountingData.row41_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row41_output_checked"
#check @Heraclitus.TransferCountingData.row41_output_checked
#print axioms Heraclitus.TransferCountingData.row41_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row42_initial_checked"
#check @Heraclitus.TransferCountingData.row42_initial_checked
#print axioms Heraclitus.TransferCountingData.row42_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row42_output_checked"
#check @Heraclitus.TransferCountingData.row42_output_checked
#print axioms Heraclitus.TransferCountingData.row42_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row43_initial_checked"
#check @Heraclitus.TransferCountingData.row43_initial_checked
#print axioms Heraclitus.TransferCountingData.row43_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row43_output_checked"
#check @Heraclitus.TransferCountingData.row43_output_checked
#print axioms Heraclitus.TransferCountingData.row43_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row44_initial_checked"
#check @Heraclitus.TransferCountingData.row44_initial_checked
#print axioms Heraclitus.TransferCountingData.row44_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row44_output_checked"
#check @Heraclitus.TransferCountingData.row44_output_checked
#print axioms Heraclitus.TransferCountingData.row44_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row45_initial_checked"
#check @Heraclitus.TransferCountingData.row45_initial_checked
#print axioms Heraclitus.TransferCountingData.row45_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row45_output_checked"
#check @Heraclitus.TransferCountingData.row45_output_checked
#print axioms Heraclitus.TransferCountingData.row45_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row46_initial_checked"
#check @Heraclitus.TransferCountingData.row46_initial_checked
#print axioms Heraclitus.TransferCountingData.row46_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row46_output_checked"
#check @Heraclitus.TransferCountingData.row46_output_checked
#print axioms Heraclitus.TransferCountingData.row46_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row47_initial_checked"
#check @Heraclitus.TransferCountingData.row47_initial_checked
#print axioms Heraclitus.TransferCountingData.row47_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row47_output_checked"
#check @Heraclitus.TransferCountingData.row47_output_checked
#print axioms Heraclitus.TransferCountingData.row47_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row48_initial_checked"
#check @Heraclitus.TransferCountingData.row48_initial_checked
#print axioms Heraclitus.TransferCountingData.row48_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row48_output_checked"
#check @Heraclitus.TransferCountingData.row48_output_checked
#print axioms Heraclitus.TransferCountingData.row48_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row49_initial_checked"
#check @Heraclitus.TransferCountingData.row49_initial_checked
#print axioms Heraclitus.TransferCountingData.row49_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row49_output_checked"
#check @Heraclitus.TransferCountingData.row49_output_checked
#print axioms Heraclitus.TransferCountingData.row49_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row50_initial_checked"
#check @Heraclitus.TransferCountingData.row50_initial_checked
#print axioms Heraclitus.TransferCountingData.row50_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row50_output_checked"
#check @Heraclitus.TransferCountingData.row50_output_checked
#print axioms Heraclitus.TransferCountingData.row50_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row51_initial_checked"
#check @Heraclitus.TransferCountingData.row51_initial_checked
#print axioms Heraclitus.TransferCountingData.row51_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row51_output_checked"
#check @Heraclitus.TransferCountingData.row51_output_checked
#print axioms Heraclitus.TransferCountingData.row51_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row52_initial_checked"
#check @Heraclitus.TransferCountingData.row52_initial_checked
#print axioms Heraclitus.TransferCountingData.row52_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row52_output_checked"
#check @Heraclitus.TransferCountingData.row52_output_checked
#print axioms Heraclitus.TransferCountingData.row52_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row53_initial_checked"
#check @Heraclitus.TransferCountingData.row53_initial_checked
#print axioms Heraclitus.TransferCountingData.row53_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row53_output_checked"
#check @Heraclitus.TransferCountingData.row53_output_checked
#print axioms Heraclitus.TransferCountingData.row53_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row54_initial_checked"
#check @Heraclitus.TransferCountingData.row54_initial_checked
#print axioms Heraclitus.TransferCountingData.row54_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row54_output_checked"
#check @Heraclitus.TransferCountingData.row54_output_checked
#print axioms Heraclitus.TransferCountingData.row54_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row55_initial_checked"
#check @Heraclitus.TransferCountingData.row55_initial_checked
#print axioms Heraclitus.TransferCountingData.row55_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row55_output_checked"
#check @Heraclitus.TransferCountingData.row55_output_checked
#print axioms Heraclitus.TransferCountingData.row55_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row56_initial_checked"
#check @Heraclitus.TransferCountingData.row56_initial_checked
#print axioms Heraclitus.TransferCountingData.row56_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row56_output_checked"
#check @Heraclitus.TransferCountingData.row56_output_checked
#print axioms Heraclitus.TransferCountingData.row56_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row57_initial_checked"
#check @Heraclitus.TransferCountingData.row57_initial_checked
#print axioms Heraclitus.TransferCountingData.row57_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row57_output_checked"
#check @Heraclitus.TransferCountingData.row57_output_checked
#print axioms Heraclitus.TransferCountingData.row57_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row58_initial_checked"
#check @Heraclitus.TransferCountingData.row58_initial_checked
#print axioms Heraclitus.TransferCountingData.row58_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row58_output_checked"
#check @Heraclitus.TransferCountingData.row58_output_checked
#print axioms Heraclitus.TransferCountingData.row58_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row59_initial_checked"
#check @Heraclitus.TransferCountingData.row59_initial_checked
#print axioms Heraclitus.TransferCountingData.row59_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row59_output_checked"
#check @Heraclitus.TransferCountingData.row59_output_checked
#print axioms Heraclitus.TransferCountingData.row59_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row60_initial_checked"
#check @Heraclitus.TransferCountingData.row60_initial_checked
#print axioms Heraclitus.TransferCountingData.row60_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row60_output_checked"
#check @Heraclitus.TransferCountingData.row60_output_checked
#print axioms Heraclitus.TransferCountingData.row60_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row61_initial_checked"
#check @Heraclitus.TransferCountingData.row61_initial_checked
#print axioms Heraclitus.TransferCountingData.row61_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row61_output_checked"
#check @Heraclitus.TransferCountingData.row61_output_checked
#print axioms Heraclitus.TransferCountingData.row61_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row62_initial_checked"
#check @Heraclitus.TransferCountingData.row62_initial_checked
#print axioms Heraclitus.TransferCountingData.row62_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row62_output_checked"
#check @Heraclitus.TransferCountingData.row62_output_checked
#print axioms Heraclitus.TransferCountingData.row62_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row63_initial_checked"
#check @Heraclitus.TransferCountingData.row63_initial_checked
#print axioms Heraclitus.TransferCountingData.row63_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row63_output_checked"
#check @Heraclitus.TransferCountingData.row63_output_checked
#print axioms Heraclitus.TransferCountingData.row63_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row64_initial_checked"
#check @Heraclitus.TransferCountingData.row64_initial_checked
#print axioms Heraclitus.TransferCountingData.row64_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row64_output_checked"
#check @Heraclitus.TransferCountingData.row64_output_checked
#print axioms Heraclitus.TransferCountingData.row64_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row65_initial_checked"
#check @Heraclitus.TransferCountingData.row65_initial_checked
#print axioms Heraclitus.TransferCountingData.row65_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row65_output_checked"
#check @Heraclitus.TransferCountingData.row65_output_checked
#print axioms Heraclitus.TransferCountingData.row65_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row66_initial_checked"
#check @Heraclitus.TransferCountingData.row66_initial_checked
#print axioms Heraclitus.TransferCountingData.row66_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row66_output_checked"
#check @Heraclitus.TransferCountingData.row66_output_checked
#print axioms Heraclitus.TransferCountingData.row66_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row67_initial_checked"
#check @Heraclitus.TransferCountingData.row67_initial_checked
#print axioms Heraclitus.TransferCountingData.row67_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row67_output_checked"
#check @Heraclitus.TransferCountingData.row67_output_checked
#print axioms Heraclitus.TransferCountingData.row67_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row68_initial_checked"
#check @Heraclitus.TransferCountingData.row68_initial_checked
#print axioms Heraclitus.TransferCountingData.row68_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row68_output_checked"
#check @Heraclitus.TransferCountingData.row68_output_checked
#print axioms Heraclitus.TransferCountingData.row68_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row69_initial_checked"
#check @Heraclitus.TransferCountingData.row69_initial_checked
#print axioms Heraclitus.TransferCountingData.row69_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row69_output_checked"
#check @Heraclitus.TransferCountingData.row69_output_checked
#print axioms Heraclitus.TransferCountingData.row69_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row70_initial_checked"
#check @Heraclitus.TransferCountingData.row70_initial_checked
#print axioms Heraclitus.TransferCountingData.row70_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row70_output_checked"
#check @Heraclitus.TransferCountingData.row70_output_checked
#print axioms Heraclitus.TransferCountingData.row70_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row71_initial_checked"
#check @Heraclitus.TransferCountingData.row71_initial_checked
#print axioms Heraclitus.TransferCountingData.row71_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row71_output_checked"
#check @Heraclitus.TransferCountingData.row71_output_checked
#print axioms Heraclitus.TransferCountingData.row71_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row72_initial_checked"
#check @Heraclitus.TransferCountingData.row72_initial_checked
#print axioms Heraclitus.TransferCountingData.row72_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row72_output_checked"
#check @Heraclitus.TransferCountingData.row72_output_checked
#print axioms Heraclitus.TransferCountingData.row72_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row73_initial_checked"
#check @Heraclitus.TransferCountingData.row73_initial_checked
#print axioms Heraclitus.TransferCountingData.row73_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row73_output_checked"
#check @Heraclitus.TransferCountingData.row73_output_checked
#print axioms Heraclitus.TransferCountingData.row73_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row74_initial_checked"
#check @Heraclitus.TransferCountingData.row74_initial_checked
#print axioms Heraclitus.TransferCountingData.row74_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row74_output_checked"
#check @Heraclitus.TransferCountingData.row74_output_checked
#print axioms Heraclitus.TransferCountingData.row74_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row75_initial_checked"
#check @Heraclitus.TransferCountingData.row75_initial_checked
#print axioms Heraclitus.TransferCountingData.row75_initial_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.TransferCountingData.row75_output_checked"
#check @Heraclitus.TransferCountingData.row75_output_checked
#print axioms Heraclitus.TransferCountingData.row75_output_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperAsymptotic.eventual_upper_of_proposed_envelope"
#check @Heraclitus.UpperAsymptotic.eventual_upper_of_proposed_envelope
#print axioms Heraclitus.UpperAsymptotic.eventual_upper_of_proposed_envelope
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperAsymptotic.eventual_upper_of_scale_bound"
#check @Heraclitus.UpperAsymptotic.eventual_upper_of_scale_bound
#print axioms Heraclitus.UpperAsymptotic.eventual_upper_of_scale_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperAsymptotic.scale_bracket"
#check @Heraclitus.UpperAsymptotic.scale_bracket
#print axioms Heraclitus.UpperAsymptotic.scale_bracket
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperAsymptotic.square_le_pow"
#check @Heraclitus.UpperAsymptotic.square_le_pow
#print axioms Heraclitus.UpperAsymptotic.square_le_pow
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.actual_boundary_tail"
#check @Heraclitus.UpperBoundaryPrefix.actual_boundary_tail
#print axioms Heraclitus.UpperBoundaryPrefix.actual_boundary_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary"
#check @Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary
#print axioms Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary_tail"
#check @Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary_tail
#print axioms Heraclitus.UpperBoundaryPrefix.actual_catalogue_boundary_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.actual_prefix_state"
#check @Heraclitus.UpperBoundaryPrefix.actual_prefix_state
#print axioms Heraclitus.UpperBoundaryPrefix.actual_prefix_state
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.actual_record_tail"
#check @Heraclitus.UpperBoundaryPrefix.actual_record_tail
#print axioms Heraclitus.UpperBoundaryPrefix.actual_record_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.allGood_prefix"
#check @Heraclitus.UpperBoundaryPrefix.allGood_prefix
#print axioms Heraclitus.UpperBoundaryPrefix.allGood_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.all_boundaries"
#check @Heraclitus.UpperBoundaryPrefix.all_boundaries
#print axioms Heraclitus.UpperBoundaryPrefix.all_boundaries
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.inner_membership"
#check @Heraclitus.UpperBoundaryPrefix.inner_membership
#print axioms Heraclitus.UpperBoundaryPrefix.inner_membership
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.original_rule_inner_tail"
#check @Heraclitus.UpperBoundaryPrefix.original_rule_inner_tail
#print axioms Heraclitus.UpperBoundaryPrefix.original_rule_inner_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.record_cover"
#check @Heraclitus.UpperBoundaryPrefix.record_cover
#print axioms Heraclitus.UpperBoundaryPrefix.record_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.record_lift"
#check @Heraclitus.UpperBoundaryPrefix.record_lift
#print axioms Heraclitus.UpperBoundaryPrefix.record_lift
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row40_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row40_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row40_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row40_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row40_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row40_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row41_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row41_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row41_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row41_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row41_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row41_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row42_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row42_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row42_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row42_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row42_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row42_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row43_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row43_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row43_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row43_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row43_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row43_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row44_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row44_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row44_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row44_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row44_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row44_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row45_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row45_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row45_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row45_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row45_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row45_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row46_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row46_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row46_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row46_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row46_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row46_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row47_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row47_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row47_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row47_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row47_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row47_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row48_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row48_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row48_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row48_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row48_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row48_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row49_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row49_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row49_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row49_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row49_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row49_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row50_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row50_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row50_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row50_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row50_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row50_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row51_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row51_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row51_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row51_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row51_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row51_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row52_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row52_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row52_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row52_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row52_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row52_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row53_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row53_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row53_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row53_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row53_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row53_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row54_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row54_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row54_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row54_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row54_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row54_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row55_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row55_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row55_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row55_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row55_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row55_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row56_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row56_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row56_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row56_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row56_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row56_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row57_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row57_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row57_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row57_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row57_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row57_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row58_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row58_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row58_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row58_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row58_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row58_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row59_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row59_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row59_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row59_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row59_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row59_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row60_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row60_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row60_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row60_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row60_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row60_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row61_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row61_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row61_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row61_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row61_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row61_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row62_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row62_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row62_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row62_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row62_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row62_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row63_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row63_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row63_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row63_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row63_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row63_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row64_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row64_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row64_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row64_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row64_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row64_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row65_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row65_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row65_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row65_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row65_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row65_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row66_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row66_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row66_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row66_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row66_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row66_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row67_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row67_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row67_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row67_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row67_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row67_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row68_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row68_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row68_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row68_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row68_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row68_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row69_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row69_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row69_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row69_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row69_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row69_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row70_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row70_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row70_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row70_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row70_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row70_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row71_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row71_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row71_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row71_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row71_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row71_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row72_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row72_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row72_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row72_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row72_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row72_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row73_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row73_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row73_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row73_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row73_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row73_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row74_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row74_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row74_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row74_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row74_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row74_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row75_inner_bound"
#check @Heraclitus.UpperBoundaryPrefix.row75_inner_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row75_inner_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.row75_outer_bound"
#check @Heraclitus.UpperBoundaryPrefix.row75_outer_bound
#print axioms Heraclitus.UpperBoundaryPrefix.row75_outer_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.scheduled_inner_start"
#check @Heraclitus.UpperBoundaryPrefix.scheduled_inner_start
#print axioms Heraclitus.UpperBoundaryPrefix.scheduled_inner_start
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperBoundaryPrefix.wordCheck_take"
#check @Heraclitus.UpperBoundaryPrefix.wordCheck_take
#print axioms Heraclitus.UpperBoundaryPrefix.wordCheck_take
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.allLocal_append"
#check @Heraclitus.UpperKernelCatalogue.allLocal_append
#print axioms Heraclitus.UpperKernelCatalogue.allLocal_append
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.allLocal_prefix"
#check @Heraclitus.UpperKernelCatalogue.allLocal_prefix
#print axioms Heraclitus.UpperKernelCatalogue.allLocal_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.all_approaches"
#check @Heraclitus.UpperKernelCatalogue.all_approaches
#print axioms Heraclitus.UpperKernelCatalogue.all_approaches
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.all_bottom_prefixes"
#check @Heraclitus.UpperKernelCatalogue.all_bottom_prefixes
#print axioms Heraclitus.UpperKernelCatalogue.all_bottom_prefixes
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.all_bottoms"
#check @Heraclitus.UpperKernelCatalogue.all_bottoms
#print axioms Heraclitus.UpperKernelCatalogue.all_bottoms
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.all_transfers"
#check @Heraclitus.UpperKernelCatalogue.all_transfers
#print axioms Heraclitus.UpperKernelCatalogue.all_transfers
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach40_bound"
#check @Heraclitus.UpperKernelCatalogue.approach40_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach40_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach41_bound"
#check @Heraclitus.UpperKernelCatalogue.approach41_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach41_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach42_bound"
#check @Heraclitus.UpperKernelCatalogue.approach42_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach42_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach43_bound"
#check @Heraclitus.UpperKernelCatalogue.approach43_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach43_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach44_bound"
#check @Heraclitus.UpperKernelCatalogue.approach44_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach44_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach45_bound"
#check @Heraclitus.UpperKernelCatalogue.approach45_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach45_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach46_bound"
#check @Heraclitus.UpperKernelCatalogue.approach46_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach46_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach47_bound"
#check @Heraclitus.UpperKernelCatalogue.approach47_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach47_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach48_bound"
#check @Heraclitus.UpperKernelCatalogue.approach48_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach48_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach49_bound"
#check @Heraclitus.UpperKernelCatalogue.approach49_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach49_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach50_bound"
#check @Heraclitus.UpperKernelCatalogue.approach50_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach50_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach51_bound"
#check @Heraclitus.UpperKernelCatalogue.approach51_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach51_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach52_bound"
#check @Heraclitus.UpperKernelCatalogue.approach52_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach52_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach53_bound"
#check @Heraclitus.UpperKernelCatalogue.approach53_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach53_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach54_bound"
#check @Heraclitus.UpperKernelCatalogue.approach54_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach54_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach55_bound"
#check @Heraclitus.UpperKernelCatalogue.approach55_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach55_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach56_bound"
#check @Heraclitus.UpperKernelCatalogue.approach56_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach56_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach57_bound"
#check @Heraclitus.UpperKernelCatalogue.approach57_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach57_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach58_bound"
#check @Heraclitus.UpperKernelCatalogue.approach58_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach58_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach59_bound"
#check @Heraclitus.UpperKernelCatalogue.approach59_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach59_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach60_bound"
#check @Heraclitus.UpperKernelCatalogue.approach60_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach60_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach61_bound"
#check @Heraclitus.UpperKernelCatalogue.approach61_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach61_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach62_bound"
#check @Heraclitus.UpperKernelCatalogue.approach62_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach62_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach63_bound"
#check @Heraclitus.UpperKernelCatalogue.approach63_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach63_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach64_bound"
#check @Heraclitus.UpperKernelCatalogue.approach64_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach64_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach65_bound"
#check @Heraclitus.UpperKernelCatalogue.approach65_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach65_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach66_bound"
#check @Heraclitus.UpperKernelCatalogue.approach66_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach66_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach67_bound"
#check @Heraclitus.UpperKernelCatalogue.approach67_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach67_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach68_bound"
#check @Heraclitus.UpperKernelCatalogue.approach68_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach68_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach69_bound"
#check @Heraclitus.UpperKernelCatalogue.approach69_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach69_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach70_bound"
#check @Heraclitus.UpperKernelCatalogue.approach70_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach70_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach71_bound"
#check @Heraclitus.UpperKernelCatalogue.approach71_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach71_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach72_bound"
#check @Heraclitus.UpperKernelCatalogue.approach72_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach72_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach73_bound"
#check @Heraclitus.UpperKernelCatalogue.approach73_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach73_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach74_bound"
#check @Heraclitus.UpperKernelCatalogue.approach74_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach74_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.approach75_bound"
#check @Heraclitus.UpperKernelCatalogue.approach75_bound
#print axioms Heraclitus.UpperKernelCatalogue.approach75_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom00_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom00_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom00_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom00_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom00_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom01_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom01_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom01_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom01_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom01_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom02_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom02_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom02_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom02_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom02_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom03_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom03_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom03_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom03_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom03_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom04_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom04_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom04_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom04_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom04_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom04_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom05_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom05_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom05_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom05_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom05_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom05_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom06_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom06_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom06_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom06_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom06_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom06_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom07_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom07_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom07_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom07_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom07_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom07_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom08_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom08_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom08_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom08_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom08_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom08_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom09_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom09_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom09_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom09_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom09_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom09_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom10_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom10_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom10_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom10_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom10_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom10_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom11_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom11_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom11_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom11_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom11_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom11_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom12_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom12_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom12_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom12_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom12_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom12_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom13_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom13_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom13_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom13_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom13_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom13_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom14_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom14_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom14_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom14_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom14_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom14_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom15_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom15_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom15_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom15_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom15_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom15_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom16_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom16_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom16_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom16_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom16_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom16_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom17_bound"
#check @Heraclitus.UpperKernelCatalogue.bottom17_bound
#print axioms Heraclitus.UpperKernelCatalogue.bottom17_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom17_chunks"
#check @Heraclitus.UpperKernelCatalogue.bottom17_chunks
#print axioms Heraclitus.UpperKernelCatalogue.bottom17_chunks
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.bottom_allLocal"
#check @Heraclitus.UpperKernelCatalogue.bottom_allLocal
#print axioms Heraclitus.UpperKernelCatalogue.bottom_allLocal
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.checkLocals_sound"
#check @Heraclitus.UpperKernelCatalogue.checkLocals_sound
#print axioms Heraclitus.UpperKernelCatalogue.checkLocals_sound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk000_local"
#check @Heraclitus.UpperKernelCatalogue.chunk000_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk000_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk001_local"
#check @Heraclitus.UpperKernelCatalogue.chunk001_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk001_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk002_local"
#check @Heraclitus.UpperKernelCatalogue.chunk002_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk002_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk003_local"
#check @Heraclitus.UpperKernelCatalogue.chunk003_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk003_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk004_local"
#check @Heraclitus.UpperKernelCatalogue.chunk004_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk004_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk005_local"
#check @Heraclitus.UpperKernelCatalogue.chunk005_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk005_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk006_local"
#check @Heraclitus.UpperKernelCatalogue.chunk006_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk006_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk007_local"
#check @Heraclitus.UpperKernelCatalogue.chunk007_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk007_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk008_local"
#check @Heraclitus.UpperKernelCatalogue.chunk008_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk008_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk009_local"
#check @Heraclitus.UpperKernelCatalogue.chunk009_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk009_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk010_local"
#check @Heraclitus.UpperKernelCatalogue.chunk010_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk010_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk011_local"
#check @Heraclitus.UpperKernelCatalogue.chunk011_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk011_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk012_local"
#check @Heraclitus.UpperKernelCatalogue.chunk012_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk012_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk013_local"
#check @Heraclitus.UpperKernelCatalogue.chunk013_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk013_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk014_local"
#check @Heraclitus.UpperKernelCatalogue.chunk014_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk014_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk015_local"
#check @Heraclitus.UpperKernelCatalogue.chunk015_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk015_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk016_local"
#check @Heraclitus.UpperKernelCatalogue.chunk016_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk016_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk017_local"
#check @Heraclitus.UpperKernelCatalogue.chunk017_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk017_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk018_local"
#check @Heraclitus.UpperKernelCatalogue.chunk018_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk018_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk019_local"
#check @Heraclitus.UpperKernelCatalogue.chunk019_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk019_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk020_local"
#check @Heraclitus.UpperKernelCatalogue.chunk020_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk020_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk021_local"
#check @Heraclitus.UpperKernelCatalogue.chunk021_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk021_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk022_local"
#check @Heraclitus.UpperKernelCatalogue.chunk022_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk022_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk023_local"
#check @Heraclitus.UpperKernelCatalogue.chunk023_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk023_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk024_local"
#check @Heraclitus.UpperKernelCatalogue.chunk024_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk024_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk025_local"
#check @Heraclitus.UpperKernelCatalogue.chunk025_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk025_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk026_local"
#check @Heraclitus.UpperKernelCatalogue.chunk026_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk026_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk027_local"
#check @Heraclitus.UpperKernelCatalogue.chunk027_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk027_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk028_local"
#check @Heraclitus.UpperKernelCatalogue.chunk028_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk028_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk029_local"
#check @Heraclitus.UpperKernelCatalogue.chunk029_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk029_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk030_local"
#check @Heraclitus.UpperKernelCatalogue.chunk030_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk030_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk031_local"
#check @Heraclitus.UpperKernelCatalogue.chunk031_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk031_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk032_local"
#check @Heraclitus.UpperKernelCatalogue.chunk032_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk032_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk033_local"
#check @Heraclitus.UpperKernelCatalogue.chunk033_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk033_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk034_local"
#check @Heraclitus.UpperKernelCatalogue.chunk034_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk034_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk035_local"
#check @Heraclitus.UpperKernelCatalogue.chunk035_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk035_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk036_local"
#check @Heraclitus.UpperKernelCatalogue.chunk036_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk036_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk037_local"
#check @Heraclitus.UpperKernelCatalogue.chunk037_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk037_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk038_local"
#check @Heraclitus.UpperKernelCatalogue.chunk038_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk038_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk039_local"
#check @Heraclitus.UpperKernelCatalogue.chunk039_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk039_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk040_local"
#check @Heraclitus.UpperKernelCatalogue.chunk040_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk040_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk041_local"
#check @Heraclitus.UpperKernelCatalogue.chunk041_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk041_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk042_local"
#check @Heraclitus.UpperKernelCatalogue.chunk042_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk042_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk043_local"
#check @Heraclitus.UpperKernelCatalogue.chunk043_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk043_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk044_local"
#check @Heraclitus.UpperKernelCatalogue.chunk044_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk044_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk045_local"
#check @Heraclitus.UpperKernelCatalogue.chunk045_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk045_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk046_local"
#check @Heraclitus.UpperKernelCatalogue.chunk046_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk046_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk047_local"
#check @Heraclitus.UpperKernelCatalogue.chunk047_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk047_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk048_local"
#check @Heraclitus.UpperKernelCatalogue.chunk048_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk048_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk049_local"
#check @Heraclitus.UpperKernelCatalogue.chunk049_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk049_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk050_local"
#check @Heraclitus.UpperKernelCatalogue.chunk050_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk050_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk051_local"
#check @Heraclitus.UpperKernelCatalogue.chunk051_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk051_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk052_local"
#check @Heraclitus.UpperKernelCatalogue.chunk052_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk052_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk053_local"
#check @Heraclitus.UpperKernelCatalogue.chunk053_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk053_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk054_local"
#check @Heraclitus.UpperKernelCatalogue.chunk054_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk054_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk055_local"
#check @Heraclitus.UpperKernelCatalogue.chunk055_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk055_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk056_local"
#check @Heraclitus.UpperKernelCatalogue.chunk056_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk056_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk057_local"
#check @Heraclitus.UpperKernelCatalogue.chunk057_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk057_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk058_local"
#check @Heraclitus.UpperKernelCatalogue.chunk058_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk058_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk059_local"
#check @Heraclitus.UpperKernelCatalogue.chunk059_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk059_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk060_local"
#check @Heraclitus.UpperKernelCatalogue.chunk060_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk060_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk061_local"
#check @Heraclitus.UpperKernelCatalogue.chunk061_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk061_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk062_local"
#check @Heraclitus.UpperKernelCatalogue.chunk062_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk062_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk063_local"
#check @Heraclitus.UpperKernelCatalogue.chunk063_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk063_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk064_local"
#check @Heraclitus.UpperKernelCatalogue.chunk064_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk064_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk065_local"
#check @Heraclitus.UpperKernelCatalogue.chunk065_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk065_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk066_local"
#check @Heraclitus.UpperKernelCatalogue.chunk066_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk066_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk067_local"
#check @Heraclitus.UpperKernelCatalogue.chunk067_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk067_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk068_local"
#check @Heraclitus.UpperKernelCatalogue.chunk068_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk068_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk069_local"
#check @Heraclitus.UpperKernelCatalogue.chunk069_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk069_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk070_local"
#check @Heraclitus.UpperKernelCatalogue.chunk070_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk070_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk071_local"
#check @Heraclitus.UpperKernelCatalogue.chunk071_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk071_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk072_local"
#check @Heraclitus.UpperKernelCatalogue.chunk072_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk072_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk073_local"
#check @Heraclitus.UpperKernelCatalogue.chunk073_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk073_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk074_local"
#check @Heraclitus.UpperKernelCatalogue.chunk074_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk074_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk075_local"
#check @Heraclitus.UpperKernelCatalogue.chunk075_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk075_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk076_local"
#check @Heraclitus.UpperKernelCatalogue.chunk076_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk076_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk077_local"
#check @Heraclitus.UpperKernelCatalogue.chunk077_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk077_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk078_local"
#check @Heraclitus.UpperKernelCatalogue.chunk078_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk078_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk079_local"
#check @Heraclitus.UpperKernelCatalogue.chunk079_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk079_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk080_local"
#check @Heraclitus.UpperKernelCatalogue.chunk080_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk080_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk081_local"
#check @Heraclitus.UpperKernelCatalogue.chunk081_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk081_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk082_local"
#check @Heraclitus.UpperKernelCatalogue.chunk082_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk082_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk083_local"
#check @Heraclitus.UpperKernelCatalogue.chunk083_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk083_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk084_local"
#check @Heraclitus.UpperKernelCatalogue.chunk084_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk084_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk085_local"
#check @Heraclitus.UpperKernelCatalogue.chunk085_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk085_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk086_local"
#check @Heraclitus.UpperKernelCatalogue.chunk086_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk086_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk087_local"
#check @Heraclitus.UpperKernelCatalogue.chunk087_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk087_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk088_local"
#check @Heraclitus.UpperKernelCatalogue.chunk088_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk088_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk089_local"
#check @Heraclitus.UpperKernelCatalogue.chunk089_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk089_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk090_local"
#check @Heraclitus.UpperKernelCatalogue.chunk090_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk090_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk091_local"
#check @Heraclitus.UpperKernelCatalogue.chunk091_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk091_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk092_local"
#check @Heraclitus.UpperKernelCatalogue.chunk092_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk092_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk093_local"
#check @Heraclitus.UpperKernelCatalogue.chunk093_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk093_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk094_local"
#check @Heraclitus.UpperKernelCatalogue.chunk094_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk094_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk095_local"
#check @Heraclitus.UpperKernelCatalogue.chunk095_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk095_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk096_local"
#check @Heraclitus.UpperKernelCatalogue.chunk096_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk096_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk097_local"
#check @Heraclitus.UpperKernelCatalogue.chunk097_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk097_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk098_local"
#check @Heraclitus.UpperKernelCatalogue.chunk098_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk098_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk099_local"
#check @Heraclitus.UpperKernelCatalogue.chunk099_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk099_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk100_local"
#check @Heraclitus.UpperKernelCatalogue.chunk100_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk100_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk101_local"
#check @Heraclitus.UpperKernelCatalogue.chunk101_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk101_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk102_local"
#check @Heraclitus.UpperKernelCatalogue.chunk102_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk102_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk103_local"
#check @Heraclitus.UpperKernelCatalogue.chunk103_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk103_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk104_local"
#check @Heraclitus.UpperKernelCatalogue.chunk104_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk104_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk105_local"
#check @Heraclitus.UpperKernelCatalogue.chunk105_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk105_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk106_local"
#check @Heraclitus.UpperKernelCatalogue.chunk106_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk106_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk107_local"
#check @Heraclitus.UpperKernelCatalogue.chunk107_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk107_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk108_local"
#check @Heraclitus.UpperKernelCatalogue.chunk108_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk108_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk109_local"
#check @Heraclitus.UpperKernelCatalogue.chunk109_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk109_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk110_local"
#check @Heraclitus.UpperKernelCatalogue.chunk110_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk110_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk111_local"
#check @Heraclitus.UpperKernelCatalogue.chunk111_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk111_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk112_local"
#check @Heraclitus.UpperKernelCatalogue.chunk112_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk112_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk113_local"
#check @Heraclitus.UpperKernelCatalogue.chunk113_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk113_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk114_local"
#check @Heraclitus.UpperKernelCatalogue.chunk114_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk114_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk115_local"
#check @Heraclitus.UpperKernelCatalogue.chunk115_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk115_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk116_local"
#check @Heraclitus.UpperKernelCatalogue.chunk116_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk116_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk117_local"
#check @Heraclitus.UpperKernelCatalogue.chunk117_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk117_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk118_local"
#check @Heraclitus.UpperKernelCatalogue.chunk118_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk118_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk119_local"
#check @Heraclitus.UpperKernelCatalogue.chunk119_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk119_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk120_local"
#check @Heraclitus.UpperKernelCatalogue.chunk120_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk120_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk121_local"
#check @Heraclitus.UpperKernelCatalogue.chunk121_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk121_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk122_local"
#check @Heraclitus.UpperKernelCatalogue.chunk122_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk122_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk123_local"
#check @Heraclitus.UpperKernelCatalogue.chunk123_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk123_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk124_local"
#check @Heraclitus.UpperKernelCatalogue.chunk124_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk124_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk125_local"
#check @Heraclitus.UpperKernelCatalogue.chunk125_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk125_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk126_local"
#check @Heraclitus.UpperKernelCatalogue.chunk126_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk126_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk127_local"
#check @Heraclitus.UpperKernelCatalogue.chunk127_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk127_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk128_local"
#check @Heraclitus.UpperKernelCatalogue.chunk128_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk128_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk129_local"
#check @Heraclitus.UpperKernelCatalogue.chunk129_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk129_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk130_local"
#check @Heraclitus.UpperKernelCatalogue.chunk130_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk130_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk131_local"
#check @Heraclitus.UpperKernelCatalogue.chunk131_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk131_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk132_local"
#check @Heraclitus.UpperKernelCatalogue.chunk132_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk132_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk133_local"
#check @Heraclitus.UpperKernelCatalogue.chunk133_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk133_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk134_local"
#check @Heraclitus.UpperKernelCatalogue.chunk134_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk134_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk135_local"
#check @Heraclitus.UpperKernelCatalogue.chunk135_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk135_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk136_local"
#check @Heraclitus.UpperKernelCatalogue.chunk136_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk136_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk137_local"
#check @Heraclitus.UpperKernelCatalogue.chunk137_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk137_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk138_local"
#check @Heraclitus.UpperKernelCatalogue.chunk138_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk138_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk139_local"
#check @Heraclitus.UpperKernelCatalogue.chunk139_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk139_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk140_local"
#check @Heraclitus.UpperKernelCatalogue.chunk140_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk140_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk141_local"
#check @Heraclitus.UpperKernelCatalogue.chunk141_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk141_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk142_local"
#check @Heraclitus.UpperKernelCatalogue.chunk142_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk142_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk143_local"
#check @Heraclitus.UpperKernelCatalogue.chunk143_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk143_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk144_local"
#check @Heraclitus.UpperKernelCatalogue.chunk144_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk144_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk145_local"
#check @Heraclitus.UpperKernelCatalogue.chunk145_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk145_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk146_local"
#check @Heraclitus.UpperKernelCatalogue.chunk146_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk146_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk147_local"
#check @Heraclitus.UpperKernelCatalogue.chunk147_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk147_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk148_local"
#check @Heraclitus.UpperKernelCatalogue.chunk148_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk148_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk149_local"
#check @Heraclitus.UpperKernelCatalogue.chunk149_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk149_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk150_local"
#check @Heraclitus.UpperKernelCatalogue.chunk150_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk150_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk151_local"
#check @Heraclitus.UpperKernelCatalogue.chunk151_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk151_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk152_local"
#check @Heraclitus.UpperKernelCatalogue.chunk152_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk152_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk153_local"
#check @Heraclitus.UpperKernelCatalogue.chunk153_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk153_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk154_local"
#check @Heraclitus.UpperKernelCatalogue.chunk154_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk154_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk155_local"
#check @Heraclitus.UpperKernelCatalogue.chunk155_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk155_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk156_local"
#check @Heraclitus.UpperKernelCatalogue.chunk156_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk156_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk157_local"
#check @Heraclitus.UpperKernelCatalogue.chunk157_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk157_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk158_local"
#check @Heraclitus.UpperKernelCatalogue.chunk158_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk158_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk159_local"
#check @Heraclitus.UpperKernelCatalogue.chunk159_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk159_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk160_local"
#check @Heraclitus.UpperKernelCatalogue.chunk160_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk160_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk161_local"
#check @Heraclitus.UpperKernelCatalogue.chunk161_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk161_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk162_local"
#check @Heraclitus.UpperKernelCatalogue.chunk162_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk162_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk163_local"
#check @Heraclitus.UpperKernelCatalogue.chunk163_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk163_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk164_local"
#check @Heraclitus.UpperKernelCatalogue.chunk164_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk164_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk165_local"
#check @Heraclitus.UpperKernelCatalogue.chunk165_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk165_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk166_local"
#check @Heraclitus.UpperKernelCatalogue.chunk166_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk166_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk167_local"
#check @Heraclitus.UpperKernelCatalogue.chunk167_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk167_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk168_local"
#check @Heraclitus.UpperKernelCatalogue.chunk168_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk168_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk169_local"
#check @Heraclitus.UpperKernelCatalogue.chunk169_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk169_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk170_local"
#check @Heraclitus.UpperKernelCatalogue.chunk170_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk170_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk171_local"
#check @Heraclitus.UpperKernelCatalogue.chunk171_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk171_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk172_local"
#check @Heraclitus.UpperKernelCatalogue.chunk172_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk172_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk173_local"
#check @Heraclitus.UpperKernelCatalogue.chunk173_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk173_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk174_local"
#check @Heraclitus.UpperKernelCatalogue.chunk174_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk174_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk175_local"
#check @Heraclitus.UpperKernelCatalogue.chunk175_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk175_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk176_local"
#check @Heraclitus.UpperKernelCatalogue.chunk176_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk176_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk177_local"
#check @Heraclitus.UpperKernelCatalogue.chunk177_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk177_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk178_local"
#check @Heraclitus.UpperKernelCatalogue.chunk178_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk178_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk179_local"
#check @Heraclitus.UpperKernelCatalogue.chunk179_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk179_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk180_local"
#check @Heraclitus.UpperKernelCatalogue.chunk180_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk180_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk181_local"
#check @Heraclitus.UpperKernelCatalogue.chunk181_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk181_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk182_local"
#check @Heraclitus.UpperKernelCatalogue.chunk182_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk182_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk183_local"
#check @Heraclitus.UpperKernelCatalogue.chunk183_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk183_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk184_local"
#check @Heraclitus.UpperKernelCatalogue.chunk184_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk184_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk185_local"
#check @Heraclitus.UpperKernelCatalogue.chunk185_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk185_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk186_local"
#check @Heraclitus.UpperKernelCatalogue.chunk186_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk186_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk187_local"
#check @Heraclitus.UpperKernelCatalogue.chunk187_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk187_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk188_local"
#check @Heraclitus.UpperKernelCatalogue.chunk188_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk188_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk189_local"
#check @Heraclitus.UpperKernelCatalogue.chunk189_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk189_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk190_local"
#check @Heraclitus.UpperKernelCatalogue.chunk190_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk190_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk191_local"
#check @Heraclitus.UpperKernelCatalogue.chunk191_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk191_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk192_local"
#check @Heraclitus.UpperKernelCatalogue.chunk192_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk192_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk193_local"
#check @Heraclitus.UpperKernelCatalogue.chunk193_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk193_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk194_local"
#check @Heraclitus.UpperKernelCatalogue.chunk194_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk194_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk195_local"
#check @Heraclitus.UpperKernelCatalogue.chunk195_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk195_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk196_local"
#check @Heraclitus.UpperKernelCatalogue.chunk196_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk196_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk197_local"
#check @Heraclitus.UpperKernelCatalogue.chunk197_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk197_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk198_local"
#check @Heraclitus.UpperKernelCatalogue.chunk198_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk198_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk199_local"
#check @Heraclitus.UpperKernelCatalogue.chunk199_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk199_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk200_local"
#check @Heraclitus.UpperKernelCatalogue.chunk200_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk200_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk201_local"
#check @Heraclitus.UpperKernelCatalogue.chunk201_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk201_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk202_local"
#check @Heraclitus.UpperKernelCatalogue.chunk202_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk202_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk203_local"
#check @Heraclitus.UpperKernelCatalogue.chunk203_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk203_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk204_local"
#check @Heraclitus.UpperKernelCatalogue.chunk204_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk204_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk205_local"
#check @Heraclitus.UpperKernelCatalogue.chunk205_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk205_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk206_local"
#check @Heraclitus.UpperKernelCatalogue.chunk206_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk206_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk207_local"
#check @Heraclitus.UpperKernelCatalogue.chunk207_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk207_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk208_local"
#check @Heraclitus.UpperKernelCatalogue.chunk208_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk208_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk209_local"
#check @Heraclitus.UpperKernelCatalogue.chunk209_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk209_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk210_local"
#check @Heraclitus.UpperKernelCatalogue.chunk210_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk210_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk211_local"
#check @Heraclitus.UpperKernelCatalogue.chunk211_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk211_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk212_local"
#check @Heraclitus.UpperKernelCatalogue.chunk212_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk212_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk213_local"
#check @Heraclitus.UpperKernelCatalogue.chunk213_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk213_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk214_local"
#check @Heraclitus.UpperKernelCatalogue.chunk214_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk214_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk215_local"
#check @Heraclitus.UpperKernelCatalogue.chunk215_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk215_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk216_local"
#check @Heraclitus.UpperKernelCatalogue.chunk216_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk216_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk217_local"
#check @Heraclitus.UpperKernelCatalogue.chunk217_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk217_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk218_local"
#check @Heraclitus.UpperKernelCatalogue.chunk218_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk218_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk219_local"
#check @Heraclitus.UpperKernelCatalogue.chunk219_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk219_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk220_local"
#check @Heraclitus.UpperKernelCatalogue.chunk220_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk220_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk221_local"
#check @Heraclitus.UpperKernelCatalogue.chunk221_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk221_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk222_local"
#check @Heraclitus.UpperKernelCatalogue.chunk222_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk222_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk223_local"
#check @Heraclitus.UpperKernelCatalogue.chunk223_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk223_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk224_local"
#check @Heraclitus.UpperKernelCatalogue.chunk224_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk224_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk225_local"
#check @Heraclitus.UpperKernelCatalogue.chunk225_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk225_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk226_local"
#check @Heraclitus.UpperKernelCatalogue.chunk226_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk226_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk227_local"
#check @Heraclitus.UpperKernelCatalogue.chunk227_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk227_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk228_local"
#check @Heraclitus.UpperKernelCatalogue.chunk228_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk228_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk229_local"
#check @Heraclitus.UpperKernelCatalogue.chunk229_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk229_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk230_local"
#check @Heraclitus.UpperKernelCatalogue.chunk230_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk230_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk231_local"
#check @Heraclitus.UpperKernelCatalogue.chunk231_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk231_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk232_local"
#check @Heraclitus.UpperKernelCatalogue.chunk232_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk232_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk233_local"
#check @Heraclitus.UpperKernelCatalogue.chunk233_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk233_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk234_local"
#check @Heraclitus.UpperKernelCatalogue.chunk234_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk234_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk235_local"
#check @Heraclitus.UpperKernelCatalogue.chunk235_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk235_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk236_local"
#check @Heraclitus.UpperKernelCatalogue.chunk236_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk236_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk237_local"
#check @Heraclitus.UpperKernelCatalogue.chunk237_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk237_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk238_local"
#check @Heraclitus.UpperKernelCatalogue.chunk238_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk238_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk239_local"
#check @Heraclitus.UpperKernelCatalogue.chunk239_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk239_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk240_local"
#check @Heraclitus.UpperKernelCatalogue.chunk240_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk240_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk241_local"
#check @Heraclitus.UpperKernelCatalogue.chunk241_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk241_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk242_local"
#check @Heraclitus.UpperKernelCatalogue.chunk242_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk242_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk243_local"
#check @Heraclitus.UpperKernelCatalogue.chunk243_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk243_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk244_local"
#check @Heraclitus.UpperKernelCatalogue.chunk244_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk244_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk245_local"
#check @Heraclitus.UpperKernelCatalogue.chunk245_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk245_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk246_local"
#check @Heraclitus.UpperKernelCatalogue.chunk246_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk246_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk247_local"
#check @Heraclitus.UpperKernelCatalogue.chunk247_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk247_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk248_local"
#check @Heraclitus.UpperKernelCatalogue.chunk248_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk248_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk249_local"
#check @Heraclitus.UpperKernelCatalogue.chunk249_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk249_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk250_local"
#check @Heraclitus.UpperKernelCatalogue.chunk250_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk250_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk251_local"
#check @Heraclitus.UpperKernelCatalogue.chunk251_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk251_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk252_local"
#check @Heraclitus.UpperKernelCatalogue.chunk252_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk252_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk253_local"
#check @Heraclitus.UpperKernelCatalogue.chunk253_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk253_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk254_local"
#check @Heraclitus.UpperKernelCatalogue.chunk254_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk254_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk255_local"
#check @Heraclitus.UpperKernelCatalogue.chunk255_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk255_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk256_local"
#check @Heraclitus.UpperKernelCatalogue.chunk256_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk256_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk257_local"
#check @Heraclitus.UpperKernelCatalogue.chunk257_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk257_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk258_local"
#check @Heraclitus.UpperKernelCatalogue.chunk258_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk258_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk259_local"
#check @Heraclitus.UpperKernelCatalogue.chunk259_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk259_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk260_local"
#check @Heraclitus.UpperKernelCatalogue.chunk260_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk260_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk261_local"
#check @Heraclitus.UpperKernelCatalogue.chunk261_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk261_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk262_local"
#check @Heraclitus.UpperKernelCatalogue.chunk262_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk262_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk263_local"
#check @Heraclitus.UpperKernelCatalogue.chunk263_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk263_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk264_local"
#check @Heraclitus.UpperKernelCatalogue.chunk264_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk264_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk265_local"
#check @Heraclitus.UpperKernelCatalogue.chunk265_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk265_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk266_local"
#check @Heraclitus.UpperKernelCatalogue.chunk266_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk266_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk267_local"
#check @Heraclitus.UpperKernelCatalogue.chunk267_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk267_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk268_local"
#check @Heraclitus.UpperKernelCatalogue.chunk268_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk268_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk269_local"
#check @Heraclitus.UpperKernelCatalogue.chunk269_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk269_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk270_local"
#check @Heraclitus.UpperKernelCatalogue.chunk270_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk270_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk271_local"
#check @Heraclitus.UpperKernelCatalogue.chunk271_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk271_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk272_local"
#check @Heraclitus.UpperKernelCatalogue.chunk272_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk272_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk273_local"
#check @Heraclitus.UpperKernelCatalogue.chunk273_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk273_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk274_local"
#check @Heraclitus.UpperKernelCatalogue.chunk274_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk274_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk275_local"
#check @Heraclitus.UpperKernelCatalogue.chunk275_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk275_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk276_local"
#check @Heraclitus.UpperKernelCatalogue.chunk276_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk276_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk277_local"
#check @Heraclitus.UpperKernelCatalogue.chunk277_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk277_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk278_local"
#check @Heraclitus.UpperKernelCatalogue.chunk278_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk278_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk279_local"
#check @Heraclitus.UpperKernelCatalogue.chunk279_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk279_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk280_local"
#check @Heraclitus.UpperKernelCatalogue.chunk280_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk280_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk281_local"
#check @Heraclitus.UpperKernelCatalogue.chunk281_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk281_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk282_local"
#check @Heraclitus.UpperKernelCatalogue.chunk282_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk282_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk283_local"
#check @Heraclitus.UpperKernelCatalogue.chunk283_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk283_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk284_local"
#check @Heraclitus.UpperKernelCatalogue.chunk284_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk284_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk285_local"
#check @Heraclitus.UpperKernelCatalogue.chunk285_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk285_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk286_local"
#check @Heraclitus.UpperKernelCatalogue.chunk286_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk286_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk287_local"
#check @Heraclitus.UpperKernelCatalogue.chunk287_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk287_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk288_local"
#check @Heraclitus.UpperKernelCatalogue.chunk288_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk288_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk289_local"
#check @Heraclitus.UpperKernelCatalogue.chunk289_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk289_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk290_local"
#check @Heraclitus.UpperKernelCatalogue.chunk290_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk290_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk291_local"
#check @Heraclitus.UpperKernelCatalogue.chunk291_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk291_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk292_local"
#check @Heraclitus.UpperKernelCatalogue.chunk292_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk292_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk293_local"
#check @Heraclitus.UpperKernelCatalogue.chunk293_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk293_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk294_local"
#check @Heraclitus.UpperKernelCatalogue.chunk294_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk294_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk295_local"
#check @Heraclitus.UpperKernelCatalogue.chunk295_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk295_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk296_local"
#check @Heraclitus.UpperKernelCatalogue.chunk296_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk296_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk297_local"
#check @Heraclitus.UpperKernelCatalogue.chunk297_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk297_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk298_local"
#check @Heraclitus.UpperKernelCatalogue.chunk298_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk298_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk299_local"
#check @Heraclitus.UpperKernelCatalogue.chunk299_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk299_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk300_local"
#check @Heraclitus.UpperKernelCatalogue.chunk300_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk300_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk301_local"
#check @Heraclitus.UpperKernelCatalogue.chunk301_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk301_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk302_local"
#check @Heraclitus.UpperKernelCatalogue.chunk302_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk302_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk303_local"
#check @Heraclitus.UpperKernelCatalogue.chunk303_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk303_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk304_local"
#check @Heraclitus.UpperKernelCatalogue.chunk304_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk304_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk305_local"
#check @Heraclitus.UpperKernelCatalogue.chunk305_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk305_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk306_local"
#check @Heraclitus.UpperKernelCatalogue.chunk306_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk306_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk307_local"
#check @Heraclitus.UpperKernelCatalogue.chunk307_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk307_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk308_local"
#check @Heraclitus.UpperKernelCatalogue.chunk308_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk308_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk309_local"
#check @Heraclitus.UpperKernelCatalogue.chunk309_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk309_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk310_local"
#check @Heraclitus.UpperKernelCatalogue.chunk310_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk310_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk311_local"
#check @Heraclitus.UpperKernelCatalogue.chunk311_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk311_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk312_local"
#check @Heraclitus.UpperKernelCatalogue.chunk312_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk312_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk313_local"
#check @Heraclitus.UpperKernelCatalogue.chunk313_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk313_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk314_local"
#check @Heraclitus.UpperKernelCatalogue.chunk314_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk314_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk315_local"
#check @Heraclitus.UpperKernelCatalogue.chunk315_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk315_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk316_local"
#check @Heraclitus.UpperKernelCatalogue.chunk316_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk316_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk317_local"
#check @Heraclitus.UpperKernelCatalogue.chunk317_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk317_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk318_local"
#check @Heraclitus.UpperKernelCatalogue.chunk318_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk318_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk319_local"
#check @Heraclitus.UpperKernelCatalogue.chunk319_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk319_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk320_local"
#check @Heraclitus.UpperKernelCatalogue.chunk320_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk320_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk321_local"
#check @Heraclitus.UpperKernelCatalogue.chunk321_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk321_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk322_local"
#check @Heraclitus.UpperKernelCatalogue.chunk322_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk322_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk323_local"
#check @Heraclitus.UpperKernelCatalogue.chunk323_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk323_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk324_local"
#check @Heraclitus.UpperKernelCatalogue.chunk324_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk324_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk325_local"
#check @Heraclitus.UpperKernelCatalogue.chunk325_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk325_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk326_local"
#check @Heraclitus.UpperKernelCatalogue.chunk326_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk326_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk327_local"
#check @Heraclitus.UpperKernelCatalogue.chunk327_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk327_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk328_local"
#check @Heraclitus.UpperKernelCatalogue.chunk328_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk328_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk329_local"
#check @Heraclitus.UpperKernelCatalogue.chunk329_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk329_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk330_local"
#check @Heraclitus.UpperKernelCatalogue.chunk330_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk330_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk331_local"
#check @Heraclitus.UpperKernelCatalogue.chunk331_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk331_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk332_local"
#check @Heraclitus.UpperKernelCatalogue.chunk332_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk332_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk333_local"
#check @Heraclitus.UpperKernelCatalogue.chunk333_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk333_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk334_local"
#check @Heraclitus.UpperKernelCatalogue.chunk334_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk334_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk335_local"
#check @Heraclitus.UpperKernelCatalogue.chunk335_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk335_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk336_local"
#check @Heraclitus.UpperKernelCatalogue.chunk336_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk336_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk337_local"
#check @Heraclitus.UpperKernelCatalogue.chunk337_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk337_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk338_local"
#check @Heraclitus.UpperKernelCatalogue.chunk338_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk338_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk339_local"
#check @Heraclitus.UpperKernelCatalogue.chunk339_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk339_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk340_local"
#check @Heraclitus.UpperKernelCatalogue.chunk340_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk340_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk341_local"
#check @Heraclitus.UpperKernelCatalogue.chunk341_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk341_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk342_local"
#check @Heraclitus.UpperKernelCatalogue.chunk342_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk342_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk343_local"
#check @Heraclitus.UpperKernelCatalogue.chunk343_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk343_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk344_local"
#check @Heraclitus.UpperKernelCatalogue.chunk344_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk344_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk345_local"
#check @Heraclitus.UpperKernelCatalogue.chunk345_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk345_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk346_local"
#check @Heraclitus.UpperKernelCatalogue.chunk346_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk346_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk347_local"
#check @Heraclitus.UpperKernelCatalogue.chunk347_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk347_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk348_local"
#check @Heraclitus.UpperKernelCatalogue.chunk348_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk348_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk349_local"
#check @Heraclitus.UpperKernelCatalogue.chunk349_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk349_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk350_local"
#check @Heraclitus.UpperKernelCatalogue.chunk350_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk350_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk351_local"
#check @Heraclitus.UpperKernelCatalogue.chunk351_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk351_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk352_local"
#check @Heraclitus.UpperKernelCatalogue.chunk352_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk352_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk353_local"
#check @Heraclitus.UpperKernelCatalogue.chunk353_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk353_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk354_local"
#check @Heraclitus.UpperKernelCatalogue.chunk354_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk354_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk355_local"
#check @Heraclitus.UpperKernelCatalogue.chunk355_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk355_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk356_local"
#check @Heraclitus.UpperKernelCatalogue.chunk356_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk356_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk357_local"
#check @Heraclitus.UpperKernelCatalogue.chunk357_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk357_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk358_local"
#check @Heraclitus.UpperKernelCatalogue.chunk358_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk358_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk359_local"
#check @Heraclitus.UpperKernelCatalogue.chunk359_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk359_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk360_local"
#check @Heraclitus.UpperKernelCatalogue.chunk360_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk360_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk361_local"
#check @Heraclitus.UpperKernelCatalogue.chunk361_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk361_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk362_local"
#check @Heraclitus.UpperKernelCatalogue.chunk362_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk362_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk363_local"
#check @Heraclitus.UpperKernelCatalogue.chunk363_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk363_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk364_local"
#check @Heraclitus.UpperKernelCatalogue.chunk364_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk364_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk365_local"
#check @Heraclitus.UpperKernelCatalogue.chunk365_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk365_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk366_local"
#check @Heraclitus.UpperKernelCatalogue.chunk366_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk366_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk367_local"
#check @Heraclitus.UpperKernelCatalogue.chunk367_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk367_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk368_local"
#check @Heraclitus.UpperKernelCatalogue.chunk368_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk368_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk369_local"
#check @Heraclitus.UpperKernelCatalogue.chunk369_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk369_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk370_local"
#check @Heraclitus.UpperKernelCatalogue.chunk370_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk370_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk371_local"
#check @Heraclitus.UpperKernelCatalogue.chunk371_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk371_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk372_local"
#check @Heraclitus.UpperKernelCatalogue.chunk372_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk372_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk373_local"
#check @Heraclitus.UpperKernelCatalogue.chunk373_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk373_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk374_local"
#check @Heraclitus.UpperKernelCatalogue.chunk374_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk374_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk375_local"
#check @Heraclitus.UpperKernelCatalogue.chunk375_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk375_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk376_local"
#check @Heraclitus.UpperKernelCatalogue.chunk376_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk376_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk377_local"
#check @Heraclitus.UpperKernelCatalogue.chunk377_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk377_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk378_local"
#check @Heraclitus.UpperKernelCatalogue.chunk378_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk378_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk379_local"
#check @Heraclitus.UpperKernelCatalogue.chunk379_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk379_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk380_local"
#check @Heraclitus.UpperKernelCatalogue.chunk380_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk380_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk381_local"
#check @Heraclitus.UpperKernelCatalogue.chunk381_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk381_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk382_local"
#check @Heraclitus.UpperKernelCatalogue.chunk382_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk382_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk383_local"
#check @Heraclitus.UpperKernelCatalogue.chunk383_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk383_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk384_local"
#check @Heraclitus.UpperKernelCatalogue.chunk384_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk384_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk385_local"
#check @Heraclitus.UpperKernelCatalogue.chunk385_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk385_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk386_local"
#check @Heraclitus.UpperKernelCatalogue.chunk386_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk386_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk387_local"
#check @Heraclitus.UpperKernelCatalogue.chunk387_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk387_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk388_local"
#check @Heraclitus.UpperKernelCatalogue.chunk388_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk388_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk389_local"
#check @Heraclitus.UpperKernelCatalogue.chunk389_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk389_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk390_local"
#check @Heraclitus.UpperKernelCatalogue.chunk390_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk390_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk391_local"
#check @Heraclitus.UpperKernelCatalogue.chunk391_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk391_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk392_local"
#check @Heraclitus.UpperKernelCatalogue.chunk392_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk392_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk393_local"
#check @Heraclitus.UpperKernelCatalogue.chunk393_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk393_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk394_local"
#check @Heraclitus.UpperKernelCatalogue.chunk394_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk394_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk395_local"
#check @Heraclitus.UpperKernelCatalogue.chunk395_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk395_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk396_local"
#check @Heraclitus.UpperKernelCatalogue.chunk396_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk396_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk397_local"
#check @Heraclitus.UpperKernelCatalogue.chunk397_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk397_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk398_local"
#check @Heraclitus.UpperKernelCatalogue.chunk398_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk398_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk399_local"
#check @Heraclitus.UpperKernelCatalogue.chunk399_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk399_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk400_local"
#check @Heraclitus.UpperKernelCatalogue.chunk400_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk400_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk401_local"
#check @Heraclitus.UpperKernelCatalogue.chunk401_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk401_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk402_local"
#check @Heraclitus.UpperKernelCatalogue.chunk402_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk402_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk403_local"
#check @Heraclitus.UpperKernelCatalogue.chunk403_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk403_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk404_local"
#check @Heraclitus.UpperKernelCatalogue.chunk404_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk404_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk405_local"
#check @Heraclitus.UpperKernelCatalogue.chunk405_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk405_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk406_local"
#check @Heraclitus.UpperKernelCatalogue.chunk406_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk406_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk407_local"
#check @Heraclitus.UpperKernelCatalogue.chunk407_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk407_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk408_local"
#check @Heraclitus.UpperKernelCatalogue.chunk408_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk408_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk409_local"
#check @Heraclitus.UpperKernelCatalogue.chunk409_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk409_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk410_local"
#check @Heraclitus.UpperKernelCatalogue.chunk410_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk410_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk411_local"
#check @Heraclitus.UpperKernelCatalogue.chunk411_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk411_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk412_local"
#check @Heraclitus.UpperKernelCatalogue.chunk412_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk412_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk413_local"
#check @Heraclitus.UpperKernelCatalogue.chunk413_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk413_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk414_local"
#check @Heraclitus.UpperKernelCatalogue.chunk414_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk414_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk415_local"
#check @Heraclitus.UpperKernelCatalogue.chunk415_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk415_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk416_local"
#check @Heraclitus.UpperKernelCatalogue.chunk416_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk416_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk417_local"
#check @Heraclitus.UpperKernelCatalogue.chunk417_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk417_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk418_local"
#check @Heraclitus.UpperKernelCatalogue.chunk418_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk418_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk419_local"
#check @Heraclitus.UpperKernelCatalogue.chunk419_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk419_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk420_local"
#check @Heraclitus.UpperKernelCatalogue.chunk420_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk420_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk421_local"
#check @Heraclitus.UpperKernelCatalogue.chunk421_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk421_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk422_local"
#check @Heraclitus.UpperKernelCatalogue.chunk422_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk422_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk423_local"
#check @Heraclitus.UpperKernelCatalogue.chunk423_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk423_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk424_local"
#check @Heraclitus.UpperKernelCatalogue.chunk424_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk424_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk425_local"
#check @Heraclitus.UpperKernelCatalogue.chunk425_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk425_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk426_local"
#check @Heraclitus.UpperKernelCatalogue.chunk426_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk426_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk427_local"
#check @Heraclitus.UpperKernelCatalogue.chunk427_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk427_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk428_local"
#check @Heraclitus.UpperKernelCatalogue.chunk428_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk428_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk429_local"
#check @Heraclitus.UpperKernelCatalogue.chunk429_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk429_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk430_local"
#check @Heraclitus.UpperKernelCatalogue.chunk430_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk430_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk431_local"
#check @Heraclitus.UpperKernelCatalogue.chunk431_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk431_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk432_local"
#check @Heraclitus.UpperKernelCatalogue.chunk432_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk432_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk433_local"
#check @Heraclitus.UpperKernelCatalogue.chunk433_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk433_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk434_local"
#check @Heraclitus.UpperKernelCatalogue.chunk434_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk434_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk435_local"
#check @Heraclitus.UpperKernelCatalogue.chunk435_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk435_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk436_local"
#check @Heraclitus.UpperKernelCatalogue.chunk436_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk436_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk437_local"
#check @Heraclitus.UpperKernelCatalogue.chunk437_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk437_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk438_local"
#check @Heraclitus.UpperKernelCatalogue.chunk438_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk438_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk439_local"
#check @Heraclitus.UpperKernelCatalogue.chunk439_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk439_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk440_local"
#check @Heraclitus.UpperKernelCatalogue.chunk440_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk440_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.chunk441_local"
#check @Heraclitus.UpperKernelCatalogue.chunk441_local
#print axioms Heraclitus.UpperKernelCatalogue.chunk441_local
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals000_checked"
#check @Heraclitus.UpperKernelCatalogue.locals000_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals000_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals001_checked"
#check @Heraclitus.UpperKernelCatalogue.locals001_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals001_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals002_checked"
#check @Heraclitus.UpperKernelCatalogue.locals002_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals002_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals003_checked"
#check @Heraclitus.UpperKernelCatalogue.locals003_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals003_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals004_checked"
#check @Heraclitus.UpperKernelCatalogue.locals004_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals004_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals005_checked"
#check @Heraclitus.UpperKernelCatalogue.locals005_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals005_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals006_checked"
#check @Heraclitus.UpperKernelCatalogue.locals006_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals006_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals007_checked"
#check @Heraclitus.UpperKernelCatalogue.locals007_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals007_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals008_checked"
#check @Heraclitus.UpperKernelCatalogue.locals008_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals008_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals009_checked"
#check @Heraclitus.UpperKernelCatalogue.locals009_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals009_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals010_checked"
#check @Heraclitus.UpperKernelCatalogue.locals010_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals010_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals011_checked"
#check @Heraclitus.UpperKernelCatalogue.locals011_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals011_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals012_checked"
#check @Heraclitus.UpperKernelCatalogue.locals012_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals012_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals013_checked"
#check @Heraclitus.UpperKernelCatalogue.locals013_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals013_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals014_checked"
#check @Heraclitus.UpperKernelCatalogue.locals014_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals014_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals015_checked"
#check @Heraclitus.UpperKernelCatalogue.locals015_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals015_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals016_checked"
#check @Heraclitus.UpperKernelCatalogue.locals016_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals016_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals017_checked"
#check @Heraclitus.UpperKernelCatalogue.locals017_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals017_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals018_checked"
#check @Heraclitus.UpperKernelCatalogue.locals018_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals018_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals019_checked"
#check @Heraclitus.UpperKernelCatalogue.locals019_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals019_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals020_checked"
#check @Heraclitus.UpperKernelCatalogue.locals020_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals020_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals021_checked"
#check @Heraclitus.UpperKernelCatalogue.locals021_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals021_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals022_checked"
#check @Heraclitus.UpperKernelCatalogue.locals022_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals022_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals023_checked"
#check @Heraclitus.UpperKernelCatalogue.locals023_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals023_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals024_checked"
#check @Heraclitus.UpperKernelCatalogue.locals024_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals024_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals025_checked"
#check @Heraclitus.UpperKernelCatalogue.locals025_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals025_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals026_checked"
#check @Heraclitus.UpperKernelCatalogue.locals026_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals026_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals027_checked"
#check @Heraclitus.UpperKernelCatalogue.locals027_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals027_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals028_checked"
#check @Heraclitus.UpperKernelCatalogue.locals028_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals028_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals029_checked"
#check @Heraclitus.UpperKernelCatalogue.locals029_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals029_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals030_checked"
#check @Heraclitus.UpperKernelCatalogue.locals030_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals030_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals031_checked"
#check @Heraclitus.UpperKernelCatalogue.locals031_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals031_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals032_checked"
#check @Heraclitus.UpperKernelCatalogue.locals032_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals032_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals033_checked"
#check @Heraclitus.UpperKernelCatalogue.locals033_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals033_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals034_checked"
#check @Heraclitus.UpperKernelCatalogue.locals034_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals034_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals035_checked"
#check @Heraclitus.UpperKernelCatalogue.locals035_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals035_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals036_checked"
#check @Heraclitus.UpperKernelCatalogue.locals036_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals036_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals037_checked"
#check @Heraclitus.UpperKernelCatalogue.locals037_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals037_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals038_checked"
#check @Heraclitus.UpperKernelCatalogue.locals038_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals038_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals039_checked"
#check @Heraclitus.UpperKernelCatalogue.locals039_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals039_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals040_checked"
#check @Heraclitus.UpperKernelCatalogue.locals040_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals040_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals041_checked"
#check @Heraclitus.UpperKernelCatalogue.locals041_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals041_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals042_checked"
#check @Heraclitus.UpperKernelCatalogue.locals042_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals042_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals043_checked"
#check @Heraclitus.UpperKernelCatalogue.locals043_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals043_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals044_checked"
#check @Heraclitus.UpperKernelCatalogue.locals044_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals044_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals045_checked"
#check @Heraclitus.UpperKernelCatalogue.locals045_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals045_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals046_checked"
#check @Heraclitus.UpperKernelCatalogue.locals046_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals046_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals047_checked"
#check @Heraclitus.UpperKernelCatalogue.locals047_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals047_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals048_checked"
#check @Heraclitus.UpperKernelCatalogue.locals048_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals048_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals049_checked"
#check @Heraclitus.UpperKernelCatalogue.locals049_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals049_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals050_checked"
#check @Heraclitus.UpperKernelCatalogue.locals050_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals050_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals051_checked"
#check @Heraclitus.UpperKernelCatalogue.locals051_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals051_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals052_checked"
#check @Heraclitus.UpperKernelCatalogue.locals052_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals052_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals053_checked"
#check @Heraclitus.UpperKernelCatalogue.locals053_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals053_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals054_checked"
#check @Heraclitus.UpperKernelCatalogue.locals054_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals054_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals055_checked"
#check @Heraclitus.UpperKernelCatalogue.locals055_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals055_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals056_checked"
#check @Heraclitus.UpperKernelCatalogue.locals056_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals056_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals057_checked"
#check @Heraclitus.UpperKernelCatalogue.locals057_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals057_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals058_checked"
#check @Heraclitus.UpperKernelCatalogue.locals058_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals058_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals059_checked"
#check @Heraclitus.UpperKernelCatalogue.locals059_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals059_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals060_checked"
#check @Heraclitus.UpperKernelCatalogue.locals060_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals060_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals061_checked"
#check @Heraclitus.UpperKernelCatalogue.locals061_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals061_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals062_checked"
#check @Heraclitus.UpperKernelCatalogue.locals062_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals062_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals063_checked"
#check @Heraclitus.UpperKernelCatalogue.locals063_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals063_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals064_checked"
#check @Heraclitus.UpperKernelCatalogue.locals064_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals064_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals065_checked"
#check @Heraclitus.UpperKernelCatalogue.locals065_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals065_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals066_checked"
#check @Heraclitus.UpperKernelCatalogue.locals066_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals066_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals067_checked"
#check @Heraclitus.UpperKernelCatalogue.locals067_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals067_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals068_checked"
#check @Heraclitus.UpperKernelCatalogue.locals068_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals068_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals069_checked"
#check @Heraclitus.UpperKernelCatalogue.locals069_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals069_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals070_checked"
#check @Heraclitus.UpperKernelCatalogue.locals070_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals070_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals071_checked"
#check @Heraclitus.UpperKernelCatalogue.locals071_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals071_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals072_checked"
#check @Heraclitus.UpperKernelCatalogue.locals072_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals072_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals073_checked"
#check @Heraclitus.UpperKernelCatalogue.locals073_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals073_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals074_checked"
#check @Heraclitus.UpperKernelCatalogue.locals074_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals074_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals075_checked"
#check @Heraclitus.UpperKernelCatalogue.locals075_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals075_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals076_checked"
#check @Heraclitus.UpperKernelCatalogue.locals076_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals076_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals077_checked"
#check @Heraclitus.UpperKernelCatalogue.locals077_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals077_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals078_checked"
#check @Heraclitus.UpperKernelCatalogue.locals078_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals078_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals079_checked"
#check @Heraclitus.UpperKernelCatalogue.locals079_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals079_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals080_checked"
#check @Heraclitus.UpperKernelCatalogue.locals080_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals080_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals081_checked"
#check @Heraclitus.UpperKernelCatalogue.locals081_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals081_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals082_checked"
#check @Heraclitus.UpperKernelCatalogue.locals082_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals082_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals083_checked"
#check @Heraclitus.UpperKernelCatalogue.locals083_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals083_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals084_checked"
#check @Heraclitus.UpperKernelCatalogue.locals084_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals084_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals085_checked"
#check @Heraclitus.UpperKernelCatalogue.locals085_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals085_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals086_checked"
#check @Heraclitus.UpperKernelCatalogue.locals086_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals086_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals087_checked"
#check @Heraclitus.UpperKernelCatalogue.locals087_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals087_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals088_checked"
#check @Heraclitus.UpperKernelCatalogue.locals088_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals088_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals089_checked"
#check @Heraclitus.UpperKernelCatalogue.locals089_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals089_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals090_checked"
#check @Heraclitus.UpperKernelCatalogue.locals090_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals090_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals091_checked"
#check @Heraclitus.UpperKernelCatalogue.locals091_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals091_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals092_checked"
#check @Heraclitus.UpperKernelCatalogue.locals092_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals092_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals093_checked"
#check @Heraclitus.UpperKernelCatalogue.locals093_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals093_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals094_checked"
#check @Heraclitus.UpperKernelCatalogue.locals094_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals094_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals095_checked"
#check @Heraclitus.UpperKernelCatalogue.locals095_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals095_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals096_checked"
#check @Heraclitus.UpperKernelCatalogue.locals096_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals096_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals097_checked"
#check @Heraclitus.UpperKernelCatalogue.locals097_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals097_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals098_checked"
#check @Heraclitus.UpperKernelCatalogue.locals098_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals098_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals099_checked"
#check @Heraclitus.UpperKernelCatalogue.locals099_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals099_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals100_checked"
#check @Heraclitus.UpperKernelCatalogue.locals100_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals100_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals101_checked"
#check @Heraclitus.UpperKernelCatalogue.locals101_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals101_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals102_checked"
#check @Heraclitus.UpperKernelCatalogue.locals102_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals102_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals103_checked"
#check @Heraclitus.UpperKernelCatalogue.locals103_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals103_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals104_checked"
#check @Heraclitus.UpperKernelCatalogue.locals104_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals104_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals105_checked"
#check @Heraclitus.UpperKernelCatalogue.locals105_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals105_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals106_checked"
#check @Heraclitus.UpperKernelCatalogue.locals106_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals106_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals107_checked"
#check @Heraclitus.UpperKernelCatalogue.locals107_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals107_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals108_checked"
#check @Heraclitus.UpperKernelCatalogue.locals108_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals108_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals109_checked"
#check @Heraclitus.UpperKernelCatalogue.locals109_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals109_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals110_checked"
#check @Heraclitus.UpperKernelCatalogue.locals110_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals110_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals111_checked"
#check @Heraclitus.UpperKernelCatalogue.locals111_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals111_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals112_checked"
#check @Heraclitus.UpperKernelCatalogue.locals112_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals112_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals113_checked"
#check @Heraclitus.UpperKernelCatalogue.locals113_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals113_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals114_checked"
#check @Heraclitus.UpperKernelCatalogue.locals114_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals114_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals115_checked"
#check @Heraclitus.UpperKernelCatalogue.locals115_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals115_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals116_checked"
#check @Heraclitus.UpperKernelCatalogue.locals116_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals116_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals117_checked"
#check @Heraclitus.UpperKernelCatalogue.locals117_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals117_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals118_checked"
#check @Heraclitus.UpperKernelCatalogue.locals118_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals118_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals119_checked"
#check @Heraclitus.UpperKernelCatalogue.locals119_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals119_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals120_checked"
#check @Heraclitus.UpperKernelCatalogue.locals120_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals120_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals121_checked"
#check @Heraclitus.UpperKernelCatalogue.locals121_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals121_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals122_checked"
#check @Heraclitus.UpperKernelCatalogue.locals122_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals122_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals123_checked"
#check @Heraclitus.UpperKernelCatalogue.locals123_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals123_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals124_checked"
#check @Heraclitus.UpperKernelCatalogue.locals124_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals124_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals125_checked"
#check @Heraclitus.UpperKernelCatalogue.locals125_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals125_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals126_checked"
#check @Heraclitus.UpperKernelCatalogue.locals126_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals126_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals127_checked"
#check @Heraclitus.UpperKernelCatalogue.locals127_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals127_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals128_checked"
#check @Heraclitus.UpperKernelCatalogue.locals128_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals128_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals129_checked"
#check @Heraclitus.UpperKernelCatalogue.locals129_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals129_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals130_checked"
#check @Heraclitus.UpperKernelCatalogue.locals130_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals130_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals131_checked"
#check @Heraclitus.UpperKernelCatalogue.locals131_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals131_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals132_checked"
#check @Heraclitus.UpperKernelCatalogue.locals132_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals132_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals133_checked"
#check @Heraclitus.UpperKernelCatalogue.locals133_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals133_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals134_checked"
#check @Heraclitus.UpperKernelCatalogue.locals134_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals134_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals135_checked"
#check @Heraclitus.UpperKernelCatalogue.locals135_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals135_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals136_checked"
#check @Heraclitus.UpperKernelCatalogue.locals136_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals136_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals137_checked"
#check @Heraclitus.UpperKernelCatalogue.locals137_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals137_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals138_checked"
#check @Heraclitus.UpperKernelCatalogue.locals138_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals138_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals139_checked"
#check @Heraclitus.UpperKernelCatalogue.locals139_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals139_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals140_checked"
#check @Heraclitus.UpperKernelCatalogue.locals140_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals140_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals141_checked"
#check @Heraclitus.UpperKernelCatalogue.locals141_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals141_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals142_checked"
#check @Heraclitus.UpperKernelCatalogue.locals142_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals142_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals143_checked"
#check @Heraclitus.UpperKernelCatalogue.locals143_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals143_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals144_checked"
#check @Heraclitus.UpperKernelCatalogue.locals144_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals144_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals145_checked"
#check @Heraclitus.UpperKernelCatalogue.locals145_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals145_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals146_checked"
#check @Heraclitus.UpperKernelCatalogue.locals146_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals146_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals147_checked"
#check @Heraclitus.UpperKernelCatalogue.locals147_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals147_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals148_checked"
#check @Heraclitus.UpperKernelCatalogue.locals148_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals148_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals149_checked"
#check @Heraclitus.UpperKernelCatalogue.locals149_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals149_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals150_checked"
#check @Heraclitus.UpperKernelCatalogue.locals150_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals150_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals151_checked"
#check @Heraclitus.UpperKernelCatalogue.locals151_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals151_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals152_checked"
#check @Heraclitus.UpperKernelCatalogue.locals152_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals152_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals153_checked"
#check @Heraclitus.UpperKernelCatalogue.locals153_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals153_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals154_checked"
#check @Heraclitus.UpperKernelCatalogue.locals154_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals154_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals155_checked"
#check @Heraclitus.UpperKernelCatalogue.locals155_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals155_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals156_checked"
#check @Heraclitus.UpperKernelCatalogue.locals156_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals156_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals157_checked"
#check @Heraclitus.UpperKernelCatalogue.locals157_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals157_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals158_checked"
#check @Heraclitus.UpperKernelCatalogue.locals158_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals158_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals159_checked"
#check @Heraclitus.UpperKernelCatalogue.locals159_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals159_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals160_checked"
#check @Heraclitus.UpperKernelCatalogue.locals160_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals160_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals161_checked"
#check @Heraclitus.UpperKernelCatalogue.locals161_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals161_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals162_checked"
#check @Heraclitus.UpperKernelCatalogue.locals162_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals162_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals163_checked"
#check @Heraclitus.UpperKernelCatalogue.locals163_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals163_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals164_checked"
#check @Heraclitus.UpperKernelCatalogue.locals164_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals164_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals165_checked"
#check @Heraclitus.UpperKernelCatalogue.locals165_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals165_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals166_checked"
#check @Heraclitus.UpperKernelCatalogue.locals166_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals166_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals167_checked"
#check @Heraclitus.UpperKernelCatalogue.locals167_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals167_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals168_checked"
#check @Heraclitus.UpperKernelCatalogue.locals168_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals168_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals169_checked"
#check @Heraclitus.UpperKernelCatalogue.locals169_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals169_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals170_checked"
#check @Heraclitus.UpperKernelCatalogue.locals170_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals170_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals171_checked"
#check @Heraclitus.UpperKernelCatalogue.locals171_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals171_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals172_checked"
#check @Heraclitus.UpperKernelCatalogue.locals172_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals172_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals173_checked"
#check @Heraclitus.UpperKernelCatalogue.locals173_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals173_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals174_checked"
#check @Heraclitus.UpperKernelCatalogue.locals174_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals174_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals175_checked"
#check @Heraclitus.UpperKernelCatalogue.locals175_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals175_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals176_checked"
#check @Heraclitus.UpperKernelCatalogue.locals176_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals176_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals177_checked"
#check @Heraclitus.UpperKernelCatalogue.locals177_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals177_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals178_checked"
#check @Heraclitus.UpperKernelCatalogue.locals178_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals178_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals179_checked"
#check @Heraclitus.UpperKernelCatalogue.locals179_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals179_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals180_checked"
#check @Heraclitus.UpperKernelCatalogue.locals180_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals180_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals181_checked"
#check @Heraclitus.UpperKernelCatalogue.locals181_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals181_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals182_checked"
#check @Heraclitus.UpperKernelCatalogue.locals182_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals182_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals183_checked"
#check @Heraclitus.UpperKernelCatalogue.locals183_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals183_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals184_checked"
#check @Heraclitus.UpperKernelCatalogue.locals184_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals184_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals185_checked"
#check @Heraclitus.UpperKernelCatalogue.locals185_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals185_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals186_checked"
#check @Heraclitus.UpperKernelCatalogue.locals186_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals186_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals187_checked"
#check @Heraclitus.UpperKernelCatalogue.locals187_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals187_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals188_checked"
#check @Heraclitus.UpperKernelCatalogue.locals188_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals188_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals189_checked"
#check @Heraclitus.UpperKernelCatalogue.locals189_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals189_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals190_checked"
#check @Heraclitus.UpperKernelCatalogue.locals190_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals190_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals191_checked"
#check @Heraclitus.UpperKernelCatalogue.locals191_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals191_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals192_checked"
#check @Heraclitus.UpperKernelCatalogue.locals192_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals192_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals193_checked"
#check @Heraclitus.UpperKernelCatalogue.locals193_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals193_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals194_checked"
#check @Heraclitus.UpperKernelCatalogue.locals194_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals194_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals195_checked"
#check @Heraclitus.UpperKernelCatalogue.locals195_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals195_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals196_checked"
#check @Heraclitus.UpperKernelCatalogue.locals196_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals196_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals197_checked"
#check @Heraclitus.UpperKernelCatalogue.locals197_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals197_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals198_checked"
#check @Heraclitus.UpperKernelCatalogue.locals198_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals198_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals199_checked"
#check @Heraclitus.UpperKernelCatalogue.locals199_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals199_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals200_checked"
#check @Heraclitus.UpperKernelCatalogue.locals200_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals200_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals201_checked"
#check @Heraclitus.UpperKernelCatalogue.locals201_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals201_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals202_checked"
#check @Heraclitus.UpperKernelCatalogue.locals202_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals202_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals203_checked"
#check @Heraclitus.UpperKernelCatalogue.locals203_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals203_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals204_checked"
#check @Heraclitus.UpperKernelCatalogue.locals204_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals204_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals205_checked"
#check @Heraclitus.UpperKernelCatalogue.locals205_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals205_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals206_checked"
#check @Heraclitus.UpperKernelCatalogue.locals206_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals206_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals207_checked"
#check @Heraclitus.UpperKernelCatalogue.locals207_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals207_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals208_checked"
#check @Heraclitus.UpperKernelCatalogue.locals208_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals208_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals209_checked"
#check @Heraclitus.UpperKernelCatalogue.locals209_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals209_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals210_checked"
#check @Heraclitus.UpperKernelCatalogue.locals210_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals210_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals211_checked"
#check @Heraclitus.UpperKernelCatalogue.locals211_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals211_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals212_checked"
#check @Heraclitus.UpperKernelCatalogue.locals212_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals212_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals213_checked"
#check @Heraclitus.UpperKernelCatalogue.locals213_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals213_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals214_checked"
#check @Heraclitus.UpperKernelCatalogue.locals214_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals214_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals215_checked"
#check @Heraclitus.UpperKernelCatalogue.locals215_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals215_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals216_checked"
#check @Heraclitus.UpperKernelCatalogue.locals216_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals216_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals217_checked"
#check @Heraclitus.UpperKernelCatalogue.locals217_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals217_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals218_checked"
#check @Heraclitus.UpperKernelCatalogue.locals218_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals218_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals219_checked"
#check @Heraclitus.UpperKernelCatalogue.locals219_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals219_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals220_checked"
#check @Heraclitus.UpperKernelCatalogue.locals220_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals220_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals221_checked"
#check @Heraclitus.UpperKernelCatalogue.locals221_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals221_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals222_checked"
#check @Heraclitus.UpperKernelCatalogue.locals222_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals222_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals223_checked"
#check @Heraclitus.UpperKernelCatalogue.locals223_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals223_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals224_checked"
#check @Heraclitus.UpperKernelCatalogue.locals224_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals224_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals225_checked"
#check @Heraclitus.UpperKernelCatalogue.locals225_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals225_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals226_checked"
#check @Heraclitus.UpperKernelCatalogue.locals226_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals226_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals227_checked"
#check @Heraclitus.UpperKernelCatalogue.locals227_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals227_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals228_checked"
#check @Heraclitus.UpperKernelCatalogue.locals228_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals228_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals229_checked"
#check @Heraclitus.UpperKernelCatalogue.locals229_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals229_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals230_checked"
#check @Heraclitus.UpperKernelCatalogue.locals230_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals230_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals231_checked"
#check @Heraclitus.UpperKernelCatalogue.locals231_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals231_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals232_checked"
#check @Heraclitus.UpperKernelCatalogue.locals232_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals232_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals233_checked"
#check @Heraclitus.UpperKernelCatalogue.locals233_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals233_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals234_checked"
#check @Heraclitus.UpperKernelCatalogue.locals234_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals234_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals235_checked"
#check @Heraclitus.UpperKernelCatalogue.locals235_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals235_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals236_checked"
#check @Heraclitus.UpperKernelCatalogue.locals236_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals236_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals237_checked"
#check @Heraclitus.UpperKernelCatalogue.locals237_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals237_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals238_checked"
#check @Heraclitus.UpperKernelCatalogue.locals238_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals238_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals239_checked"
#check @Heraclitus.UpperKernelCatalogue.locals239_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals239_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals240_checked"
#check @Heraclitus.UpperKernelCatalogue.locals240_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals240_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals241_checked"
#check @Heraclitus.UpperKernelCatalogue.locals241_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals241_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals242_checked"
#check @Heraclitus.UpperKernelCatalogue.locals242_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals242_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals243_checked"
#check @Heraclitus.UpperKernelCatalogue.locals243_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals243_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals244_checked"
#check @Heraclitus.UpperKernelCatalogue.locals244_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals244_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals245_checked"
#check @Heraclitus.UpperKernelCatalogue.locals245_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals245_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals246_checked"
#check @Heraclitus.UpperKernelCatalogue.locals246_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals246_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals247_checked"
#check @Heraclitus.UpperKernelCatalogue.locals247_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals247_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals248_checked"
#check @Heraclitus.UpperKernelCatalogue.locals248_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals248_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals249_checked"
#check @Heraclitus.UpperKernelCatalogue.locals249_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals249_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals250_checked"
#check @Heraclitus.UpperKernelCatalogue.locals250_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals250_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals251_checked"
#check @Heraclitus.UpperKernelCatalogue.locals251_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals251_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals252_checked"
#check @Heraclitus.UpperKernelCatalogue.locals252_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals252_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals253_checked"
#check @Heraclitus.UpperKernelCatalogue.locals253_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals253_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals254_checked"
#check @Heraclitus.UpperKernelCatalogue.locals254_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals254_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals255_checked"
#check @Heraclitus.UpperKernelCatalogue.locals255_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals255_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals256_checked"
#check @Heraclitus.UpperKernelCatalogue.locals256_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals256_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals257_checked"
#check @Heraclitus.UpperKernelCatalogue.locals257_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals257_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals258_checked"
#check @Heraclitus.UpperKernelCatalogue.locals258_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals258_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals259_checked"
#check @Heraclitus.UpperKernelCatalogue.locals259_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals259_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals260_checked"
#check @Heraclitus.UpperKernelCatalogue.locals260_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals260_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals261_checked"
#check @Heraclitus.UpperKernelCatalogue.locals261_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals261_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals262_checked"
#check @Heraclitus.UpperKernelCatalogue.locals262_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals262_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals263_checked"
#check @Heraclitus.UpperKernelCatalogue.locals263_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals263_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals264_checked"
#check @Heraclitus.UpperKernelCatalogue.locals264_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals264_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals265_checked"
#check @Heraclitus.UpperKernelCatalogue.locals265_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals265_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals266_checked"
#check @Heraclitus.UpperKernelCatalogue.locals266_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals266_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals267_checked"
#check @Heraclitus.UpperKernelCatalogue.locals267_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals267_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals268_checked"
#check @Heraclitus.UpperKernelCatalogue.locals268_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals268_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals269_checked"
#check @Heraclitus.UpperKernelCatalogue.locals269_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals269_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals270_checked"
#check @Heraclitus.UpperKernelCatalogue.locals270_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals270_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals271_checked"
#check @Heraclitus.UpperKernelCatalogue.locals271_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals271_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals272_checked"
#check @Heraclitus.UpperKernelCatalogue.locals272_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals272_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals273_checked"
#check @Heraclitus.UpperKernelCatalogue.locals273_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals273_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals274_checked"
#check @Heraclitus.UpperKernelCatalogue.locals274_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals274_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals275_checked"
#check @Heraclitus.UpperKernelCatalogue.locals275_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals275_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals276_checked"
#check @Heraclitus.UpperKernelCatalogue.locals276_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals276_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals277_checked"
#check @Heraclitus.UpperKernelCatalogue.locals277_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals277_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals278_checked"
#check @Heraclitus.UpperKernelCatalogue.locals278_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals278_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals279_checked"
#check @Heraclitus.UpperKernelCatalogue.locals279_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals279_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals280_checked"
#check @Heraclitus.UpperKernelCatalogue.locals280_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals280_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals281_checked"
#check @Heraclitus.UpperKernelCatalogue.locals281_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals281_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals282_checked"
#check @Heraclitus.UpperKernelCatalogue.locals282_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals282_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals283_checked"
#check @Heraclitus.UpperKernelCatalogue.locals283_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals283_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals284_checked"
#check @Heraclitus.UpperKernelCatalogue.locals284_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals284_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals285_checked"
#check @Heraclitus.UpperKernelCatalogue.locals285_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals285_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals286_checked"
#check @Heraclitus.UpperKernelCatalogue.locals286_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals286_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals287_checked"
#check @Heraclitus.UpperKernelCatalogue.locals287_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals287_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals288_checked"
#check @Heraclitus.UpperKernelCatalogue.locals288_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals288_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals289_checked"
#check @Heraclitus.UpperKernelCatalogue.locals289_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals289_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals290_checked"
#check @Heraclitus.UpperKernelCatalogue.locals290_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals290_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals291_checked"
#check @Heraclitus.UpperKernelCatalogue.locals291_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals291_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals292_checked"
#check @Heraclitus.UpperKernelCatalogue.locals292_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals292_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals293_checked"
#check @Heraclitus.UpperKernelCatalogue.locals293_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals293_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals294_checked"
#check @Heraclitus.UpperKernelCatalogue.locals294_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals294_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals295_checked"
#check @Heraclitus.UpperKernelCatalogue.locals295_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals295_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals296_checked"
#check @Heraclitus.UpperKernelCatalogue.locals296_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals296_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals297_checked"
#check @Heraclitus.UpperKernelCatalogue.locals297_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals297_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals298_checked"
#check @Heraclitus.UpperKernelCatalogue.locals298_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals298_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals299_checked"
#check @Heraclitus.UpperKernelCatalogue.locals299_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals299_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals300_checked"
#check @Heraclitus.UpperKernelCatalogue.locals300_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals300_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals301_checked"
#check @Heraclitus.UpperKernelCatalogue.locals301_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals301_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals302_checked"
#check @Heraclitus.UpperKernelCatalogue.locals302_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals302_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals303_checked"
#check @Heraclitus.UpperKernelCatalogue.locals303_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals303_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals304_checked"
#check @Heraclitus.UpperKernelCatalogue.locals304_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals304_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals305_checked"
#check @Heraclitus.UpperKernelCatalogue.locals305_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals305_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals306_checked"
#check @Heraclitus.UpperKernelCatalogue.locals306_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals306_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals307_checked"
#check @Heraclitus.UpperKernelCatalogue.locals307_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals307_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals308_checked"
#check @Heraclitus.UpperKernelCatalogue.locals308_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals308_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals309_checked"
#check @Heraclitus.UpperKernelCatalogue.locals309_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals309_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals310_checked"
#check @Heraclitus.UpperKernelCatalogue.locals310_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals310_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals311_checked"
#check @Heraclitus.UpperKernelCatalogue.locals311_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals311_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals312_checked"
#check @Heraclitus.UpperKernelCatalogue.locals312_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals312_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals313_checked"
#check @Heraclitus.UpperKernelCatalogue.locals313_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals313_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals314_checked"
#check @Heraclitus.UpperKernelCatalogue.locals314_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals314_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals315_checked"
#check @Heraclitus.UpperKernelCatalogue.locals315_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals315_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals316_checked"
#check @Heraclitus.UpperKernelCatalogue.locals316_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals316_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals317_checked"
#check @Heraclitus.UpperKernelCatalogue.locals317_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals317_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals318_checked"
#check @Heraclitus.UpperKernelCatalogue.locals318_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals318_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals319_checked"
#check @Heraclitus.UpperKernelCatalogue.locals319_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals319_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals320_checked"
#check @Heraclitus.UpperKernelCatalogue.locals320_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals320_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals321_checked"
#check @Heraclitus.UpperKernelCatalogue.locals321_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals321_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals322_checked"
#check @Heraclitus.UpperKernelCatalogue.locals322_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals322_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals323_checked"
#check @Heraclitus.UpperKernelCatalogue.locals323_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals323_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals324_checked"
#check @Heraclitus.UpperKernelCatalogue.locals324_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals324_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals325_checked"
#check @Heraclitus.UpperKernelCatalogue.locals325_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals325_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals326_checked"
#check @Heraclitus.UpperKernelCatalogue.locals326_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals326_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals327_checked"
#check @Heraclitus.UpperKernelCatalogue.locals327_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals327_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals328_checked"
#check @Heraclitus.UpperKernelCatalogue.locals328_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals328_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals329_checked"
#check @Heraclitus.UpperKernelCatalogue.locals329_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals329_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals330_checked"
#check @Heraclitus.UpperKernelCatalogue.locals330_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals330_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals331_checked"
#check @Heraclitus.UpperKernelCatalogue.locals331_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals331_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals332_checked"
#check @Heraclitus.UpperKernelCatalogue.locals332_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals332_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals333_checked"
#check @Heraclitus.UpperKernelCatalogue.locals333_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals333_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals334_checked"
#check @Heraclitus.UpperKernelCatalogue.locals334_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals334_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals335_checked"
#check @Heraclitus.UpperKernelCatalogue.locals335_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals335_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals336_checked"
#check @Heraclitus.UpperKernelCatalogue.locals336_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals336_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals337_checked"
#check @Heraclitus.UpperKernelCatalogue.locals337_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals337_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals338_checked"
#check @Heraclitus.UpperKernelCatalogue.locals338_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals338_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals339_checked"
#check @Heraclitus.UpperKernelCatalogue.locals339_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals339_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals340_checked"
#check @Heraclitus.UpperKernelCatalogue.locals340_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals340_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals341_checked"
#check @Heraclitus.UpperKernelCatalogue.locals341_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals341_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals342_checked"
#check @Heraclitus.UpperKernelCatalogue.locals342_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals342_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals343_checked"
#check @Heraclitus.UpperKernelCatalogue.locals343_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals343_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals344_checked"
#check @Heraclitus.UpperKernelCatalogue.locals344_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals344_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals345_checked"
#check @Heraclitus.UpperKernelCatalogue.locals345_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals345_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals346_checked"
#check @Heraclitus.UpperKernelCatalogue.locals346_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals346_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals347_checked"
#check @Heraclitus.UpperKernelCatalogue.locals347_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals347_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals348_checked"
#check @Heraclitus.UpperKernelCatalogue.locals348_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals348_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals349_checked"
#check @Heraclitus.UpperKernelCatalogue.locals349_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals349_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals350_checked"
#check @Heraclitus.UpperKernelCatalogue.locals350_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals350_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals351_checked"
#check @Heraclitus.UpperKernelCatalogue.locals351_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals351_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals352_checked"
#check @Heraclitus.UpperKernelCatalogue.locals352_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals352_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals353_checked"
#check @Heraclitus.UpperKernelCatalogue.locals353_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals353_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals354_checked"
#check @Heraclitus.UpperKernelCatalogue.locals354_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals354_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals355_checked"
#check @Heraclitus.UpperKernelCatalogue.locals355_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals355_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals356_checked"
#check @Heraclitus.UpperKernelCatalogue.locals356_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals356_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals357_checked"
#check @Heraclitus.UpperKernelCatalogue.locals357_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals357_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals358_checked"
#check @Heraclitus.UpperKernelCatalogue.locals358_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals358_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals359_checked"
#check @Heraclitus.UpperKernelCatalogue.locals359_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals359_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals360_checked"
#check @Heraclitus.UpperKernelCatalogue.locals360_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals360_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals361_checked"
#check @Heraclitus.UpperKernelCatalogue.locals361_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals361_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals362_checked"
#check @Heraclitus.UpperKernelCatalogue.locals362_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals362_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals363_checked"
#check @Heraclitus.UpperKernelCatalogue.locals363_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals363_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals364_checked"
#check @Heraclitus.UpperKernelCatalogue.locals364_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals364_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals365_checked"
#check @Heraclitus.UpperKernelCatalogue.locals365_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals365_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals366_checked"
#check @Heraclitus.UpperKernelCatalogue.locals366_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals366_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals367_checked"
#check @Heraclitus.UpperKernelCatalogue.locals367_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals367_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals368_checked"
#check @Heraclitus.UpperKernelCatalogue.locals368_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals368_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals369_checked"
#check @Heraclitus.UpperKernelCatalogue.locals369_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals369_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals370_checked"
#check @Heraclitus.UpperKernelCatalogue.locals370_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals370_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals371_checked"
#check @Heraclitus.UpperKernelCatalogue.locals371_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals371_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals372_checked"
#check @Heraclitus.UpperKernelCatalogue.locals372_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals372_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals373_checked"
#check @Heraclitus.UpperKernelCatalogue.locals373_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals373_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals374_checked"
#check @Heraclitus.UpperKernelCatalogue.locals374_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals374_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals375_checked"
#check @Heraclitus.UpperKernelCatalogue.locals375_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals375_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals376_checked"
#check @Heraclitus.UpperKernelCatalogue.locals376_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals376_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals377_checked"
#check @Heraclitus.UpperKernelCatalogue.locals377_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals377_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals378_checked"
#check @Heraclitus.UpperKernelCatalogue.locals378_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals378_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals379_checked"
#check @Heraclitus.UpperKernelCatalogue.locals379_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals379_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals380_checked"
#check @Heraclitus.UpperKernelCatalogue.locals380_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals380_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals381_checked"
#check @Heraclitus.UpperKernelCatalogue.locals381_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals381_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals382_checked"
#check @Heraclitus.UpperKernelCatalogue.locals382_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals382_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals383_checked"
#check @Heraclitus.UpperKernelCatalogue.locals383_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals383_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals384_checked"
#check @Heraclitus.UpperKernelCatalogue.locals384_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals384_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals385_checked"
#check @Heraclitus.UpperKernelCatalogue.locals385_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals385_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals386_checked"
#check @Heraclitus.UpperKernelCatalogue.locals386_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals386_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals387_checked"
#check @Heraclitus.UpperKernelCatalogue.locals387_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals387_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals388_checked"
#check @Heraclitus.UpperKernelCatalogue.locals388_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals388_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals389_checked"
#check @Heraclitus.UpperKernelCatalogue.locals389_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals389_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals390_checked"
#check @Heraclitus.UpperKernelCatalogue.locals390_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals390_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals391_checked"
#check @Heraclitus.UpperKernelCatalogue.locals391_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals391_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals392_checked"
#check @Heraclitus.UpperKernelCatalogue.locals392_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals392_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals393_checked"
#check @Heraclitus.UpperKernelCatalogue.locals393_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals393_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals394_checked"
#check @Heraclitus.UpperKernelCatalogue.locals394_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals394_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals395_checked"
#check @Heraclitus.UpperKernelCatalogue.locals395_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals395_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals396_checked"
#check @Heraclitus.UpperKernelCatalogue.locals396_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals396_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals397_checked"
#check @Heraclitus.UpperKernelCatalogue.locals397_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals397_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals398_checked"
#check @Heraclitus.UpperKernelCatalogue.locals398_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals398_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals399_checked"
#check @Heraclitus.UpperKernelCatalogue.locals399_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals399_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals400_checked"
#check @Heraclitus.UpperKernelCatalogue.locals400_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals400_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals401_checked"
#check @Heraclitus.UpperKernelCatalogue.locals401_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals401_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals402_checked"
#check @Heraclitus.UpperKernelCatalogue.locals402_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals402_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals403_checked"
#check @Heraclitus.UpperKernelCatalogue.locals403_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals403_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals404_checked"
#check @Heraclitus.UpperKernelCatalogue.locals404_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals404_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals405_checked"
#check @Heraclitus.UpperKernelCatalogue.locals405_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals405_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals406_checked"
#check @Heraclitus.UpperKernelCatalogue.locals406_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals406_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals407_checked"
#check @Heraclitus.UpperKernelCatalogue.locals407_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals407_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals408_checked"
#check @Heraclitus.UpperKernelCatalogue.locals408_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals408_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals409_checked"
#check @Heraclitus.UpperKernelCatalogue.locals409_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals409_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals410_checked"
#check @Heraclitus.UpperKernelCatalogue.locals410_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals410_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals411_checked"
#check @Heraclitus.UpperKernelCatalogue.locals411_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals411_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals412_checked"
#check @Heraclitus.UpperKernelCatalogue.locals412_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals412_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals413_checked"
#check @Heraclitus.UpperKernelCatalogue.locals413_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals413_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals414_checked"
#check @Heraclitus.UpperKernelCatalogue.locals414_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals414_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals415_checked"
#check @Heraclitus.UpperKernelCatalogue.locals415_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals415_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals416_checked"
#check @Heraclitus.UpperKernelCatalogue.locals416_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals416_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals417_checked"
#check @Heraclitus.UpperKernelCatalogue.locals417_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals417_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals418_checked"
#check @Heraclitus.UpperKernelCatalogue.locals418_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals418_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals419_checked"
#check @Heraclitus.UpperKernelCatalogue.locals419_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals419_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals420_checked"
#check @Heraclitus.UpperKernelCatalogue.locals420_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals420_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals421_checked"
#check @Heraclitus.UpperKernelCatalogue.locals421_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals421_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals422_checked"
#check @Heraclitus.UpperKernelCatalogue.locals422_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals422_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals423_checked"
#check @Heraclitus.UpperKernelCatalogue.locals423_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals423_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals424_checked"
#check @Heraclitus.UpperKernelCatalogue.locals424_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals424_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals425_checked"
#check @Heraclitus.UpperKernelCatalogue.locals425_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals425_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals426_checked"
#check @Heraclitus.UpperKernelCatalogue.locals426_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals426_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals427_checked"
#check @Heraclitus.UpperKernelCatalogue.locals427_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals427_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals428_checked"
#check @Heraclitus.UpperKernelCatalogue.locals428_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals428_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals429_checked"
#check @Heraclitus.UpperKernelCatalogue.locals429_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals429_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals430_checked"
#check @Heraclitus.UpperKernelCatalogue.locals430_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals430_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals431_checked"
#check @Heraclitus.UpperKernelCatalogue.locals431_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals431_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals432_checked"
#check @Heraclitus.UpperKernelCatalogue.locals432_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals432_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals433_checked"
#check @Heraclitus.UpperKernelCatalogue.locals433_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals433_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals434_checked"
#check @Heraclitus.UpperKernelCatalogue.locals434_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals434_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals435_checked"
#check @Heraclitus.UpperKernelCatalogue.locals435_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals435_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals436_checked"
#check @Heraclitus.UpperKernelCatalogue.locals436_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals436_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals437_checked"
#check @Heraclitus.UpperKernelCatalogue.locals437_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals437_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals438_checked"
#check @Heraclitus.UpperKernelCatalogue.locals438_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals438_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals439_checked"
#check @Heraclitus.UpperKernelCatalogue.locals439_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals439_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals440_checked"
#check @Heraclitus.UpperKernelCatalogue.locals440_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals440_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.locals441_checked"
#check @Heraclitus.UpperKernelCatalogue.locals441_checked
#print axioms Heraclitus.UpperKernelCatalogue.locals441_checked
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.matches_sound"
#check @Heraclitus.UpperKernelCatalogue.matches_sound
#print axioms Heraclitus.UpperKernelCatalogue.matches_sound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.route_allLocal"
#check @Heraclitus.UpperKernelCatalogue.route_allLocal
#print axioms Heraclitus.UpperKernelCatalogue.route_allLocal
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.signed_marker_count"
#check @Heraclitus.UpperKernelCatalogue.signed_marker_count
#print axioms Heraclitus.UpperKernelCatalogue.signed_marker_count
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.signed_markers_bound"
#check @Heraclitus.UpperKernelCatalogue.signed_markers_bound
#print axioms Heraclitus.UpperKernelCatalogue.signed_markers_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer000_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer000_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer000_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer001_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer001_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer001_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer002_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer002_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer002_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer003_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer003_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer003_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer004_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer004_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer004_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer005_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer005_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer005_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer006_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer006_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer006_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer007_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer007_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer007_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer008_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer008_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer008_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer009_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer009_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer009_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer010_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer010_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer010_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer011_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer011_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer011_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer012_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer012_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer012_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer013_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer013_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer013_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer014_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer014_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer014_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer015_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer015_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer015_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer016_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer016_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer016_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer017_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer017_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer017_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer018_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer018_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer018_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer019_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer019_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer019_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer020_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer020_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer020_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer021_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer021_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer021_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer022_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer022_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer022_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer023_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer023_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer023_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer024_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer024_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer024_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer025_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer025_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer025_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer026_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer026_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer026_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer027_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer027_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer027_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer028_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer028_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer028_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer029_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer029_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer029_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer030_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer030_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer030_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer031_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer031_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer031_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer032_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer032_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer032_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer033_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer033_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer033_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer034_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer034_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer034_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer035_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer035_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer035_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer036_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer036_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer036_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer037_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer037_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer037_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer038_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer038_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer038_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer039_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer039_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer039_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer040_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer040_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer040_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer041_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer041_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer041_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer042_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer042_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer042_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer043_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer043_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer043_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer044_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer044_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer044_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer045_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer045_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer045_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer046_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer046_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer046_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer047_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer047_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer047_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer048_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer048_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer048_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer049_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer049_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer049_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer050_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer050_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer050_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer051_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer051_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer051_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer052_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer052_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer052_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer053_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer053_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer053_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer054_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer054_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer054_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer055_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer055_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer055_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer056_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer056_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer056_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer057_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer057_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer057_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer058_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer058_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer058_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer059_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer059_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer059_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer060_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer060_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer060_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer061_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer061_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer061_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer062_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer062_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer062_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer063_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer063_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer063_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer064_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer064_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer064_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer065_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer065_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer065_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer066_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer066_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer066_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer067_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer067_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer067_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer068_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer068_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer068_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer069_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer069_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer069_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer070_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer070_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer070_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer071_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer071_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer071_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer072_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer072_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer072_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer073_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer073_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer073_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer074_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer074_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer074_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer075_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer075_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer075_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer076_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer076_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer076_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer077_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer077_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer077_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer078_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer078_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer078_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer079_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer079_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer079_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer080_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer080_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer080_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer081_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer081_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer081_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer082_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer082_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer082_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer083_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer083_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer083_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer084_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer084_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer084_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer085_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer085_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer085_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer086_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer086_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer086_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer087_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer087_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer087_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer088_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer088_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer088_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer089_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer089_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer089_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer090_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer090_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer090_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer091_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer091_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer091_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer092_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer092_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer092_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer093_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer093_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer093_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer094_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer094_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer094_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer095_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer095_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer095_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer096_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer096_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer096_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer097_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer097_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer097_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer098_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer098_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer098_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer099_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer099_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer099_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer100_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer100_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer100_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer101_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer101_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer101_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer102_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer102_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer102_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer103_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer103_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer103_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer104_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer104_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer104_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer105_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer105_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer105_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer106_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer106_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer106_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer107_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer107_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer107_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer108_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer108_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer108_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer109_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer109_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer109_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer110_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer110_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer110_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer111_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer111_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer111_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer112_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer112_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer112_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer113_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer113_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer113_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer114_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer114_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer114_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer115_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer115_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer115_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer116_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer116_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer116_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer117_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer117_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer117_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer118_bound"
#check @Heraclitus.UpperKernelCatalogue.transfer118_bound
#print axioms Heraclitus.UpperKernelCatalogue.transfer118_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperKernelCatalogue.transfer_route_bounds"
#check @Heraclitus.UpperKernelCatalogue.transfer_route_bounds
#print axioms Heraclitus.UpperKernelCatalogue.transfer_route_bounds
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.actual_finite_tail"
#check @Heraclitus.UpperLadderPrefix.actual_finite_tail
#print axioms Heraclitus.UpperLadderPrefix.actual_finite_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.actual_ladder_tail"
#check @Heraclitus.UpperLadderPrefix.actual_ladder_tail
#print axioms Heraclitus.UpperLadderPrefix.actual_ladder_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.actual_prefix_bound"
#check @Heraclitus.UpperLadderPrefix.actual_prefix_bound
#print axioms Heraclitus.UpperLadderPrefix.actual_prefix_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.allLocal_cover"
#check @Heraclitus.UpperLadderPrefix.allLocal_cover
#print axioms Heraclitus.UpperLadderPrefix.allLocal_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_finite_append"
#check @Heraclitus.UpperLadderPrefix.all_finite_append
#print axioms Heraclitus.UpperLadderPrefix.all_finite_append
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_finite_cover"
#check @Heraclitus.UpperLadderPrefix.all_finite_cover
#print axioms Heraclitus.UpperLadderPrefix.all_finite_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_finite_mark"
#check @Heraclitus.UpperLadderPrefix.all_finite_mark
#print axioms Heraclitus.UpperLadderPrefix.all_finite_mark
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_finite_translate"
#check @Heraclitus.UpperLadderPrefix.all_finite_translate
#print axioms Heraclitus.UpperLadderPrefix.all_finite_translate
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_ladders"
#check @Heraclitus.UpperLadderPrefix.all_ladders
#print axioms Heraclitus.UpperLadderPrefix.all_ladders
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_mark"
#check @Heraclitus.UpperLadderPrefix.all_mark
#print axioms Heraclitus.UpperLadderPrefix.all_mark
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.all_translate"
#check @Heraclitus.UpperLadderPrefix.all_translate
#print axioms Heraclitus.UpperLadderPrefix.all_translate
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ascent_prefix"
#check @Heraclitus.UpperLadderPrefix.ascent_prefix
#print axioms Heraclitus.UpperLadderPrefix.ascent_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.bottom_ladder_bound"
#check @Heraclitus.UpperLadderPrefix.bottom_ladder_bound
#print axioms Heraclitus.UpperLadderPrefix.bottom_ladder_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.chain"
#check @Heraclitus.UpperLadderPrefix.chain
#print axioms Heraclitus.UpperLadderPrefix.chain
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.complete_prefix"
#check @Heraclitus.UpperLadderPrefix.complete_prefix
#print axioms Heraclitus.UpperLadderPrefix.complete_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.covered_mark"
#check @Heraclitus.UpperLadderPrefix.covered_mark
#print axioms Heraclitus.UpperLadderPrefix.covered_mark
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.covered_translate"
#check @Heraclitus.UpperLadderPrefix.covered_translate
#print axioms Heraclitus.UpperLadderPrefix.covered_translate
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.current_lower"
#check @Heraclitus.UpperLadderPrefix.current_lower
#print axioms Heraclitus.UpperLadderPrefix.current_lower
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.descent_prefix"
#check @Heraclitus.UpperLadderPrefix.descent_prefix
#print axioms Heraclitus.UpperLadderPrefix.descent_prefix
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.finite_covered"
#check @Heraclitus.UpperLadderPrefix.finite_covered
#print axioms Heraclitus.UpperLadderPrefix.finite_covered
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.halfline_all_prefixes"
#check @Heraclitus.UpperLadderPrefix.halfline_all_prefixes
#print axioms Heraclitus.UpperLadderPrefix.halfline_all_prefixes
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder00_bound"
#check @Heraclitus.UpperLadderPrefix.ladder00_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder01_bound"
#check @Heraclitus.UpperLadderPrefix.ladder01_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder02_bound"
#check @Heraclitus.UpperLadderPrefix.ladder02_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder03_bound"
#check @Heraclitus.UpperLadderPrefix.ladder03_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder04_bound"
#check @Heraclitus.UpperLadderPrefix.ladder04_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder04_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder05_bound"
#check @Heraclitus.UpperLadderPrefix.ladder05_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder05_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder06_bound"
#check @Heraclitus.UpperLadderPrefix.ladder06_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder06_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder07_bound"
#check @Heraclitus.UpperLadderPrefix.ladder07_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder07_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder08_bound"
#check @Heraclitus.UpperLadderPrefix.ladder08_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder08_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder09_bound"
#check @Heraclitus.UpperLadderPrefix.ladder09_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder09_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder10_bound"
#check @Heraclitus.UpperLadderPrefix.ladder10_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder10_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder11_bound"
#check @Heraclitus.UpperLadderPrefix.ladder11_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder11_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder12_bound"
#check @Heraclitus.UpperLadderPrefix.ladder12_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder12_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder13_bound"
#check @Heraclitus.UpperLadderPrefix.ladder13_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder13_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder14_bound"
#check @Heraclitus.UpperLadderPrefix.ladder14_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder14_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder15_bound"
#check @Heraclitus.UpperLadderPrefix.ladder15_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder15_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder16_bound"
#check @Heraclitus.UpperLadderPrefix.ladder16_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder16_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.ladder17_bound"
#check @Heraclitus.UpperLadderPrefix.ladder17_bound
#print axioms Heraclitus.UpperLadderPrefix.ladder17_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer00_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer00_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer00_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer00_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer00_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer00_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer00_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer00_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer00_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer00_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer00_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer00_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer01_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer01_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer01_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer01_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer01_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer01_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer01_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer01_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer01_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer01_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer01_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer01_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_04_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_04_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_04_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_05_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_05_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_05_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_06_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_06_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_06_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_07_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_07_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_07_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_08_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_08_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_08_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_09_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_09_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_09_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_10_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_10_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_10_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_11_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_11_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_11_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_12_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_12_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_12_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_13_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_13_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_13_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_14_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_14_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_14_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_15_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_15_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_15_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_16_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_16_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_16_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_17_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_17_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_17_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_18_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_18_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_18_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_19_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_19_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_19_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_20_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_20_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_20_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_21_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_21_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_21_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_22_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_22_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_22_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_23_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_23_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_23_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_24_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_24_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_24_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_25_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_25_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_25_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_26_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_26_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_26_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_27_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_27_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_27_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_28_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_28_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_28_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_29_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_29_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_29_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_30_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_30_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_30_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_31_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_31_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_31_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_32_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_32_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_32_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_33_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_33_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_33_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_34_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_34_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_34_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_35_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_35_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_35_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer02_36_bound"
#check @Heraclitus.UpperLadderPrefix.layer02_36_bound
#print axioms Heraclitus.UpperLadderPrefix.layer02_36_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer03_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer03_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer03_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer03_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer03_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer03_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer03_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer03_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer03_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer03_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer03_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer03_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer04_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer04_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer04_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer04_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer04_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer04_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer04_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer04_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer04_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer05_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer05_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer05_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer05_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer05_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer05_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer05_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer05_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer05_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer05_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer05_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer05_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer06_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer06_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer06_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer06_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer06_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer06_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer06_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer06_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer06_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer07_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer07_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer07_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer07_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer07_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer07_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer07_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer07_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer07_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer08_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer08_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer08_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer08_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer08_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer08_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer08_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer08_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer08_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer09_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer09_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer09_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer09_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer09_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer09_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer09_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer09_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer09_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer09_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer09_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer09_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer10_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer10_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer10_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer10_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer10_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer10_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer10_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer10_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer10_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer11_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer11_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer11_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer11_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer11_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer11_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer11_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer11_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer11_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer11_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer11_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer11_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer12_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer12_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer12_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer12_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer12_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer12_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer12_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer12_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer12_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_04_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_04_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_04_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_05_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_05_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_05_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_06_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_06_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_06_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_07_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_07_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_07_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_08_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_08_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_08_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_09_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_09_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_09_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_10_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_10_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_10_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_11_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_11_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_11_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_12_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_12_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_12_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_13_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_13_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_13_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_14_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_14_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_14_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_15_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_15_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_15_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_16_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_16_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_16_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_17_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_17_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_17_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_18_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_18_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_18_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_19_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_19_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_19_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_20_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_20_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_20_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_21_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_21_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_21_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_22_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_22_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_22_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_23_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_23_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_23_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_24_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_24_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_24_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_25_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_25_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_25_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_26_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_26_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_26_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_27_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_27_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_27_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_28_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_28_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_28_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_29_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_29_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_29_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_30_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_30_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_30_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_31_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_31_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_31_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_32_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_32_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_32_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_33_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_33_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_33_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_34_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_34_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_34_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_35_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_35_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_35_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer13_36_bound"
#check @Heraclitus.UpperLadderPrefix.layer13_36_bound
#print axioms Heraclitus.UpperLadderPrefix.layer13_36_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer14_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer14_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer14_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer14_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer14_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer14_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer14_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer14_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer14_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer15_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer15_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer15_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer15_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer15_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer15_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer15_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer15_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer15_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer16_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer16_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer16_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer16_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer16_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer16_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer16_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer16_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer16_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer17_00_bound"
#check @Heraclitus.UpperLadderPrefix.layer17_00_bound
#print axioms Heraclitus.UpperLadderPrefix.layer17_00_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer17_01_bound"
#check @Heraclitus.UpperLadderPrefix.layer17_01_bound
#print axioms Heraclitus.UpperLadderPrefix.layer17_01_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer17_02_bound"
#check @Heraclitus.UpperLadderPrefix.layer17_02_bound
#print axioms Heraclitus.UpperLadderPrefix.layer17_02_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.layer17_03_bound"
#check @Heraclitus.UpperLadderPrefix.layer17_03_bound
#print axioms Heraclitus.UpperLadderPrefix.layer17_03_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.normalized_state"
#check @Heraclitus.UpperLadderPrefix.normalized_state
#print axioms Heraclitus.UpperLadderPrefix.normalized_state
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.one_layer"
#check @Heraclitus.UpperLadderPrefix.one_layer
#print axioms Heraclitus.UpperLadderPrefix.one_layer
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.tower"
#check @Heraclitus.UpperLadderPrefix.tower
#print axioms Heraclitus.UpperLadderPrefix.tower
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperLadderPrefix.transfer_output_bound"
#check @Heraclitus.UpperLadderPrefix.transfer_output_bound
#print axioms Heraclitus.UpperLadderPrefix.transfer_output_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.actual_cycle_frame"
#check @Heraclitus.UpperOutgoingPrefix.actual_cycle_frame
#print axioms Heraclitus.UpperOutgoingPrefix.actual_cycle_frame
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.all_row_bounds"
#check @Heraclitus.UpperOutgoingPrefix.all_row_bounds
#print axioms Heraclitus.UpperOutgoingPrefix.all_row_bounds
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.boundary_prefix_band"
#check @Heraclitus.UpperOutgoingPrefix.boundary_prefix_band
#print axioms Heraclitus.UpperOutgoingPrefix.boundary_prefix_band
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.cycle_defect"
#check @Heraclitus.UpperOutgoingPrefix.cycle_defect
#print axioms Heraclitus.UpperOutgoingPrefix.cycle_defect
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.defect_of_two_bounds"
#check @Heraclitus.UpperOutgoingPrefix.defect_of_two_bounds
#print axioms Heraclitus.UpperOutgoingPrefix.defect_of_two_bounds
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.inner_defect"
#check @Heraclitus.UpperOutgoingPrefix.inner_defect
#print axioms Heraclitus.UpperOutgoingPrefix.inner_defect
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperOutgoingPrefix.original_rule_before_crossing"
#check @Heraclitus.UpperOutgoingPrefix.original_rule_before_crossing
#print axioms Heraclitus.UpperOutgoingPrefix.original_rule_before_crossing
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.ladder_member"
#check @Heraclitus.UpperPhaseBridge.ladder_member
#print axioms Heraclitus.UpperPhaseBridge.ladder_member
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.original_rule_all_phase_routes"
#check @Heraclitus.UpperPhaseBridge.original_rule_all_phase_routes
#print axioms Heraclitus.UpperPhaseBridge.original_rule_all_phase_routes
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.original_rule_all_scales"
#check @Heraclitus.UpperPhaseBridge.original_rule_all_scales
#print axioms Heraclitus.UpperPhaseBridge.original_rule_all_scales
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.original_rule_ordinary_ladder"
#check @Heraclitus.UpperPhaseBridge.original_rule_ordinary_ladder
#print axioms Heraclitus.UpperPhaseBridge.original_rule_ordinary_ladder
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.phase_checkpoint"
#check @Heraclitus.UpperPhaseBridge.phase_checkpoint
#print axioms Heraclitus.UpperPhaseBridge.phase_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.phase_exponent"
#check @Heraclitus.UpperPhaseBridge.phase_exponent
#print axioms Heraclitus.UpperPhaseBridge.phase_exponent
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.phase_least"
#check @Heraclitus.UpperPhaseBridge.phase_least
#print axioms Heraclitus.UpperPhaseBridge.phase_least
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.phase_match"
#check @Heraclitus.UpperPhaseBridge.phase_match
#print axioms Heraclitus.UpperPhaseBridge.phase_match
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.phase_route"
#check @Heraclitus.UpperPhaseBridge.phase_route
#print axioms Heraclitus.UpperPhaseBridge.phase_route
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.reached_entrance"
#check @Heraclitus.UpperPhaseBridge.reached_entrance
#print axioms Heraclitus.UpperPhaseBridge.reached_entrance
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.reached_ordinary_ladder"
#check @Heraclitus.UpperPhaseBridge.reached_ordinary_ladder
#print axioms Heraclitus.UpperPhaseBridge.reached_ordinary_ladder
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperPhaseBridge.scale_parameters"
#check @Heraclitus.UpperPhaseBridge.scale_parameters
#print axioms Heraclitus.UpperPhaseBridge.scale_parameters
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.actual_crossing_start"
#check @Heraclitus.UpperReturnGeometry.actual_crossing_start
#print axioms Heraclitus.UpperReturnGeometry.actual_crossing_start
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.all_phase_crossing_offsets"
#check @Heraclitus.UpperReturnGeometry.all_phase_crossing_offsets
#print axioms Heraclitus.UpperReturnGeometry.all_phase_crossing_offsets
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.all_phase_radius_bounds"
#check @Heraclitus.UpperReturnGeometry.all_phase_radius_bounds
#print axioms Heraclitus.UpperReturnGeometry.all_phase_radius_bounds
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.boundary_used_upper"
#check @Heraclitus.UpperReturnGeometry.boundary_used_upper
#print axioms Heraclitus.UpperReturnGeometry.boundary_used_upper
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.crossing_time"
#check @Heraclitus.UpperReturnGeometry.crossing_time
#print axioms Heraclitus.UpperReturnGeometry.crossing_time
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.entrance_prefix_cover"
#check @Heraclitus.UpperReturnGeometry.entrance_prefix_cover
#print axioms Heraclitus.UpperReturnGeometry.entrance_prefix_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.original_rule_entrance_tail"
#check @Heraclitus.UpperReturnGeometry.original_rule_entrance_tail
#print axioms Heraclitus.UpperReturnGeometry.original_rule_entrance_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.original_rule_radius_lower"
#check @Heraclitus.UpperReturnGeometry.original_rule_radius_lower
#print axioms Heraclitus.UpperReturnGeometry.original_rule_radius_lower
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.original_rule_radius_upper"
#check @Heraclitus.UpperReturnGeometry.original_rule_radius_upper
#print axioms Heraclitus.UpperReturnGeometry.original_rule_radius_upper
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.original_rule_return_geometry"
#check @Heraclitus.UpperReturnGeometry.original_rule_return_geometry
#print axioms Heraclitus.UpperReturnGeometry.original_rule_return_geometry
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.original_rule_scale_radius"
#check @Heraclitus.UpperReturnGeometry.original_rule_scale_radius
#print axioms Heraclitus.UpperReturnGeometry.original_rule_scale_radius
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.record_radius_bound"
#check @Heraclitus.UpperReturnGeometry.record_radius_bound
#print axioms Heraclitus.UpperReturnGeometry.record_radius_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnGeometry.two_moves_valid"
#check @Heraclitus.UpperReturnGeometry.two_moves_valid
#print axioms Heraclitus.UpperReturnGeometry.two_moves_valid
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.actual_approach"
#check @Heraclitus.UpperReturnTail.actual_approach
#print axioms Heraclitus.UpperReturnTail.actual_approach
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.actual_post"
#check @Heraclitus.UpperReturnTail.actual_post
#print axioms Heraclitus.UpperReturnTail.actual_post
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.actual_post_core"
#check @Heraclitus.UpperReturnTail.actual_post_core
#print axioms Heraclitus.UpperReturnTail.actual_post_core
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.actual_short_post"
#check @Heraclitus.UpperReturnTail.actual_short_post
#print axioms Heraclitus.UpperReturnTail.actual_short_post
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.actual_transfer"
#check @Heraclitus.UpperReturnTail.actual_transfer
#print axioms Heraclitus.UpperReturnTail.actual_transfer
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.after_core_to_checkpoint"
#check @Heraclitus.UpperReturnTail.after_core_to_checkpoint
#print axioms Heraclitus.UpperReturnTail.after_core_to_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.approach_cover"
#check @Heraclitus.UpperReturnTail.approach_cover
#print axioms Heraclitus.UpperReturnTail.approach_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.approach_exponent"
#check @Heraclitus.UpperReturnTail.approach_exponent
#print axioms Heraclitus.UpperReturnTail.approach_exponent
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.approach_local_cover"
#check @Heraclitus.UpperReturnTail.approach_local_cover
#print axioms Heraclitus.UpperReturnTail.approach_local_cover
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.approach_member"
#check @Heraclitus.UpperReturnTail.approach_member
#print axioms Heraclitus.UpperReturnTail.approach_member
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.approach_scale"
#check @Heraclitus.UpperReturnTail.approach_scale
#print axioms Heraclitus.UpperReturnTail.approach_scale
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.following_checkpoint"
#check @Heraclitus.UpperReturnTail.following_checkpoint
#print axioms Heraclitus.UpperReturnTail.following_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.original_rule_core_to_checkpoint"
#check @Heraclitus.UpperReturnTail.original_rule_core_to_checkpoint
#print axioms Heraclitus.UpperReturnTail.original_rule_core_to_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.outer_member"
#check @Heraclitus.UpperReturnTail.outer_member
#print axioms Heraclitus.UpperReturnTail.outer_member
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.post_approach"
#check @Heraclitus.UpperReturnTail.post_approach
#print axioms Heraclitus.UpperReturnTail.post_approach
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.post_member"
#check @Heraclitus.UpperReturnTail.post_member
#print axioms Heraclitus.UpperReturnTail.post_member
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.post_phase"
#check @Heraclitus.UpperReturnTail.post_phase
#print axioms Heraclitus.UpperReturnTail.post_phase
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.tail_enlarge"
#check @Heraclitus.UpperReturnTail.tail_enlarge
#print axioms Heraclitus.UpperReturnTail.tail_enlarge
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperReturnTail.tail_join"
#check @Heraclitus.UpperReturnTail.tail_join
#print axioms Heraclitus.UpperReturnTail.tail_join
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.actual_core_start"
#check @Heraclitus.UpperScaleAssembly.actual_core_start
#print axioms Heraclitus.UpperScaleAssembly.actual_core_start
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.canonical_three_eighths"
#check @Heraclitus.UpperScaleAssembly.canonical_three_eighths
#print axioms Heraclitus.UpperScaleAssembly.canonical_three_eighths
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.crossing_after_checkpoint"
#check @Heraclitus.UpperScaleAssembly.crossing_after_checkpoint
#print axioms Heraclitus.UpperScaleAssembly.crossing_after_checkpoint
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.cycle_index_exists"
#check @Heraclitus.UpperScaleAssembly.cycle_index_exists
#print axioms Heraclitus.UpperScaleAssembly.cycle_index_exists
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.cycle_index_unique"
#check @Heraclitus.UpperScaleAssembly.cycle_index_unique
#print axioms Heraclitus.UpperScaleAssembly.cycle_index_unique
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.exponent_large"
#check @Heraclitus.UpperScaleAssembly.exponent_large
#print axioms Heraclitus.UpperScaleAssembly.exponent_large
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.original_rule_eventual_upper"
#check @Heraclitus.UpperScaleAssembly.original_rule_eventual_upper
#print axioms Heraclitus.UpperScaleAssembly.original_rule_eventual_upper
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.original_rule_phase_bound"
#check @Heraclitus.UpperScaleAssembly.original_rule_phase_bound
#print axioms Heraclitus.UpperScaleAssembly.original_rule_phase_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.original_rule_return_tail"
#check @Heraclitus.UpperScaleAssembly.original_rule_return_tail
#print axioms Heraclitus.UpperScaleAssembly.original_rule_return_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.original_rule_scale_bound"
#check @Heraclitus.UpperScaleAssembly.original_rule_scale_bound
#print axioms Heraclitus.UpperScaleAssembly.original_rule_scale_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.original_rule_three_eighths"
#check @Heraclitus.UpperScaleAssembly.original_rule_three_eighths
#print axioms Heraclitus.UpperScaleAssembly.original_rule_three_eighths
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.return_defect"
#check @Heraclitus.UpperScaleAssembly.return_defect
#print axioms Heraclitus.UpperScaleAssembly.return_defect
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperScaleAssembly.scale_large"
#check @Heraclitus.UpperScaleAssembly.scale_large
#print axioms Heraclitus.UpperScaleAssembly.scale_large
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.actual_catalogue_tail"
#check @Heraclitus.UpperTransferPrefix.actual_catalogue_tail
#print axioms Heraclitus.UpperTransferPrefix.actual_catalogue_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.actual_tail"
#check @Heraclitus.UpperTransferPrefix.actual_tail
#print axioms Heraclitus.UpperTransferPrefix.actual_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.actual_transfer_tail"
#check @Heraclitus.UpperTransferPrefix.actual_transfer_tail
#print axioms Heraclitus.UpperTransferPrefix.actual_transfer_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.append"
#check @Heraclitus.UpperTransferPrefix.append
#print axioms Heraclitus.UpperTransferPrefix.append
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.catalogue_prefixes"
#check @Heraclitus.UpperTransferPrefix.catalogue_prefixes
#print axioms Heraclitus.UpperTransferPrefix.catalogue_prefixes
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.catalogue_uniform"
#check @Heraclitus.UpperTransferPrefix.catalogue_uniform
#print axioms Heraclitus.UpperTransferPrefix.catalogue_uniform
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.covered_node"
#check @Heraclitus.UpperTransferPrefix.covered_node
#print axioms Heraclitus.UpperTransferPrefix.covered_node
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.covered_tail"
#check @Heraclitus.UpperTransferPrefix.covered_tail
#print axioms Heraclitus.UpperTransferPrefix.covered_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.cycles"
#check @Heraclitus.UpperTransferPrefix.cycles
#print axioms Heraclitus.UpperTransferPrefix.cycles
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.execute_current_positive"
#check @Heraclitus.UpperTransferPrefix.execute_current_positive
#print axioms Heraclitus.UpperTransferPrefix.execute_current_positive
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.prefix_node_mem"
#check @Heraclitus.UpperTransferPrefix.prefix_node_mem
#print axioms Heraclitus.UpperTransferPrefix.prefix_node_mem
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.route"
#check @Heraclitus.UpperTransferPrefix.route
#print axioms Heraclitus.UpperTransferPrefix.route
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.route_bound"
#check @Heraclitus.UpperTransferPrefix.route_bound
#print axioms Heraclitus.UpperTransferPrefix.route_bound
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.transfer"
#check @Heraclitus.UpperTransferPrefix.transfer
#print axioms Heraclitus.UpperTransferPrefix.transfer
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.transfer_from_nodes"
#check @Heraclitus.UpperTransferPrefix.transfer_from_nodes
#print axioms Heraclitus.UpperTransferPrefix.transfer_from_nodes
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.transfer_tail"
#check @Heraclitus.UpperTransferPrefix.transfer_tail
#print axioms Heraclitus.UpperTransferPrefix.transfer_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.transfer_tower_tail"
#check @Heraclitus.UpperTransferPrefix.transfer_tower_tail
#print axioms Heraclitus.UpperTransferPrefix.transfer_tower_tail
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.uniform"
#check @Heraclitus.UpperTransferPrefix.uniform
#print axioms Heraclitus.UpperTransferPrefix.uniform
#eval IO.println "END"
#eval IO.println "BEGIN Heraclitus.UpperTransferPrefix.uniform_from_nodes"
#check @Heraclitus.UpperTransferPrefix.uniform_from_nodes
#print axioms Heraclitus.UpperTransferPrefix.uniform_from_nodes
#eval IO.println "END"
example : Heraclitus.UpperMachineAudit.OriginalRuleThreeEighths := Heraclitus.UpperScaleAssembly.original_rule_three_eighths
#print Heraclitus.UpperMachineAudit.defect
#print Heraclitus.UpperMachineAudit.EventualUpperBound
#print Heraclitus.UpperMachineAudit.FrequentLowerBound
#print Heraclitus.UpperMachineAudit.OriginalRuleThreeEighths
