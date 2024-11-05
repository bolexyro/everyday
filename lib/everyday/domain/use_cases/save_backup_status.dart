import 'package:myapp/everyday/domain/repository/today_repository.dart';

class SaveBackupStatusUseCase {
  SaveBackupStatusUseCase(this.repository);
  final TodayRepository repository;

  Future<void> call(bool status) async {
    await repository.saveBackupStatus(status);
  }
}
