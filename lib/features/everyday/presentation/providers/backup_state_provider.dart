import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/everyday/domain/entities/backup_progress.dart';

class BackupStateNotifier extends StateNotifier<BackupProgress> {
  BackupStateNotifier() : super(const BackupNotInProgress());

  void updateBackupProgress(BackupProgress backupProgress) {
    if (backupProgress is BackupInProgress && backupProgress.progress == 1) {
      state = const BackupNotInProgress();
      return;
    }
    state = backupProgress;
  }
}

final backupProgressStateProvider =
    StateNotifierProvider<BackupStateNotifier, BackupProgress>(
        (ref) => BackupStateNotifier());
