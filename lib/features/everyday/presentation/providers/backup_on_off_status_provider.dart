import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/features/everyday/domain/use_cases/get_backup_status.dart';
import 'package:myapp/features/everyday/domain/use_cases/save_backup_status.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

class BackupOnOffStatus {
  const BackupOnOffStatus({
    required this.isLoading,
    required this.isOn,
  });
  final bool isLoading;
  final bool isOn;
}

class BackupOnOffStatusNotifier extends StateNotifier<BackupOnOffStatus> {
  BackupOnOffStatusNotifier(
    this._backupStatusUseCase,
    this._saveBackupStatusUseCase,
  ) : super(const BackupOnOffStatus(isLoading: false, isOn: false));
  final GetBackupStatusUseCase _backupStatusUseCase;
  final SaveBackupStatusUseCase _saveBackupStatusUseCase;

  Future<void> getBackupStatus() async {
    state = const BackupOnOffStatus(isLoading: true, isOn: false);
    state = BackupOnOffStatus(
        isLoading: false, isOn: await _backupStatusUseCase.call());
  }

  Future<void> saveBackupStatus(bool status) async {
    // state = BackupOnOffStatus(isLoading: true, isOn: status);
    await _saveBackupStatusUseCase.call(status);
    state = BackupOnOffStatus(isLoading: false, isOn: status);
  }
}

final backupOnOffStatusStateProvider =
    StateNotifierProvider<BackupOnOffStatusNotifier, BackupOnOffStatus>(
        (ref) => BackupOnOffStatusNotifier(
              GetBackupStatusUseCase(todayRepoImpl, authRepo),
              SaveBackupStatusUseCase(todayRepoImpl, authRepo),
            ));
