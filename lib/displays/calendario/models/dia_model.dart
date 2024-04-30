import 'dart:convert';

class DiaModel {
  String name;
  int value;
  int indexWeek;

  DiaModel({
    required this.name,
    required this.value,
    required this.indexWeek,
  });

  factory DiaModel.fromJson(String str) => DiaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiaModel.fromMap(Map<String, dynamic> json) => DiaModel(
        name: json["name"],
        value: json["value"],
        indexWeek: json["indexWeek"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "value": value,
        "indexWeek": indexWeek,
      };
}
