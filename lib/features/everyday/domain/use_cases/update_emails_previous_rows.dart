import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

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
