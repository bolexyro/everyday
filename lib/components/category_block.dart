import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/screens/category_screen.dart';

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({
    super.key,
    required this.category,
  });

  final Category category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.navigator
          .push(context.route(CategoryScreen(category: category))),
      child: Container(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
                child: Image.file(
              File(category.thumbnailPath),
              fit: BoxFit.cover,
            )),
            Container(
              width: double.infinity,
              height: 30,
              color: context.colorScheme.onSurface,
              child: Center(
                child: Text(
                  category.name,
                  style: TextStyle(color: context.colorScheme.surfaceContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
