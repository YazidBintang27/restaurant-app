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
      error: json["error"],
      founded: json["founded"],
      restaurants: List<Restaurant>.from(
        json["restaurants"].map((x) => Restaurant.fromJson(x)),
      ),
    );
  }
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: (json["rating"] is int) ? (json["rating"] as int).toDouble() : json["rating"],
    );
  }
}