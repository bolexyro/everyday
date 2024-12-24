import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/components/app_scaffold.dart';
import 'package:myapp/core/extensions.dart';

class ShareIntroScreen extends StatelessWidget {
  const ShareIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.navigator.pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('friends'.png),
                  ),
                  const Gap(12),
                  Text(
                    'Share todays with your favourite person',
                    style: context.textTheme.bodyLarge?.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),
                  const Text(
                    'Set up automatic sharing with your parnter so that they can always enjoy your important todays. You\'re in control: share some todays or all of your todays',
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.backup_outlined),
                      Gap(12),
                      Expanded(
                        child: Text(
                            'Your parner can only see photos that you\'ve backed up'),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
