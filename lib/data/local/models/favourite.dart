class Favourite {
  String id;
  String name;
  String image;
  String city;
  double rating;

  Favourite(
      {required this.id,
      required this.name,
      required this.image,
      required this.city,
      required this.rating});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'city': city,
      'rating': rating
    };
  }

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        city: json['city'],
        rating: json['rating']);
  }
}
