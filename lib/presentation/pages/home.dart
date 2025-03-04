import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/local/models/favourite.dart';
import 'package:restaurant_app/presentation/providers/database/local_database_provider.dart';
import 'package:restaurant_app/presentation/providers/home/restaurant_list_provider.dart';
import 'package:restaurant_app/presentation/providers/setting/shared_preference_provider.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';
import 'package:restaurant_app/utils/app_list_result_state.dart';

import '../providers/notification/local_notification_provider.dart';

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
    Future.microtask(() {
      context.read<SharedPreferenceProvider>().getThemesAndNotificationValue();
    });
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context
        .read<LocalNotificationProvider>()
        .scheduleDailyElevenAMNotification();
  }

  Future<void> _cancelNotification(int id) async {
    context.read<LocalNotificationProvider>().cancelNotification(id);
  }

  @override
  Widget build(BuildContext context) {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Resto.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Consumer<SharedPreferenceProvider>(
                builder: (context, value, child) => GestureDetector(
                  onTap: () async {
                    value.toggleNotification(value.notification);
                    if (value.notification) {
                      await _requestPermission();
                      await _scheduleDailyElevenAMNotification();
                    } else {
                      await _cancelNotification(3);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value.notification
                              ? 'Notifikasi diaktifkan'
                              : 'Notifikasi dinonaktifkan',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: value.notification
                      ? HugeIcon(
                          icon: HugeIcons.strokeRoundedNotification01,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        )
                      : HugeIcon(
                          icon: HugeIcons.strokeRoundedNotificationOff01,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        ),
                ),
              )),
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
                            return Hero(
                              tag: restaurant.pictureId,
                              child: RestaurantCard(
                                restaurant: restaurant,
                                isFromLocal: false,
                                onTap: () {
                                  context
                                      .push('/detail/${restaurant.id}/false');
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
                              ),
                            );
                          },
                        ),
                      AppListErrorState() => Center(
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
