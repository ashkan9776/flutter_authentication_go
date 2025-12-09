import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegisterMode ? 'ثبت نام' : 'ورود'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'نام کاربری',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'رمز عبور',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (authState.errorMessage != null)
              Text(
                authState.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      final username = _usernameController.text.trim();
                      final password = _passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('نام کاربری و رمز عبور را وارد کنید'),
                          ),
                        );
                        return;
                      }

                      if (_isRegisterMode) {
                        await authNotifier.register(username, password);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ثبت نام انجام شد، حالا وارد شوید'),
                          ),
                        );
                        setState(() {
                          _isRegisterMode = false;
                        });
                      } else {
                        await authNotifier.login(username, password);
                      }
                    },
              child: authState.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isRegisterMode ? 'ثبت نام' : 'ورود'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegisterMode = !_isRegisterMode;
                });
              },
              child: Text(_isRegisterMode
                  ? 'حساب داری؟ برو صفحه ورود'
                  : 'حساب نداری؟ ثبت نام کن'),
            ),
          ],
        ),
      ),
    );
  }
}
