import 'package:flutter/material.dart';

class HomeRestaurantViewModel extends ChangeNotifier {
  //controlar proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
