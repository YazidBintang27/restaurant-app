import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentation/providers/database/local_database_provider.dart';
import 'package:restaurant_app/presentation/providers/setting/shared_preference_provider.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
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
                  onTap: () => value.toggleNotification(value.notification),
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
                          tag: favourite.image ?? 'default_tag_$index',
                          child: RestaurantCard(
                            onTap: () {},
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
