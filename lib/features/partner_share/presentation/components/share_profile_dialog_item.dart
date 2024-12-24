import 'package:flutter/material.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/presentation/components/profile_dialog.dart';
import 'package:myapp/features/partner_share/presentation/screens/share_intro_screen.dart';

class ShareProfileDialogItem extends StatelessWidget {
  const ShareProfileDialogItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileDialogItem(
      onTap: () =>
          context.navigator.push(context.route(const ShareIntroScreen())),
      title: 'Share with a partner',
      icon: const Icon(Icons.swap_horizontal_circle_outlined),
    );
  }
}
