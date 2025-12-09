import 'dart:convert';

import '../../core/api_client.dart';
import '../../core/auth_storage.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  AuthRepository(this._apiClient, this._authStorage);

  Future<void> register(String username, String password) async {
    final response = await _apiClient.post(
      '/register',
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Register failed');
    }
  }

  Future<void> login(String username, String password) async {
    final response = await _apiClient.post(
      '/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Login failed');
    }

    final token = data['token'] as String?;
    if (token == null) {
      throw Exception('No token received');
    }

    await _authStorage.saveToken(token);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _authStorage.getToken();
    if (token == null) {
      throw Exception('Not logged in');
    }

    final response = await _apiClient.get(
      '/api/profile',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to fetch profile');
    }

    return data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _authStorage.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _authStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
