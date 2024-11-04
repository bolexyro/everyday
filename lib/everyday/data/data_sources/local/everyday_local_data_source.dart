import 'dart:io';

import 'package:myapp/core/resources/local_buckets.dart';
import 'package:myapp/everyday/data/data_sources/local/everyday_db_helper.dart';
import 'package:myapp/everyday/data/models/today_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EverydayLocalDataSource {
  static final EverydayLocalDataSource _instance =
      EverydayLocalDataSource._internal();

  factory EverydayLocalDataSource() => _instance;

  EverydayLocalDataSource._internal();

  final dbHelper = TodayDatabaseHelper();

  Future<sql.Database?> get database async => await dbHelper.database;
  SharedPreferencesWithCache? _prefsCache;

  Future<SharedPreferencesWithCache> get prefsWithCache async {
    _prefsCache ??= await SharedPreferencesWithCache.create(
      cacheOptions:
          const SharedPreferencesWithCacheOptions(allowList: {'backup'}),
    );
    return _prefsCache!;
  }

  Future<TodayModel> insert(
      String videoPath, String caption, String currentUserEmail,
      {TodayModel? todayParam}) async {
    // if today is provided, then we are inserting from the cloud
    if (todayParam != null) {
      final db = await database;

      await db!.insert(TodayDatabaseHelper.todayTable, todayParam.toJson());
      return todayParam;
    }
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );

    final savedVideoId = const Uuid().v4();
    final savedVideoFile = await FilePathManager()
        .createFile(await FilePathManager().getVideoPath(savedVideoId));
    await File(videoPath).copy(savedVideoFile.path);

    final savedThumbnailFile = await FilePathManager()
        .createFile(await FilePathManager().getThumbnailPath(savedVideoId))
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
    final List<Map<String, dynamic>> rows = await db!.query(
      TodayDatabaseHelper.todayTable,
      where: '${TodayDatabaseHelper.columnEmail} = ?',
      whereArgs: [currentUserEmail],
    );
    return List<TodayModel>.from(rows.map((map) {
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

  Future<void> update(TodayModel today) async {
    final db = await database;
    await db!.update(
      TodayDatabaseHelper.todayTable,
      today.toJson(),
      where: '${TodayDatabaseHelper.columnId} = ?',
      whereArgs: [today.id],
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

  Future<void> saveBackupStatus(bool status) async {
    final prefs = await prefsWithCache;
    await prefs.setBool('backup', status);
  }

  Future<bool> getBackupStatus() async {
    final prefs = await prefsWithCache;
    return prefs.getBool('backup') ?? false;
  }
}
