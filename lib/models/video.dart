import 'dart:typed_data';

class Video {
  Video({
    required this.title,
    required this.path,
    required this.time,
    required this.thumbnail,
  });
  final String title;
  final String path;
  final Uint8List thumbnail;
  final DateTime time;
}
