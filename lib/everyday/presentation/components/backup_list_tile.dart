import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/everyday/domain/entities/backup_progress.dart';
import 'package:myapp/everyday/presentation/components/back_up_bottom_sheet.dart';
import 'package:myapp/everyday/presentation/components/profile_dialog.dart';
import 'package:myapp/everyday/presentation/providers/backup_provider.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BackupListTile extends ConsumerStatefulWidget {
  const BackupListTile({super.key});

  @override
  ConsumerState<BackupListTile> createState() => _BackupListTileState();
}

class _BackupListTileState extends ConsumerState<BackupListTile> {
  bool _isBright = true;
  late Timer _timer;

  late Future<bool> _backupStatusFuture;

  @override
  void initState() {
    _backupStatusFuture = ref.read(everydayProvider.notifier).getBackupStatus();
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
    final backupState = ref.watch(backupStateProvider);
    return FutureBuilder(
        future: _backupStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProfileDialogItem(
              icon: Icon(Icons.backup_outlined),
              isLoading: true,
            );
          }
          if (snapshot.hasError) {
            return const ProfileDialogItem(
              icon: Icon(Icons.error),
              title: 'An error occurred',
            );
          }
          final backupStatus = snapshot.data!;
          if (backupState.isBackingUp) {
            return ProfileDialogItemBackingUp(backupState: backupState);
          }
          final numberOfUnbackedupTodays = ref
              .read(everydayProvider)
              .where((today) => today.isBackedUp == false)
              .length;
          return ProfileDialogItem(
            onTap: () {},
            title: 'Backup is ${backupStatus ? 'on' : 'off'}',
            subTitle: backupStatus == true
                ? numberOfUnbackedupTodays == 0
                    ? 'Your everyday is backed up'
                    : 'You have $numberOfUnbackedupTodays unbacked up todays'
                : 'Keep your todays safe by backing them up to your everyday account',
            button: numberOfUnbackedupTodays == 0
                ? null
                : TextButton(
                    onPressed: () => backupStatus
                        ? ref
                            .read(everydayProvider.notifier)
                            .uploadEveryday(ref.read(authProvider).user!.email)
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
                    child: Text(backupStatus ? 'Backup' : 'Turn on backup'),
                  ),
            icon: const Icon(Icons.backup_outlined),
          );
        });
  }
}

class ProfileDialogItemBackingUp extends StatefulWidget {
  const ProfileDialogItemBackingUp({super.key, required this.backupState});

  final BackupProgress backupState;

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
      onTap: () {},
      title: 'Backup',
      subTitle: 'Backing up · ${widget.backupState.left} today left',
      button: null,
      icon: CircularPercentIndicator(
        radius: 12.0,
        lineWidth: 2.0,
        percent: widget.backupState.progress,
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
