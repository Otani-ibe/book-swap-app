import 'package:book_swap/domain/entities/book.dart';
import 'package:book_swap/presentation/providers/auth_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final cloudinaryProvider = Provider<CloudinaryPublic>((ref) {
  return CloudinaryPublic('dxgda9wrv', 'rzg3v3tn', cache: false);
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.uid;
});

final booksStreamProvider = StreamProvider<List<Book>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('books')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
      });
});

final browseListProvider = Provider<List<Book>>((ref) {
  final allBooks = ref.watch(booksStreamProvider).value ?? [];
  return allBooks.where((book) => book.status == 'available').toList();
});

final myListingsProvider = Provider<List<Book>>((ref) {
  final allBooks = ref.watch(booksStreamProvider).value ?? [];
  final userId = ref.watch(currentUserIdProvider);
  return allBooks.where((book) => book.authorId == userId).toList();
});

final myOffersProvider = Provider<List<Book>>((ref) {
  final allBooks = ref.watch(booksStreamProvider).value ?? [];
  final userId = ref.watch(currentUserIdProvider);
  return allBooks.where((book) => book.requesterId == userId).toList();
});

final bookControllerProvider = StateNotifierProvider<BookController, bool>((
  ref,
) {
  return BookController(ref);
});

class BookController extends StateNotifier<bool> {
  final Ref _ref;
  BookController(this._ref) : super(false);

  FirebaseFirestore get _firestore => _ref.read(firestoreProvider);

  Future<String> _uploadImageToCloudinary(XFile image) async {
    final cloudinary = _ref.read(cloudinaryProvider);
    try {
      CloudinaryFile file = CloudinaryFile.fromFile(
        image.path,
        resourceType: CloudinaryResourceType.Image,
      );
      CloudinaryResponse response = await cloudinary.uploadFile(file);
      return response.secureUrl;
    } on CloudinaryException {
      rethrow;
    }
  }

  Future<void> createBook({
    required String title,
    required String author,
    required String condition,
    required XFile? image,
  }) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('Not logged in.');
    }
    if (image == null) {
      throw Exception('Please select a cover image.');
    }
    if (title.isEmpty || author.isEmpty) {
      throw Exception('Please fill out all fields.');
    }

    state = true;
    try {
      final imageUrl = await _uploadImageToCloudinary(image);

      final newBook = {
        "title": title,
        "author": author,
        "authorId": userId,
        "condition": condition,
        "imageUrl": imageUrl,
        "status": "available",
        "requesterId": "",
        "createdAt": FieldValue.serverTimestamp(),
      };

      await _firestore.collection('books').add(newBook);
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> requestSwap(String bookId, String userId) async {
    await _firestore.collection('books').doc(bookId).update({
      'status': 'pending',
      'requesterId': userId,
    });
  }

  Future<void> cancelSwap(String bookId) async {
    await _firestore.collection('books').doc(bookId).update({
      'status': 'available',
      'requesterId': '',
    });
  }

  Future<void> deleteBook(String bookId) async {
    await _firestore.collection('books').doc(bookId).delete();
  }

  Future<void> updateBook({
    required String bookId,
    required String title,
    required String author,
    required String condition,
  }) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'title': title,
        'author': author,
        'condition': condition,
      });
    } catch (e) {
      rethrow;
    }
  }
}
