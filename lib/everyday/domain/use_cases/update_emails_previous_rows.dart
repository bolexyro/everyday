import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class UpdateEmailsPreviousRowsUseCase {
  const UpdateEmailsPreviousRowsUseCase(this.authRepository, this.everydayRepository);
  final AuthRepository authRepository;
  final EverydayRepository everydayRepository;

  Future<void> call() async {
    final currentUser = authRepository.currentUser!;
    await everydayRepository.updateEmailForPreviousRows(currentUser.email);
  }
}
