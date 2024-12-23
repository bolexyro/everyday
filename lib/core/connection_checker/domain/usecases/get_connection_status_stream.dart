import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';
import 'package:myapp/core/connection_checker/domain/repository/connection_repository.dart';

class GetConnectionStatusStreamUseCase {
  const GetConnectionStatusStreamUseCase(this.connectionRepository);
  final ConnectionRepository connectionRepository;

  Stream<ConnectionStatus> call() {
    return connectionRepository.getConnectionStatusStream();
  }
}
