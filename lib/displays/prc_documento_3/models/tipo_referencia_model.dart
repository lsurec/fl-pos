import 'dart:convert';

class TipoReferenciaModel {
  int tipoReferencia;
  String descripcion;
  int estado;

  TipoReferenciaModel({
    required this.tipoReferencia,
    required this.descripcion,
    required this.estado,
  });

  factory TipoReferenciaModel.fromJson(String str) =>
      TipoReferenciaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoReferenciaModel.fromMap(Map<String, dynamic> json) =>
      TipoReferenciaModel(
        tipoReferencia: json["tipo_Referencia"],
        descripcion: json["descripcion"],
        estado: json["estado"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Referencia": tipoReferencia,
        "descripcion": descripcion,
        "estado": estado,
      };
}
