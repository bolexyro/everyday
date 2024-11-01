import 'package:myapp/auth/domain/entity/user.dart' as auth_entity;

class AppAuthState{
  const AppAuthState({
    this.user,
    this.isAuthenticated = false,
  });

  final auth_entity.AppUser? user;
  final bool isAuthenticated;
}
