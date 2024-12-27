import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/core/resources/local_buckets.dart';
import 'package:myapp/features/everyday/data/data_sources/local/today_local_data_source.dart';
import 'package:myapp/features/everyday/data/models/today_model.dart';
import 'package:myapp/features/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class TodayRepositoryImpl implements TodayRepository {
  TodayRepositoryImpl(this.localDataSource, this.remoteDb, this.remoteStorage);
  final TodayLocalDataSource localDataSource;
  final FirebaseFirestore remoteDb;
  final FirebaseStorage remoteStorage;

  final _backupProgressController = StreamController<BackupProgress>();

  @override
  Future<DataState<Today>> addToday(
      String videoPath, String caption, String currentUserEmail) async {
    try {
      final savedTodayModel =
          await localDataSource.insert(videoPath, caption, currentUserEmail);
      return DataSuccess(Today.fromModel(savedTodayModel));
    } catch (e) {
      return DataException(e.toString());
    }
  }

  @override
  Future<void> deleteToday(String id, String videoPath, bool onlyLocal) async {
    if (onlyLocal) {
      await localDataSource.delete(id, videoPath);
    }
  }

  @override
  Future<DataState<List<Today>>> readTodays(
      currentUserEmail, bool isConnected) async {
    try {
      final allLocallyAvilableTodayModels =
          await localDataSource.readAll(currentUserEmail);

      final allLocallyAvilableTodayEntities = allLocallyAvilableTodayModels
          .map((todayModel) => Today.fromModel(todayModel))
          .toList();

      if (!isConnected) {
        allLocallyAvilableTodayEntities
            .sort((a, b) => b.date.compareTo(a.date));

        return DataSuccessWithException(allLocallyAvilableTodayEntities,
            'Check your internet connection and refresh');
      }
      final List<Today> allCloudStoredTodays = [];
      final querySnapshot = await remoteDb
          .collection("everyday")
          .where("email", isEqualTo: currentUserEmail)
          .get(const GetOptions(source: Source.server));
      for (final docSnapshot in querySnapshot.docs) {
        allCloudStoredTodays
            .add(Today.fromModel(TodayModel.fromJson(docSnapshot.data())));
      }

      final List<Today> allTodays = [...allLocallyAvilableTodayEntities];

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

      allTodays.sort((a, b) => b.date.compareTo(a.date));

      return DataSuccess(allTodays);
    } catch (e) {
      return const DataSuccessWithException(
          [], 'An unexpected error occurred. Close and open the app.');
    }
  }

  @override
  Future<void> updateEmailForPreviousRows(email) async {
    await localDataSource.updateEmailForPreviousRows(email);
  }

  @override
  Stream<BackupProgress> get backupProgressStream =>
      _backupProgressController.stream;

  @override
  Future<void> backupTodays(todays, currentUserEmail) async {
    int total = todays.length;
    int completed = 0;

    for (final today in todays) {
      final storageRef = remoteStorage.ref();
      final todayThumbnailRef = storageRef
          .child(MediaStorageHelper().getThumbnailStorageRefPath(today.id));

      final todayVideoRef = storageRef
          .child(MediaStorageHelper().getVideoStorageRefPath(today.id));

      _backupProgressController.add(BackupInProgress(
        uploadedCount: completed,
        total: total,
        currentlyUploadingToday: today,
      ));
      final thumbnailUploadTask =
          todayThumbnailRef.putFile(File(today.localThumbnailPath!));
      final videoUploadTask =
          todayVideoRef.putFile(File(today.localVideoPath!));

      await thumbnailUploadTask;
      await videoUploadTask;

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
        BackupInProgress(
          uploadedCount: completed,
          total: total,
          justUploadedToday: Today.fromModel(todayModel),
        ),
      );
    }
  }

  @override
  Future<bool> getBackupStatus(currentUserEmail) async {
    return await localDataSource.getBackupStatus(currentUserEmail);
  }

  @override
  Future<void> saveBackupStatus(status, currentUserEmail) async {
    await localDataSource.saveBackupStatus(status, currentUserEmail);
  }

  @override
  Future<void> downloadTodays() {
    // TODO: implement downloadTodays
    throw UnimplementedError();
  }

  @override
  Future<DataState> updateToday(Today today, String currentUserEmail) async {
    try {
      await localDataSource.update(TodayModel(
        id: today.id,
        caption: today.caption,
        localVideoPath: today.localVideoPath,
        remoteVideoUrl: today.remoteVideoUrl,
        date: today.date,
        localThumbnailPath: today.localThumbnailPath,
        remoteThumbnailUrl: today.remoteThumbnailUrl,
        email: currentUserEmail,
      ));
      return const DataSuccess('');
    } catch (e) {
      return const DataException('An unknown error occurred');
    }
  }
}
