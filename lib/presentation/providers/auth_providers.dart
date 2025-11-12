import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  AuthController(this._ref) : super(false);

  FirebaseAuth get _auth => _ref.read(firebaseAuthProvider);
  FirebaseFirestore get _firestore => _ref.read(firestoreProvider);

  Future<void> signUp(String email, String password, String displayName) async {
    state = true;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;
      if (user != null) {
        final batch = _firestore.batch();

        final userDocRef = _firestore.collection('users').doc(user.uid);
        batch.set(userDocRef, {
          'email': email,
          'displayName': displayName,
          'uid': user.uid,
        });

        // --- NEW WORKING IMAGE URL ---
        final book1Ref = _firestore.collection('books').doc();
        batch.set(book1Ref, {
          "title": "Advanced Frontend Development",
          "author": displayName,
          "authorId": user.uid,
          "condition": "Like New",
          "imageUrl":
              "https://m.media-amazon.com/images/I/511-vIg1HaL._AC_UF1000,1000_QL80_.jpg",
          "status": "available",
          "requesterId": "",
          "createdAt": FieldValue.serverTimestamp(),
        });

        final book2Ref = _firestore.collection('books').doc();
        batch.set(book2Ref, {
          "title": "Introduction to Databases",
          "author": displayName,
          "authorId": user.uid,
          "condition": "Used",
          "imageUrl":
              "https://pictures.abebooks.com/isbn/9780321197849-us-300.jpg",
          "status": "available",
          "requesterId": "",
          "createdAt": FieldValue.serverTimestamp(),
        });

        await batch.commit();
        await user.sendEmailVerification();
        await _auth.signOut();
      }
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> logIn(String email, String password) async {
    state = true;
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null && !cred.user!.emailVerified) {
        await _auth.signOut();
        throw Exception(
          'Email not verified. Please check your inbox and verify your email.',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
