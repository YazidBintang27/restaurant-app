import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:restaurant_app/data/models/response/restaurant.dart';
import 'package:restaurant_app/utils/api_constant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final Function() onTap;
  const RestaurantCard(
      {super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  '${ApiConstant.baseUrl}${ApiConstant.imagePath}/${restaurant.pictureId}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox.square(
              dimension: 8,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox.square(
                  dimension: 6,
                ),
                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedLocation01,
                      color: Theme.of(context).colorScheme.primary,
                      size: 14.0,
                    ),
                    const SizedBox.square(
                      dimension: 4,
                    ),
                    Expanded(
                      child: Text(
                        restaurant.city,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/star.png', width: 14, height: 14,),
                    const SizedBox.square(dimension: 4,),
                    Expanded(
                      child: Text(restaurant.rating.toString(), style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis, maxLines: 1,)
                    )
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
