import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/models/video.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoCaptionDialog extends StatefulWidget {
  const VideoCaptionDialog({
    super.key,
    required this.onVideoCreated,
    required this.videoPath,
  });

  final void Function(Video) onVideoCreated;
  final String videoPath;

  @override
  State<VideoCaptionDialog> createState() => _VideoCaptionDialogState();
}

class _VideoCaptionDialogState extends State<VideoCaptionDialog> {
  late final TextEditingController _captionController;

  @override
  void initState() {
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
          const Text('Enter caption'),
          const Gap(12),
          TextField(
            controller: _captionController,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
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
              maxWidth: 128,
              quality: 25,
            );
            widget.onVideoCreated(
              Video(
                title: _captionController.text,
                path: File(widget.videoPath).path,
                time: DateTime.now(),
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
