import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8080';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    return _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    return _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    );
  }
}
