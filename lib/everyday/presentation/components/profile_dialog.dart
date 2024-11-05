import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/presentation/components/profile_dialog_backup_list_tile.dart';
import 'package:myapp/everyday/presentation/providers/today_provider.dart';

class ProfileDialog extends ConsumerWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).user!;

    double dragDistance = 0;

    return GestureDetector(
      onPanUpdate: (details) {
        dragDistance += details.delta.dy;
        if (dragDistance > 100) {
          Navigator.of(context).pop();
        }
      },
      onPanEnd: (details) {
        dragDistance = 0;
      },
      child: AlertDialog(
        backgroundColor: context.colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: MediaQuery.sizeOf(context).width),
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.navigator.pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  'Everyday',
                  style: context.textTheme.bodyLarge,
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.colorScheme.surface,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: context.textTheme.titleMedium,
                              ),
                              Text(
                                user.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),
                        Text(ref.read(todayProvider).length >= 100
                            ? '100+'
                            : ref.read(todayProvider).length.toString())
                      ],
                    ),
                  ),
                  const Gap(16),
                  Divider(
                    color: context.colorScheme.surface,
                    height: 0,
                    thickness: 2,
                  ),
                  Column(
                    children: [
                      const ProfileDialogBackupListTile(),
                      ProfileDialogItem(
                        onTap: () {},
                        title: 'Share with a partner',
                        icon: const Icon(Icons.swap_horizontal_circle_outlined),
                      ),
                      ProfileDialogItem(
                        onTap: () {},
                        title: 'Add another account',
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                      ),
                      ProfileDialogItem(
                        onTap: () => ref.read(authProvider.notifier).logout(),
                        title: 'Logout',
                        icon: const Icon(Icons.logout),
                      ),
                      // const Gap(16),
                    ],
                  )
                ],
              ),
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      foregroundColor: context.colorScheme.onSurface),
                  child: Text(
                    'Privacy Policy',
                    style: context.textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: CircleAvatar(
                    backgroundColor: context.colorScheme.onSurface,
                    radius: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      foregroundColor: context.colorScheme.onSurface),
                  child: Text(
                    'Terms of Service',
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDialogItem extends StatelessWidget {
  const ProfileDialogItem({
    super.key,
    this.onTap,
    this.title,
    this.subTitle,
    required this.icon,
    this.button,
    this.isLoading = false,
  });

  final VoidCallback? onTap;
  final String? title;
  final String? subTitle;
  final Widget? button;
  final Widget icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: subTitle == null
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: icon,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: isLoading == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title!,
                              style: context.textTheme.titleMedium,
                            ),
                            if (subTitle != null)
                              Text(
                                subTitle!,
                                style: context.textTheme.bodyMedium,
                              ),
                            if (button != null) button!
                          ],
                        )
                      : const Center(
                          child: LinearProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
