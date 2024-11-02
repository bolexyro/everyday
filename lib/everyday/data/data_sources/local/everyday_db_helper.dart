import 'dart:io';
import 'dart:typed_data';

import 'package:myapp/core/resources/local_buckets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class TodayDatabaseHelper {
  static const _databaseName = "TodayDatabase.db";
  static const _databaseVersion = 4;
  static const todayTable = 'today';

  static const columnId = 'id';
  static const columnCaption = 'caption';
  static const columnVideoPath = 'videoPath';
  static const columnThumbnail = 'thumbnail';
  static const columnDate = 'date';
  static const columnEmail = 'email';
  static const columnThumbnailPath = 'thumbnailPath';

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
    }
  }

  Future<void> _databaseVersion1(sql.Database db) async {
    await db.execute('''
    CREATE TABLE $todayTable (
      $columnId TEXT PRIMARY KEY,
      $columnCaption TEXT NOT NULL,
      $columnVideoPath TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnThumbnail BLOB NOT NULL
    )
  ''');
  }

  Future<void> _databaseVersion2(sql.Database db) async {
    await db.execute(
        'ALTER TABLE $todayTable ADD COLUMN $columnEmail TEXT NOT NULL DEFAULT ""');
  }

  Future<void> _databaseVersion3(sql.Database db) async {
    const newTableName = 'today_new';
    final batch = db.batch();
    batch.execute('''
    CREATE TABLE $newTableName (
      $columnId TEXT PRIMARY KEY,
      $columnCaption TEXT NOT NULL,
      $columnVideoPath TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnThumbnail BLOB NOT NULL,
      $columnEmail TEXT NOT NULL
    )
  ''');
    batch.execute(
        "INSERT INTO $newTableName ($columnId, $columnCaption, $columnVideoPath, $columnDate, $columnThumbnail, $columnEmail) SELECT $columnId, $columnCaption, $columnVideoPath, $columnDate, $columnThumbnail, $columnEmail FROM $todayTable");
    batch.execute("DROP TABLE $todayTable");
    batch.execute("ALTER TABLE $newTableName RENAME TO $todayTable");
    await batch.commit(noResult: true);
  }

  Future<void> _databaseVersion4(sql.Database db) async {
    await db.execute(
        'ALTER TABLE $todayTable ADD COLUMN $columnThumbnailPath TEXT NOT NULL DEFAULT ""');
    final List<Map<String, dynamic>> rows = await db.query(todayTable);

    for (var row in rows) {
      final String id = row[columnId];
      final Uint8List blobData = row[columnThumbnail];

      final directory = await getApplicationDocumentsDirectory();
      final savedFileId = const Uuid().v4();
      final savedFile = await File(
              '${directory.path}/${LocalBuckets.thumbnails}/$savedFileId.jpg')
          .create(recursive: true)
        ..writeAsBytes(blobData);

      await db.update(
        todayTable,
        {columnThumbnailPath: savedFile.path},
        where: '$columnId = ?',
        whereArgs: [id],
      );
    }

    const newTableName = 'today_new';
    final batch = db.batch();
    batch.execute('''
    CREATE TABLE $newTableName (
      $columnId TEXT PRIMARY KEY,
      $columnCaption TEXT NOT NULL,
      $columnVideoPath TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnThumbnailPath TEXT NOT NULL,
      $columnEmail TEXT NOT NULL
    )
  ''');
    batch.execute(
        "INSERT INTO $newTableName ($columnId, $columnCaption, $columnVideoPath, $columnDate, $columnThumbnailPath, $columnEmail) SELECT $columnId, $columnCaption, $columnVideoPath, $columnDate, $columnThumbnailPath, $columnEmail FROM $todayTable");
    batch.execute("DROP TABLE $todayTable");
    batch.execute("ALTER TABLE $newTableName RENAME TO $todayTable");
    await batch.commit(noResult: true);
    print('I am done with migrations');
  }
}
