import 'package:app/models/workout_session.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/models/advanced/intelligence_models.dart';

class WorkoutRecap {
  final WorkoutSession session;
  final List<PersonalRecord> newPrs;
  final int streakDays;
  final int rankMovement;
  final String nextSuggestedGoal;
  final LiftIQCoachBrief? coachBrief;

  WorkoutRecap({
    required this.session,
    this.newPrs = const [],
    this.streakDays = 0,
    this.rankMovement = 0,
    this.nextSuggestedGoal = "Rest and recover!",
    this.coachBrief,
  });
}
