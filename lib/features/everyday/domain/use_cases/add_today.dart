import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class AddTodayUseCase {
  const AddTodayUseCase(this.todayRepository, this.authRepository);
  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<DataState<Today>> call(String videoPath, String caption) {
    final currentUser = authRepository.currentUser!;
    return todayRepository.addToday(videoPath, caption, currentUser.email);
  }
}
