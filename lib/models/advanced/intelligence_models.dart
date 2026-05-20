class TrainingLoadReport {
  final double acuteLoad; // Last 7 days volume
  final double chronicLoad; // Last 28 days average weekly volume
  final double loadRatio; // acute / chronic
  final double readinessScore; // 0-100
  final String status; // Undertraining, Productive, High Load, Fatigue Risk

  TrainingLoadReport({
    required this.acuteLoad,
    required this.chronicLoad,
    required this.loadRatio,
    required this.readinessScore,
    required this.status,
  });
}

class MuscleBalanceReport {
  final Map<String, double> currentWeeklyVolume;
  final Map<String, double> baselineWeeklyVolume;
  final List<String> undertrainedMuscles;
  final List<String> overtrainedMuscles;
  final double balanceScore;

  MuscleBalanceReport({
    required this.currentWeeklyVolume,
    required this.baselineWeeklyVolume,
    required this.undertrainedMuscles,
    required this.overtrainedMuscles,
    required this.balanceScore,
  });
}

class ProgressionRecommendation {
  final String exerciseId;
  final String exerciseName;
  final String suggestion; // e.g. "Increase Weight", "Deload", "Maintain"

  ProgressionRecommendation({
    required this.exerciseId,
    required this.exerciseName,
    required this.suggestion,
  });
}

class RivalGapReport {
  final String rivalUsername;
  final double volumeGap;
  final int estimatedSetsNeeded;
  final int estimatedSessionsNeeded;

  RivalGapReport({
    required this.rivalUsername,
    required this.volumeGap,
    required this.estimatedSetsNeeded,
    required this.estimatedSessionsNeeded,
  });
}

class LiftIQMission {
  final String title;
  final String description;
  final String targetMuscleGroup;
  final double targetVolume;

  LiftIQMission({
    required this.title,
    required this.description,
    required this.targetMuscleGroup,
    required this.targetVolume,
  });
}

class LiftIQCoachBrief {
  final TrainingLoadReport loadReport;
  final MuscleBalanceReport balanceReport;
  final List<ProgressionRecommendation> recommendations;
  final RivalGapReport? rivalGap;
  final LiftIQMission nextMission;
  final String summaryMessage;

  LiftIQCoachBrief({
    required this.loadReport,
    required this.balanceReport,
    required this.recommendations,
    this.rivalGap,
    required this.nextMission,
    required this.summaryMessage,
  });
}
