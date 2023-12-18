import 'dart:convert';

class GetDocModel {
  int consecutivoInterno;
  String estructura;
  String userName;
  String fechaHora;
  int tipoEstructura;
  int estado;
  dynamic mUserName;
  dynamic mFechaHora;
  String idUnc;

  GetDocModel({
    required this.consecutivoInterno,
    required this.estructura,
    required this.userName,
    required this.fechaHora,
    required this.tipoEstructura,
    required this.estado,
    required this.mUserName,
    required this.mFechaHora,
    required this.idUnc,
  });

  factory GetDocModel.fromJson(String str) =>
      GetDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetDocModel.fromMap(Map<String, dynamic> json) => GetDocModel(
        consecutivoInterno: json["consecutivo_Interno"],
        estructura: json["estructura"],
        userName: json["userName"],
        fechaHora: json["fecha_Hora"],
        tipoEstructura: json["tipo_Estructura"],
        estado: json["estado"],
        mUserName: json["m_UserName"],
        mFechaHora: json["m_Fecha_Hora"],
        idUnc: json["id_Unc"],
      );

  Map<String, dynamic> toMap() => {
        "consecutivo_Interno": consecutivoInterno,
        "estructura": estructura,
        "userName": userName,
        "fecha_Hora": fechaHora,
        "tipo_Estructura": tipoEstructura,
        "estado": estado,
        "m_UserName": mUserName,
        "m_Fecha_Hora": mFechaHora,
        "id_Unc": idUnc,
      };
}
