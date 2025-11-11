// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:book_swap/presentation/screens/main/browse_screen.dart';
import 'package:book_swap/presentation/screens/main/my_listings_screen.dart';
// We can leave this import
import 'package:book_swap/presentation/screens/main/settings_screen.dart';

// --- THIS IS THE LINE YOU ARE LIKELY MISSING ---
import 'package:book_swap/presentation/screens/main/chat_screen.dart';
// --- END OF FIX ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // The 'ChatsScreen' class will now be found
  static final List<Widget> _pages = <Widget>[
    const BrowseScreen(),
    const MyListingsScreen(),
    const ChatsScreen(), // This will now be correct
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Listings'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
