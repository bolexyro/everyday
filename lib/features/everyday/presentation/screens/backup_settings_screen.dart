import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/app_scaffold.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/features/everyday/presentation/components/backup_fours.dart';
import 'package:myapp/features/everyday/presentation/components/backup_indicator_icon.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_on_off_status_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_state_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupOnOffStatus = ref.watch(backupOnOffStatusStateProvider);
    final changingTextStyle = context.textTheme.bodyMedium
        ?.copyWith(color: backupOnOffStatus.isOn ? null : Colors.grey);

    return AppScaffold(
      appBar: AppBar(),
      // i don't think it would ever be loading because you can't get here befoe
      // status is loaded, and while you're here and you change the status, I didn't
      // emit a loading state
      body: backupOnOffStatus.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  Text(
                    'Backup is ${backupOnOffStatus.isOn ? 'on' : 'off'}',
                    style: context.textTheme.headlineMedium,
                  ),
                  const Gap(16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                        'Backup your todays from this device to your everyday account'),
                    titleTextStyle: context.textTheme.bodyMedium,
                    trailing: Switch(
                      value: backupOnOffStatus.isOn,
                      onChanged: (val) => ref
                          .read(backupOnOffStatusStateProvider.notifier)
                          .saveBackupStatus(val),
                    ),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Text(
                        'Backup account',
                        style: changingTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        ref.read(authProvider).user!.email,
                        style: changingTextStyle,
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Text(
                        'Quality',
                        style: changingTextStyle,
                      ),
                      const Spacer(),
                      Text(
                        'Original',
                        style: changingTextStyle,
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  const BackupListTile(),
                  const Gap(16),
                  if (ref.watch(backupProgressStateProvider)
                          is BackupInProgress ||
                      ref.watch(backupProgressStateProvider)
                          is BackupPausedDueToNoInternet)
                    const BackupFours()
                ],
              ),
            ),
    );
  }
}

class BackupListTile extends ConsumerStatefulWidget {
  const BackupListTile({super.key});

  @override
  ConsumerState<BackupListTile> createState() => _BackupListTileState();
}

class _BackupListTileState extends ConsumerState<BackupListTile> {
  late final bool _autoRetryBackupIsOn =
      ref.read(todayProvider.notifier).isAutoRetryBackupOn;

  @override
  Widget build(BuildContext context) {
    final noTodaysNotBackedUp = ref
        .watch(todayProvider)
        .where((today) => today.isBackedUp == false)
        .length;
    final backupOnOffStatus = ref.watch(backupOnOffStatusStateProvider);
    final backupProgressState = ref.watch(backupProgressStateProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: backupProgressState is BackupInProgress
          ? CircularPercentIndicator(
              radius: 12.0,
              lineWidth: 2.0,
              percent: backupProgressState.progress,
              center: const BackupIndicatorIcon(),
              progressColor: AppColors.neonGreen,
            )
          : backupOnOffStatus.isOn
              ? const Icon(Icons.backup_outlined)
              : const Icon(
                  Icons.error,
                  color: AppColors.error,
                ),
      title: Text(backupProgressState is BackupInProgress
          ? 'Backing up · ${(ref.watch(backupProgressStateProvider) as BackupInProgress).left} today left'
          : 'Backup is ${backupOnOffStatus.isOn ? 'on' : 'off'}'),
      subtitle: backupProgressState is BackupInProgress
          ? null
          : noTodaysNotBackedUp == 0
              ? const Text('Nothing to back up')
              : Text('$noTodaysNotBackedUp todays not backed up'),
      trailing: backupOnOffStatus.isOn &&
              backupProgressState is! BackupInProgress &&
              noTodaysNotBackedUp > 0
          ? TextButton(
              onPressed: () => ref.read(todayProvider.notifier).backupTodays(),

              // onPressed: _autoRetryBackupIsOn
              //     ? () {
              //         context.scaffoldMessenger.showSnackBar(
              //           appSnackbar(
              //             text:
              //                 'Are you sure you want to turn off auto retry backup?',
              //             action: SnackBarAction(
              //               label: 'Turn off',
              //               onPressed: () {
              //                 setState(() {
              //                   _autoRetryBackupIsOn = false;
              //                 });
              //                 ref.read(todayProvider.notifier).autoRetryBackup =
              //                     false;
              //               },
              //             ),
              //           ),
              //         );
              //       }
              //     : () {
              //         if (ref.read(connectionProvider).isConnected) {
              //           ref.read(todayProvider.notifier).backupTodays();
              //         } else {
              //           context.scaffoldMessenger.showSnackBar(
              //             appSnackbar(
              //               text:
              //                   'You\'re currently not connected to the interenet. Backup couldn\'t be started',
              //               color: AppColors.error,
              //               action: SnackBarAction(
              //                 label: 'Enable auto retry',
              //                 backgroundColor: Colors.white,
              //                 onPressed: () {
              //                   setState(() {
              //                     _autoRetryBackupIsOn = true;
              //                   });
              //                   ref
              //                       .read(todayProvider.notifier)
              //                       .autoRetryBackup = true;
              //                 },
              //               ),
              //             ),
              //           );
              //         }
              //       },
              child: Text(_autoRetryBackupIsOn ? 'Auto retry on' : 'Backup'),
            )
          : const SizedBox(),
    );
  }
}
