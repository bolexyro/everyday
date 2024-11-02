import 'dart:io';
import 'dart:typed_data';

import 'package:myapp/core/resources/local_buckets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class TodayDatabaseHelper {
  static const _databaseName = "TodayDatabase.db";
  static const _databaseVersion = 5;
  static const todayTable = 'today';

  static const columnId = 'id';
  static const columnCaption = 'caption';
  static const columnLocalVideoPath = 'localVideoPath';
  static const columnRemoteVideoUrl = 'remoteVideoUrl';
  static const columnLocalThumbnailPath = 'localThumbnailPath';
  static const columnRemoteThumbnailUrl = 'remoteThumbnailUrl';
  static const columnDate = 'date';
  static const columnEmail = 'email';

  static final TodayDatabaseHelper _instance = TodayDatabaseHelper._internal();

  factory TodayDatabaseHelper() => _instance;

  TodayDatabaseHelper._internal();

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
      final String id = row[columnId];
      final Uint8List blobData = row['thumbnail'];

      final directory = await getApplicationDocumentsDirectory();
      final savedFileId = const Uuid().v4();
      final savedFile = await File(
              '${directory.path}/${LocalBuckets.thumbnails}/$savedFileId.jpg')
          .create(recursive: true)
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
      $columnId TEXT PRIMARY KEY,
      $columnCaption TEXT NOT NULL,
      $columnLocalVideoPath TEXT,
      $columnRemoteVideoUrl TEXT,
      $columnLocalThumbnailPath TEXT,
      $columnRemoteThumbnailUrl TEXT,
      $columnDate TEXT NOT NULL,
      $columnEmail TEXT NOT NULL
    )
  ''');
    batch.execute('''
        INSERT INTO $newTableName ($columnId, $columnCaption, $columnLocalVideoPath, $columnDate, $columnLocalThumbnailPath, $columnEmail) 
        SELECT $columnId, $columnCaption, videoPath, $columnDate, thumbnailPath, $columnEmail FROM $todayTable''');
    batch.execute("DROP TABLE $todayTable");
    batch.execute("ALTER TABLE $newTableName RENAME TO $todayTable");
    await batch.commit(noResult: true);
  }
}
