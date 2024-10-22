import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/components/category_block.dart';
import 'package:myapp/models/category.dart';

class CategoriesGridView extends StatelessWidget {
  const CategoriesGridView({
    super.key,
    required this.categories,
    required this.onScroll,
  });
  final List<Category> categories;
  final void Function({required bool extend}) onScroll;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.forward || scrollNotification.direction == ScrollDirection.reverse) {
            onScroll(extend: false);
          } else if (scrollNotification.metrics.atEdge) {
            onScroll(extend: true);
          }
        }
        return false;
      },
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: categories
            .map((category) => CategoryBlock(category: category))
            .toList(),
      ),
    );
  }
}
