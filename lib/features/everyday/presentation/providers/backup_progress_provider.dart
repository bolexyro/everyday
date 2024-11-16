import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/everyday/domain/entities/backup_progress.dart';

class BackupProgressNotifier extends StateNotifier<BackupProgress> {
  BackupProgressNotifier() : super(BackupProgress.isNotUploading());

  void updateBackupProgress(BackupProgress backupProgress) {
    if (backupProgress.progress == 1) {
      state = BackupProgress.isNotUploading();
      return;
    }
    state = backupProgress;
  }
}

final backupProgressStateProvider =
    StateNotifierProvider<BackupProgressNotifier, BackupProgress>(
        (ref) => BackupProgressNotifier());
