import 'package:myapp/everyday/data/data_sources/everyday_local_data_source.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class EverydayRepositoryImpl implements EverydayRepository {
  const EverydayRepositoryImpl(this.localDataSource);
  final EverydayLocalDataSource localDataSource;

  @override
  Future<Today> addToday(String videoPath, String caption) async {
    final savedTodayModel = await localDataSource.insert(videoPath, caption);
    return Today.fromModel(savedTodayModel);
  }

  @override
  Future<void> deleteToday(String id, String videoPath) async {
    await localDataSource.delete(id, videoPath);
  }

  @override
  Future<List<Today>> readEveryday() async {
    final allSavedTodays = await localDataSource.readAll();
    return allSavedTodays
        .map((todayModel) => Today.fromModel(todayModel))
        .toList();
  }

@override
  Future<void> updateEmailForPreviousRows(String email) async{
   await  localDataSource.updateEmailForPreviousRows(email);
  }
  @override
  Future<void> uploadEveryday() {
    // TODO: implement uploadEveryday
    throw UnimplementedError();
  }
}
