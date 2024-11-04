import 'package:equatable/equatable.dart';
import 'package:myapp/everyday/data/models/today_model.dart';

class Today extends Equatable {
  const Today({
    required this.id,
    required this.caption,
    this.localVideoPath,
    this.remoteVideoUrl,
    required this.date,
    this.localThumbnailPath,
    this.remoteThumbnailUrl,
  });

  final String id;
  final String caption;
  final String? localVideoPath;
  final String? remoteVideoUrl;
  final DateTime date;
  final String? localThumbnailPath;
  final String? remoteThumbnailUrl;

  Today.fromModel(TodayModel todayModel)
      : this(
          id: todayModel.id,
          caption: todayModel.caption,
          localVideoPath: todayModel.localVideoPath,
          remoteVideoUrl: todayModel.remoteVideoUrl,
          date: todayModel.date,
          localThumbnailPath: todayModel.localThumbnailPath,
          remoteThumbnailUrl: todayModel.remoteThumbnailUrl,
        );

  bool get isAvailableLocal => localVideoPath != null;
  bool get isBackedUp => remoteVideoUrl != null;

  Today copyWith({
    String? id,
    String? caption,
    String? localVideoPath,
    String? remoteVideoUrl,
    DateTime? date,
    String? localThumbnailPath,
    String? remoteThumbnailUrl,
  }) {
    return Today(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      localVideoPath: localVideoPath ?? this.localVideoPath,
      remoteVideoUrl: remoteVideoUrl ?? this.remoteVideoUrl,
      date: date ?? this.date,
      localThumbnailPath: localThumbnailPath ?? this.localThumbnailPath,
      remoteThumbnailUrl: remoteThumbnailUrl ?? this.remoteThumbnailUrl,
    );
  }

  @override
  List<Object?> get props => [id];
}
