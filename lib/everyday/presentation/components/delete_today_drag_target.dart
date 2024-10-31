import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';

class DeleteTodayDragTarget extends ConsumerWidget {
  const DeleteTodayDragTarget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<Today>(
      builder: (context, candidateToday, rejectedItems) {
        return Container(
          width: double.infinity,
          height: 60,        
          color: candidateToday.isNotEmpty ? Colors.red : null,
          child: const Icon(Icons.delete),
        );
      },
      onAcceptWithDetails: (details) {
        ref.read(everydayProvider.notifier).deleteToday(details.data);
      },
    );
  }
}
