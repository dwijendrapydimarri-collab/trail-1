abstract class UserRepository {
  Future<String?> getCurrentUserId();
  Future<void> signInAnonymously();
}
