import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String authorId;
  final String condition;
  final String imageUrl;
  final String status;
  final String requesterId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.authorId,
    required this.condition,
    required this.imageUrl,
    required this.status,
    required this.requesterId,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      authorId: data['authorId'] ?? '',
      condition: data['condition'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      status: data['status'] ?? 'available',
      requesterId: data['requesterId'] ?? '',
    );
  }
}
