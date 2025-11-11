// lib/presentation/widgets/book_card.dart
// import 'dart:io'; // <-- We don't need this anymore
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String condition;
  final String imageUrl;
  final VoidCallback onSwapPressed;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.condition,
    required this.imageUrl,
    required this.onSwapPressed,
  });

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
            // --- THIS IS THE SIMPLIFIED IMAGE WIDGET ---
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                // <-- Only use Image.network
                imageUrl,
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              ),
            ),
            // --- END OF UPDATE ---
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
                          title,
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
                    'by $author',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(condition),
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
