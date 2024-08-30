import 'dart:convert';

class BodegaProductoModel {
  int bodega;
  String nombre;
  double existencia;
  bool poseeComponente;

  BodegaProductoModel({
    required this.bodega,
    required this.nombre,
    required this.existencia,
    required this.poseeComponente,
  });

  factory BodegaProductoModel.fromJson(String str) =>
      BodegaProductoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BodegaProductoModel.fromMap(Map<String, dynamic> json) =>
      BodegaProductoModel(
        bodega: json["bodega"],
        nombre: json["nombre"],
        existencia: json["existencia"],
        poseeComponente: json["posee_Componente"],
      );

  Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "nombre": nombre,
        "existencia": existencia,
        "posee_Componente": poseeComponente,
      };
}
