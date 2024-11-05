import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth/data/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/everyday/data/data_sources/local/today_local_data_source.dart';
import 'package:myapp/everyday/data/repository/today_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/use_cases/add_today.dart';
import 'package:myapp/everyday/domain/use_cases/backup_todays.dart';
import 'package:myapp/everyday/domain/use_cases/delete_today.dart';
import 'package:myapp/everyday/domain/use_cases/get_backup_progress.dart';
import 'package:myapp/everyday/domain/use_cases/read_todays.dart';
import 'package:myapp/everyday/domain/use_cases/update_emails_previous_rows.dart';
import 'package:myapp/everyday/presentation/providers/backup_progress_provider.dart';

class TodayNotifier extends StateNotifier<List<Today>> {
  TodayNotifier(
    this.ref,
    this._addTodayUseCase,
    this._readTodaysUseCase,
    this._deleteTodayUseCase,
    this._updateEmailsPreviousRowsUseCase,
    this._backupTodaysUseCase,
    this._backupProgressUseCase,
  ) : super([]) {
    _backupProgressUseCase().listen((progress) {
      if (progress.justUploadedToday != null) {
        final stateWithoutAToday = state
            .where((today) => today != progress.justUploadedToday!)
            .toList();
        state = [...stateWithoutAToday, progress.justUploadedToday!];
      }
      ref
          .read(backupProgressStateProvider.notifier)
          .updateBackupProgress(progress);
    });
  }

  final Ref ref;
  final AddTodayUseCase _addTodayUseCase;
  final ReadTodaysUseCase _readTodaysUseCase;
  final DeleteTodayUseCase _deleteTodayUseCase;
  final UpdateEmailsPreviousRowsUseCase _updateEmailsPreviousRowsUseCase;

  final BackupTodaysUseCase _backupTodaysUseCase;
  final GetBackupProgressUseCase _backupProgressUseCase;

  List<Today> get unBackedupTodays =>
      state.where((today) => today.isBackedUp == false).toList();

  Future<DataState> addToday(String videoPath, String caption) async {
    final dataState = await _addTodayUseCase.call(videoPath, caption);
    if (dataState is DataSuccess) {
      state = [dataState.data!, ...state];
    }
    return dataState;
  }

  Future<DataState<List<Today>>> getTodays() async {
    await _updateEmailsPreviousRowsUseCase.call();
    final dataState = await _readTodaysUseCase.call();
    if (dataState is DataSuccess<List<Today>> ||
        dataState is DataSuccessWithException<List<Today>>) {
      state = dataState.data!;
    } else {
      state = [];
    }

    return dataState;
  }

  Future<void> deleteToday(Today today) async {
    await _deleteTodayUseCase.call(today.id, today.localVideoPath!);
    state = state.where((eachToday) => eachToday != today).toList();
  }

  Future<void> backupTodays() async {
    if (unBackedupTodays.isEmpty) {
      return;
    }
    await _backupTodaysUseCase.call(unBackedupTodays);
  }
}

final todayRepoImpl = TodayRepositoryImpl(
  TodayLocalDataSource(),
  FirebaseFirestore.instance,
  FirebaseStorage.instance,
);
final todayProvider = StateNotifierProvider<TodayNotifier, List<Today>>(
  (ref) => TodayNotifier(
    ref,
    AddTodayUseCase(
      todayRepoImpl,
      AuthRepositoryImpl(FirebaseAuth.instance),
    ),
    ReadTodaysUseCase(
      todayRepoImpl,
      AuthRepositoryImpl(FirebaseAuth.instance),
    ),
    DeleteTodayUseCase(todayRepoImpl),
    UpdateEmailsPreviousRowsUseCase(
      AuthRepositoryImpl(FirebaseAuth.instance),
      todayRepoImpl,
    ),
    BackupTodaysUseCase(
      todayRepoImpl,
      AuthRepositoryImpl(FirebaseAuth.instance),
    ),
    GetBackupProgressUseCase(todayRepoImpl),
  ),
);
