// lib/presentation/screens/main/browse_screen.dart
import 'package:book_swap/presentation/providers/book_providers.dart';
import 'package:book_swap/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:book_swap/presentation/screens/main/post_book_screen.dart';
// 1. Import Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 2. The 'dummyBooks' list is GONE from this file. That's correct!

// 3. Change to a 'ConsumerWidget'
class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  // 4. Add 'WidgetRef ref' to the build method
  Widget build(BuildContext context, WidgetRef ref) {
    // 5. "Watch" the new provider. This list will now update automatically!
    final books = ref.watch(bookListProvider);

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
        // 6. Use the dynamic list's length
        itemCount: books.length,
        itemBuilder: (context, index) {
          // 7. Use the dynamic list's item
          final book = books[index];
          return BookCard(
            title: book['title']!,
            author: book['author']!,
            condition: book['condition']!,
            imageUrl: book['imageUrl']!,
            onSwapPressed: () {
              print('Swap pressed for ${book['title']}');
            },
          );
        },
      ),
    );
  }
}
