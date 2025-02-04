class RestaurantAddReviewRequest {
  String id;

  String name;

  String review;

  RestaurantAddReviewRequest(
      {required this.id, required this.name, required this.review});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'review': review,
    };
  }
}
