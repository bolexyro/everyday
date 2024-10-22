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
  final List<Category> _categories = [Category(name: 'Everyday')];

  bool _fabIsExtended = true;

  void _addCategory(Category category) {
    setState(() {
      _categories.add(category);
    });
  }

  void _extendFab({required bool extend}) {
    setState(() {
      _fabIsExtended = extend;
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
        child: _categories.isEmpty
            ? const Center(child: Text('No categories yet'))
            : CategoriesGridView(
                categories: _categories,
                onScroll: _extendFab,
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAdaptiveDialog(
          context: context,
          builder: (context) =>
              CreateCategoryDialog(onCategoryCreated: _addCategory),
        ),
        extendedIconLabelSpacing: _fabIsExtended ? 10 : 0,
        extendedPadding:
            _fabIsExtended ? null : const EdgeInsets.symmetric(horizontal: 16),
        label: AnimatedSize(
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 100),
          child: _fabIsExtended ? const Text('Create Category') : Container(),
        ),
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
