import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/connection_checker/data/repository/connection_repository.dart';
import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';
import 'package:myapp/core/connection_checker/domain/usecases/get_connection_status.dart';
import 'package:myapp/core/connection_checker/domain/usecases/get_connection_status_stream.dart';
import 'package:myapp/service_locator.dart';

class ConnectionNotifier extends StateNotifier<ConnectionStatus> {
  ConnectionNotifier(
      this._getConnectionStatusStreamUseCase, this._getConnectionStatusUseCase)
      : super(ConnectionStatus.disconnected) {
    state = _getConnectionStatusUseCase();
    _getConnectionStatusStreamUseCase().listen((status) {
      state = status;
    });
  }

  final GetConnectionStatusStreamUseCase _getConnectionStatusStreamUseCase;
  final GetConnectionStatusUseCase _getConnectionStatusUseCase;
}

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, ConnectionStatus>((ref) =>
        ConnectionNotifier(
            GetConnectionStatusStreamUseCase(getIt<ConnectionRepositoryImpl>()),
            GetConnectionStatusUseCase(getIt<ConnectionRepositoryImpl>())));
