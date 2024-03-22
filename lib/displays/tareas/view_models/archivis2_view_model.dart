// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class Archivos2ViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  
}
