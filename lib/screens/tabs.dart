import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/screens/smart_recipe_gen.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    if (_selectedPageIndex == 2) {
      activePage = CreateSmartRecipies();
      activePageTitle = 'Smart Recipe Generator';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )),
        actions: <Widget>[
          if (activePageTitle == 'Categories' || activePageTitle == 'Favorites')
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FiltersScreen()));
              },
              icon: const Icon(Icons.filter_list),
            ),
        ],
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: _setScreen,
      // ),
      body: activePage,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).primaryColorDark,
        selectedIndex: _selectedPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.food_bank),
            icon: Icon(Icons.food_bank_outlined),
            label: 'Categories',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.star),
            icon: Icon(Icons.star_border),
            label: 'Favorites',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bubble_chart),
            icon: Icon(Icons.bubble_chart_outlined),
            label: 'Recipe Generator',
          ),
        ],
      ),
    );
  }
}
