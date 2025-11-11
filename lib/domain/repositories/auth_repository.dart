abstract class AuthRepository {
  Future<void> signUp(String email, String password, String displayName);
  Future<void> logIn(String email, String password);
  Future<void> logOut();
  // We'll add more here later
}
