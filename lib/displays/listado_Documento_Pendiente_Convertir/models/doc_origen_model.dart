import 'dart:convert';

class DocOrigenModel {
  int consecutivoInterno;
  int disponible;
  String clase;
  dynamic marca;
  String id;
  String producto;
  String bodega;
  int cantidad;

  DocOrigenModel({
    required this.consecutivoInterno,
    required this.disponible,
    required this.clase,
    required this.marca,
    required this.id,
    required this.producto,
    required this.bodega,
    required this.cantidad,
  });

  factory DocOrigenModel.fromJson(String str) =>
      DocOrigenModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocOrigenModel.fromMap(Map<String, dynamic> json) => DocOrigenModel(
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
