import 'package:json_annotation/json_annotation.dart';
part 'streak_model.g.dart';

@JsonSerializable()
class StreakModel {
  StreakModel({
    required this.email,
    required this.date,
  });

  final String email;
  final DateTime date;

  factory StreakModel.fromJson(Map<String, dynamic> json) =>
      _$StreakModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreakModelToJson(this);
}
