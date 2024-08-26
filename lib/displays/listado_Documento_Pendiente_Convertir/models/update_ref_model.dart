import 'dart:convert';

class UpdateRefModel {
  String? descripcion;
  String? referenciaID;
  int empresa;
  int? referencia;
  String? observacion;
  DateTime? fechaIni;
  DateTime? fechaFin;
  int? tipoReferencia;
  String mUser;
  String? observacion2;
  String? observacion3;

  UpdateRefModel({
    required this.descripcion,
    required this.referenciaID,
    required this.empresa,
    required this.referencia,
    required this.observacion,
    required this.fechaIni,
    required this.fechaFin,
    required this.tipoReferencia,
    required this.mUser,
    required this.observacion2,
    required this.observacion3,
  });

  factory UpdateRefModel.fromJson(String str) =>
      UpdateRefModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateRefModel.fromMap(Map<String, dynamic> json) => UpdateRefModel(
        descripcion: json["descripcion"],
        referenciaID: json["referenciaID"],
        empresa: json["empresa"],
        referencia: json["referencia"],
        observacion: json["observacion"],
        fechaIni:
            json["fechaIni"] != null ? DateTime.parse(json["fechaIni"]) : null,
        fechaFin:
            json["fechaFin"] != null ? DateTime.parse(json["fechaFin"]) : null,
        tipoReferencia: json["tipoReferencia"],
        mUser: json["mUser"],
        observacion2: json["observacion2"],
        observacion3: json["observacion3"],
      );

  Map<String, dynamic> toMap() => {
        "descripcion": descripcion,
        "referenciaID": referenciaID,
        "empresa": empresa,
        "referencia": referencia,
        "observacion": observacion,
        "fechaIni": fechaIni?.toIso8601String(),
        "fechaFin": fechaFin?.toIso8601String(),
        "tipoReferencia": tipoReferencia,
        "mUser": mUser,
        "observacion2": observacion2,
        "observacion3": observacion3,
      };
}
