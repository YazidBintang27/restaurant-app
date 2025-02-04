import 'package:flutter/material.dart';
import 'package:restaurant_app/data/models/request/restaurant_add_review_request.dart';
import 'package:restaurant_app/data/service/api_service.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantReviewProvider(this._apiService);

  Future<void> addReview(RestaurantAddReviewRequest request) async {
    await _apiService.addReviewRestaurant(request);
  }
}
