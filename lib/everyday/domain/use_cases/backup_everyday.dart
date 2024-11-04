import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class BackupEverydayUseCase {
  const BackupEverydayUseCase(this.todayRepository, this.authRepository);
  final EverydayRepository todayRepository;
  final AuthRepository authRepository;

  Future<void> call(List<Today> everyday) {
    return todayRepository.backupEveryday(
        everyday, authRepository.currentUser!.email);
  }
}
