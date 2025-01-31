import 'dart:async';

import 'package:dio/dio.dart';
import 'package:restaurant_app/data/models/response/restaurant_add_review.dart';
import 'package:restaurant_app/data/models/request/restaurant_add_review_request.dart';
import 'package:restaurant_app/data/models/response/restaurant_detail.dart';
import 'package:restaurant_app/data/models/response/restaurant_list.dart';
import 'package:restaurant_app/data/models/response/restaurant_search.dart';
import 'package:restaurant_app/utils/api_constant.dart';

class ApiService {
  Dio dio = Dio();

  Future<RestaurantList> getListRestaurant() async {
    try {
      final response = await dio
          .get('${ApiConstant.baseUrl}${ApiConstant.list}',
              options: Options(
                  headers: {'Accept': 'application/json'},
                  contentType: 'application/json'))
          .timeout(const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Connection time out'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        RestaurantList restaurantList = RestaurantList.fromJson(data);
        return restaurantList;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(String id) async {
    try {
      final response = await dio
          .get('${ApiConstant.baseUrl}${ApiConstant.detail}/$id',
              options: Options(
                  headers: {'Accept': 'application/json'},
                  contentType: 'application/json'))
          .timeout(const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Connection time out'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        RestaurantDetail restaurantDetail = RestaurantDetail.fromJson(data);
        return restaurantDetail;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantSearch> searchRestaurant(String query) async {
    try {
      final response = await dio
          .get('${ApiConstant.baseUrl}${ApiConstant.search}',
              queryParameters: {'q': query},
              options: Options(
                  headers: {'Accept': 'application/json'},
                  contentType: 'application/json'))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Connection time out'),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        RestaurantSearch restaurantSearch = RestaurantSearch.fromJson(data);
        return restaurantSearch;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantAddReview> addReviewRestaurant(
      RestaurantAddReviewRequest restaurantAddReview) async {
    try {
      final response = await dio
          .post('${ApiConstant.baseUrl}${ApiConstant.addReview}',
              options: Options(
                  headers: {'Accept': 'application/json'},
                  contentType: 'application/json'),
              data: restaurantAddReview)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Connectin time out'),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        RestaurantAddReview restaurantAddReview =
            RestaurantAddReview.fromJson(data);
        return restaurantAddReview;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }
}
