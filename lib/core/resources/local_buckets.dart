import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalBuckets {
  static const thumbnails = 'thumbnails';
  static const videos = 'videos';
}

class FilePathManager {
  static const String _videoFolder = 'videos';
  static const String _thumbnailFolder = 'thumbnails';

  static final FilePathManager _instance = FilePathManager._internal();
  FilePathManager._internal();
  factory FilePathManager() => _instance;

  Future<Directory> get _appDirectory async =>
      await getApplicationDocumentsDirectory();

  Future<String> getVideoPath(String videoId) async {
    final directory = await _appDirectory;
    return '${directory.path}/$_videoFolder/$videoId.mp4';
  }

  Future<String> getThumbnailPath(String thumbnailId) async {
    final directory = await _appDirectory;
    return '${directory.path}/$_thumbnailFolder/$thumbnailId.jpg';
  }

  Future<File> createFile(String path) async {
    return await File(path).create(recursive: true);
  }
}
