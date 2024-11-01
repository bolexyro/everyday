import 'package:myapp/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this.authRepository);
  final AuthRepository authRepository;

  Future<void> call() async {
    await authRepository.login();
  }
}
