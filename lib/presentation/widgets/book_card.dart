// lib/presentation/widgets/book_card.dart
import 'package:book_swap/domain/entities/book.dart'; // <-- Import Book
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  // 1. We now accept a single Book object
  final Book book;
  final VoidCallback onSwapPressed;

  const BookCard({super.key, required this.book, required this.onSwapPressed});

  // Placeholder for broken images
  Widget _buildErrorPlaceholder() {
    return Container(
      width: 80,
      height: 110,
      color: Colors.grey[800],
      child: const Icon(Icons.book, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C4E),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              // 2. Use data from the book object
              child: Image.network(
                book.imageUrl, // <-- Use object
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          book.title, // <-- Use object
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onSwapPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1A1A2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('Swap'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${book.author}', // <-- Use object
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(book.condition), // <-- Use object
                    labelStyle: const TextStyle(color: Colors.black87),
                    backgroundColor: const Color(0xFFE9C46A),
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
