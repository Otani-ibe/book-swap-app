import 'package:book_swap/presentation/providers/book_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOffersScreen extends ConsumerWidget {
  const MyOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myOffers = ref.watch(myOffersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Offers')),
      body: myOffers.isEmpty
          ? const Center(
              child: Text(
                'You haven\'t made any swap offers yet.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: myOffers.length,
              itemBuilder: (context, index) {
                final book = myOffers[index];
                return Card(
                  color: const Color(0xFF2C2C4E),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network(
                        book.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[800],
                          );
                        },
                      ),
                    ),
                    title: Text(
                      book.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Swap with: ${book.author}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            book.status,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(bookControllerProvider.notifier)
                                .cancelSwap(book.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
