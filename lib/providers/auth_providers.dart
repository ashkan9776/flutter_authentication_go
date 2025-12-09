import 'package:flutter_application_1/features/auth/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/api_client.dart';
import '../core/auth_storage.dart';
import '../features/auth/auth_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final authStorageProvider = Provider<AuthStorage>((ref) {
  return AuthStorage();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final storage = ref.read(authStorageProvider);
  return AuthRepository(apiClient, storage);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(repo);
});
