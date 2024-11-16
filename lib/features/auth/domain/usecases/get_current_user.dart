import 'package:myapp/features/auth/domain/entity/user.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this.authRepository);
  final AuthRepository authRepository;

  AppUser? call() => authRepository.currentUser;
}
