import 'package:myapp/features/streaks/data/data_sources/local_data_source.dart';
import 'package:myapp/features/streaks/domain/repository/streak_repository.dart';

class StreakRepositoryImpl implements StreakRepository {
  const StreakRepositoryImpl(this._localDataSource);
  final StreaksLocalDataSource _localDataSource;

  @override
  Future<int> getCurrentStreakCount(String currentUserEmail) {
    return _localDataSource.getCurrentStreakCount(currentUserEmail);
  }

  @override
  Future<int> getMostStreakCount(String currentUserEmail) {
    // TODO: implement getMostStreakCount
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getStreakCalendar(String currentUserEmail) {
    // TODO: implement getStreakCalendar
    throw UnimplementedError();
  }
}
