import 'package:flutter/material.dart';

class CreateCategoryDialog extends StatelessWidget {
  const CreateCategoryDialog({
    super.key,
    required this.onCategoryCreated,
  });

  final void Function(String name) onCategoryCreated;

  @override
  Widget build(BuildContext context) {
    final categoryNameController = TextEditingController();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: categoryNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category Name',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onCategoryCreated(categoryNameController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
