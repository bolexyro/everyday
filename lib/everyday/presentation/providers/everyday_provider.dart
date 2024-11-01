import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/everyday/data/data_sources/everyday_local_data_source.dart';
import 'package:myapp/everyday/data/repository/everyday_repository.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/use_cases/add_today.dart';
import 'package:myapp/everyday/domain/use_cases/delete_today.dart';
import 'package:myapp/everyday/domain/use_cases/read_everyday.dart';

class EverydayNotifier extends StateNotifier<List<Today>> {
  EverydayNotifier(
    this._addTodayUseCase,
    this._readEverydayUseCase,
    this._deleteTodayUseCase,
  ) : super([]);
  final AddTodayUseCase _addTodayUseCase;
  final ReadEverydayUseCase _readEverydayUseCase;
  final DeleteTodayUseCase _deleteTodayUseCase;

  Future<void> addToday(String videoPath, String caption) async {
    final today = await _addTodayUseCase.call(videoPath, caption);
    state = [...state, today];
  }

  Future<void> getEveryday() async {
    state = await _readEverydayUseCase.call();
  }

  Future<void> deleteToday(Today today) async {
    await _deleteTodayUseCase.call(today.id, today.videoPath);
    state = state.where((eachToday) => eachToday != today).toList();
  }
}

final everydayProvider = StateNotifierProvider<EverydayNotifier, List<Today>>(
    (ref) => EverydayNotifier(
          AddTodayUseCase(EverydayRepositoryImpl(EverydayLocalDataSource())),
          ReadEverydayUseCase(
              EverydayRepositoryImpl(EverydayLocalDataSource())),
          DeleteTodayUseCase(EverydayRepositoryImpl(EverydayLocalDataSource())),
        ));
