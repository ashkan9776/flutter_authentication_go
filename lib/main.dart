import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/auth_notifier.dart';
import 'package:flutter_application_1/features/auth/login_screen.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    Widget home;
    switch (authState.status) {
      case AuthStatus.unknown:
        home = const Scaffold(body: Center(child: CircularProgressIndicator()));
        break;
      case AuthStatus.unauthenticated:
        home = const LoginScreen();
        break;
      case AuthStatus.authenticated:
        home = const HomeScreen();
        break;
    }

    return MaterialApp(
      title: 'Flutter + Go Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
