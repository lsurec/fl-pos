import 'dart:convert';

class UnitarioModel {
  int id;
  double precioU;
  String descripcion;
  bool precio;
  int moneda;

  UnitarioModel({
    required this.id,
    required this.precioU,
    required this.descripcion,
    required this.precio,
    required this.moneda,
  });

  factory UnitarioModel.fromJson(String str) =>
      UnitarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnitarioModel.fromMap(Map<String, dynamic> json) => UnitarioModel(
        id: json["id"],
        precioU: json["precioU"]?.toDouble(),
        descripcion: json["descripcion"],
        precio: json["precio"],
        moneda: json["moneda"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "precioU": precioU,
        "descripcion": descripcion,
        "precio": precio,
        "moneda": moneda,
      };
}
