import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MediaStorageHelper {
  static const String _videoFolder = 'videos';
  static const String _thumbnailFolder = 'thumbnails';

  static final MediaStorageHelper _instance = MediaStorageHelper._internal();
  MediaStorageHelper._internal();
  factory MediaStorageHelper() => _instance;

  Future<Directory> get _appDirectory async =>
      await getApplicationDocumentsDirectory();

  Future<String> getLocalVideoPath(String videoId) async {
    final directory = await _appDirectory;
    return '${directory.path}/$_videoFolder/$videoId.mp4';
  }

  Future<String> getLocalThumbnailPath(String thumbnailId) async {
    final directory = await _appDirectory;
    return '${directory.path}/$_thumbnailFolder/$thumbnailId.jpg';
  }

  String getVideoStorageRefPath(String videoId) {
    // videofolder here is the same as videoBucket
    return '$_videoFolder/$videoId.mp4';
  }

  String getThumbnailStorageRefPath(String thumbnailId) {
    return '$_thumbnailFolder/$thumbnailId.jpg';
  }

  Future<File> createFile(String path) async {
    return await File(path).create(recursive: true);
  }
}
