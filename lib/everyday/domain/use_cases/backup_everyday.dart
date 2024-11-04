import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class BackupEverydayUseCase {
  const BackupEverydayUseCase(this.todayRepository);
  final EverydayRepository todayRepository;

  Future<void> call(List<Today> everyday, String currentUserEmail) {
    return todayRepository.backupEveryday(everyday, currentUserEmail);
  }
}
