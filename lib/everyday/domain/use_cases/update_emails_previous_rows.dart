import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/repository/today_repository.dart';

class UpdateEmailsPreviousRowsUseCase {
  const UpdateEmailsPreviousRowsUseCase(
      this.authRepository, this.todayRepository);
  final AuthRepository authRepository;
  final TodayRepository todayRepository;

  Future<void> call() async {
    final currentUser = authRepository.currentUser!;
    await todayRepository.updateEmailForPreviousRows(currentUser.email);
  }
}
