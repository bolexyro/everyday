import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';
import 'package:myapp/core/connection_checker/domain/repository/connection_repository.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  ConnectionRepositoryImpl(this._connectivityChecker,
      this._internetConnectionChecker, this._initialConnectionStatus) {
    _connectionStatus = _initialConnectionStatus;
    initialize();
  }
  final InternetConnectionChecker _internetConnectionChecker;
  final Connectivity _connectivityChecker;
  final ConnectionStatus _initialConnectionStatus;

  late ConnectionStatus _connectionStatus;

  final StreamController<ConnectionStatus> _connectionChangeController =
      StreamController.broadcast();

  @override
  Stream<ConnectionStatus> getConnectionStatusStream() =>
      _connectionChangeController.stream;

  @override
  ConnectionStatus getConnectionStatus() => _connectionStatus;

  Future<void> initialize() async {
    _internetConnectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) async {
        ConnectionStatus previousConnectionStatus = _connectionStatus;

        if (status == InternetConnectionStatus.connected) {
          _connectionStatus = ConnectionStatus.connected;
        } else {
          final requiredConnections = [
            ConnectivityResult.mobile,
            ConnectivityResult.wifi
          ];
          final List<ConnectivityResult> connectivityResult =
              await (_connectivityChecker.checkConnectivity());
          if (requiredConnections
              .any((element) => connectivityResult.contains(element))) {
            _connectionStatus = ConnectionStatus.connecting;
          } else {
            _connectionStatus = ConnectionStatus.disconnected;
          }
        }
        if (previousConnectionStatus != _connectionStatus) {
          _connectionChangeController.add(_connectionStatus);
        }
      },
    );
  }
}
