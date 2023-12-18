import 'package:flutter/material.dart';

class DetailsDocViewModel extends ChangeNotifier {
  //Mostrar boton para imprimir
  bool _showBlock = false;
  bool get showBlock => _showBlock;

  set showBlock(bool value) {
    _showBlock = value;
    notifyListeners();
  }
}
