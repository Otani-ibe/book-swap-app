// lib/presentation/screens/main/chat_detail_screen.dart
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Mock list of messages from your sample UI
  final List<Map<String, String>> _messages = [
    {"sender": "other", "text": "Hi, are you interested in finding?"},
    {"sender": "me", "text": "Yes, I'm interested!"},
    {"sender": "other", "text": "Great! When can we meet?"},
    {"sender": "me", "text": "How about tomorrow?"},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender": "me", "text": _messageController.text.trim()});
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alice'), // Mock chat partner name
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 1. List of messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isMe = message['sender'] == 'me';
                return _buildMessageBubble(message['text']!, isMe);
              },
            ),
          ),
          // 2. Message input field
          _buildTextInput(),
        ],
      ),
    );
  }

  // A widget for the text input bar
  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: const Color(0xFF2C2C4E), // Dark card color
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E), // Dark blue
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFFE9C46A)),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  // A widget for a single message bubble
  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFE9C46A) : const Color(0xFF2C2C4E),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
