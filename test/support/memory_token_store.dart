import 'package:reading_tracker/core/storage/token_store.dart';

class MemoryTokenStore implements TokenStore {
  String? value;
  @override
  Future<String?> readToken() async => value;
  @override
  Future<void> saveToken(String token) async { value = token; }
  @override
  Future<void> deleteToken() async { value = null; }
}
