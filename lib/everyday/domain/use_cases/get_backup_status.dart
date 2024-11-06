import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/repository/today_repository.dart';

class GetBackupStatusUseCase {
  GetBackupStatusUseCase(this.todayRepository, this.authRepository);

  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<bool> call() async {
    return await todayRepository
        .getBackupStatus(authRepository.currentUser!.email);
  }
}
