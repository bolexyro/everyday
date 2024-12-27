import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

class DeleteConfirmationDialog extends ConsumerStatefulWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.today,
  });

  final Today today;

  @override
  ConsumerState<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState
    extends ConsumerState<DeleteConfirmationDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Today?'),
      content: const Text(
          'This video will disapper from your device and you won\'t be able to access it again since it is not backed up'),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => context.navigator.pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  ref.read(todayProvider.notifier).deleteToday(widget.today);
                  setState(() {
                    _isLoading = false;
                  });
                  context.navigator.pop(true);
                },
          child: Text(
            'Delete',
            style:
                context.textTheme.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
