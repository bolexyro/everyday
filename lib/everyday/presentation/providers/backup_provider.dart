import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/everyday/domain/entities/backup_progress.dart';

class BackupNotifier extends StateNotifier<BackupProgress> {
  BackupNotifier() : super(BackupProgress.isNotUploading());
  void updateBackupProgress(BackupProgress progress) {
    print(progress.progress);
    if (progress.progress == 1) {
      state = BackupProgress.isNotUploading();
      return;
    }
    state = progress;
  }
}

final backupStateProvider =
    StateNotifierProvider<BackupNotifier, BackupProgress>(
        (ref) => BackupNotifier());
