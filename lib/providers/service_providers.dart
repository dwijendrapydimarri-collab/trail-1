import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/workout_stats_service.dart';
import 'package:app/services/personal_record_service.dart';
import 'package:app/services/progression_service.dart';
import 'package:app/services/advanced/training_load_service.dart';
import 'package:app/services/advanced/muscle_balance_service.dart';
import 'package:app/services/advanced/rival_gap_service.dart';
import 'package:app/services/advanced/mission_generator_service.dart';

final workoutStatsServiceProvider = Provider((ref) => WorkoutStatsService());
final personalRecordServiceProvider = Provider(
  (ref) => PersonalRecordService(),
);
final progressionServiceProvider = Provider((ref) => ProgressionService());

final trainingLoadServiceProvider = Provider((ref) => TrainingLoadService());
final muscleBalanceServiceProvider = Provider((ref) => MuscleBalanceService());
final rivalGapServiceProvider = Provider((ref) => RivalGapService());
final progressionRecommendationServiceProvider = Provider(
  (ref) => ProgressionRecommendationService(),
);
final missionGeneratorServiceProvider = Provider(
  (ref) => MissionGeneratorService(),
);
final liftIQCoachServiceProvider = Provider((ref) => LiftIQCoachService());
