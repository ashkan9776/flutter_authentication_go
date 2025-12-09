
import 'package:flutter_riverpod/legacy.dart';

import 'auth_repository.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final isLoggedIn = await _repository.isLoggedIn();
    state = state.copyWith(
      status: isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.login(username, password);
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.authenticated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.register(username, password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}
