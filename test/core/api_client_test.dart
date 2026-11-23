import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reading_tracker/core/api/api_client.dart';
import 'package:reading_tracker/core/api/api_exception.dart';
import '../support/memory_token_store.dart';

void main() {
  test('404 maps to NotFoundException', () async {
    final client = ApiClient(MockClient((_) async => http.Response('{}', 404)),
      host: 'example.org', tokens: MemoryTokenStore());
    expect(client.getJson('/book'), throwsA(isA<NotFoundException>()));
  });
  test('503 maps to ServerException', () async {
    final client = ApiClient(MockClient((_) async => http.Response('{}', 503)),
      host: 'example.org', tokens: MemoryTokenStore());
    expect(client.getJson('/book'), throwsA(isA<ServerException>()));
  });
  test('socket failure maps to NoConnectionException', () async {
    final client = ApiClient(MockClient((_) async => throw const SocketException('offline')),
      host: 'example.org', tokens: MemoryTokenStore());
    expect(client.getJson('/book'), throwsA(isA<NoConnectionException>()));
  });
  test('malformed JSON maps to BadResponseException', () async {
    final client = ApiClient(MockClient((_) async => http.Response('broken', 200)),
      host: 'example.org', tokens: MemoryTokenStore());
    expect(client.getJson('/book'), throwsA(isA<BadResponseException>()));
  });
}
