import 'dart:convert';

class OriginDetailsModel {
  int consecutivoInterno;
  double disponible;
  String clase;
  dynamic marca;
  String id;
  String producto;
  String bodega;
  double cantidad;

  OriginDetailsModel({
    required this.consecutivoInterno,
    required this.disponible,
    required this.clase,
    required this.marca,
    required this.id,
    required this.producto,
    required this.bodega,
    required this.cantidad,
  });

  factory OriginDetailsModel.fromJson(String str) =>
      OriginDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OriginDetailsModel.fromMap(Map<String, dynamic> json) =>
      OriginDetailsModel(
        consecutivoInterno: json["consecutivo_Interno"],
        disponible: json["disponible"],
        clase: json["clase"],
        marca: json["marca"],
        id: json["id"],
        producto: json["producto"],
        bodega: json["bodega"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toMap() => {
        "consecutivo_Interno": consecutivoInterno,
        "disponible": disponible,
        "clase": clase,
        "marca": marca,
        "id": id,
        "producto": producto,
        "bodega": bodega,
        "cantidad": cantidad,
      };
}
