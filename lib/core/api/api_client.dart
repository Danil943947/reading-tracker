import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../storage/token_store.dart';
import 'api_exception.dart';

// Prepared for week 2. Fake mode never creates or calls this client.
class ApiClient {
  ApiClient(this._client, {required this.host, required this._tokens});
  final http.Client _client;
  final String host;
  final TokenStore _tokens;

  Future<dynamic> getJson(String path, {Map<String, String>? query, bool authenticated = false}) =>
      _request('GET', path, query: query, authenticated: authenticated);

  Future<dynamic> postJson(String path, Map<String, dynamic> body, {bool authenticated = true}) =>
      _request('POST', path, body: body, authenticated: authenticated);

  Future<dynamic> putJson(String path, Map<String, dynamic> body, {bool authenticated = true}) =>
      _request('PUT', path, body: body, authenticated: authenticated);

  Future<dynamic> deleteJson(String path, {bool authenticated = true}) =>
      _request('DELETE', path, authenticated: authenticated);

  Future<dynamic> _request(String method, String path, {
    Map<String, String>? query, Map<String, dynamic>? body, bool authenticated = false,
  }) async {
    final uri = Uri.https(host, path, query);
    final token = authenticated ? await _tokens.readToken() : null;
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final stopwatch = Stopwatch()..start();
    late final http.Response response;
    try {
      final future = switch (method) {
        'GET' => _client.get(uri, headers: headers),
        'POST' => _client.post(uri, headers: headers, body: jsonEncode(body)),
        'PUT' => _client.put(uri, headers: headers, body: jsonEncode(body)),
        'DELETE' => _client.delete(uri, headers: headers),
        _ => throw const RequestException('Unsupported HTTP method'),
      };
      response = await future.timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    } finally {
      stopwatch.stop();
    }
    if (kDebugMode) {
      developer.log('$method ${uri.path} ${response.statusCode} ${stopwatch.elapsedMilliseconds}ms', name: 'api');
    }
    _check(response);
    if (response.body.trim().isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } on FormatException catch (error) {
      throw BadResponseException('$path: invalid JSON ($error)');
    }
  }

  void _check(http.Response response) {
    final code = response.statusCode;
    if (code == 401) throw const UnauthorizedException();
    if (code == 404) throw const NotFoundException();
    if (code >= 500) throw ServerException(code);
    if (code >= 400) throw RequestException('Request failed ($code)');
    if (code < 200 || code >= 300) throw RequestException('Unexpected status ($code)');
  }
}
