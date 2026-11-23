import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reading_tracker/features/auth/providers/auth_provider.dart';
import 'package:reading_tracker/features/auth/repositories/fake_auth_repository.dart';
import 'package:reading_tracker/features/auth/screens/login_screen.dart';
import '../support/memory_token_store.dart';

void main() {
  testWidgets('invalid password shows login error', (tester) async {
    final auth = AuthProvider(repository: FakeAuthRepository(delay: Duration.zero),
      tokens: MemoryTokenStore());
    await tester.pumpWidget(ChangeNotifierProvider.value(value: auth,
      child: const MaterialApp(home: LoginScreen())));
    await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(auth.isSignedIn, isFalse);
    expect(find.textContaining('Session expired'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
    auth.dispose();
  });
}
