import 'package:myapp/core/resources/db_setup.dart';
import 'package:myapp/features/streaks/data/models/streak_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

class StreaksLocalDataSource {
  SharedPreferencesWithCache? _prefsCache;
  final _dbSetup = DatabaseSetup();

  Future<sql.Database?> get _database async => await _dbSetup.database;

  String? _lastEmailThatAccessedPrefs;

  Future<SharedPreferencesWithCache> _prefsWithCache(
      String currentUserEmail) async {
    if (_lastEmailThatAccessedPrefs != currentUserEmail) {
      _prefsCache = null;
    }
    _lastEmailThatAccessedPrefs = currentUserEmail;

    _prefsCache ??= await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: {
          '${currentUserEmail}currentStreakCount',
          '${currentUserEmail}mostStreakCount'
        },
      ),
    );
    return _prefsCache!;
  }

  Future<StreakModel?> _readLastStreak(String currentUserEmail) async {
    final db = await _database;
    final List<Map<String, dynamic>> result = await db!.query(
      DatabaseSetup.streakCalendarTable,
      orderBy: '${DatabaseSetup.streakCalendarColumnId} DESC',
      limit: 1,
      where: '${DatabaseSetup.todayColumnEmail} = ?',
      whereArgs: [currentUserEmail],
    );
    return result.isNotEmpty ? StreakModel.fromJson(result.first) : null;
  }

  Future<List<StreakModel>> _readAllStreak(String currentUserEmail) async {
    final db = await _database;
    final List<Map<String, dynamic>> result = await db!.query(
      DatabaseSetup.streakCalendarTable,
      where: '${DatabaseSetup.todayColumnEmail} = ?',
      whereArgs: [currentUserEmail],
    );
    return result.map((streak) => StreakModel.fromJson(streak)).toList();
  }

  Future<void> _insertStreak(StreakModel streak) async {
    final db = await _database;
    await db!.insert(
      DatabaseSetup.streakCalendarTable,
      streak.toJson(),
    );
  }

  Future<int> getCurrentStreakCount(String currentUserEmail) async {
    final prefs = await _prefsWithCache(currentUserEmail);
    int? savedCurrentStreakCount =
        prefs.getInt('${currentUserEmail}currentStreakCount');

    final currentDate = DateTime.now();

    // handle the edge case where share prefs loses our data.
    // so get the streaks from the db, and calculate currentStreakCount
    if (savedCurrentStreakCount == null) {
      final lastStreak = await _readLastStreak(currentUserEmail);
      if (lastStreak == null) {
        await prefs.setInt('${currentUserEmail}currentStreakCount', 1);
        await _insertStreak(
            StreakModel(email: currentUserEmail, date: currentDate));
        return 1;
      } else {
        final allStreaks = await _readAllStreak(currentUserEmail);
        final todayStreakExists = allStreaks.any((streak) =>
            streak.date.year == currentDate.year &&
            streak.date.month == currentDate.month &&
            streak.date.day == currentDate.day);

        if (!todayStreakExists) {
          allStreaks
              .add(StreakModel(email: currentUserEmail, date: currentDate));
          await _insertStreak(
              StreakModel(email: currentUserEmail, date: currentDate));
        }

        allStreaks.sort((a, b) => a.date.compareTo(b.date));
        int streakCount = 1; // Start with a streak count of 1 (the last login)
        DateTime lastStreakDate = allStreaks.last.date;

        // Calculate the streak count by checking consecutive days
        for (int i = allStreaks.length - 2; i >= 0; i--) {
          final streakDate = allStreaks[i].date;
          final gapInDays = lastStreakDate.difference(streakDate).inDays;

          if (gapInDays == 1) {
            streakCount++;
            lastStreakDate = streakDate;
          } else {
            break;
          }
        }

        await prefs.setInt(
            '${currentUserEmail}currentStreakCount', streakCount);
        return streakCount;
      }
    }

    final lastStreak = await _readLastStreak(currentUserEmail);

    if (lastStreak == null) {
      await prefs.setInt('${currentUserEmail}currentStreakCount', 1);
      await _insertStreak(
          StreakModel(email: currentUserEmail, date: currentDate));
      return 1;
    }
    final gapInDays = currentDate.difference(lastStreak.date).inDays;

    if (gapInDays == 1) {
      await prefs.setInt(
          '${currentUserEmail}currentStreakCount', ++savedCurrentStreakCount);

      await _insertStreak(
          StreakModel(email: currentUserEmail, date: currentDate));
      return savedCurrentStreakCount;
    }

    if (gapInDays > 1) {
      await prefs.setInt('${currentUserEmail}currentStreakCount', 1);
      await _insertStreak(
          StreakModel(email: currentUserEmail, date: currentDate));
      return 1;
    }

    return savedCurrentStreakCount;
  }
}
