import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class ReadEverydayUseCase {
  const ReadEverydayUseCase(this.todayRepository, this.authRepository);
  final EverydayRepository todayRepository;
  final AuthRepository authRepository;

  Future<List<Today>> call() {
    final currentUser = authRepository.currentUser!;
    return todayRepository.readEveryday(currentUser.email);
  }
}
