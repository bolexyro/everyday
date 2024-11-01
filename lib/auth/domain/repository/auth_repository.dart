import 'package:myapp/auth/domain/auth_state.dart';
import 'package:myapp/auth/domain/entity/user.dart';

abstract class AuthRepository {
  Stream<AppAuthState> get authStateChanges;
  Future<void> login();
  Future<void> logout();
  AppUser? get currentUser;
}
