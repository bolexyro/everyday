import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/connection_checker/presentation/providers/connection_provider.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/auth/data/repository/auth_repository.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/data/repository/today_repository.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/domain/use_cases/add_today.dart';
import 'package:myapp/features/everyday/domain/use_cases/backup_todays.dart';
import 'package:myapp/features/everyday/domain/use_cases/delete_today.dart';
import 'package:myapp/features/everyday/domain/use_cases/get_backup_progress.dart';
import 'package:myapp/features/everyday/domain/use_cases/read_todays.dart';
import 'package:myapp/features/everyday/domain/use_cases/update_emails_previous_rows.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_progress_provider.dart';
import 'package:myapp/service_locator.dart';

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
        final stateWithoutJustUploadedToday = state
            .where((today) => today != progress.justUploadedToday!)
            .toList();
        state = [...stateWithoutJustUploadedToday, progress.justUploadedToday!];
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
    final dataState =
        await _readTodaysUseCase.call(ref.read(connectionProvider).isConnected);
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

final todayProvider = StateNotifierProvider<TodayNotifier, List<Today>>(
  (ref) => TodayNotifier(
    ref,
    AddTodayUseCase(
      getIt<TodayRepositoryImpl>(),
      getIt<AuthRepositoryImpl>(),
    ),
    ReadTodaysUseCase(
      getIt<TodayRepositoryImpl>(),
      getIt<AuthRepositoryImpl>(),
    ),
    DeleteTodayUseCase(
      getIt<TodayRepositoryImpl>(),
    ),
    UpdateEmailsPreviousRowsUseCase(
      getIt<AuthRepositoryImpl>(),
      getIt<TodayRepositoryImpl>(),
    ),
    BackupTodaysUseCase(
      getIt<TodayRepositoryImpl>(),
      getIt<AuthRepositoryImpl>(),
    ),
    GetBackupProgressUseCase(
      getIt<TodayRepositoryImpl>(),
    ),
  ),
);
