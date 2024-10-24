import 'dart:typed_data';

class Today {
  Today({
    required this.caption,
    required this.videoPath,
    required this.date,
    required this.thumbnail,
  });
  final String caption;
  final String videoPath;
  final Uint8List thumbnail;
  final DateTime date;
}
