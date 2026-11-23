import '../models/auth_session.dart';
abstract interface class AuthRepository {
  Future<AuthSession> login(String email, String password);
}
