import 'package:flutter_test/flutter_test.dart';
import 'package:reading_tracker/features/auth/providers/auth_provider.dart';
import 'package:reading_tracker/features/auth/repositories/fake_auth_repository.dart';
import '../support/memory_token_store.dart';

void main() {
  late AuthProvider auth;
  late MemoryTokenStore tokens;
  setUp(() {
    tokens = MemoryTokenStore();
    auth = AuthProvider(repository: FakeAuthRepository(delay: Duration.zero), tokens: tokens);
  });
  tearDown(() => auth.dispose());
  test('correct demo password signs in', () async {
    expect(await auth.login('reader@example.com', 'password123'), isTrue);
    expect(auth.isSignedIn, isTrue);
    expect(tokens.value, isNotNull);
  });
  test('wrong password does not sign in', () async {
    expect(await auth.login('reader@example.com', 'wrong'), isFalse);
    expect(auth.isSignedIn, isFalse);
  });
  test('restore uses previously saved secure token', () async {
    tokens.value = 'stored';
    await auth.restoreSession();
    expect(auth.isSignedIn, isTrue);
  });
  test('sign out deletes token', () async {
    await auth.login('reader@example.com', 'password123');
    await auth.signOut();
    expect(tokens.value, isNull);
    expect(auth.isSignedIn, isFalse);
  });
}
