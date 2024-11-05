import 'package:myapp/everyday/domain/repository/today_repository.dart';

class GetBackupStatusUseCase {
  final TodayRepository todayRepository;

  GetBackupStatusUseCase(this.todayRepository);

  Future<bool> call() async {
    return await todayRepository.getBackupStatus();
  }
}
