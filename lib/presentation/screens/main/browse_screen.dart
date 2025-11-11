// lib/presentation/screens/main/browse_screen.dart
import 'package:book_swap/presentation/providers/book_providers.dart';
import 'package:book_swap/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:book_swap/presentation/screens/main/post_book_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- 1. UPDATE ---
    // We now watch the new 'browseListProvider'
    final books = ref.watch(browseListProvider);
    // --- END OF UPDATE ---

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PostBookScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            title: book['title']!,
            author: book['author']!,
            condition: book['condition']!,
            imageUrl: book['imageUrl']!,
            // --- 2. UPDATE ---
            // We connect the button to our new swap logic
            onSwapPressed: () {
              ref.read(bookListProvider.notifier).requestSwap(book['title']!);
            },
            // --- END OF UPDATE ---
          );
        },
      ),
    );
  }
}
