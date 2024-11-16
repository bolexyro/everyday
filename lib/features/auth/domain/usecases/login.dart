import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';

class LoginUseCase {
  const LoginUseCase(this.authRepository);
  final AuthRepository authRepository;

  Future<DataState?> call() async {
    return await authRepository.login();
  }
}
