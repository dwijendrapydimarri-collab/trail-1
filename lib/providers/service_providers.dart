import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/workout_stats_service.dart';
import 'package:app/services/personal_record_service.dart';
import 'package:app/services/progression_service.dart';

final workoutStatsServiceProvider = Provider((ref) => WorkoutStatsService());
final personalRecordServiceProvider = Provider(
  (ref) => PersonalRecordService(),
);
final progressionServiceProvider = Provider((ref) => ProgressionService());
