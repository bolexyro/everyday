import 'package:flutter/material.dart';

class FileCategoryDialog extends StatelessWidget {
  const FileCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog.adaptive(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('data')],
      ),
    );
  }
}
