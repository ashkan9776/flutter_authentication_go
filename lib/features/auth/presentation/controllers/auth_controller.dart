import 'package:flutter_riverpod/legacy.dart';

import '../../data/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

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

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    final loggedIn = await _repository.isLoggedIn();
    state = state.copyWith(
      status: loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
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
        errorMessage: _mapErrorMessage(e),
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
        errorMessage: _mapErrorMessage(e),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
    );
  }

  String _mapErrorMessage(Object e) {
    if (e is AuthException) {
      final text = e.message.toLowerCase();
      if (text.contains('invalid credentials')) {
        return 'نام کاربری یا رمز عبور اشتباه است';
      }
      if (text.contains('user already exists')) {
        return 'این نام کاربری قبلاً ثبت شده است';
      }
      if (text.contains('not logged in')) {
        return 'ابتدا وارد حساب کاربری خود شوید';
      }
      // پیام خام سرور اگر نخواستی map کنی
      return e.message;
    }

    // برای هر ارور غیرمنتظره
    return 'خطای ناشناخته، کمی بعد دوباره تلاش کنید';
  }
}
