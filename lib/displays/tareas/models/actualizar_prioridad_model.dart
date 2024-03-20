import 'dart:convert';

class ActualizarPrioridadModel {
  int tarea;
  String userName;
  int prioridad;

  ActualizarPrioridadModel({
    required this.tarea,
    required this.userName,
    required this.prioridad,
  });

  factory ActualizarPrioridadModel.fromJson(String str) =>
      ActualizarPrioridadModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ActualizarPrioridadModel.fromMap(Map<String, dynamic> json) =>
      ActualizarPrioridadModel(
        tarea: json["tarea"],
        userName: json["userName"],
        prioridad: json["prioridad"],
      );

  Map<String, dynamic> toMap() => {
        "tarea": tarea,
        "userName": userName,
        "prioridad": prioridad,
      };
}
