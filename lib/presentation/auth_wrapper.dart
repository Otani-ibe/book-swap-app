// lib/presentation/auth_wrapper.dart
import 'package:book_swap/presentation/providers/auth_providers.dart';
import 'package:book_swap/presentation/screens/auth/login_screen.dart';
import 'package:book_swap/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- THIS IS THE REAL, LIVE LOGIC ---
    // We are now watching the real authStateProvider
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // Check if user is logged in AND email is verified
        if (user != null && user.emailVerified) {
          return const HomeScreen(); // User is logged in
        }
        // If user is null, or not verified, show Login
        return const LoginScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
    // --- END OF REAL LOGIC ---
  }
}
