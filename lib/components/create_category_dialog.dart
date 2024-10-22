import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/models/category.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({
    super.key,
    required this.onCategoryCreated,
  });

  final void Function(Category) onCategoryCreated;

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  late final TextEditingController _categoryNameController;
  bool _thumbnailSelected = false;
  late XFile _selectedThumbnail;
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
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const Gap(16),
          GestureDetector(
            onTap: () async {
              final XFile? image =
                  await picker.pickImage(source: ImageSource.camera);
              if (image == null) {
                return;
              }
              setState(() {
                _thumbnailSelected = true;
                _selectedThumbnail = image;
              });
            },
            child: _thumbnailSelected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(File(_selectedThumbnail.path)),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Set Thumbnail'),
                      const Gap(8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                                color: context.colorScheme.onSurface),
                          ),
                        ),
                        child: const Icon(Icons.file_upload_outlined),
                      ),
                    ],
                  ),
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
            widget.onCategoryCreated(Category(
                name: _categoryNameController.text,
                thumbnailPath: _selectedThumbnail.path));
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
