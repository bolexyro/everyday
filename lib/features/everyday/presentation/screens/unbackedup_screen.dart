import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/app_scaffold.dart';
import 'package:myapp/core/components/circle_border_container.dart';
import 'package:myapp/features/everyday/presentation/components/backup_indicator_icon.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

class UnbackedupScreen extends ConsumerWidget {
  const UnbackedupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unbackedTodays = ref.watch(todayProvider.notifier).unBackedupTodays;
    return AppScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: List.generate(unbackedTodays.length, (index) {
            final today = unbackedTodays[index];
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  child: today.isAvailableLocal
                      ? Image.file(File(today.localThumbnailPath!))
                      : Image.network(today.remoteThumbnailUrl!),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.8),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: index == 0
                        ? const CircleBorderContainer(
                            padding: EdgeInsets.all(2),
                            color: AppColors.neonGreen,
                            child: BackupIndicatorIcon(),
                          )
                        : const Icon(Icons.schedule_outlined),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
