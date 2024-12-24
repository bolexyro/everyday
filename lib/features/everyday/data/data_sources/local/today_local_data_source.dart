import 'dart:io';

import 'package:myapp/core/resources/local_buckets.dart';
import 'package:myapp/core/resources/db_setup.dart';
import 'package:myapp/features/everyday/data/models/today_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class TodayLocalDataSource {
  static final TodayLocalDataSource _instance =
      TodayLocalDataSource._internal();

  factory TodayLocalDataSource() => _instance;

  TodayLocalDataSource._internal();

  final dbSetup = DatabaseSetup();

  Future<sql.Database?> get database async => await dbSetup.database;
  SharedPreferencesWithCache? _prefsCache;

  String? lastEmailThatAccessedPrefs;

  Future<SharedPreferencesWithCache> prefsWithCache(
      String currentUserEmail) async {
    if (lastEmailThatAccessedPrefs != currentUserEmail) {
      _prefsCache = null;
    }
    lastEmailThatAccessedPrefs = currentUserEmail;

    _prefsCache ??= await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: {'${currentUserEmail}backup'},
      ),
    );
    return _prefsCache!;
  }

  Future<TodayModel> insert(
      String videoPath, String caption, String currentUserEmail,
      {TodayModel? todayParam}) async {
    // if today is provided, then we are inserting from the cloud
    if (todayParam != null) {
      final db = await database;

      await db!.insert(DatabaseSetup.todayTable, todayParam.toJson());
      return todayParam;
    }

    final savedVideoId = const Uuid().v4();

    final savedVideoFilePath =
        await MediaStorageHelper().getLocalVideoPath(savedVideoId);
    await MediaStorageHelper().createFile(savedVideoFilePath);
    await File(videoPath).copy(savedVideoFilePath);

    final savedThumbnailPath =
        await MediaStorageHelper().getLocalThumbnailPath(savedVideoId);
    await MediaStorageHelper().createFile(savedThumbnailPath);
    File savedThumbnailFile = await VideoCompress.getFileThumbnail(videoPath);
    savedThumbnailFile = await savedThumbnailFile.copy(savedThumbnailPath);

    VideoCompress.deleteAllCache();

    final today = TodayModel(
      id: savedVideoId,
      caption: caption,
      localVideoPath: savedVideoFilePath,
      date: DateTime.now(),
      localThumbnailPath: savedThumbnailFile.path,
      email: currentUserEmail,
    );

    final db = await database;
    await db!.insert(DatabaseSetup.todayTable, today.toJson());
    return today;
  }

  Future<List<TodayModel>> readAll(String currentUserEmail) async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db!.query(
      DatabaseSetup.todayTable,
      where: '${DatabaseSetup.todayColumnEmail} = ?',
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
      DatabaseSetup.todayTable,
      where: '${DatabaseSetup.todayColumnId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(TodayModel today) async {
    final db = await database;
    await db!.update(
      DatabaseSetup.todayTable,
      today.toJson(),
      where: '${DatabaseSetup.todayColumnId} = ?',
      whereArgs: [today.id],
    );
  }

  Future<void> updateEmailForPreviousRows(String currentUserEmail) async {
    final db = await database;
    db!.update(
      DatabaseSetup.todayTable,
      {DatabaseSetup.todayColumnEmail: currentUserEmail},
      where: '${DatabaseSetup.todayColumnEmail} = ?',
      whereArgs: [''],
    );
  }

  Future<void> saveBackupStatus(bool status, String currentUserEmail) async {
    final prefs = await prefsWithCache(currentUserEmail);
    await prefs.setBool('${currentUserEmail}backup', status);
  }

  Future<bool> getBackupStatus(currentUserEmail) async {
    final prefs = await prefsWithCache(currentUserEmail);
    return prefs.getBool('${currentUserEmail}backup') ?? false;
  }
}
