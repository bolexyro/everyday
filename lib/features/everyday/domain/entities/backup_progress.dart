import 'package:myapp/features/everyday/domain/entities/today.dart';

abstract class BackupProgress {
  const BackupProgress();
}

class BackupInProgress extends BackupProgress {
  const BackupInProgress({
    required this.uploadedCount,
    required this.total,
    this.justUploadedToday,
    this.currentlyUploadingToday,
  });

  final int uploadedCount;
  final int total;
  final Today? justUploadedToday;
  final Today? currentlyUploadingToday;

  double get progress => uploadedCount / total;
  int get left => total - uploadedCount;
}

class BackupNotInProgress extends BackupProgress {
  const BackupNotInProgress();
}

class BackupPausedDueToNoInternet extends BackupProgress {
  const BackupPausedDueToNoInternet({
    required this.currentlyUploadingToday,
  });
  final Today? currentlyUploadingToday;
}
