import 'dart:convert';

class BodegaProductoModel {
  int bodega;
  String nombre;
  double existencia;
  bool poseeComponente;
  int orden;

  BodegaProductoModel({
    required this.bodega,
    required this.nombre,
    required this.existencia,
    required this.poseeComponente,
    required this.orden,
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
        orden: json["orden"],
      );

  Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "nombre": nombre,
        "existencia": existencia,
        "posee_Componente": poseeComponente,
        "orden": orden,
      };
}
