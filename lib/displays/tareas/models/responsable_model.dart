import 'dart:convert';

class ResponsableModel {
  String tUserName;
  String estado;
  String userName;
  DateTime fechaHora;
  String? mUserName;
  DateTime? mFechaHora;
  String? dHm;
  int consecutivoInterno;

  ResponsableModel({
    required this.tUserName,
    required this.estado,
    required this.userName,
    required this.fechaHora,
    required this.mUserName,
    required this.mFechaHora,
    required this.dHm,
    required this.consecutivoInterno,
  });

  factory ResponsableModel.fromJson(String str) =>
      ResponsableModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponsableModel.fromMap(Map<String, dynamic> json) =>
      ResponsableModel(
        tUserName: json["t_UserName"],
        estado: json["estado"],
        userName: json["userName"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        mUserName: json["m_UserName"],
        mFechaHora: json["m_Fecha_Hora"] == null
            ? null
            : DateTime.parse(json["m_Fecha_Hora"]),
        dHm: json["dHm"],
        consecutivoInterno: json["consecutivo_Interno"],
      );

  Map<String, dynamic> toMap() => {
        "t_UserName": tUserName,
        "estado": estado,
        "userName": userName,
        "fecha_Hora": fechaHora.toIso8601String(),
        "m_UserName": mUserName,
        "m_Fecha_Hora": mFechaHora?.toIso8601String(),
        "dHm": dHm,
        "consecutivo_Interno": consecutivoInterno,
      };
}
