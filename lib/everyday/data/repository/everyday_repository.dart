import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/everyday/data/data_sources/local/everyday_local_data_source.dart';
import 'package:myapp/everyday/data/models/today_model.dart';
import 'package:myapp/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';
import 'package:path/path.dart' as path;

class EverydayRepositoryImpl implements EverydayRepository {
  EverydayRepositoryImpl(
      this.localDataSource, this.remoteDb, this.remoteStorage);
  final EverydayLocalDataSource localDataSource;
  final FirebaseFirestore remoteDb;
  final FirebaseStorage remoteStorage;

  final _backupProgressController = StreamController<BackupProgress>();

  @override
  Future<Today> addToday(
      String videoPath, String caption, String currentUserEmail) async {
    final savedTodayModel =
        await localDataSource.insert(videoPath, caption, currentUserEmail);
    return Today.fromModel(savedTodayModel);
  }

  @override
  Future<void> deleteToday(String id, String videoPath) async {
    throw UnimplementedError();
    // await localDataSource.delete(id, videoPath);
  }

  @override
  Future<List<Today>> readEveryday(currentUserEmail) async {
    final allLocallyAvilableTodayModels =
        await localDataSource.readAll(currentUserEmail);

    final allLocallyAvilableTodayEntities = allLocallyAvilableTodayModels
        .map((todayModel) => Today.fromModel(todayModel))
        .toList();
    final List<Today> allCloudStoredTodays = [];
    final querySnapshot = await remoteDb
        .collection("everyday")
        .where("email", isEqualTo: currentUserEmail)
        .get();
    for (final docSnapshot in querySnapshot.docs) {
      allCloudStoredTodays
          .add(Today.fromModel(TodayModel.fromJson(docSnapshot.data())));
    }

    final List<Today> allTodays = [];

    for (final cloudToday in allCloudStoredTodays) {
      // syncing is getting what is in cloud and making it available locally
      // so anything in cloud not in local should be collected
      if (!allLocallyAvilableTodayEntities.contains(cloudToday)) {
        allTodays.add(cloudToday);
        await localDataSource.insert(
          '',
          '',
          '',
          todayParam: TodayModel(
            id: cloudToday.id,
            caption: cloudToday.caption,
            date: cloudToday.date,
            email: currentUserEmail,
            remoteThumbnailUrl: cloudToday.remoteThumbnailUrl,
            remoteVideoUrl: cloudToday.remoteVideoUrl,
          ),
        );
      }
    }

    allTodays.sort((a, b) => a.date.compareTo(b.date));

    return allLocallyAvilableTodayEntities..addAll(allTodays);
  }

  @override
  Future<void> updateEmailForPreviousRows(email) async {
    await localDataSource.updateEmailForPreviousRows(email);
  }

  @override
  Stream<BackupProgress> get backupProgressStream =>
      _backupProgressController.stream;

  @override
  Future<void> backupEveryday(everyday, currentUserEmail) async {
    int total = everyday.length;
    int completed = 0;
    _backupProgressController.add(BackupProgress(uploaded: 0, total: total));

    for (final today in everyday) {
      final storageRef = remoteStorage.ref();
      final thumbnailsRef = storageRef.child('thumbnails');
      final thumbnailExtension = path.extension(today.localThumbnailPath!);
      final todayThumbnailRef =
          thumbnailsRef.child("${today.id}$thumbnailExtension");

      final videosRef = storageRef.child('vidoes');
      final videoExtension = path.extension(today.localVideoPath!);
      final todayVideoRef = videosRef.child('${today.id}$videoExtension');

      await todayThumbnailRef.putFile(File(today.localThumbnailPath!));
      await todayVideoRef.putFile(File(today.localVideoPath!));

      final remoteThumbnailUrl = await todayThumbnailRef.getDownloadURL();
      final remoteVideoUrl = await todayVideoRef.getDownloadURL();

      final todayModel = TodayModel(
        id: today.id,
        caption: today.caption,
        date: today.date,
        email: currentUserEmail,
        remoteThumbnailUrl: remoteThumbnailUrl,
        remoteVideoUrl: remoteVideoUrl,
      );
      await remoteDb.collection("everyday").doc(today.id).set(
            todayModel.toJson(),
          );
      await localDataSource.update(todayModel.copyWith(
        localThumbnailPath: today.localThumbnailPath,
        remoteThumbnailUrl: remoteThumbnailUrl,
        localVideoPath: today.localVideoPath,
        remoteVideoUrl: remoteVideoUrl,
      ));
      completed++;
      _backupProgressController.add(
        BackupProgress(
          uploaded: completed,
          total: total,
          justUploadedToday: Today.fromModel(todayModel),
        ),
      );
    }
  }

  @override
  Future<bool> getBackupStatus() async {
    return await localDataSource.getBackupStatus();
  }

  @override
  Future<void> saveBackupStatus(bool status) async {
    await localDataSource.saveBackupStatus(status);
  }
}
