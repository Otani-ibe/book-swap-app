// lib/presentation/screens/main/browse_screen.dart
// <-- Import auth
import 'package:book_swap/presentation/providers/book_providers.dart';
import 'package:book_swap/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:book_swap/presentation/screens/main/post_book_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap/presentation/screens/main/my_offers_screen.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(browseListProvider);
    final userId = ref.watch(
      currentUserIdProvider,
    ); // <-- 'currentUserIdProvider' is now defined

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'My Offers',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MyOffersScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Post a Book',
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
          final book = books[index]; // 'book' is now a Book object
          return BookCard(
            book: book, // <-- Pass the object
            onSwapPressed: () {
              if (userId != null) {
                // 'requestSwap' and 'book.id' are now correct
                ref
                    .read(bookControllerProvider.notifier)
                    .requestSwap(book.id, userId);
              }
            },
          );
        },
      ),
    );
  }
}
