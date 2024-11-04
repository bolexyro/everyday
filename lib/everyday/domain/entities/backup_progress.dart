import 'package:myapp/everyday/domain/entities/today.dart';

class BackupProgress {
  BackupProgress({
    this.isBackingUp = true,
    required this.uploaded,
    required this.total,
    this.justUploadedToday,
  });
  final bool isBackingUp;
  final int uploaded;
  final int total;
  final Today? justUploadedToday;

  BackupProgress.isNotUploading()
      : isBackingUp = false,
        uploaded = 0,
        total = 0,
        justUploadedToday = null;

  double get progress => uploaded / total;

  int get left => total - uploaded;
}
