import 'package:myapp/features/everyday/domain/entities/today.dart';

class BackupProgress {
  BackupProgress({
    this.isBackingUp = true,
    required this.uploaded,
    required this.total,
    this.justUploadedToday,
    // this.currentlyUploadingToday,
  });

  final bool isBackingUp;
  final int uploaded;
  final int total;
  final Today? justUploadedToday;
  // final Today? currentlyUploadingToday;

  BackupProgress.isNotUploading()
      : isBackingUp = false,
        uploaded = 0,
        total = 0,
        justUploadedToday = null;

  double get progress => uploaded / total;

  int get left => total - uploaded;
}
