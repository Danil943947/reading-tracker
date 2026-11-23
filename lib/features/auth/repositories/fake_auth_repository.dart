import '../../../core/api/api_exception.dart';
import '../models/auth_session.dart';
import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.delay = const Duration(milliseconds: 200), this.shouldFail = false});
  final Duration delay;
  bool shouldFail;
  static const demoEmail = 'reader@example.com';
  static const demoPassword = 'password123';

  @override
  Future<AuthSession> login(String email, String password) async {
    // With zero delay do not schedule an event-loop timer in widget tests.
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (shouldFail) throw const NoConnectionException();
    if (email.trim().toLowerCase() != demoEmail || password != demoPassword) {
      throw const UnauthorizedException();
    }
    return const AuthSession(token: 'offline-demo-token', email: demoEmail);
  }
}
