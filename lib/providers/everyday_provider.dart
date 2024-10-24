import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/models/today.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EverydayNotifier extends StateNotifier<List<Today>> {
  EverydayNotifier() : super([]);

  Future<void> addToday(String videoPath, String caption) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    final directory = await getApplicationDocumentsDirectory();
    final savedFileId = const Uuid().v4();
    final savedFile =
        await File(videoPath).copy('${directory.path}/$savedFileId.mp4');

    final today = Today(
      id: savedFileId,
      caption: caption,
      videoPath: savedFile.path,
      date: DateTime.now(),
      thumbnail: uint8list!,
    );

    await DbHelper.instance.insertToday(today);
    state = [...state, today];
  }

  Future<void> getEveryday() async {
    state = await DbHelper.instance.readAllTodays();
  }
}

final everydayProvider = StateNotifierProvider<EverydayNotifier, List<Today>>(
    (ref) => EverydayNotifier());
