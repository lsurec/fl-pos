import 'dart:convert';

class BodegaProductoModel {
  int bodega;
  String nombre;
  double existencia;

  BodegaProductoModel({
    required this.bodega,
    required this.nombre,
    required this.existencia,
  });

  factory BodegaProductoModel.fromJson(String str) =>
      BodegaProductoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BodegaProductoModel.fromMap(Map<String, dynamic> json) =>
      BodegaProductoModel(
        bodega: json["bodega"],
        nombre: json["nombre"],
        existencia: json["existencia"],
      );

  Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "nombre": nombre,
        "existencia": existencia,
      };
}
