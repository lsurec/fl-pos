import 'dart:convert';

class DestinationDetailModel {
  int consecutivoInterno;
  String id;
  String producto;
  String bodega;
  double cantidad;

  DestinationDetailModel({
    required this.consecutivoInterno,
    required this.id,
    required this.producto,
    required this.bodega,
    required this.cantidad,
  });

  factory DestinationDetailModel.fromJson(String str) =>
      DestinationDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DestinationDetailModel.fromMap(Map<String, dynamic> json) =>
      DestinationDetailModel(
        consecutivoInterno: json["consecutivo_Interno"],
        id: json["id"],
        producto: json["producto"],
        bodega: json["bodega"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toMap() => {
        "consecutivo_Interno": consecutivoInterno,
        "id": id,
        "producto": producto,
        "bodega": bodega,
        "cantidad": cantidad,
      };
}
