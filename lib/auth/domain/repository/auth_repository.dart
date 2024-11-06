import 'package:myapp/auth/domain/auth_state.dart';
import 'package:myapp/auth/domain/entity/user.dart';
import 'package:myapp/core/resources/data_state.dart';

abstract class AuthRepository {
  Stream<AppAuthState> get authStateChanges;
  Future<DataState?> login();
  Future<void> logout();
  AppUser? get currentUser;
}
