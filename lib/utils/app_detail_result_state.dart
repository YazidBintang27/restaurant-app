import 'package:restaurant_app/data/remote/models/response/restaurant_detail.dart';

sealed class AppDetailResultState {}

class AppDetailNoneState extends AppDetailResultState {}

class AppDetailLoadingState extends AppDetailResultState {}

class AppDetailErrorState extends AppDetailResultState {
  final String error;

  AppDetailErrorState({required this.error});
}

class AppDetailLoadedState extends AppDetailResultState {
  final Restaurant data;

  AppDetailLoadedState({required this.data});
}
