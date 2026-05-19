import 'package:app/models/routine.dart';

class WorkoutSession {
  final String id;
  final String userId;
  final Routine routine;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalVolume;
  final int totalSets;
  final int xpEarned;
  final Map<String, double> muscleGroupVolumes;

  WorkoutSession({
    required this.id,
    this.userId = '',
    required this.routine,
    required this.startTime,
    this.endTime,
    this.totalVolume = 0.0,
    this.totalSets = 0,
    this.xpEarned = 0,
    this.muscleGroupVolumes = const {},
  });

  WorkoutSession copyWith({
    String? id,
    String? userId,
    Routine? routine,
    DateTime? startTime,
    DateTime? endTime,
    double? totalVolume,
    int? totalSets,
    int? xpEarned,
    Map<String, double>? muscleGroupVolumes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      routine: routine ?? this.routine,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalVolume: totalVolume ?? this.totalVolume,
      totalSets: totalSets ?? this.totalSets,
      xpEarned: xpEarned ?? this.xpEarned,
      muscleGroupVolumes: muscleGroupVolumes ?? this.muscleGroupVolumes,
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? '',
      routine: Routine.fromJson(json['routine'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      totalVolume: (json['totalVolume'] as num?)?.toDouble() ?? 0.0,
      totalSets: json['totalSets'] as int? ?? 0,
      xpEarned: json['xpEarned'] as int? ?? 0,
      muscleGroupVolumes:
          (json['muscleGroupVolumes'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'routine': routine.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalVolume': totalVolume,
      'totalSets': totalSets,
      'xpEarned': xpEarned,
      'muscleGroupVolumes': muscleGroupVolumes,
    };
  }
}
