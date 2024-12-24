import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/features/streaks/domain/repository/streak_repository.dart';

class GetCurrentStreakCountUseCase {
  const GetCurrentStreakCountUseCase(
      this.authRepository, this.streakRepository);
  final AuthRepository authRepository;
  final StreakRepository streakRepository;

  Future<int> call() async {
    return streakRepository
        .getCurrentStreakCount(authRepository.currentUser!.email);
  }
}
