import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/presentation/components/back_up_bottom_sheet.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';

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
                color: context.colorScheme.surfaceContainerHigh,
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
                        Text(ref.read(everydayProvider).length >= 100
                            ? '100+'
                            : ref.read(everydayProvider).length.toString())
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
                      _DialogItem(
                        onTap: () {},
                        title: 'Backup is off',
                        subTitle:
                            'Keep your todays safe by backing them up to your everyday account',
                        button: TextButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => const BackUpBottomSheet(),
                            isScrollControlled: true,
                            enableDrag: false,
                            sheetAnimationStyle: AnimationStyle.noAnimation,
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                          ),
                          child: const Text('Turn on backup'),
                        ),
                        icon: Icons.backup_outlined,
                      ),
                      // ListTile(),
                      _DialogItem(
                        onTap: () {},
                        title: 'Share with a partner',
                        icon: Icons.swap_horizontal_circle_outlined,
                      ),
                      _DialogItem(
                        onTap: () {},
                        title: 'Add another account',
                        icon: Icons.person_add_alt_1_outlined,
                      ),
                      _DialogItem(
                        onTap: () => ref.read(authProvider.notifier).logout(),
                        title: 'Logout',
                        icon: Icons.logout,
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

class _DialogItem extends StatelessWidget {
  const _DialogItem({
    required this.onTap,
    required this.title,
    this.subTitle,
    required this.icon,
    this.button,
  });

  final VoidCallback onTap;
  final String title;
  final String? subTitle;
  final Widget? button;
  final IconData icon;

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
                    child: Icon(icon),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.titleMedium,
                      ),
                      if (subTitle != null)
                        Text(
                          subTitle!,
                          style: context.textTheme.bodyMedium,
                        ),
                      if (button != null) button!
                    ],
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
