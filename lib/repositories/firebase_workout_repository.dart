import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/models/user_progress.dart';
import 'package:app/repositories/workout_repository.dart';

class FirebaseWorkoutRepository implements WorkoutRepository {
  final FirebaseFirestore _firestore;

  FirebaseWorkoutRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    await _firestore
        .collection('workout_sessions')
        .doc(session.id)
        .set(session.toJson());
  }

  @override
  Future<List<WorkoutSession>> getWorkoutHistory(String userId) async {
    final snapshot = await _firestore
        .collection('workout_sessions')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => WorkoutSession.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> saveRoutine(Routine routine) async {
    await _firestore
        .collection('routines')
        .doc(routine.id)
        .set(routine.toJson());
  }

  @override
  Future<List<Routine>> getRoutines(String userId) async {
    final snapshot = await _firestore
        .collection('routines')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Routine.fromJson(doc.data())).toList();
  }

  @override
  Future<List<PersonalRecord>> getPersonalRecords(String userId) async {
    final snapshot = await _firestore
        .collection('personal_records')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => PersonalRecord.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> savePersonalRecord(String userId, PersonalRecord pr) async {
    await _firestore.collection('personal_records').add({
      ...pr.toJson(),
      'userId': userId,
    });
  }

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    final snapshot = await _firestore
        .collection('user_progress')
        .doc(userId)
        .get();
    if (!snapshot.exists) return null;
    return UserProgress.fromJson(snapshot.data()!);
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    await _firestore
        .collection('user_progress')
        .doc(progress.userId)
        .set(progress.toJson());
  }
}
