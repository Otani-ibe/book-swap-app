// lib/presentation/auth_wrapper.dart
import 'package:book_swap/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LATER, we will use this Riverpod provider to check if the user is logged in
// final authStateProvider = StreamProvider<User?>((ref) {
//   // return ref.watch(firebaseAuthProvider).authStateChanges();
// });

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- THIS IS THE REAL LOGIC WE WILL USE LATER ---
    // final authState = ref.watch(authStateProvider);
    // return authState.when(
    //   data: (user) {
    //     if (user != null) {
    //       return const HomeScreen(); // User is logged in
    //     }
    //     return const LoginScreen(); // User is logged out
    //   },
    //   loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    //   error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    // );

    // --- THIS IS THE UPDATED PART FOR TESTING ---
    // We are temporarily skipping the LoginScreen to test our main app.
    return const HomeScreen();

    // --- To go back to the LoginScreen, comment out the line above
    // --- and uncomment this line:
    // return const LoginScreen();
  }
}
