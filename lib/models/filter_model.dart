import 'dart:convert';

class FilterModel {
  int id;
  String descripcion;

  FilterModel({
    required this.id,
    required this.descripcion,
  });

  factory FilterModel.fromJson(String str) =>
      FilterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FilterModel.fromMap(Map<String, dynamic> json) => FilterModel(
        id: json["id"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "descripcion": descripcion,
      };
}
