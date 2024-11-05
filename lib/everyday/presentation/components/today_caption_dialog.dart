import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/presentation/providers/today_provider.dart';

class TodayCaptionDialog extends ConsumerStatefulWidget {
  const TodayCaptionDialog({
    super.key,
    required this.videoPath,
  });

  final String videoPath;

  @override
  ConsumerState<TodayCaptionDialog> createState() => _TodayCaptionDialogState();
}

class _TodayCaptionDialogState extends ConsumerState<TodayCaptionDialog> {
  late final TextEditingController _captionController;
  late final DateTime _timeOfCreation;
  bool _isSaving = false;

  @override
  void initState() {
    _timeOfCreation = DateTime.now();
    _captionController = TextEditingController(text: 'Uncaptioned Video');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captionController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _captionController.text.length,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
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
          Text('Caption your day', style: context.textTheme.titleMedium),
          const Gap(12),
          TextField(
            controller: _captionController,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_timeOfCreation.formatDateWithShortDay),
            ],
          ),
          const Gap(16),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () {
                  context.navigator.pop();
                },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isSaving
              ? null
              : () async {
                  setState(() {
                    _isSaving = true;
                  });

                  await ref.read(todayProvider.notifier).addToday(
                        widget.videoPath,
                        _captionController.text.trim(),
                      );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
