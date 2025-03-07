import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/remote/models/response/restaurant.dart';
import 'package:restaurant_app/utils/api_constant.dart';
import '../../data/local/models/favourite.dart';
import '../providers/database/local_database_provider.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant? restaurant;
  final Favourite? favourite;
  final bool isFromLocal;
  final Function() onTap;
  final Function() onFavourite;

  const RestaurantCard({
    super.key,
    this.restaurant,
    required this.onTap,
    required this.onFavourite,
    required this.isFromLocal,
    this.favourite,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = isFromLocal
        ? '${ApiConstant.baseUrl}${ApiConstant.imagePath}/${favourite?.image}'
        : '${ApiConstant.baseUrl}${ApiConstant.imagePath}/${restaurant?.pictureId}';

    final name = isFromLocal
        ? favourite?.name ?? 'Unknown'
        : restaurant?.name ?? 'Unknown';
    final city = isFromLocal
        ? favourite?.city ?? 'Unknown'
        : restaurant?.city ?? 'Unknown';
    final rating = isFromLocal
        ? favourite?.rating.toString() ?? '0.0'
        : restaurant?.rating.toString() ?? '0.0';

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedLocation01,
                        color: Theme.of(context).colorScheme.primary,
                        size: 14.0,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          city,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/star.png',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          rating,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Consumer<LocalDatabaseProvider>(
              builder: (context, localDatabaseProvider, child) {
                return FutureBuilder<bool>(
                  future: isFromLocal
                      ? localDatabaseProvider
                          .isFavouriteRestaurant(favourite?.id ?? '')
                      : localDatabaseProvider
                          .isFavouriteRestaurant(restaurant?.id ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    return IconButton(
                      icon: Icon(
                        isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline,
                        color: Colors.redAccent,
                        size: 24.0,
                      ),
                      onPressed: onFavourite,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
