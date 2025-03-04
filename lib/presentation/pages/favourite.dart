import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentation/providers/database/local_database_provider.dart';
import 'package:restaurant_app/presentation/providers/setting/shared_preference_provider.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';

import '../providers/notification/local_notification_provider.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocalDatabaseProvider>().getAllItem();
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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Favourite',
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
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
                  'Your Favourite Restaurant',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Expanded(
                child: Consumer<LocalDatabaseProvider>(
                  builder: (context, value, child) {
                    bool isFavourite = value.isFavourite;
                    if (value.favouriteList == null ||
                        value.favouriteList!.isEmpty) {
                      return const Center(
                        child: Text("No favourite restaurants found."),
                      );
                    }
                    return ListView.builder(
                      itemCount: value.favouriteList!.length,
                      itemBuilder: (context, index) {
                        final favourite = value.favouriteList![index];
                        return Hero(
                          tag: favourite.image,
                          child: RestaurantCard(
                            onTap: () {
                              debugPrint('is Favourite? $isFavourite');
                              context
                                  .push('/detail/${favourite.id}/$isFavourite');
                            },
                            onFavourite: () {
                              value.toggleFavourite(favourite, favourite.id);
                            },
                            isFromLocal: true,
                            favourite: favourite,
                          ),
                        );
                      },
                    );
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
