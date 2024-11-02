import 'package:equatable/equatable.dart';
import 'package:myapp/everyday/data/models/today_model.dart';

class Today extends Equatable {
  const Today({
    required this.id,
    required this.caption,
    required this.videoPath,
    required this.date,
    required this.thumbnailPath,
  });

  final String id;
  final String caption;
  final String videoPath;
  final DateTime date;
  final String thumbnailPath;

  Today.fromModel(TodayModel todayModel)
      : this(
          id: todayModel.id,
          caption: todayModel.caption,
          videoPath: todayModel.videoPath,
          date: todayModel.date,
          thumbnailPath: todayModel.thumbnailPath,
        );

  @override
  List<Object?> get props => [id];
}
