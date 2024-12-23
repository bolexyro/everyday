import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';

abstract class ConnectionRepository {
  Stream<ConnectionStatus> getConnectionStatusStream();
  ConnectionStatus getConnectionStatus();
}
