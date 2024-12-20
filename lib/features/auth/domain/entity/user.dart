import 'package:myapp/features/auth/data/models/user_model.dart';

class AppUser {
  const AppUser({
    required this.email,
    required this.name,
    required this.photoUrl,
  });
  final String email;
  final String name;
  final String photoUrl;

  AppUser.anonymous()
      : email = '',
        name = '',
        photoUrl = '';

  AppUser.fromModel(UserModel userModel)
      : email = userModel.email,
        name = userModel.name,
        photoUrl = userModel.photoUrl;
        
  @override
  String toString() {
    return 'AppUser(email: $email, name: $name, photoUrl: $photoUrl)';
  }
}
