import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:myapp/everyday/data/models/today_model.dart';

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
  final Uint8List thumbnail;

  Today.fromModel(TodayModel todayModel)
      : this(
          id: todayModel.id,
          caption: todayModel.caption,
          videoPath: todayModel.videoPath,
          date: todayModel.date,
          thumbnail: todayModel.thumbnail,
        );

  @override
  List<Object?> get props => [id];
}
