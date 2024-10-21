import 'package:flutter/material.dart';
import 'package:myapp/components/expandable_fab.dart';
import 'package:myapp/components/file_category_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Everyday'),
      ),
      body: const Center(),
      floatingActionButton: ExpandableFab(
        initialOpen: false,
        distance: 60,
        children: [
          ActionButton(
            onPressed: () => showAdaptiveDialog(
              context: context,
              builder: (context) => const FileCategoryDialog(),
            ),
            icon: const Icon(Icons.videocam),
          ),
          const ActionButton(
            onPressed: null,
            icon: Icon(Icons.insert_photo),
          ),
        ],
      ),
    );
  }
}
