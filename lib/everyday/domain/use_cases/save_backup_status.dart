import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/repository/today_repository.dart';

class SaveBackupStatusUseCase {
  SaveBackupStatusUseCase(this.todayRepository, this.authRepository);
  
  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<void> call(bool status) async {
    await todayRepository.saveBackupStatus(
        status, authRepository.currentUser!.email);
  }
}
