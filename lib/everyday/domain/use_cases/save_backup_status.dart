import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class SaveBackupStatusUseCase {
  SaveBackupStatusUseCase(this.repository);
  final EverydayRepository repository;
  
  Future<void> call(bool status) async {
    await repository.saveBackupStatus(status);
  }
}
