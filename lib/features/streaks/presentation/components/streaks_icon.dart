import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/core/extensions.dart';
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
    return Row(
      children: [
        SvgPicture.asset(
          'bolt'.svg,
          colorFilter: ColorFilter.mode(
            Theme.of(context).iconTheme.color!,
            BlendMode.srcIn,
          ),
        ),
        Text(ref.watch(streakProvider).currentStreakCount.toString()),
      ],
    );
  }
}
