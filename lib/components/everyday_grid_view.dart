import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/components/today_block.dart';
import 'package:myapp/models/today.dart';

class AllTodayGridView extends StatelessWidget {
  const AllTodayGridView({
    super.key,
    required this.everyday,
    required this.onScroll,
  });
  final List<Today> everyday;
  final void Function({required bool extend}) onScroll;

  @override
  Widget build(BuildContext context) {
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
