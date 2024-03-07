import 'dart:convert';

class ResNuevoUsuarioModel {
  int tareaUserName;
  int tarea;
  String userNameT;
  int estado;
  String userName;
  DateTime fechaHora;
  dynamic mUserName;
  dynamic mFechaHora;

  ResNuevoUsuarioModel({
    required this.tareaUserName,
    required this.tarea,
    required this.userNameT,
    required this.estado,
    required this.userName,
    required this.fechaHora,
    required this.mUserName,
    required this.mFechaHora,
  });

  factory ResNuevoUsuarioModel.fromJson(String str) =>
      ResNuevoUsuarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResNuevoUsuarioModel.fromMap(Map<String, dynamic> json) =>
      ResNuevoUsuarioModel(
        tareaUserName: json["tarea_UserName"],
        tarea: json["tarea"],
        userNameT: json["userName_T"],
        estado: json["estado"],
        userName: json["userName"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        mUserName: json["m_UserName"],
        mFechaHora: json["m_Fecha_Hora"],
      );

  Map<String, dynamic> toMap() => {
        "tarea_UserName": tareaUserName,
        "tarea": tarea,
        "userName_T": userNameT,
        "estado": estado,
        "userName": userName,
        "fecha_Hora": fechaHora.toIso8601String(),
        "m_UserName": mUserName,
        "m_Fecha_Hora": mFechaHora,
      };
}
