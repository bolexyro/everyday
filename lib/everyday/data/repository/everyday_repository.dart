import 'package:myapp/everyday/data/data_sources/everyday_local_data_source.dart';
import 'package:myapp/everyday/data/models/today_model.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class EverydayRepositoryImpl implements EverydayRepository {
  const EverydayRepositoryImpl(this.localDataSource);
  final EverydayLocalDataSource localDataSource;

  @override
  Future<Today> addToday(Today today) async {
    final todayModel = TodayModel(
      id: today.id,
      caption: today.caption,
      videoPath: today.videoPath,
      date: today.date,
      thumbnail: today.thumbnail,
    );
    final savedTodayModel = await localDataSource.insertToday(todayModel);
    return Today.fromModel(savedTodayModel);
  }

  @override
  Future<void> deleteToday(String id) {
    // TODO: implement deleteToday
    throw UnimplementedError();
  }

  @override
  Future<List<Today>> readEveryday() async {
    final allSavedTodays = await localDataSource.readAllTodays();
    return allSavedTodays
        .map((todayModel) => Today.fromModel(todayModel))
        .toList();
  }

  @override
  Future<void> uploadEveryday() {
    // TODO: implement uploadEveryday
    throw UnimplementedError();
  }
}
