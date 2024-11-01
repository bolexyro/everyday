import 'package:myapp/auth/domain/auth_state.dart';
import 'package:myapp/auth/domain/repository/auth_repository.dart';

class AuthStateChangeUseCase {
  const AuthStateChangeUseCase(this.authRepository);
  final AuthRepository authRepository;

  Stream<AppAuthState> call() => authRepository.authStateChanges;
}
