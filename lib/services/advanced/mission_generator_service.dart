import 'package:app/models/advanced/intelligence_models.dart';

class ProgressionRecommendationService {
  List<ProgressionRecommendation> generateRecommendations(
    MuscleBalanceReport balance,
  ) {
    List<ProgressionRecommendation> recs = [];

    for (final muscle in balance.undertrainedMuscles) {
      recs.add(
        ProgressionRecommendation(
          exerciseId: 'system',
          exerciseName: '$muscle Focus',
          suggestion: 'Increase Volume',
        ),
      );
    }

    if (recs.isEmpty) {
      recs.add(
        ProgressionRecommendation(
          exerciseId: 'system',
          exerciseName: 'Full Body',
          suggestion: 'Maintain Progressive Overload',
        ),
      );
    }

    return recs;
  }
}

class MissionGeneratorService {
  LiftIQMission generateMission(
    MuscleBalanceReport balance,
    RivalGapReport? rivalGap,
  ) {
    String targetMuscle = 'Full Body';
    double volumeTarget = 10000;

    if (balance.undertrainedMuscles.isNotEmpty) {
      targetMuscle = balance.undertrainedMuscles.first;
    }

    if (rivalGap != null && rivalGap.volumeGap > 0) {
      volumeTarget = rivalGap.volumeGap > 15000 ? 15000 : rivalGap.volumeGap;
    }

    return LiftIQMission(
      title: 'Operation $targetMuscle',
      description: 'Your $targetMuscle is lagging. Close the gap today.',
      targetMuscleGroup: targetMuscle,
      targetVolume: volumeTarget,
    );
  }
}

class LiftIQCoachService {
  LiftIQCoachBrief generateBrief({
    required TrainingLoadReport load,
    required MuscleBalanceReport balance,
    required List<ProgressionRecommendation> recs,
    RivalGapReport? rivalGap,
    required LiftIQMission mission,
  }) {
    String message = 'Keep pushing!';

    if (load.status == 'Fatigue Risk') {
      message =
          'High fatigue detected. Consider a deload or active recovery session.';
    } else if (rivalGap != null) {
      message =
          'You are ${(rivalGap.volumeGap / 1000).toStringAsFixed(1)}k kg from overtaking ${rivalGap.rivalUsername}. A heavy ${mission.targetMuscleGroup} session will close the gap.';
    } else if (balance.undertrainedMuscles.isNotEmpty) {
      message =
          'Your ${balance.undertrainedMuscles.join(" and ")} needs work to maintain optimal balance.';
    }

    return LiftIQCoachBrief(
      loadReport: load,
      balanceReport: balance,
      recommendations: recs,
      rivalGap: rivalGap,
      nextMission: mission,
      summaryMessage: message,
    );
  }
}
