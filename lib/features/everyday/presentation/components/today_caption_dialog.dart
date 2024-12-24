import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

class TodayCaptionDialog extends ConsumerStatefulWidget {
  const TodayCaptionDialog({
    super.key,
    this.videoPath,
    this.today,
  });

  // today should be provided if we are using it to update an already existing
  // today
  final Today? today;
  // videoPath should be provided if we are creating a new today
  final String? videoPath;

  @override
  ConsumerState<TodayCaptionDialog> createState() => _TodayCaptionDialogState();
}

class _TodayCaptionDialogState extends ConsumerState<TodayCaptionDialog> {
  late final TextEditingController _captionController;
  late final DateTime _displayTime;
  bool _isLoading = false;

  String? _error;

  @override
  void initState() {
    _displayTime = widget.today == null ? DateTime.now() : widget.today!.date;
    _captionController = TextEditingController(
        text:
            widget.today == null ? 'Uncaptioned Video' : widget.today!.caption);

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

  void _addToday() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final dataState = widget.today == null
        ? await ref.read(todayProvider.notifier).addToday(
              widget.videoPath!,
              _captionController.text.trim(),
            )
        : await ref.read(todayProvider.notifier).updateToday(
            widget.today!.copyWith(caption: _captionController.text.trim()));

    if (dataState is DataException) {
      setState(() {
        _isLoading = false;
        _error = dataState.exceptionMessage;
      });
      return;
    }
    if (mounted) {
      Navigator.of(context)
          .pop(widget.today == null ? null : _captionController.text.trim());
    }
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
            onSubmitted: (value) => _addToday(),
            controller: _captionController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _error,
              errorMaxLines: 3,
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_displayTime.formatDateWithShortDay),
            ],
          ),
          const Gap(16),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  context.navigator.pop();
                },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _addToday,
          child: _isLoading
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(),
                )
              : Text(widget.today == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}
