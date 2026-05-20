import 'package:app/models/advanced/intelligence_models.dart';
import 'package:app/models/workout_session.dart';

class TrainingLoadService {
  TrainingLoadReport calculateLoad(List<WorkoutSession> history) {
    final now = DateTime.now();
    double acuteLoad = 0;
    double totalChronicLoad = 0;

    for (final session in history) {
      final daysDiff = now
          .difference(session.endTime ?? session.startTime)
          .inDays;
      if (daysDiff <= 7) {
        acuteLoad += session.totalVolume;
      }
      if (daysDiff <= 28) {
        totalChronicLoad += session.totalVolume;
      }
    }

    final chronicLoad = totalChronicLoad / 4; // average per week
    double loadRatio = 0.0;

    if (chronicLoad > 0) {
      loadRatio = acuteLoad / chronicLoad;
    }

    String status;
    double readinessScore;

    if (loadRatio < 0.80) {
      status = 'Undertraining';
      readinessScore = 90.0;
    } else if (loadRatio <= 1.30) {
      status = 'Productive';
      readinessScore = 100.0 - ((loadRatio - 0.8) * 40); // 80-100 range roughly
    } else if (loadRatio <= 1.60) {
      status = 'High Load';
      readinessScore = 50.0;
    } else {
      status = 'Fatigue Risk';
      readinessScore = 20.0;
    }

    // Catch-all for new users
    if (chronicLoad == 0) {
      status = 'Calibrating';
      readinessScore = 100.0;
    }

    return TrainingLoadReport(
      acuteLoad: acuteLoad,
      chronicLoad: chronicLoad,
      loadRatio: loadRatio,
      readinessScore: readinessScore.clamp(0, 100),
      status: status,
    );
  }
}
