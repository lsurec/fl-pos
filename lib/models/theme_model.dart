import 'dart:convert';

import 'package:flutter/material.dart';

class ThemeModel {
  int id;
  String descripcion;
  ThemeData theme;

  ThemeModel({
    required this.id,
    required this.descripcion,
    required this.theme,
  });

  factory ThemeModel.fromJson(String str) =>
      ThemeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ThemeModel.fromMap(Map<String, dynamic> json) => ThemeModel(
        id: json["id"],
        descripcion: json["descripcion"],
        theme: json["theme"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "descripcion": descripcion,
        "theme": theme,
      };
}
