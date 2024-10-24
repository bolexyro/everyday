import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/models/today.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TodayCaptionDialog extends StatefulWidget {
  const TodayCaptionDialog({
    super.key,
    required this.onVideoCaptioned,
    required this.videoPath,
  });

  final void Function(Today) onVideoCaptioned;
  final String videoPath;

  @override
  State<TodayCaptionDialog> createState() => _TodayCaptionDialogState();
}

class _TodayCaptionDialogState extends State<TodayCaptionDialog> {
  late final TextEditingController _captionController;

  late final DateTime _timeOfCreation;

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
          onPressed: () {
            context.navigator.pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final uint8list = await VideoThumbnail.thumbnailData(
              video: widget.videoPath,
              imageFormat: ImageFormat.JPEG,
              // maxWidth: ,
              quality: 25,
            );
            widget.onVideoCaptioned(
              Today(
                caption: _captionController.text,
                videoPath: File(widget.videoPath).path,
                date: DateTime.now(),
                thumbnail: uint8list!,
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
