// lib/presentation/screens/main/settings_screen.dart
import 'package:book_swap/presentation/providers/auth_providers.dart';
import 'package:book_swap/presentation/screens/main/my_offers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. Import Riverpod

// 2. Change to a ConsumerStatefulWidget to use 'ref'
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  // 3. Update state class
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

// 4. Update state class
class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = true;
  bool _emailUpdates = true;

  @override
  Widget build(BuildContext context) {
    // 5. Get the user's data from the auth provider
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFE9C46A), // Yellow
            child: Icon(
              Icons.person,
              size: 50,
              color: Color(0xFF1A1A2E), // Dark blue
            ),
          ),
          const SizedBox(height: 8),
          // 6. Show the REAL user's info
          Text(
            user?.displayName ?? 'Book Swapper', // Real name
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'No email', // Real email
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          SwitchListTile(
            title: const Text(
              'Notification reminders',
              style: TextStyle(color: Colors.white),
            ),
            value: _notifications,
            onChanged: (bool value) {
              setState(() {
                _notifications = value;
              });
            },
            activeTrackColor: const Color(0xFFE9C46A),
            activeThumbColor: Colors.white,
          ),
          SwitchListTile(
            title: const Text(
              'Email Updates',
              style: TextStyle(color: Colors.white),
            ),
            value: _emailUpdates,
            onChanged: (bool value) {
              setState(() {
                _emailUpdates = value;
              });
            },
            activeTrackColor: const Color(0xFFE9C46A),
            activeThumbColor: Colors.white,
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white70),
            title: const Text('About', style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Show an 'About' dialog
            },
          ),
          // 7. This is the updated "Log Out" button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              // Call the REAL logout function from your provider
              ref.read(authControllerProvider.notifier).logOut();
            },
          ),
        ],
      ),
    );
  }
}
