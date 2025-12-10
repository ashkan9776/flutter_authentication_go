import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final authController = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('خانه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: profileAsync.when(
          data: (profile) {
            // profile از نوع Profile است
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'سلام ${profile.username} 👋',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(profile.message),
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'خطا در دریافت پروفایل:\n$err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.refresh(profileProvider);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
