import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String review;
  final String date;

  const ReviewCard(
      {super.key,
      required this.name,
      required this.review,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 60,
          maxHeight: 70,
          minWidth: MediaQuery.of(context).size.width / 1,
          maxWidth: MediaQuery.of(context).size.width / 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$name - ',
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                date,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            review,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
