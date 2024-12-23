import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/features/everyday/presentation/components/back_up_bottom_sheet.dart';
import 'package:myapp/features/everyday/presentation/components/backup_indicator_icon.dart';
import 'package:myapp/features/everyday/presentation/components/profile_dialog.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_state_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_on_off_status_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';
import 'package:myapp/features/everyday/presentation/screens/backup_settings_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileDialogBackupListTile extends ConsumerStatefulWidget {
  const ProfileDialogBackupListTile({super.key});

  @override
  ConsumerState<ProfileDialogBackupListTile> createState() =>
      _ProfileDialogBackupListTileState();
}

class _ProfileDialogBackupListTileState
    extends ConsumerState<ProfileDialogBackupListTile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backupOnOffStatusStateProvider.notifier).getBackupStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backupOnOffStatus = ref.watch(backupOnOffStatusStateProvider);
    if (backupOnOffStatus.isLoading) {
      return const ProfileDialogItem(
        icon: Icon(Icons.backup_outlined),
        isLoading: true,
      );
    } else {
      final backupProgressState = ref.watch(backupProgressStateProvider);

      if (backupProgressState is BackupInProgress) {
        return ProfileDialogItemBackingUp(
            backupProgressState: backupProgressState);
      }
      final allTodays = ref.read(todayProvider);
      final numberOfUnbackedupTodays =
          allTodays.where((today) => today.isBackedUp == false).length;
      return ProfileDialogItem(
        onTap: () =>
            context.navigator.push(context.route(const BackupSettingsScreen())),
        title: 'Backup is ${backupOnOffStatus.isOn ? 'on' : 'off'}',
        subTitle: backupOnOffStatus.isOn == true
            ? allTodays.isEmpty
                ? 'Nothing to backup'
                : numberOfUnbackedupTodays == 0
                    ? 'Your todays are backed up'
                    : 'You have $numberOfUnbackedupTodays todays not backed up'
            : 'Keep your todays safe by backing them up to your everyday account',
        button: backupOnOffStatus.isOn && numberOfUnbackedupTodays == 0
            ? null
            : TextButton(
                onPressed: () => backupOnOffStatus.isOn
                    ? ref.read(todayProvider.notifier).backupTodays()
                    : showModalBottomSheet(
                        context: context,
                        builder: (context) => const BackUpBottomSheet(),
                        isScrollControlled: true,
                        enableDrag: false,
                        sheetAnimationStyle: AnimationStyle.noAnimation,
                      ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                ),
                child:
                    Text(backupOnOffStatus.isOn ? 'Backup' : 'Turn on backup'),
              ),
        icon: const Icon(Icons.backup_outlined),
      );
    }
  }
}

class ProfileDialogItemBackingUp extends StatelessWidget {
  const ProfileDialogItemBackingUp(
      {super.key, required this.backupProgressState});

  final BackupProgress backupProgressState;

  @override
  Widget build(BuildContext context) {
    return ProfileDialogItem(
      onTap: () =>
          context.navigator.push(context.route(const BackupSettingsScreen())),
      title: 'Backup',
      subTitle:
          'Backing up · ${(backupProgressState as BackupInProgress).left} today left',
      icon: CircularPercentIndicator(
        radius: 12.0,
        lineWidth: 2.0,
        percent: (backupProgressState as BackupInProgress).progress,
        center: const BackupIndicatorIcon(),
        progressColor: AppColors.neonGreen,
      ),
    );
  }
}
