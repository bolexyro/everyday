import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/presentation/components/today_caption_dialog.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

class TodayActionsBottomSheet extends ConsumerStatefulWidget {
  const TodayActionsBottomSheet({
    super.key,
    required this.today,
  });
  final Today today;

  @override
  ConsumerState<TodayActionsBottomSheet> createState() =>
      _TodayActionsBottomSheetState();
}

class _TodayActionsBottomSheetState
    extends ConsumerState<TodayActionsBottomSheet> {
  late String _displayCaption = widget.today.caption;
  late DateTime _displayDateTime = widget.today.date;

  bool _isUpdating = false;
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
                text: 'Permanent Delete',
                onTap: () {},
              ),
              if (!widget.today.isBackedUp)
                TodayAction(
                  icon: Icons.backup_outlined,
                  text: 'Back up',
                  onTap: () {},
                ),
              if (widget.today.isAvailableLocal)
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
                    title: Text(_displayCaption),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) =>
                              TodayCaptionDialog(today: widget.today),
                        );
                        if (result != null) {
                          setState(() {
                            _displayCaption = result;
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title:
                        Text(_displayDateTime.formatDateWithShortDayWithTime),
                    trailing: IconButton(
                      icon: _isUpdating
                          ? const SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.edit),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          currentDate: widget.today.date,
                          firstDate: widget.today.date
                              .subtract(const Duration(days: 14)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          if (context.mounted) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: widget.today.date.hour,
                                  minute: widget.today.date.minute),
                            );
                            setState(() {
                              _isUpdating = true;
                            });

                            if (time != null) {
                              final dateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                              final dataState = await ref
                                  .read(todayProvider.notifier)
                                  .updateToday(
                                      widget.today.copyWith(date: dateTime));
                              if (dataState is DataSuccess) {
                                setState(() {
                                  _displayDateTime = dateTime;
                                });
                              }
                              setState(() {
                                _isUpdating = false;
                              });
                            }
                          }
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.mobile_friendly),
                    title: !widget.today.isAvailableLocal
                        ? const Text('Not available offline')
                        : FutureBuilder(
                            future: File(widget.today.localVideoPath!).size(1),
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
                    title: !widget.today.isBackedUp
                        ? const Text('Not Backed up')
                        : widget.today.isAvailableLocal
                            ? FutureBuilder(
                                future:
                                    File(widget.today.localVideoPath!).size(1),
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
