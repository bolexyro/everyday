import 'package:flutter/material.dart';
import 'package:myapp/models/category.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: const Center(
        child: Text('Category Screen'),
      ),
    );
  }
}
