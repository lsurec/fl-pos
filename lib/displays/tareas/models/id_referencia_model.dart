import 'dart:convert';

class IdReferenciaModel {
  int referencia;
  String descripcion;
  String referenciaId;
  dynamic orden;
  String fDesEstadoObjeto;

  IdReferenciaModel({
    required this.referencia,
    required this.descripcion,
    required this.referenciaId,
    required this.orden,
    required this.fDesEstadoObjeto,
  });

  factory IdReferenciaModel.fromJson(String str) =>
      IdReferenciaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IdReferenciaModel.fromMap(Map<String, dynamic> json) =>
      IdReferenciaModel(
        referencia: json["referencia"],
        descripcion: json["descripcion"],
        referenciaId: json["referencia_Id"],
        orden: json["orden"],
        fDesEstadoObjeto: json["fDes_Estado_Objeto"],
      );

  Map<String, dynamic> toMap() => {
        "referencia": referencia,
        "descripcion": descripcion,
        "referencia_Id": referenciaId,
        "orden": orden,
        "fDes_Estado_Objeto": fDesEstadoObjeto,
      };
}
