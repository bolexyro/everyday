import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/everyday/domain/entities/backup_progress.dart';

class BackupProgressNotifier extends StateNotifier<BackupProgress> {
  BackupProgressNotifier() : super(BackupProgress.isNotUploading());
  void updateBackupProgress(BackupProgress progress) {
    if (progress.progress == 1) {
      state = BackupProgress.isNotUploading();
      return;
    }
    state = progress;
  }
}

final backupProgressStateProvider =
    StateNotifierProvider<BackupProgressNotifier, BackupProgress>(
        (ref) => BackupProgressNotifier());
