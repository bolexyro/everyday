import 'dart:typed_data';

import 'package:myapp/core/resources/local_buckets.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class DatabaseSetup {
  static const _databaseName = "TodayDatabase.db";
  static const _databaseVersion = 6;

  static const todayTable = 'today';
  static const streakCalendarTable = 'streak_calendar';

  static const todayColumnId = 'id';
  static const todayColumnCaption = 'caption';
  static const todayColumnLocalVideoPath = 'localVideoPath';
  static const todayColumnRemoteVideoUrl = 'remoteVideoUrl';
  static const todayColumnLocalThumbnailPath = 'localThumbnailPath';
  static const todayColumnRemoteThumbnailUrl = 'remoteThumbnailUrl';
  static const todayColumnDate = 'date';
  static const todayColumnEmail = 'email';

  static const streakCalendarColumnId = 'id';
  static const streakCalendarColumnEmail = 'email';
  static const streakCalendarColumnDate = 'date';

  static final DatabaseSetup _instance = DatabaseSetup._internal();

  factory DatabaseSetup() => _instance;

  DatabaseSetup._internal();

  static sql.Database? _database;

  Future<sql.Database?> get database async {
    if (_database != null) return _database;
    final databasesPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(databasesPath, _databaseName),
      version: _databaseVersion,
      onCreate: (db, newVersion) async {
        for (int version = 0; version < newVersion; version++) {
          await _performDbOperationsVersionWise(db, version + 1);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int version = oldVersion; version < newVersion; version++) {
          await _performDbOperationsVersionWise(db, version + 1);
        }
      },
    );
    _database = db;
    return _database;
  }

  Future<void> _performDbOperationsVersionWise(
      sql.Database db, int version) async {
    switch (version) {
      case 1:
        await _databaseVersion1(db);
        break;
      case 2:
        await _databaseVersion2(db);
        break;
      case 3:
        await _databaseVersion3(db);
        break;
      case 4:
        await _databaseVersion4(db);
        break;
      case 5:
        await _databaseVersion5(db);
        break;
      case 6:
        await _databaseVersion6(db);
        break;
    }
  }

  Future<void> _databaseVersion1(sql.Database db) async {
    await db.execute('''
    CREATE TABLE $todayTable (
      id TEXT PRIMARY KEY,
      caption TEXT NOT NULL,
      videoPath TEXT NOT NULL,
      date TEXT NOT NULL,
      thumbnail BLOB NOT NULL
    )
  ''');
  }

  Future<void> _databaseVersion2(sql.Database db) async {
    await db.execute(
        'ALTER TABLE $todayTable ADD COLUMN email TEXT NOT NULL DEFAULT ""');
  }

  Future<void> _databaseVersion3(sql.Database db) async {
    const newTableName = 'today_new';
    final batch = db.batch();
    batch.execute('''
    CREATE TABLE $newTableName (
      id TEXT PRIMARY KEY,
      caption TEXT NOT NULL,
      videoPath TEXT NOT NULL,
      date TEXT NOT NULL,
      thumbnail BLOB NOT NULL,
      email TEXT NOT NULL
    )
  ''');
    batch.execute(
        "INSERT INTO $newTableName (id, caption, videoPath, date, thumbnail, email) SELECT id, caption, videoPath, date, thumbnail, email FROM $todayTable");
    batch.execute("DROP TABLE $todayTable");
    batch.execute("ALTER TABLE $newTableName RENAME TO $todayTable");
    await batch.commit(noResult: true);
  }

  Future<void> _databaseVersion4(sql.Database db) async {
    await db.execute(
        'ALTER TABLE $todayTable ADD COLUMN thumbnailPath TEXT NOT NULL DEFAULT ""');
    final List<Map<String, dynamic>> rows = await db.query(todayTable);

    for (var row in rows) {
      final String id = row[todayColumnId];
      final Uint8List blobData = row['thumbnail'];

      final savedFileId = const Uuid().v4();
      final savedFile = (await MediaStorageHelper().createFile(
          await MediaStorageHelper().getLocalThumbnailPath(savedFileId)))
        ..writeAsBytes(blobData);

      await db.update(
        todayTable,
        {'thumbnailPath': savedFile.path},
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    const newTableName = 'today_new';
    final batch = db.batch();
    batch.execute('''
    CREATE TABLE $newTableName (
      id TEXT PRIMARY KEY,
      caption TEXT NOT NULL,
      videoPath TEXT NOT NULL,
      date TEXT NOT NULL,
      thumbnailPath TEXT NOT NULL,
      email TEXT NOT NULL
    )
  ''');
    batch.execute("""
        INSERT INTO $newTableName (id, caption, videoPath, date, thumbnailPath, email) 
        SELECT id, caption, videoPath, date, thumbnailPath, email FROM $todayTable
        """);
    batch.execute("DROP TABLE $todayTable");
    batch.execute("ALTER TABLE $newTableName RENAME TO $todayTable");
    await batch.commit(noResult: true);
  }

  Future<void> _databaseVersion5(sql.Database db) async {
    const newTableName = 'today_new';
    final batch = db.batch();
    batch.execute('''
    CREATE TABLE $newTableName (
      $todayColumnId TEXT PRIMARY KEY,
      $todayColumnCaption TEXT NOT NULL,
      $todayColumnLocalVideoPath TEXT,
      $todayColumnRemoteVideoUrl TEXT,
      $todayColumnLocalThumbnailPath TEXT,
      $todayColumnRemoteThumbnailUrl TEXT,
      $todayColumnDate TEXT NOT NULL,
      $todayColumnEmail TEXT NOT NULL
    )
  ''');
    batch.execute('''
        INSERT INTO $newTableName ($todayColumnId, $todayColumnCaption, $todayColumnLocalVideoPath, $todayColumnDate, $todayColumnLocalThumbnailPath, $todayColumnEmail) 
        SELECT $todayColumnId, $todayColumnCaption, videoPath, $todayColumnDate, thumbnailPath, $todayColumnEmail FROM $todayTable''');
    batch.execute("DROP TABLE $todayTable");
    batch.execute("ALTER TABLE $newTableName RENAME TO $todayTable");
    await batch.commit(noResult: true);
  }

  Future<void> _databaseVersion6(sql.Database db) async {
    await db.execute('''
    CREATE TABLE $streakCalendarTable (
      $streakCalendarColumnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $streakCalendarColumnDate TEXT NOT NULL,
      $streakCalendarColumnEmail TEXT NOT NULL
    )
  ''');
  }
}
