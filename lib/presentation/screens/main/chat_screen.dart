// lib/presentation/screens/main/chat_screen.dart
import 'package:book_swap/presentation/screens/main/chat_detail_screen.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We'll just show one mock conversation for now
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE9C46A),
              child: Text('A', style: TextStyle(color: Colors.black)),
            ),
            title: const Text(
              'Alice', // Mock user
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'How about tomorrow?', // Last message
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Text(
              '10:32 AM',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            onTap: () {
              // Navigate to the detail screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatDetailScreen(),
                ),
              );
            },
          ),
          const Divider(color: Colors.white24),
        ],
      ),
    );
  }
}
