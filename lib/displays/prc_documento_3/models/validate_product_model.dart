import 'dart:convert';

class ValidateProductModel {
  String sku;
  String productoDesc;
  String bodega;
  String tipoDoc;
  String serie;
  List<String> mensajes;

  ValidateProductModel({
    required this.sku,
    required this.productoDesc,
    required this.bodega,
    required this.tipoDoc,
    required this.serie,
    required this.mensajes,
  });

  factory ValidateProductModel.fromJson(String str) =>
      ValidateProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ValidateProductModel.fromMap(Map<String, dynamic> json) =>
      ValidateProductModel(
        sku: json["sku"],
        productoDesc: json["productoDesc"],
        bodega: json["bodega"],
        tipoDoc: json["tipoDoc"],
        serie: json["serie"],
        mensajes: List<String>.from(json["mensajes"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "sku": sku,
        "productoDesc": productoDesc,
        "bodega": bodega,
        "tipoDoc": tipoDoc,
        "serie": serie,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x)),
      };
}
