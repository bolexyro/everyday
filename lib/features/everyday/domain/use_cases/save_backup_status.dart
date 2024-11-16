import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class SaveBackupStatusUseCase {
  SaveBackupStatusUseCase(this.todayRepository, this.authRepository);
  
  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<void> call(bool status) async {
    await todayRepository.saveBackupStatus(
        status, authRepository.currentUser!.email);
  }
}
