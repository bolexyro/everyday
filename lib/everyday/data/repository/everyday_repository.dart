import 'package:myapp/everyday/data/data_sources/local/everyday_local_data_source.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class EverydayRepositoryImpl implements EverydayRepository {
  const EverydayRepositoryImpl(this.localDataSource);
  final EverydayLocalDataSource localDataSource;

  @override
  Future<Today> addToday(
      String videoPath, String caption, String currentUserEmail) async {
    final savedTodayModel =
        await localDataSource.insert(videoPath, caption, currentUserEmail);
    return Today.fromModel(savedTodayModel);
  }

  @override
  Future<void> deleteToday(String id, String videoPath) async {
    await localDataSource.delete(id, videoPath);
  }

  @override
  Future<List<Today>> readEveryday(currentUserEmail) async {
    final allSavedTodays = await localDataSource.readAll(currentUserEmail);
    return allSavedTodays
        .map((todayModel) => Today.fromModel(todayModel))
        .toList();
  }

  @override
  Future<void> updateEmailForPreviousRows(email) async {
    await localDataSource.updateEmailForPreviousRows(email);
  }

  @override
  Future<void> backupEveryday(everyday) {
    // TODO: implement uploadEveryday
    throw UnimplementedError();
  }
}
