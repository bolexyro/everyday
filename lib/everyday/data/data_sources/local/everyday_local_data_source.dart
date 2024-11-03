import 'dart:io';

import 'package:myapp/core/resources/local_buckets.dart';
import 'package:myapp/everyday/data/data_sources/local/everyday_db_helper.dart';
import 'package:myapp/everyday/data/models/today_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EverydayLocalDataSource {
  static final EverydayLocalDataSource _instance =
      EverydayLocalDataSource._internal();

  factory EverydayLocalDataSource() => _instance;

  EverydayLocalDataSource._internal();

  Future<sql.Database?> get database async =>
      await TodayDatabaseHelper().database;

  Future<TodayModel> insert(
      String videoPath, String caption, String currentUserEmail) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );

    final directory = await getApplicationDocumentsDirectory();

    final savedVideoId = const Uuid().v4();
    final savedVideoFile =
        await File('${directory.path}/${LocalBuckets.videos}/$savedVideoId.mp4')
            .create(recursive: true);

    await File(videoPath).copy(savedVideoFile.path);

    final savedThumbnailFile = await File(
            '${directory.path}/${LocalBuckets.thumbnails}/$savedVideoId.jpg')
        .create(recursive: true)
      ..writeAsBytes(uint8list!);

    final today = TodayModel(
      id: savedVideoId,
      caption: caption,
      localVideoPath: savedVideoFile.path,
      date: DateTime.now(),
      localThumbnailPath: savedThumbnailFile.path,
      email: currentUserEmail,
    );

    final db = await database;
    await db!.insert(TodayDatabaseHelper.todayTable, today.toJson());
    return today;
  }

  Future<List<TodayModel>> readAll(String currentUserEmail) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TodayDatabaseHelper.todayTable,
      where: '${TodayDatabaseHelper.columnEmail} = ?',
      whereArgs: [currentUserEmail],
    );
    return List<TodayModel>.from(maps.map((map) {
      return TodayModel.fromJson(map);
    }));
  }

  Future<void> delete(String id, String videoPath) async {
    final db = await database;
    await File(videoPath).delete();
    await db!.delete(
      TodayDatabaseHelper.todayTable,
      where: '${TodayDatabaseHelper.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateEmailForPreviousRows(String currentUserEmail) async {
    final db = await database;
    db!.update(
      TodayDatabaseHelper.todayTable,
      {TodayDatabaseHelper.columnEmail: currentUserEmail},
      where: '${TodayDatabaseHelper.columnEmail} = ?',
      whereArgs: [''],
    );
  }
}
