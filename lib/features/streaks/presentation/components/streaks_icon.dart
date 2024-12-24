import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/streaks/presentation/provider/streak_provider.dart';

class StreaksIcon extends ConsumerStatefulWidget {
  const StreaksIcon({super.key});

  @override
  ConsumerState<StreaksIcon> createState() => _StreaksIconState();
}

class _StreaksIconState extends ConsumerState<StreaksIcon> {
  @override
  void initState() {
    ref.read(streakProvider.notifier).getCurrentStreakCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'mkbhd is da goat ${ref.watch(streakProvider).currentStreakCount.toString()}');
    return Row(
      children: [
        const Icon(Icons.bolt_outlined),
        Text(ref.watch(streakProvider).currentStreakCount.toString()),
      ],
    );
  }
}
