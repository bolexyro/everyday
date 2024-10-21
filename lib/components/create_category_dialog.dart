import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/extensions.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({
    super.key,
    required this.onCategoryCreated,
  });

  final void Function(String name) onCategoryCreated;

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  late final TextEditingController _categoryNameController;
  final picker = ImagePicker();

  @override
  void initState() {
    _categoryNameController = TextEditingController(text: 'Untitled Category');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _categoryNameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _categoryNameController.text.length,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New Category'),
          const Gap(12),
          TextField(
            controller: _categoryNameController,
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Set Thumbnail'),
              const Gap(8),
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image == null) {
                    return;
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(side: BorderSide())),
                  child: const Icon(Icons.file_upload_outlined),
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.navigator.pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.navigator.pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
