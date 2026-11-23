abstract interface class TokenStore {
  Future<String?> readToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}
