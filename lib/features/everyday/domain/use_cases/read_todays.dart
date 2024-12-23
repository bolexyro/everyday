import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class ReadTodaysUseCase {
  const ReadTodaysUseCase(this.todayRepository, this.authRepository);
  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<DataState<List<Today>>> call(bool isConnected) {
    final currentUser = authRepository.currentUser!;
    return todayRepository.readTodays(currentUser.email, isConnected);
  }
}
