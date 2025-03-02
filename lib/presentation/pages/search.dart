import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/local/models/favourite.dart';
import 'package:restaurant_app/presentation/providers/database/local_database_provider.dart';
import 'package:restaurant_app/presentation/providers/search/restaurant_search_provider.dart';
import 'package:restaurant_app/presentation/providers/setting/shared_preference_provider.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';
import 'package:restaurant_app/utils/app_search_result_state.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<RestaurantSearchProvider>()
          .searchRestaurant(_controller.text);
      context.read<SharedPreferenceProvider>().getThemesAndNotificationValue();
    });
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: SearchBar(
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Theme.of(context).colorScheme.tertiary,
              size: 20.0,
            ),
            backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.onPrimary),
            elevation: WidgetStateProperty.all(0),
            controller: _controller,
            side: WidgetStateProperty.all(BorderSide(
                color: Theme.of(context).colorScheme.tertiary, width: 1)),
            hintText: 'Search Restaurant',
            hintStyle: WidgetStateProperty.all(Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16)),
            onChanged: (value) {
              context.read<RestaurantSearchProvider>().searchRestaurant(value);
            },
            onSubmitted: (value) {
              context.read<RestaurantSearchProvider>().searchRestaurant(value);
            },
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Consumer<SharedPreferenceProvider>(
                  builder: (context, value, child) => GestureDetector(
                    onTap: () => value.toggleTheme(value.themes),
                    child: value.themes
                        ? HugeIcon(
                            icon: HugeIcons.strokeRoundedMoon02,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.0,
                          )
                        : HugeIcon(
                            icon: HugeIcons.strokeRoundedSun03,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.0,
                          ),
                  ),
                )),
          ],
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Consumer<RestaurantSearchProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  AppSearchLoadingState() => Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                  AppSearchLoadedState(data: var restaurantSearch) =>
                    restaurantSearch.restaurants.isEmpty
                        ? Center(
                            child: Text('"${_controller.text}" not found',
                                style: Theme.of(context).textTheme.titleSmall),
                          )
                        : ListView.builder(
                            itemCount: restaurantSearch.restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant =
                                  restaurantSearch.restaurants[index];
                              return RestaurantCard(
                                restaurant: restaurant,
                                isFromLocal: false,
                                onTap: () {
                                  context.push('/detail/${restaurant.id}');
                                },
                                onFavourite: () {
                                  Favourite favourite = Favourite(
                                      id: restaurant.id,
                                      name: restaurant.name,
                                      image: restaurant.pictureId,
                                      city: restaurant.city,
                                      rating: restaurant.rating);
                                  localDatabaseProvider.toggleFavourite(
                                      favourite, restaurant.id);
                                },
                              );
                            },
                          ),
                  AppSearchErrorState() => Center(
                      child: Lottie.asset('assets/animations/error.json',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                          repeat: false),
                    ),
                  _ => const SizedBox()
                };
              },
            ),
          ),
        ));
  }
}
