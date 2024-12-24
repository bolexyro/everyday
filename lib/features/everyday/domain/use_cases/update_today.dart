import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class UpdateTodayUseCase {
  const UpdateTodayUseCase(this._authRepository, this._todayRepository);
  final AuthRepository _authRepository;
  final TodayRepository _todayRepository;

  Future<DataState> call(Today today) {
    return _todayRepository.updateToday(
        today, _authRepository.currentUser!.email);
  }
}
