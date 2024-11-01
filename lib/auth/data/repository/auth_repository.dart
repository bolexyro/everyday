import 'package:myapp/auth/data/data_sources/remote_data_source.dart';
import 'package:myapp/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<void> login() async {
    await remoteDataSource.login();
  }
}
