import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/everyday/presentation/components/back_up_bottom_sheet.dart';
import 'package:myapp/everyday/presentation/components/profile_dialog.dart';
import 'package:myapp/everyday/presentation/providers/backup_progress_provider.dart';
import 'package:myapp/everyday/presentation/providers/backup_on_off_status_provider.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';
import 'package:myapp/everyday/presentation/screens/backup_settings_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileDialogBackupListTile extends ConsumerStatefulWidget {
  const ProfileDialogBackupListTile({super.key});

  @override
  ConsumerState<ProfileDialogBackupListTile> createState() =>
      _BackupListTileState();
}

class _BackupListTileState extends ConsumerState<ProfileDialogBackupListTile> {
  bool _isBright = true;
  late Timer _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backupOnOffStatusStateProvider.notifier).getBackupStatus();
    });
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBright = !_isBright;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

      if (backupProgressState.isBackingUp) {
        return ProfileDialogItemBackingUp(
            backupProgressState: backupProgressState);
      }
      final totalNumberofTodays = ref.read(everydayProvider);
      final numberOfUnbackedupTodays = totalNumberofTodays
          .where((today) => today.isBackedUp == false)
          .length;
      return ProfileDialogItem(
        onTap: () =>
            context.navigator.push(context.route(const BackupSettingsScreen())),
        title: 'Backup is ${backupOnOffStatus.isOn ? 'on' : 'off'}',
        subTitle: backupOnOffStatus.isOn == true
            ? totalNumberofTodays.isEmpty
                ? 'You have no today'
                : numberOfUnbackedupTodays == 0
                    ? 'Your everyday is backed up'
                    : 'You have $numberOfUnbackedupTodays unbacked up todays'
            : 'Keep your todays safe by backing them up to your everyday account',
        button: backupOnOffStatus.isOn && numberOfUnbackedupTodays == 0
            ? null
            : TextButton(
                onPressed: () => backupOnOffStatus.isOn
                    ? ref.read(everydayProvider.notifier).backupEveryday()
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

class ProfileDialogItemBackingUp extends StatefulWidget {
  const ProfileDialogItemBackingUp(
      {super.key, required this.backupProgressState});

  final BackupProgress backupProgressState;

  @override
  State<ProfileDialogItemBackingUp> createState() =>
      _ProfileDialogItemBackingUpState();
}

class _ProfileDialogItemBackingUpState
    extends State<ProfileDialogItemBackingUp> {
  bool _isBright = true;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBright = !_isBright;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileDialogItem(
      onTap: () =>
          context.navigator.push(context.route(const BackupSettingsScreen())),
      title: 'Backup',
      subTitle: 'Backing up · ${widget.backupProgressState.left} today left',
      button: null,
      icon: CircularPercentIndicator(
        radius: 12.0,
        lineWidth: 2.0,
        percent: widget.backupProgressState.progress,
        center: AnimatedOpacity(
          opacity: _isBright ? 1.0 : 0.3,
          duration: const Duration(milliseconds: 500),
          child: const Icon(
            Icons.arrow_upward,
            size: 16.0,
            color: AppColors.neonGreen,
          ),
        ),
        progressColor: AppColors.neonGreen,
      ),
    );
  }
}
