import 'package:flutter/material.dart';

class SharingTab extends StatelessWidget {
  const SharingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people),
          Text('Sharing'),
        ],
      ),
    );
  }
}
