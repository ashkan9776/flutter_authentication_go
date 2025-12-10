import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:flutter_application_1/core/storage/auth_storage.dart';
import 'package:flutter_application_1/features/auth/data/auth_repository.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/models/profile.dart';

/// ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// AuthStorage
final authStorageProvider = Provider<AuthStorage>((ref) {
  return AuthStorage();
});

/// AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(authStorageProvider);
  return AuthRepository(apiClient, storage);
});

/// AuthController (StateNotifier)
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo);
  },
);

/// پروفایل → FutureProvider جدا برای گرفتن /api/profile

final profileProvider = FutureProvider<Profile>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.fetchProfile();
});
