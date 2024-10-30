import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/core/app_colors.dart';

class SharingTab extends StatelessWidget {
  const SharingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 20),
                Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Choose to share some or all of your days automatically'),
                      Gap(4),
                      Text(
                        'Share with partner',
                        style: TextStyle(
                          color: AppColors.neonGreen,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.backup),
                ),
                Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Backup is off'),
                      Gap(4),
                      Text(
                        'Keep your photos safe by backing them up to your Google Account.',
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
