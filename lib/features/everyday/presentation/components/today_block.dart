import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/others.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/core/internet_connection/connection_status.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/presentation/screens/today_screen.dart';

class TodayBlock extends StatelessWidget {
  const TodayBlock({
    super.key,
    required this.today,
    required this.onDragStartedOrEnded,
  });

  final Today today;
  final void Function(bool show) onDragStartedOrEnded;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      dragAnchorStrategy: (Draggable<Object> _, BuildContext __, Offset ___) =>
          const Offset(40, 100),
      feedback: SizedBox(
        width: 80,
        height: 200,
        child: today.localThumbnailPath == null
            ? CachedNetworkImage(
                imageUrl: today.remoteThumbnailUrl!,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
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
      data: today,
      onDragStarted: () => onDragStartedOrEnded(true),
      onDragEnd: (draggableDetails) => onDragStartedOrEnded(false),
      onDragCompleted: () => context.scaffoldMessenger.showSnackBar(
          appSnackbar(text: 'Today has been added to the recycle bin')),
      child: GestureDetector(
        onTap: () {
          if (ConnectionStatusHelper.getInstance().hasInternetConnection ||
              today.isAvailableLocal) {
            context.navigator.push(context.route(TodayScreen(today: today)));
          } else {
            context.scaffoldMessenger.showSnackBar(appSnackbar(
              text:
                  'You don\'t have this video available offline. Connect to the internet and try again',
              color: AppColors.error,
            ));
          }
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.bottomCenter,
          width: 200,
          height: 100,
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
      ),
    );
  }
}
