import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/circle_border_container.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/presentation/components/backup_indicator_icon.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_progress_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';
import 'package:myapp/features/everyday/presentation/screens/unbackedup_screen.dart';

class BackupFours extends ConsumerWidget {
  const BackupFours({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // I just want to display the first 4 unbacked videos
    // where the first one is the currently backing up one
    final backupProgressState = ref.watch(backupProgressStateProvider);
    final unBackedupTodays = ref.watch(todayProvider.notifier).unBackedupTodays;
    final fours = unBackedupTodays.take(4).toList().reversed.toList();

    return backupProgressState.isBackingUp
        ? SizedBox(
            height: 150,
            child: Row(
              children: List.generate(4, (index) {
                if (index < (4 - fours.length)) {
                  return Expanded(child: Container());
                } else {
                  final today = fours[index - (4 - fours.length)];

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Stack(
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
                          // if (index == 3)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: index == 3
                                  ? const CircleBorderContainer(
                                      padding: EdgeInsets.all(2),
                                      color: AppColors.neonGreen,
                                      child: BackupIndicatorIcon(),
                                    )
                                  : const Icon(Icons.schedule_outlined),
                            ),
                          ),
                          if (index == 3 && unBackedupTodays.length > 4)
                            GestureDetector(
                              onTap: () => context.navigator.push(
                                  context.route(const UnbackedupScreen())),
                              child: const CircleBorderContainer(
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.arrow_forward),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),
          )
        : Container();
  }
}
