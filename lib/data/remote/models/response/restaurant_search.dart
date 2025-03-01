import 'restaurant.dart';

class RestaurantSearch {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  RestaurantSearch({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearch.fromJson(Map<String, dynamic> json) {
    return RestaurantSearch(
      error: json['error'],
      founded: json['founded'],
      restaurants: (json['restaurants'] as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList(),
    );
  }
}
