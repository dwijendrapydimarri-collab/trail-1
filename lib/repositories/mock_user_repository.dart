import 'package:app/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<String?> getCurrentUserId() async {
    return 'user_123';
  }

  @override
  Future<void> signInAnonymously() async {
    // Mock sign in
  }
}
