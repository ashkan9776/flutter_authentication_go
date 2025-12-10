import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:flutter_application_1/core/storage/auth_storage.dart';
import 'package:flutter_application_1/features/auth/data/models/profile.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  AuthRepository(this._apiClient, this._authStorage);

  Future<void> register(String username, String password) async {
    try {
      await _apiClient.postJson(
        '/register',
        body: {'username': username, 'password': password},
      );
      // اگر لازم داشتی می‌تونی پیام برگشتی رو هم بخونی
    } on ApiException catch (e) {
      // تبدیل به AuthException که لایه بالاتر بدونه مربوط به auth است
      throw AuthException(e.message);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final data = await _apiClient.postJson(
        '/login',
        body: {'username': username, 'password': password},
      );

      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw AuthException('توکن از سرور دریافت نشد');
      }

      await _authStorage.saveToken(token);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<Profile> fetchProfile() async {
    final token = await _authStorage.getToken();
    if (token == null || token.isEmpty) {
      throw AuthException('Not logged in');
    }

    try {
      final data = await _apiClient.getJson(
        '/api/profile',
        headers: {'Authorization': 'Bearer $token'},
      );

      return Profile.fromJson(data);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<void> logout() async {
    await _authStorage.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _authStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
