import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_application_1/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    Widget home;
    switch (authState.status) {
      case AuthStatus.unknown:
        home = const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
        break;
      case AuthStatus.unauthenticated:
        home = const LoginScreen();
        break;
      case AuthStatus.authenticated:
        home = const HomeScreen();
        break;
    }

    return MaterialApp(
      title: 'Flutter + Go Clean Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
