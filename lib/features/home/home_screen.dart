import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _message;
  bool _loading = false;
  String? _error;

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = ref.read(authRepositoryProvider);

    try {
      final data = await repo.getProfile();
      setState(() {
        _message = jsonEncode(data);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('خانه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authNotifier.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
            ? Text(_error!, style: const TextStyle(color: Colors.red))
            : Text(_message ?? 'هیچ داده‌ای دریافت نشد'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadProfile,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
