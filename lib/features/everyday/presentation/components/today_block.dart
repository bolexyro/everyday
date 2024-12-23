import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/presentation/components/today_actions_bottom_sheet.dart';
import 'package:myapp/features/everyday/presentation/screens/watch_today_screen.dart';

class TodayBlock extends ConsumerWidget {
  const TodayBlock({
    super.key,
    required this.today,
    required this.canPlayToday,
  });

  final Today today;
  final bool canPlayToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () => showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.hardEdge,
        context: context,
        builder: (context) => TodayActionsBottomSheet(today: today),
      ),
      onTap: () {
        if (canPlayToday) {
          context.navigator.push(context.route(WatchTodayScreen(today: today)));
        }
      },
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.colorScheme.surfaceContainer,
            ),
            child: Column(
              children: [
                Expanded(
                  child: today.localThumbnailPath == null
                      ? CachedNetworkImage(
                          imageUrl: today.remoteThumbnailUrl!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.wifi_off_outlined),
                        )
                      : Image.file(
                          File(today.localThumbnailPath!),
                          fit: BoxFit.fill,
                        ),
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      color: context.colorScheme.onSecondaryContainer,
                      child: Center(
                        child: Text(
                          today.date.formatDateWithShortDay,
                          style: TextStyle(
                              color: context.colorScheme.surfaceContainer),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        size: 18,
                        today.isBackedUp
                            ? Icons.cloud_done_outlined
                            : Icons.cloud_off_outlined,
                        color: context.colorScheme.surfaceContainer,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (!canPlayToday)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: Icon(Icons.error_outline, color: Colors.white, size: 40),
              ),
            )
        ],
      ),
    );
  }
}
