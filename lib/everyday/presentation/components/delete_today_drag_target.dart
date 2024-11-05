import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/presentation/providers/today_provider.dart';

class DeleteTodayDragTarget extends ConsumerWidget {
  const DeleteTodayDragTarget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<Today>(
      builder: (context, candidateToday, rejectedItems) {
        return Container(
          width: double.infinity,
          color: candidateToday.isNotEmpty ? AppColors.error : null,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          // ),
          height: 60,
          child: const Icon(Icons.delete),
        );
      },
      onAcceptWithDetails: (details) {
        ref.read(todayProvider.notifier).deleteToday(details.data);
      },
    );
  }
}
