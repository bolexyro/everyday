import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth/data/repository/auth_repository.dart';
import 'package:myapp/everyday/data/data_sources/local/everyday_local_data_source.dart';
import 'package:myapp/everyday/data/repository/everyday_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/use_cases/add_today.dart';
import 'package:myapp/everyday/domain/use_cases/backup_everyday.dart';
import 'package:myapp/everyday/domain/use_cases/delete_today.dart';
import 'package:myapp/everyday/domain/use_cases/get_backup_progress.dart';
import 'package:myapp/everyday/domain/use_cases/read_everyday.dart';
import 'package:myapp/everyday/domain/use_cases/update_emails_previous_rows.dart';
import 'package:myapp/everyday/presentation/providers/backup_progress_provider.dart';

class EverydayNotifier extends StateNotifier<List<Today>> {
  EverydayNotifier(
    this.ref,
    this._addTodayUseCase,
    this._readEverydayUseCase,
    this._deleteTodayUseCase,
    this._updateEmailsPreviousRowsUseCase,
    this._backupEverydayUseCase,
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
  final ReadEverydayUseCase _readEverydayUseCase;
  final DeleteTodayUseCase _deleteTodayUseCase;
  final UpdateEmailsPreviousRowsUseCase _updateEmailsPreviousRowsUseCase;

  final BackupEverydayUseCase _backupEverydayUseCase;
  final GetBackupProgressUseCase _backupProgressUseCase;

  List<Today> get unBackedupTodays =>
      state.where((today) => today.isBackedUp == false).toList();

  Future<void> addToday(String videoPath, String caption) async {
    final today = await _addTodayUseCase.call(videoPath, caption);
    state = [...state, today];
  }

  Future<void> getEveryday() async {
    await _updateEmailsPreviousRowsUseCase.call();
    state = await _readEverydayUseCase.call();
  }

  Future<void> deleteToday(Today today) async {
    await _deleteTodayUseCase.call(today.id, today.localVideoPath!);
    state = state.where((eachToday) => eachToday != today).toList();
  }

  Future<void> backupEveryday() async {
    if (unBackedupTodays.isEmpty) {
      return;
    }
    await _backupEverydayUseCase
        .call(unBackedupTodays);
  }
}

final everydayRepoImpl = EverydayRepositoryImpl(
  EverydayLocalDataSource(),
  FirebaseFirestore.instance,
  FirebaseStorage.instance,
);
final everydayProvider = StateNotifierProvider<EverydayNotifier, List<Today>>(
  (ref) => EverydayNotifier(
    ref,
    AddTodayUseCase(
      everydayRepoImpl,
      AuthRepositoryImpl(FirebaseAuth.instance),
    ),
    ReadEverydayUseCase(
      everydayRepoImpl,
      AuthRepositoryImpl(FirebaseAuth.instance),
    ),
    DeleteTodayUseCase(everydayRepoImpl),
    UpdateEmailsPreviousRowsUseCase(
      AuthRepositoryImpl(FirebaseAuth.instance),
      everydayRepoImpl,
    ),
    BackupEverydayUseCase(
      everydayRepoImpl,
      AuthRepositoryImpl(FirebaseAuth.instance),
    ),
    GetBackupProgressUseCase(everydayRepoImpl),
  ),
);
