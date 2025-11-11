# 📚 BookSwap App

BookSwap is a Flutter marketplace app created for a class assignment. It allows students to list textbooks for exchange, browse listings from other students, and initiate swap offers.

This project uses a mock (in-memory) backend to simulate all required functionality, including real-time state management, image uploads, and swap logic.

---

## 🎯 Features

* **State Management:** Built with **Riverpod**, following a clean, reactive pattern.
* **Architecture:** Follows a 3-tier **Clean Architecture** (`presentation/`, `domain/`, `data/`).
* **Full CRUD for Books:**
    * **Create:** Post new books with image uploads.
    * **Read:** "Browse" (all books) and "My Listings" (filtered) screens.
    * **Delete:** Remove books from the "My Listings" screen.
* **Cloudinary Uploads:** Uses Cloudinary for "unsigned" image uploads, a professional-grade alternative to Firebase Storage.
* **Swap Functionality:**
    * Request a swap, which moves a book from "Browse" to "My Offers" and sets its status to "pending."
    * Cancel a swap, which returns the book to the "Browse" screen.
* **Bonus: Chat Feature:** Includes a mock UI for a chat list and a detailed chat conversation screen.

---

## 🏛️ Architecture

This project follows a simple Clean Architecture pattern to separate concerns:

* **`lib/presentation/` (UI Layer)**
    * Contains all Flutter Widgets (Screens, Widgets).
    * Contains all Riverpod **Providers** (`auth_providers.dart`, `book_providers.dart`).
    * This layer "watches" providers for state and "calls" methods on the controllers.

* **`lib/domain/` (Business Logic Layer)**
    * Contains the abstract rules of the app (e.g., `book.dart`).
    * This layer has **zero knowledge** of Flutter or Firebase. It's pure Dart.

* **`lib/data/` (Data Layer)**
    * Contains concrete implementations. For this project, this is our **mock in-memory database** (`BookListNotifier` in `book_providers.dart`) that manages the state of the book list.
    * If we were to add real Firebase, we would only need to change this layer.

**Diagram:**
`[UI Widgets]` -> `[Riverpod Providers]` -> `[Mock Notifier (Data)]`

---

## 🚀 How to Build and Run

1.  **Clone the repository.**
2.  **Ensure you have the Flutter SDK installed.**
3.  **Set up Cloudinary:**
    * Create a free Cloudinary account.
    * Create an "unsigned" upload preset.
    * Open `lib/presentation/providers/book_providers.dart`.
    * Paste your `Cloud Name` and `Upload Preset Name` into the `cloudinaryProvider`.
4.  **Get Dependencies:**
    ```bash
    flutter pub get
    ```
5.  **Run the App:**
    ```bash
    flutter run
    ```