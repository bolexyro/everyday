import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/everyday/data/data_sources/everyday_local_data_source.dart';
import 'package:myapp/everyday/data/repository/everyday_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/use_cases/add_today.dart';
import 'package:myapp/everyday/domain/use_cases/read_everyday.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EverydayNotifier extends StateNotifier<List<Today>> {
  EverydayNotifier(
    this.addTodayUseCase,
    this.readEverydayUseCase,
  ) : super([]);
  final AddTodayUseCase addTodayUseCase;
  final ReadEverydayUseCase readEverydayUseCase;

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

    await addTodayUseCase.call(today);
    state = [...state, today];
  }

  Future<void> getEveryday() async {
    state = await readEverydayUseCase.call();
  }
}

final everydayProvider =
    StateNotifierProvider<EverydayNotifier, List<Today>>((ref) =>
        EverydayNotifier(
            AddTodayUseCase(EverydayRepositoryImpl(EverydayLocalDataSource())),
            ReadEverydayUseCase(
                EverydayRepositoryImpl(EverydayLocalDataSource()))));
