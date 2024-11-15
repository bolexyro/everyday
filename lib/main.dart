import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:myapp/core/internet_connection/connection_status.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final connectionStatus = ConnectionStatusHelper.getInstance();
  await connectionStatus.initialize();
  connectionStatus.connectionChange.listen(
    (event) => print('has internet $event'),
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
