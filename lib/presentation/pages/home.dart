import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentation/providers/home/restaurant_list_provider.dart';
import 'package:restaurant_app/presentation/providers/theme/theme_provider.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';
import 'package:restaurant_app/utils/app_list_result_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantListProvider>().getRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resto.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Consumer<ThemeProvider>(
                builder: (context, value, child) => GestureDetector(
                  onTap: () => value.toggleTheme = value.isDark,
                  child: value.isDark
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 10),
                child: Text(
                  'Recommendation for You!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Expanded(
                child: Consumer<RestaurantListProvider>(
                  builder: (context, value, child) {
                    return switch (value.resultState) {
                      AppListLoadingState() => Center(
                            child: Lottie.asset(
                          'assets/animations/loading.json',
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                        )),
                      AppListLoadedState(data: var restaurantList) =>
                        ListView.builder(
                          itemCount: restaurantList.restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant =
                                restaurantList.restaurants[index];
                            return RestaurantCard(
                                restaurant: restaurant,
                                onTap: () {
                                  context.go('/detail');
                                });
                          },
                        ),
                      AppListErrorState(error: var message) => Center(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
