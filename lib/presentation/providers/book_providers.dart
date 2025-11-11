// lib/presentation/providers/book_providers.dart
import 'package:cloudinary_public/cloudinary_public.dart'; // <-- 1. Import Cloudinary
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// --- 2. Create the Cloudinary Provider ---
final cloudinaryProvider = Provider<CloudinaryPublic>((ref) {
  return CloudinaryPublic(
    'dxgda9wrv', // <-- Your Cloud Name
    'rzg3v3tn', // <-- Your Upload Preset
    cache: false,
  );
});
// ----------------------------------------

final List<Map<String, String>> dummyBooks = [
  {
    "title": "Advanced Frontend Development",
    "author": "Jane Smith",
    "condition": "Like New",
    "imageUrl":
        "https://m.media-amazon.com/images/I/511-vIg1HaL._AC_UF1000,1000_QL80_.jpg",
  },
  {
    "title": "Introduction to Databases",
    "author": "C.J. Date",
    "condition": "Used",
    "imageUrl": "https://pictures.abebooks.com/isbn/9780321197849-us-300.jpg",
  },
  {
    "title": "Dart for Beginners",
    "author": "Chris Baker",
    "condition": "New",
    "imageUrl":
        "https://m.media-amazon.com/images/I/71gP2-c328L._AC_UF1000,1000_QL80_.jpg",
  },
];

class BookListNotifier extends StateNotifier<List<Map<String, String>>> {
  BookListNotifier() : super(dummyBooks);

  void addBook(Map<String, String> book) {
    state = [book, ...state];
  }

  void deleteBook(String title) {
    state = state.where((book) => book['title'] != title).toList();
  }
}

final bookListProvider =
    StateNotifierProvider<BookListNotifier, List<Map<String, String>>>((ref) {
      return BookListNotifier();
    });

final myListingsProvider = Provider<List<Map<String, String>>>((ref) {
  final allBooks = ref.watch(bookListProvider);
  return allBooks
      .where((book) => book['author'] == 'Otani Ibe') // Mock user
      .toList();
});

final bookControllerProvider = StateNotifierProvider<BookController, bool>((
  ref,
) {
  return BookController(ref);
});

// --- 3. THIS IS THE UPDATED CONTROLLER ---
class BookController extends StateNotifier<bool> {
  final Ref _ref;
  BookController(this._ref) : super(false);

  // New private method to upload the image
  Future<String> _uploadImageToCloudinary(XFile image) async {
    final cloudinary = _ref.read(cloudinaryProvider);
    try {
      CloudinaryFile file = await CloudinaryFile.fromFile(
        image.path,
        resourceType: CloudinaryResourceType.Image,
      );
      CloudinaryResponse response = await cloudinary.uploadFile(file);
      return response.secureUrl; // Return the internet URL
    } on CloudinaryException catch (e) {
      print('Cloudinary Error: ${e.message}');
      rethrow;
    }
  }

  Future<void> createBook({
    required String title,
    required String author,
    required String condition,
    required XFile? image,
  }) async {
    if (image == null) {
      throw Exception('Please select a cover image.');
    }
    if (title.isEmpty || author.isEmpty) {
      throw Exception('Please fill out all fields.');
    }

    state = true;
    try {
      // --- THIS IS THE UPDATE ---
      print('--- UPLOADING IMAGE TO CLOUDINARY ---');
      // 1. Upload the image and get the URL
      final imageUrl = await _uploadImageToCloudinary(image);
      print('--- UPLOAD SUCCESSFUL: $imageUrl ---');

      // 2. Create the new book with the *Cloudinary URL*
      final newBook = {
        "title": title,
        "author": author,
        "condition": condition,
        "imageUrl": imageUrl, // <-- Use the new network URL
      };

      // 3. Add the book to our state
      _ref.read(bookListProvider.notifier).addBook(newBook);
      print('--- BOOK CREATED SUCCESSFULLY ---');
      // --- END OF UPDATE ---
    } catch (e) {
      print('Error creating book: $e');
      rethrow;
    } finally {
      state = false;
    }
  }
}
