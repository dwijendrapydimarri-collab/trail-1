import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _auth;

  FirebaseUserRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  @override
  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }
}
