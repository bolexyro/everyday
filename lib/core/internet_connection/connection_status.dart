import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusHelper {
  static final _singleton = ConnectionStatusHelper._internal();

  ConnectionStatusHelper._internal();

  static ConnectionStatusHelper getInstance() => _singleton;
  bool hasInternetConnection = false;

  final StreamController<bool> _connectionChangeController =
      StreamController.broadcast();

  Stream get connectionChange => _connectionChangeController.stream;

  final Connectivity _connectivity = Connectivity();

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged
        .listen((result) => checkInternetConnection());
    await checkInternetConnection();
  }

  Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> checkInternetConnection() async {
    bool previousInternetConnection = hasInternetConnection;
    hasInternetConnection = await isConnectedToInternet();

    if (previousInternetConnection != hasInternetConnection) {
      _connectionChangeController.add(hasInternetConnection);
    }

    return hasInternetConnection;
  }

  void dispose() {
    _connectionChangeController.close();
  }
}
