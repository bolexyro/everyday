import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/today_repository.dart';

class ReadTodaysUseCase {
  const ReadTodaysUseCase(this.todayRepository, this.authRepository);
  final TodayRepository todayRepository;
  final AuthRepository authRepository;

  Future<DataState<List<Today>>> call() {
    final currentUser = authRepository.currentUser!;
    return todayRepository.readTodays(currentUser.email);
  }
}
