import 'package:flutter_post_printer_example/models/models.dart';

class MenuModel {
  MenuModel({
    required this.name,
    // required this.id,
    required this.route,
    required this.children,
    this.idChild,
    this.idFather,
    required this.display,
  });

  String name;
  // int id;
  String route;
  int? idFather;
  int? idChild;
  List<MenuModel> children;
  DisplayModel? display;
}

class MenuData {
  MenuData({
    required this.application,
    required this.children,
  });

  ApplicationModel application;
  List<DisplayModel> children;
}
