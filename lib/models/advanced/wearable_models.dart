class RecoverySignal {
  final DateTime date;
  final double hrvScore; // 0-100
  final double sleepScore; // 0-100
  final double restingHeartRate;

  RecoverySignal({
    required this.date,
    required this.hrvScore,
    required this.sleepScore,
    required this.restingHeartRate,
  });
}

class VideoSetReview {
  final String setId;
  final String videoUrl;
  final double estimatedRpe;
  final double averageBarVelocity;

  VideoSetReview({
    required this.setId,
    required this.videoUrl,
    required this.estimatedRpe,
    required this.averageBarVelocity,
  });
}
