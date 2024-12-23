import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myapp/core/connection_checker/data/repository/connection_repository.dart';
import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';
import 'package:myapp/features/auth/data/repository/auth_repository.dart';
import 'package:myapp/features/everyday/data/data_sources/local/today_local_data_source.dart';
import 'package:myapp/features/everyday/data/repository/today_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final initialConnectionStatus =
      await InternetConnectionChecker.instance.hasConnection
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected;

  getIt.registerLazySingleton<ConnectionRepositoryImpl>(
    () => ConnectionRepositoryImpl(
      Connectivity(),
      InternetConnectionChecker.instance,
      initialConnectionStatus,
    ),
  );

  getIt.registerSingleton<TodayLocalDataSource>(TodayLocalDataSource());
  getIt.registerSingleton<TodayRepositoryImpl>(TodayRepositoryImpl(
      getIt(), FirebaseFirestore.instance, FirebaseStorage.instance));

  getIt.registerSingleton<AuthRepositoryImpl>(
      AuthRepositoryImpl(FirebaseAuth.instance));
}
