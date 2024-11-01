import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this.supabase);
  final SupabaseClient supabase;
  Future<void> login() async {
    await supabase.auth.signInWithOAuth(OAuthProvider.google);
  }
}
