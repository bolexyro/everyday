import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/core/app_colors.dart';

class BackupIndicatorIcon extends StatefulWidget {
  const BackupIndicatorIcon({super.key});

  @override
  State<BackupIndicatorIcon> createState() => _BackupIndicatorIconState();
}

class _BackupIndicatorIconState extends State<BackupIndicatorIcon> {
  bool _isBright = true;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBright = !_isBright;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isBright ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 500),
      child: const Icon(
        Icons.arrow_upward,
        size: 16.0,
        color: AppColors.neonGreen,
      ),
    );
  }
}
