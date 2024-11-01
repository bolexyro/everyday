import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/auth/domain/auth_state.dart';
import 'package:myapp/auth/domain/entity/user.dart';
import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.supabaseClient) {
    _initializeAuthStateListener();
  }

  final SupabaseClient supabaseClient;
  final _authStateController = StreamController<AppAuthState>();
  final webClientId =
      '260386231659-g4u93n6lfvvfch4uf3fja488lvno63b2.apps.googleusercontent.com';
  late final googleSignIn = GoogleSignIn(
    serverClientId: webClientId,
  );

  @override
  Stream<AppAuthState> get authStateChanges => _authStateController.stream;

  void _initializeAuthStateListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        final user = session!.user;
        _authStateController.add(
          AppAuthState(
            isAuthenticated: true,
            user: AppUser(
              email: user.email!,
              name: user.appMetadata.toString(),
              photoUrl: user.appMetadata.toString(),
            ),
          ),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        _authStateController.add(
          AppAuthState(
            isAuthenticated: false,
            user: AppUser.anonymous(),
          ),
        );
      }
    });
  }

  @override
  AppUser? get currentUser {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      return null;
    }
    return AppUser(
      email: user.email!,
      name: user.appMetadata.toString(),
      photoUrl: user.appMetadata.toString(),
    );
  }

  @override
  Future<void> login() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    if (kIsWeb) {
      await supabaseClient.auth.signInWithOAuth(OAuthProvider.google);
      return;
    }

    await supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
    await googleSignIn.signOut();
  }
}
