import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required String baseUrl, http.Client? client})
    : baseUrl = baseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  // HTTP Headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Tạo URL cho API
  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final uri = Uri.parse('$baseUrl$path');

    if (queryParameters != null) {
      return uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }

  // GET
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return await _client
        .get(
          _buildUri(path, queryParameters: queryParameters),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 30));
  }

  // POST
  Future<http.Response> post(String path, {Object? body}) async {
    return await _client
        .post(
          _buildUri(path),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 30));
  }

  // PUT
  Future<http.Response> put(String path, {Object? body}) async {
    return await _client
        .put(
          _buildUri(path),
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 30));
  }

  // DELETE
  Future<http.Response> delete(String path) async {
    return await _client
        .delete(_buildUri(path), headers: _headers)
        .timeout(const Duration(seconds: 30));
  }

  // Đóng HTTP Client
  void dispose() {
    _client.close();
  }
}
