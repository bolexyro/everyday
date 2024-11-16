import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/presentation/providers/backup_on_off_status_provider.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

class BackUpBottomSheet extends ConsumerStatefulWidget {
  const BackUpBottomSheet({super.key});

  @override
  ConsumerState<BackUpBottomSheet> createState() => _BackUpBottomSheetState();
}

class _BackUpBottomSheetState extends ConsumerState<BackUpBottomSheet> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = ref.read(authProvider).user!;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox.square(
              dimension: 160,
              child: Image.asset('backup'.png),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth * 0.85,
                child: Column(
                  children: [
                    Text(
                      'Keep your todays safe',
                      style: context.textTheme.titleLarge,
                    ),
                    const Gap(12),
                    Text(
                      'Your todays will be securely backed up to  your Everyday Account',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              );
            },
          ),
          const Gap(20),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Do not back up'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await ref
                        .read(backupOnOffStatusStateProvider.notifier)
                        .saveBackupStatus(true);

                    setState(() {
                      _isLoading = false;
                    });
                    ref.read(todayProvider.notifier).backupTodays();
                    if (context.mounted) {
                      context.navigator.pop();
                    }
                  },
                  child: _isLoading
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Turn on backup'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
