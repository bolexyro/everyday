import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';

class ProfileDialog extends ConsumerWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).user!;
   double dragDistance = 0; // Track the drag distance

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
            const SizedBox(width: double.infinity),
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
                const Text('Everyday')
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
                              Text(user.name),
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
                        title: 'Backup',
                        icon: Icons.backup_outlined,
                      ),
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
    required this.icon,
  });

  final VoidCallback onTap;
  final String title;
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
              children: [
                SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: Icon(icon),
                  ),
                ),
                const Gap(12),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
