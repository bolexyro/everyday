import 'package:json_annotation/json_annotation.dart';
part 'today_model.g.dart';

@JsonSerializable()
class TodayModel {
  const TodayModel({
    required this.id,
    required this.caption,
    this.localVideoPath,
    this.remoteVideoUrl,
    required this.date,
    this.localThumbnailPath,
    this.remoteThumbnailUrl,
    required this.email,
  });

  final String id;
  final String caption;
  final String? localVideoPath;
  final String? remoteVideoUrl;
  final DateTime date;
  final String? localThumbnailPath;
  final String? remoteThumbnailUrl;
  final String email;

  factory TodayModel.fromJson(Map<String, dynamic> json) =>
      _$TodayModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodayModelToJson(this);

  TodayModel copyWith({
    String? id,
    String? caption,
    String? localVideoPath,
    String? remoteVideoUrl,
    DateTime? date,
    String? localThumbnailPath,
    String? remoteThumbnailUrl,
    String? email,
  }) {
    return TodayModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      localVideoPath: localVideoPath ?? this.localVideoPath,
      remoteVideoUrl: remoteVideoUrl ?? this.remoteVideoUrl,
      date: date ?? this.date,
      localThumbnailPath: localThumbnailPath ?? this.localThumbnailPath,
      remoteThumbnailUrl: remoteThumbnailUrl ?? this.remoteThumbnailUrl,
      email: email ?? this.email,
    );
  }
}
