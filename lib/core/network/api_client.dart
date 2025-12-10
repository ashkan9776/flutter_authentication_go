import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  ApiException(this.message, {this.statusCode, this.cause});

  @override
  String toString() => statusCode != null ? '[$statusCode] $message' : message;
}

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({String? baseUrl, http.Client? client})
    : baseUrl = _normalizeBaseUrl(baseUrl ?? 'http://10.0.2.2:8080'),
      _client = client ?? http.Client();

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = _buildUri(path);

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(timeout);

      return response;
    } catch (e) {
      throw ApiException('خطا در اتصال به سرور', cause: e);
    }
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final uri = _buildUri(path);

    try {
      final response = await _client
          .get(uri, headers: {'Content-Type': 'application/json', ...?headers})
          .timeout(timeout);

      return response;
    } catch (e) {
      throw ApiException('خطا در اتصال به سرور', cause: e);
    }
  }

  // ---------------------------
  // 🔥 متدهای جدید JSON
  // ---------------------------

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final response = await post(
      path,
      headers: headers,
      body: body,
      timeout: timeout,
    );

    final decoded = _decodeJson(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['error']?.toString() ?? 'درخواست با خطا مواجه شد',
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final response = await get(path, headers: headers, timeout: timeout);

    final decoded = _decodeJson(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['error']?.toString() ?? 'درخواست با خطا مواجه شد',
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }

  // ---------------------------
  // Helpers
  // ---------------------------

  static String _normalizeBaseUrl(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$normalizedPath');
  }

  Map<String, dynamic> _decodeJson(String body) {
    if (body.isEmpty) return {};
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;

    throw ApiException('فرمت JSON نامعتبر است');
  }
}
