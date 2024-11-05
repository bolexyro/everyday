import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/auth/domain/auth_state.dart';
import 'package:myapp/auth/domain/entity/user.dart';
import 'package:myapp/auth/domain/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.firebaseAuth) {
    _initializeAuthStateListener();
  }
  final FirebaseAuth firebaseAuth;
  final _authStateController = StreamController<AppAuthState>();
  late final googleSignIn = GoogleSignIn();

  @override
  Stream<AppAuthState> get authStateChanges => _authStateController.stream;

  void _initializeAuthStateListener() {
    firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _authStateController.add(
          AppAuthState(
            isAuthenticated: true,
            user: AppUser(
              email: user.email!,
              name: user.providerData.first.displayName ?? 'Bolexyro NAtions',
              photoUrl: user.providerData.first.photoURL ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpt04Av779EWVHmAKPWu4X1fKJ3t8rQ__Ztw&s',
            ),
          ),
        );
      } else {
        _authStateController.add(
          const AppAuthState(
            isAuthenticated: false,
          ),
        );
      }
    });
  }

  @override
  AppUser? get currentUser {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return AppUser(
      email: user.email!,
      name: user.providerData.first.displayName!,
      photoUrl: user.providerData.first.photoURL!,
    );
  }

  @override
  Future<DataState> login() async {
    try {
      // throw 'Bolexyro Nations';
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return const DataException(
            'An error occurred. Please check your internet connection and try again');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return const DataSuccess('Login success');
    } on PlatformException catch (e) {
      return DataException(e.code == 'network_error'
          ? 'Please check your internet connection and try again'
          : 'An unknown error occurred');
    } catch (e) {
      return const DataException('An unknown error occurred');
    }
  }

  @override
  Future<void> logout() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
