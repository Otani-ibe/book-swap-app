// lib/presentation/providers/book_providers.dart
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final cloudinaryProvider = Provider<CloudinaryPublic>((ref) {
  return CloudinaryPublic(
    'dxgda9wrv', // Your Cloud Name
    'rzg3v3tn', // Your Upload Preset
    cache: false,
  );
});

// --- 1. MOCK DATA UPDATED ---
// We've added 'status' and 'requesterId' to our mock data
final List<Map<String, String>> dummyBooks = [
  {
    "title": "Advanced Frontend Development",
    "author": "Jane Smith",
    "condition": "Like New",
    "imageUrl":
        "https://m.media-amazon.com/images/I/511-vIg1HaL._AC_UF1000,1000_QL80_.jpg",
    "status": "available",
    "requesterId": "",
  },
  {
    "title": "Introduction to Databases",
    "author": "C.J. Date",
    "condition": "Used",
    "imageUrl": "https://pictures.abebooks.com/isbn/9780321197849-us-300.jpg",
    "status": "available",
    "requesterId": "",
  },
  {
    "title": "Dart for Beginners",
    "author": "Chris Baker",
    "condition": "New",
    "imageUrl":
        "https://m.media-amazon.com/images/I/71gP2-c328L._AC_UF1000,1000_QL80_.jpg",
    "status": "available",
    "requesterId": "",
  },
];

// --- 2. NOTIFIER UPDATED ---
class BookListNotifier extends StateNotifier<List<Map<String, String>>> {
  BookListNotifier() : super(dummyBooks);

  void addBook(Map<String, String> book) {
    state = [book, ...state];
  }

  void deleteBook(String title) {
    state = state.where((book) => book['title'] != title).toList();
  }

  // --- NEW FUNCTION for Swap Logic ---
  void requestSwap(String title) {
    // Find the book, update its status, and set our mock user as the requester
    state = [
      for (final book in state)
        if (book['title'] == title)
          {
            ...book, // Keep all old data
            'status': 'pending', // Change status
            'requesterId': 'Otani Ibe', // Set our mock user
          }
        else
          book,
    ];
    print('Swap requested for $title');
  }
}

// --- 3. PROVIDERS UPDATED ---
final bookListProvider =
    StateNotifierProvider<BookListNotifier, List<Map<String, String>>>((ref) {
      return BookListNotifier();
    });

// NEW: We create a provider for the "Browse" screen that *only*
// shows books with a status of 'available'.
final browseListProvider = Provider<List<Map<String, String>>>((ref) {
  final allBooks = ref.watch(bookListProvider);
  return allBooks.where((book) => book['status'] == 'available').toList();
});

// This provider is for "My Listings" (books I own)
final myListingsProvider = Provider<List<Map<String, String>>>((ref) {
  final allBooks = ref.watch(bookListProvider);
  return allBooks
      .where((book) => book['author'] == 'Otani Ibe') // Mock user
      .toList();
});

// NEW: This provider is for "My Offers" (books I want)
final myOffersProvider = Provider<List<Map<String, String>>>((ref) {
  final allBooks = ref.watch(bookListProvider);
  return allBooks
      .where((book) => book['requesterId'] == 'Otani Ibe') // Mock user
      .toList();
});
// --- END OF NEW PROVIDERS ---

final bookControllerProvider = StateNotifierProvider<BookController, bool>((
  ref,
) {
  return BookController(ref);
});

class BookController extends StateNotifier<bool> {
  final Ref _ref;
  BookController(this._ref) : super(false);

  Future<String> _uploadImageToCloudinary(XFile image) async {
    // ... (rest of this function is unchanged)
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
      print('--- UPLOADING IMAGE TO CLOUDINARY ---');
      final imageUrl = await _uploadImageToCloudinary(image);
      print('--- UPLOAD SUCCESSFUL: $imageUrl ---');

      // --- 4. UPDATE "createBook" ---
      // Add the new fields to our new book
      final newBook = {
        "title": title,
        "author": author,
        "condition": condition,
        "imageUrl": imageUrl,
        "status": "available", // <-- Add this
        "requesterId": "", // <-- Add this
      };

      _ref.read(bookListProvider.notifier).addBook(newBook);
      print('--- BOOK CREATED SUCCESSFULLY ---');
    } catch (e) {
      print('Error creating book: $e');
      rethrow;
    } finally {
      state = false;
    }
  }
}
