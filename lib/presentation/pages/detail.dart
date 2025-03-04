import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/local/models/favourite.dart';
import 'package:restaurant_app/data/remote/models/response/restaurant_detail.dart';
import 'package:restaurant_app/presentation/providers/database/local_database_provider.dart';
import 'package:restaurant_app/presentation/providers/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/presentation/widgets/menu_card.dart';
import 'package:restaurant_app/presentation/widgets/review_card.dart';
import 'package:restaurant_app/presentation/widgets/review_dialog.dart';
import 'package:restaurant_app/utils/api_constant.dart';
import 'package:restaurant_app/utils/app_detail_result_state.dart';

class Detail extends StatefulWidget {
  final String id;
  final bool isFromLocal;
  const Detail({super.key, required this.id, required this.isFromLocal});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  void initState() {
    super.initState();
    if (!widget.isFromLocal) {
      Future.microtask(() {
        context.read<RestaurantDetailProvider>().getDetailRestaurant(widget.id);
      });
    } else {
      Future.microtask(() {
        context.read<LocalDatabaseProvider>().getItemById(widget.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: widget.isFromLocal
                ? Consumer<LocalDatabaseProvider>(
                    builder: (context, value, child) {
                      return DetailContent(null, value.favourite);
                    },
                  )
                : Consumer<RestaurantDetailProvider>(
                    builder: (context, value, child) {
                      return switch (value.resultState) {
                        AppDetailLoadingState() => Center(
                            child: Lottie.asset(
                              'assets/animations/loading.json',
                              width: 240,
                              height: 240,
                              fit: BoxFit.cover,
                            ),
                          ),
                        AppDetailLoadedState(data: var restaurant) =>
                          DetailContent(restaurant, null),
                        AppDetailErrorState() => Center(
                            child: Lottie.asset('assets/animations/error.json',
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                                repeat: false)),
                        _ => const SizedBox()
                      };
                    },
                  )),
      ),
    );
  }

  Widget DetailContent(Restaurant? restaurant, Favourite? favourite) {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    bool isLocal = restaurant == null;
    String id;
    String name;
    String image;
    String city;
    double rating;

    if (isLocal) {
      id = widget.id;
      name = favourite!.name;
      image = favourite.image;
      city = favourite.city;
      rating = favourite.rating;
    } else {
      id = widget.id;
      name = restaurant.name;
      image = restaurant.pictureId;
      city = restaurant.city;
      rating = restaurant.rating;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Hero(
              tag: image,
              child: Image.network(
                '${ApiConstant.baseUrl}${ApiConstant.imagePath}/$image',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / 1,
                height: 270,
              ),
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GestureDetector(
                      onTap: () => context.go('/main'),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.onPrimary),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft02,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        Favourite favourite = Favourite(
                            id: id,
                            name: name,
                            image: image,
                            city: city,
                            rating: rating);
                        localDatabaseProvider.toggleFavourite(favourite, id);
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.onPrimary),
                        child: Center(
                          child: Consumer<LocalDatabaseProvider>(
                            builder: (context, localDatabaseProvider, child) {
                              return FutureBuilder<bool>(
                                future: localDatabaseProvider
                                    .isFavouriteRestaurant(id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.grey,
                                      size: 24.0,
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 24.0,
                                    );
                                  }
                                  bool isFavourite = snapshot.data ?? false;
                                  return Icon(
                                    isFavourite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_outline,
                                    color: Colors.redAccent,
                                    size: 24.0,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/star.png',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$rating',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedLocation01,
                color: Theme.of(context).colorScheme.primary,
                size: 16.0,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                restaurant?.address != null ? '${restaurant!.address}, $city' : city,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        if (!isLocal) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              restaurant.description,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Foods',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
                padding: const EdgeInsets.only(top: 8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3),
                itemCount: restaurant.menus.foods.length,
                itemBuilder: (context, index) {
                  return MenuCard(menu: restaurant.menus.foods[index].name);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14),
            child: Text(
              'Drinks',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
                padding: const EdgeInsets.only(top: 8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3),
                itemCount: restaurant.menus.drinks.length,
                itemBuilder: (context, index) {
                  return MenuCard(menu: restaurant.menus.drinks[index].name);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14),
            child: Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 8),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final review = restaurant.customerReviews[index];
                return ReviewCard(
                    name: review.name,
                    review: review.review,
                    date: review.date);
              },
              itemCount: restaurant.customerReviews.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReviewDialog(
                          id: restaurant.id,
                        );
                      });
                },
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 1, 48)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1)))),
                child: Text(
                  'Write a review',
                  style: Theme.of(context).textTheme.titleSmall,
                )),
          )
        ]
      ],
    );
  }
}
