import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class AddTodayUseCase {
  const AddTodayUseCase(this.todayRepository, this.authRepository);
  final EverydayRepository todayRepository;
  final AuthRepository authRepository;

  Future<Today> call(String videoPath, String caption) {
    final currentUser = authRepository.currentUser!;
    return todayRepository.addToday(videoPath, caption, currentUser.email);
  }
}
