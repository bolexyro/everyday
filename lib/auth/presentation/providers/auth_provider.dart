import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth/data/data_sources/remote_data_source.dart';
import 'package:myapp/auth/data/repository/auth_repository.dart';
import 'package:myapp/auth/domain/usecases/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends StateNotifier {
  AuthNotifier(this.loginUseCase) : super([]);

  final LoginUseCase loginUseCase;

  Future<void> login() async {
    await loginUseCase.call();
  }
}

final authProvider = StateNotifierProvider(
  (ref) => AuthNotifier(
    LoginUseCase(
      AuthRepositoryImpl(
        AuthRemoteDataSource(Supabase.instance.client),
      ),
    ),
  ),
);
