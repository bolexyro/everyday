import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/data/repository/auth_repository.dart';
import 'package:myapp/features/streaks/data/repository/streak_repository.dart';
import 'package:myapp/features/streaks/domain/entities/streak_state_data.dart';
import 'package:myapp/features/streaks/domain/usecase/get_current_streak_count.dart';
import 'package:myapp/service_locator.dart';

class StreakNotifier extends StateNotifier<StreakStateData> {
  final GetCurrentStreakCountUseCase _getCurrentStreakCountUseCase;

  StreakNotifier(this._getCurrentStreakCountUseCase)
      : super(
          StreakStateData(
            currentStreakCount: 1,
            mostStreakCount: 1,
            streakCalendr: [DateTime.now()],
          ),
        );

  Future<void> getCurrentStreakCount() async {
    state = state.copyWith(
      currentStreakCount: await _getCurrentStreakCountUseCase(),
    );
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, StreakStateData>(
    (ref) => StreakNotifier(GetCurrentStreakCountUseCase(
        getIt<AuthRepositoryImpl>(), getIt<StreakRepositoryImpl>())));
