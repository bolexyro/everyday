import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/components/today_block.dart';
import 'package:myapp/providers/everyday_provider.dart';

class AllTodayGridView extends ConsumerWidget {
  const AllTodayGridView({
    super.key,
    required this.onScroll,
  });
  final void Function({required bool extend}) onScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final everyday = ref.watch(everydayProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.forward ||
              scrollNotification.direction == ScrollDirection.reverse) {
            onScroll(extend: false);
          } else if (scrollNotification.metrics.atEdge) {
            onScroll(extend: true);
          }
        }
        return false;
      },
      child: everyday.isEmpty
          ? const Center(child: Text('No todays yet'))
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: everyday
                  .map((category) => TodayBlock(today: category))
                  .toList(),
            ),
    );
  }
}
