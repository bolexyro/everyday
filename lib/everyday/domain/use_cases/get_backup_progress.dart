import 'package:myapp/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class GetBackupProgressUseCase {
  const GetBackupProgressUseCase(this.everydayRepository);
  final EverydayRepository everydayRepository;

  Stream<BackupProgress> call() => everydayRepository.backupProgressStream;
  
}
