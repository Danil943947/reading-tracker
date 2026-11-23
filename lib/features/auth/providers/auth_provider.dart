import 'package:flutter/foundation.dart';
import '../../../core/storage/token_store.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.repository, required this.tokens});
  final AuthRepository repository;
  final TokenStore tokens;
  String? _token;
  bool isBusy = false;
  Object? error;

  bool get isSignedIn => _token?.isNotEmpty ?? false;

  Future<void> restoreSession() async {
    _token = await tokens.readToken();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (isBusy) return false;
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      final session = await repository.login(email, password);
      await tokens.saveToken(session.token);
      _token = session.token;
      return true;
    } catch (e) {
      error = e;
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (isBusy) return;
    isBusy = true;
    notifyListeners();
    try {
      await tokens.deleteToken();
      _token = null;
      error = null;
    } catch (e) {
      error = e;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
