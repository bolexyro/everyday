import 'package:flutter/material.dart';
import 'package:myapp/components/categories_grid_view.dart';
import 'package:myapp/components/create_category_dialog.dart';
import 'package:myapp/models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  final List<Category> _categories = [
    Category(name: 'My days'),
    Category(name: 'Gratitudes'),
    Category(name: 'Blessings'),
    Category(name: 'Shockers'),
    Category(name: 'COC'),
  ];

  bool _fabIsHidden = false;

  void _addCategory(String categoryName) {
    setState(() {
      _categories.add(Category(name: categoryName));
    });
  }

  void _hideUnhideFab({required bool hide}) {
    setState(() {
      _fabIsHidden = hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Everyday'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0)
            .add(const EdgeInsets.only(top: 8)),
        child: CategoriesGridView(
          categories: _categories,
          onScroll: _hideUnhideFab,
        ),
      ),
      floatingActionButton: _fabIsHidden
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showAdaptiveDialog(
                context: context,
                builder: (context) =>
                    CreateCategoryDialog(onCategoryCreated: _addCategory),
              ),
              label: const Text('Create Cateogry'),
              icon: const Icon(Icons.add),
            ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Sharing',
          ),
        ],
      ),
    );
  }
}
