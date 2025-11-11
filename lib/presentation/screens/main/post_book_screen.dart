import 'dart:io';
import 'package:book_swap/presentation/providers/book_providers.dart';
import 'package:book_swap/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());
final selectedImageProvider = StateProvider<XFile?>((ref) => null);
final selectedConditionProvider = StateProvider<String>((ref) => 'New');

class PostBookScreen extends ConsumerStatefulWidget {
  const PostBookScreen({super.key});

  @override
  ConsumerState<PostBookScreen> createState() => _PostBookScreenState();
}

class _PostBookScreenState extends ConsumerState<PostBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final imagePicker = ref.read(imagePickerProvider);
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ref.read(selectedImageProvider.notifier).state = file;
    }
  }

  void onPostBook() async {
    final selectedImage = ref.read(selectedImageProvider);
    final selectedCondition = ref.read(selectedConditionProvider);

    try {
      await ref
          .read(bookControllerProvider.notifier)
          .createBook(
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            condition: selectedCondition,
            image: selectedImage,
          );

      if (!context.mounted) return;
      ref.read(selectedImageProvider.notifier).state = null;
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage = ref.watch(selectedImageProvider);
    final selectedCondition = ref.watch(selectedConditionProvider);
    final isLoading = ref.watch(bookControllerProvider);
    final theme = Theme.of(context);

    final conditions = ['New', 'Like New', 'Good', 'Used'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Book'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C4E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white54, width: 1),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(selectedImage.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: Colors.white70,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap to upload cover image',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _titleController,
              hintText: 'Book Title',
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _authorController, hintText: 'Author'),
            const SizedBox(height: 24),
            const Text(
              'Condition',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              children: conditions.map((condition) {
                final isSelected = condition == selectedCondition;
                return ChoiceChip(
                  label: Text(condition),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primary, // Yellow
                  backgroundColor: const Color(0xFF2C2C4E),
                  onSelected: (isSelected) {
                    if (isSelected) {
                      ref.read(selectedConditionProvider.notifier).state =
                          condition;
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onPostBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary, // Yellow
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1A1A2E),
                      ),
                    )
                  : const Text(
                      'Post Book',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
