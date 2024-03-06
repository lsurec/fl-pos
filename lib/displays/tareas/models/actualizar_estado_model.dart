import 'dart:convert';

class ActualizarEstadoModel {
  int tarea;
  String userName;
  int estado;

  ActualizarEstadoModel({
    required this.tarea,
    required this.userName,
    required this.estado,
  });

  factory ActualizarEstadoModel.fromJson(String str) =>
      ActualizarEstadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ActualizarEstadoModel.fromMap(Map<String, dynamic> json) =>
      ActualizarEstadoModel(
        tarea: json["tarea"],
        userName: json["userName"],
        estado: json["estado"],
      );

  Map<String, dynamic> toMap() => {
        "tarea": tarea,
        "userName": userName,
        "estado": estado,
      };
}
