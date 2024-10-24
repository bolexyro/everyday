import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'today.g.dart';

@JsonSerializable()
class Today extends Equatable {
  const Today({
    required this.id,
    required this.caption,
    required this.videoPath,
    required this.date,
    required this.thumbnail,
  });

  final String id;
  final String caption;
  final String videoPath;
  final DateTime date;
  // @Uint8ListConverter()
  final Uint8List thumbnail;

  @override
  List<Object?> get props => [id];

  factory Today.fromJson(Map<String, dynamic> json) => _$TodayFromJson(json);

  // toJson method
  Map<String, dynamic> toJson() => _$TodayToJson(this);
}

/// Converts to and from [Uint8List] and [List]<[int]>.
class Uint8ListConverter implements JsonConverter<Uint8List, List<int>> {
  /// Create a new instance of [Uint8ListConverter].
  const Uint8ListConverter();

  @override
  Uint8List fromJson(List<int> json) {

    return Uint8List.fromList(json);
  }

  @override
  List<int> toJson(Uint8List object) {

    return object.toList();
  }
}
