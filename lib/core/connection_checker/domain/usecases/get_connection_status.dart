import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';
import 'package:myapp/core/connection_checker/domain/repository/connection_repository.dart';

class GetConnectionStatusUseCase {
  const GetConnectionStatusUseCase(this.connectionRepository);
  final ConnectionRepository connectionRepository;

  ConnectionStatus call() {
    return connectionRepository.getConnectionStatus();
  }
}
