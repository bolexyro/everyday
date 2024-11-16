import 'package:myapp/features/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class GetBackupProgressUseCase {
  const GetBackupProgressUseCase(this.todayRepository);
  final TodayRepository todayRepository;

  Stream<BackupProgress> call() => todayRepository.backupProgressStream;
}
