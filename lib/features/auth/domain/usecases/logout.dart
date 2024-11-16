import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase{
  final AuthRepository authRepository;
  const LogoutUseCase(this.authRepository);

  Future<void> call() async {
    return await authRepository.logout();
  }

}