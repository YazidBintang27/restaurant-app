import 'restaurant.dart';

class RestaurantList {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    return RestaurantList(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );
  }
}
