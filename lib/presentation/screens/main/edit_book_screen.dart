// lib/presentation/screens/main/edit_book_screen.dart
import 'package:book_swap/domain/entities/book.dart';
import 'package:book_swap/presentation/providers/book_providers.dart';
import 'package:book_swap/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editConditionProvider = StateProvider<String>((ref) => 'New');

class EditBookScreen extends ConsumerStatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editConditionProvider.notifier).state = widget.book.condition;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void onUpdateBook() async {
    final selectedCondition = ref.read(editConditionProvider);
    try {
      await ref
          .read(bookControllerProvider.notifier)
          .updateBook(
            bookId: widget.book.id,
            title: _titleController.text.trim(),
            author: _authorController.text.trim(),
            condition: selectedCondition,
          );
      if (!context.mounted) return;
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
    final selectedCondition = ref.watch(editConditionProvider);
    final theme = Theme.of(context);
    final conditions = ['New', 'Like New', 'Good', 'Used'];

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: const Color(0xFF2C2C4E),
                  onSelected: (isSelected) {
                    if (isSelected) {
                      ref.read(editConditionProvider.notifier).state =
                          condition;
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onUpdateBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Update Book',
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
