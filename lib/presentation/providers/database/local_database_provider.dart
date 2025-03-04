import 'package:flutter/material.dart';
import 'package:restaurant_app/data/local/models/favourite.dart';
import 'package:restaurant_app/data/local/services/sqlite_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqliteService _sqliteService;

  LocalDatabaseProvider(this._sqliteService);

  String _message = '';
  String get message => _message;

  Favourite? _favourite;
  Favourite? get favourite => _favourite;

  List<Favourite>? _favouriteList;
  List<Favourite>? get favouriteList => _favouriteList;

  bool _isFavourite = true;
  bool get isFavourite => _isFavourite;

  Future<void> insertItem(Favourite value) async {
    try {
      final result = await _sqliteService.insertItem(value);
      final isError = result == 0;

      if (isError) {
        _message = 'Insert item fail';
        notifyListeners();
      } else {
        _message = 'Insert item success';
        notifyListeners();
      }
    } catch (e) {
      _message = 'An error occured';
      notifyListeners();
    }
  }

  Future<void> getAllItem() async {
    try {
      _favouriteList = await _sqliteService.getAllFavourite();
      _message = 'Get data success';
      notifyListeners();
    } catch (e) {
      _message = 'Get data fail';
      notifyListeners();
    }
  }

  Future<void> getItemById(String id) async {
    try {
      _favourite = await _sqliteService.getItemById(id);
      _message = 'Get data success';
      notifyListeners();
    } catch (e) {
      _message = 'Get data fail';
      notifyListeners();
    }
  }

  Future<void> updateItem(String id, Favourite value) async {
    try {
      final result = await _sqliteService.updateItem(id, favourite!);
      final isError = result == 0;

      if (isError) {
        _message = 'Update data fail';
        notifyListeners();
      } else {
        _message = 'Update data success';
        notifyListeners();
      }
    } catch (e) {
      _message = 'An error occured';
      notifyListeners();
    }
  }

  Future<void> removeItem(String id) async {
    try {
      final result = await _sqliteService.removeItem(id);
      final isError = result == 0;

      if (isError) {
        _message = 'Remove data fail';
        notifyListeners();
      } else {
        _message = 'Remove data success';
        notifyListeners();
      }
    } catch (e) {
      _message = 'An error occured';
      notifyListeners();
    }
  }

  void toggleFavourite(Favourite favourite, String id) {
    _isFavourite = !_isFavourite;
    notifyListeners();
    if (_isFavourite) {
      insertItem(favourite);
    } else {
      removeItem(id);
    }
  }

  Future<bool> isFavouriteRestaurant(String id) async {
    try {
      final fav = await _sqliteService.getItemById(id);
      return fav is Favourite;
    } catch (e) {
      _message = 'Check favourite status failed: $e';
      notifyListeners();
      return false;
    }
  }
}
