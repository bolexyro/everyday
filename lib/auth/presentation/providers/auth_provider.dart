import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth/data/repository/auth_repository.dart';
import 'package:myapp/auth/domain/auth_state.dart';
import 'package:myapp/auth/domain/usecases/auth_state_change.dart';
import 'package:myapp/auth/domain/usecases/get_current_user.dart';
import 'package:myapp/auth/domain/usecases/login.dart';
import 'package:myapp/auth/domain/usecases/logout.dart';
import 'package:myapp/auth/presentation/screens/login_screen.dart';
import 'package:myapp/everyday/presentation/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthNotifier extends StateNotifier<AppAuthState> {
  AuthNotifier(
    this._loginUseCase,
    this._authStateChangeUseCase,
    this._getCurrentUserUseCase,
    this._logoutUseCase,
  ) : super(const AppAuthState(isAuthenticated: false)) {
    getCurrentUser();
    _initializeAuthState();
  }

  final LoginUseCase _loginUseCase;
  final AuthStateChangeUseCase _authStateChangeUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  void _initializeAuthState() {
    _authStateChangeUseCase().listen((authState) {
      state = authState;
      if (state.isAuthenticated) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  void getCurrentUser() {
    final user = _getCurrentUserUseCase.call();
    if (user != null) {
      state = AppAuthState(
        isAuthenticated: true,
        user: user,
      );
    }
  }

  Future<void> login() async {
    await _loginUseCase.call();
  }

  Future<void> logout() async {
    await _logoutUseCase();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AppAuthState>(
  (ref) => AuthNotifier(
    LoginUseCase(
      AuthRepositoryImpl(
        Supabase.instance.client,
      ),
    ),
    AuthStateChangeUseCase(
      AuthRepositoryImpl(Supabase.instance.client),
    ),
    GetCurrentUserUseCase(
      AuthRepositoryImpl(Supabase.instance.client),
    ),
    LogoutUseCase(
      AuthRepositoryImpl(Supabase.instance.client),
    ),
  ),
);
