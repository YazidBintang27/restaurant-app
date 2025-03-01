import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentation/pages/favourite.dart';
import 'package:restaurant_app/presentation/pages/home.dart';
import 'package:restaurant_app/presentation/pages/search.dart';
import 'package:restaurant_app/presentation/providers/main/index_nav_provider.dart';

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(builder: (context, value, child) {
        return switch (value.indexBottomNavbar) {
          0 => const Home(),
          1 => const Search(),
          _ => const Favourite()
        };
      }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<IndexNavProvider>().indexBottomNavbar,
          onTap: (index) =>
              context.read<IndexNavProvider>().setIndexbottomNavbar = index,
          selectedLabelStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          items: [
            BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome01,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                ),
                label: 'Home',
                tooltip: 'Home'),
            BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                ),
                label: 'Search',
                tooltip: 'Search'),
            BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedFavourite,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                ),
                label: 'Favourite',
                tooltip: 'Favourite'),
          ]),
    );
  }
}
