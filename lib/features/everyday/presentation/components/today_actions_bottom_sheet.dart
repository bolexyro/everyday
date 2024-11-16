import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';

class TodayActionsBottomSheet extends StatelessWidget {
  const TodayActionsBottomSheet({
    super.key,
    required this.today,
  });
  final Today today;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TodayAction(
                icon: Icons.share_outlined,
                text: 'Share',
                onTap: () {},
              ),
              TodayAction(
                icon: Icons.delete_outline,
                text: 'Delete',
                onTap: () {},
              ),
              TodayAction(
                icon: Icons.backup_outlined,
                text: 'Back up',
                onTap: () {},
              ),
              TodayAction(
                icon: Icons.mobile_off_outlined,
                text: 'Delete from device',
                onTap: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Text(
                'Details',
                style: context.textTheme.titleMedium,
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.text_snippet),
                    title: Text(today.caption),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) =>
                        //         const TodayCaptionDialog(videoPath: ''));
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text(today.date.formatDateWithShortDayWithTime),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          currentDate: today.date,
                          firstDate:
                              today.date.subtract(const Duration(days: 14)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          if (context.mounted) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: today.date.hour,
                                  minute: today.date.minute),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.mobile_friendly),
                    title: !today.isAvailableLocal
                        ? const Text('Not available offline')
                        : FutureBuilder(
                            future: File(today.localVideoPath!).size(1),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LinearProgressIndicator();
                              }
                              final fileSize = snapshot.data!;
                              return Text('On device ($fileSize)');
                            },
                          ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.backup_outlined),
                    title: !today.isBackedUp
                        ? const Text('Not Backed up')
                        : today.isAvailableLocal
                            ? FutureBuilder(
                                future: File(today.localVideoPath!).size(1),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const LinearProgressIndicator();
                                  }
                                  final fileSize = snapshot.data!;
                                  return Text('Backed up ($fileSize)');
                                },
                              )
                            : const Text('Backed up'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Add a location'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class TodayAction extends StatelessWidget {
  const TodayAction({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        child: SizedBox(
          width: 55,
          child: Column(
            children: [
              Icon(icon),
              const Gap(4),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
