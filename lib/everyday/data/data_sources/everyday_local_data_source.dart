import 'dart:io';

import 'package:myapp/everyday/data/models/today_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EverydayLocalDataSource {
  static const _databaseName = "TodayDatabase.db";
  static const _databaseVersion = 3;
  static const todayTable = 'today';

  static const columnId = 'id';
  static const columnCaption = 'caption';
  static const columnVideoPath = 'videoPath';
  static const columnThumbnail = 'thumbnail';
  static const columnDate = 'date';
  static const columnEmail = 'email';

  static final EverydayLocalDataSource _instance =
      EverydayLocalDataSource._internal();

  factory EverydayLocalDataSource() => _instance;

  EverydayLocalDataSource._internal();

  static sql.Database? _database;

  Future<sql.Database?> get database async {
    if (_database != null) return _database;
    final databasesPath = await sql.getDatabasesPath();

    // this works but In general, using path.join(await getDatabasesPath(), 'my_db.db') explicitly is often considered a best practice to avoid any ambiguity.
    // final db = await sql.openDatabase(
    // _databaseName,
    final db = await sql.openDatabase(
      path.join(databasesPath, _databaseName),
      version: _databaseVersion,
      onCreate: (db, newVersion) async {
        for (int version = 0; version < newVersion; version++) {
          _performDbOperationsVersionWise(db, version + 1);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int version = oldVersion; version < newVersion; version++) {
          _performDbOperationsVersionWise(db, version + 1);
        }
      },
    );
    _database = db;
    return _database;
  }

  static Future<void> _performDbOperationsVersionWise(
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
    }
  }

  static Future<void> _databaseVersion1(sql.Database db) async {
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

  static Future<void> _databaseVersion2(sql.Database db) async {
    await db.execute(
        'ALTER TABLE $todayTable ADD COLUMN $columnEmail TEXT NOT NULL DEFAULT ""');
  }

  static Future<void> _databaseVersion3(sql.Database db) async {
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

  Future<TodayModel> insert(String videoPath, String caption) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    final directory = await getApplicationDocumentsDirectory();
    final savedFileId = const Uuid().v4();
    final savedFile =
        await File(videoPath).copy('${directory.path}/$savedFileId.mp4');

    final today = TodayModel(
      id: savedFileId,
      caption: caption,
      videoPath: savedFile.path,
      date: DateTime.now(),
      thumbnail: uint8list!,
    );

    final db = await database;
    await db!.insert(todayTable, today.toJson());
    return today;
  }

  Future<List<TodayModel>> readAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.query(todayTable);
    // resulting maps are read only
    // so if you do maps.first[columnId]  = 2, it would throw an exception
    return List<TodayModel>.from(maps.map((map) {
      return TodayModel.fromJson(map);
    }));
  }

  Future<void> delete(String id, String videoPath) async {
    final db = await database;
    await File(videoPath).delete();
    await db!.delete(todayTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> updateEmailForPreviousRows(String currentUserEmail) async {
    if (_databaseVersion != 2) {
      return;
    }
    final db = await database;
    db!.update(todayTable, {columnEmail: currentUserEmail},
        where: '$columnEmail = ?', whereArgs: ['']);
  }
}


//  for (var row
//         in (await db!.query('sqlite_master', columns: ['type', 'name']))) {
//       print(row.values);
//     }