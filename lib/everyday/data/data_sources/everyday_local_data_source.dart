import 'package:myapp/everyday/data/models/today_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class EverydayLocalDataSource {
  static const _databaseName = "TodayDatabase.db";
  static const _databaseVersion = 1;
  static const todayTable = 'today';

  static const columnId = 'id';
  static const columnCaption = 'caption';
  static const columnVideoPath = 'videoPath';
  static const columnThumbnail = 'thumbnail';
  static const columnDate = 'date';

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
    }
  }

  static Future<void> _databaseVersion1(sql.Database db) async {
    await db.execute('''
    CREATE TABLE today (
      $columnId TEXT PRIMARY KEY,
      $columnCaption TEXT NOT NULL,
      $columnVideoPath TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnThumbnail BLOB NOT NULL
    )
  ''');
  }

  Future<TodayModel> insertToday(TodayModel today) async {
    final db = await database;
    await db!.insert(todayTable, today.toJson());
    return today;
  }

  Future<List<TodayModel>> readAllTodays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('today');
    // resulting maps are read only
    // so if you do maps.first[columnId]  = 2, it would throw an exception
    return List<TodayModel>.from(maps.map((map) {
      return TodayModel.fromJson(map);
    }));
  }
}
