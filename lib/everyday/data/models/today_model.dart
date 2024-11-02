import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/core/converter/uint8_list_converter.dart';
part 'today_model.g.dart';

@JsonSerializable()
class TodayModel {
  const TodayModel({
    required this.id,
    required this.caption,
    required this.videoPath,
    required this.date,
    required this.thumbnail,
    required this.email,
  });

  final String id;
  final String caption;
  final String videoPath;
  final DateTime date;
  @Uint8ListConverter()
  final Uint8List thumbnail;
  final String email;

  factory TodayModel.fromJson(Map<String, dynamic> json) =>
      _$TodayModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodayModelToJson(this);
}
