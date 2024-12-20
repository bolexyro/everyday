import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/app_scaffold.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/presentation/components/backup_fours.dart';
import 'package:myapp/features/everyday/presentation/components/backup_indicator_icon.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_on_off_status_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_progress_provider.dart';
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
                  const BackupFours()
                ],
              ),
            ),
    );
  }
}

class BackupListTile extends ConsumerWidget {
  const BackupListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noTodaysNotBackedUp = ref
        .watch(todayProvider)
        .where((today) => today.isBackedUp == false)
        .length;
    final backupOnOffStatus = ref.watch(backupOnOffStatusStateProvider);
    final backupProgressState = ref.watch(backupProgressStateProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: backupProgressState.isBackingUp
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
      title: Text(backupProgressState.isBackingUp
          ? 'Backing up · ${ref.watch(backupProgressStateProvider).left} today left'
          : 'Backup is ${backupOnOffStatus.isOn ? 'on' : 'off'}'),
      subtitle: backupProgressState.isBackingUp
          ? null
          : noTodaysNotBackedUp == 0
              ? const Text('Nothing to back up')
              : Text('$noTodaysNotBackedUp todays not backed up'),
      trailing: backupOnOffStatus.isOn &&
              !backupProgressState.isBackingUp &&
              noTodaysNotBackedUp > 0
          ? TextButton(
              onPressed: () => ref.read(todayProvider.notifier).backupTodays(),
              child: const Text('Backup'),
            )
          : const SizedBox(),
    );
  }
}
