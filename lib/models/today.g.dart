// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Today _$TodayFromJson(Map<String, dynamic> json) => Today(
      id: json['id'] as String,
      caption: json['caption'] as String,
      videoPath: json['videoPath'] as String,
      date: DateTime.parse(json['date'] as String),
      thumbnail:
          const Uint8ListConverter().fromJson(json['thumbnail'] as List<int>),
    );

Map<String, dynamic> _$TodayToJson(Today instance) => <String, dynamic>{
      'id': instance.id,
      'caption': instance.caption,
      'videoPath': instance.videoPath,
      'date': instance.date.toIso8601String(),
      'thumbnail': const Uint8ListConverter().toJson(instance.thumbnail),
    };
