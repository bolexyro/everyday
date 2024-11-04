import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class GetBackupStatusUseCase {
  final EverydayRepository repository;

  GetBackupStatusUseCase(this.repository);

  Future<bool> call() async {
    return await repository.getBackupStatus();
  }
}

