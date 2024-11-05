import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/today_repository.dart';

class BackupTodaysUseCase {
  const BackupTodaysUseCase(this.todayRepository, this.authRepository);
  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<void> call(List<Today> todays) {
    return todayRepository.backupTodays(
        todays, authRepository.currentUser!.email);
  }
}
