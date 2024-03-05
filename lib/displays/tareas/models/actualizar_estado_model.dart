import 'dart:convert';

class ActualizarEstadoModel {
  int tareaComentario;
  int tarea;
  DateTime fechaHora;
  String userName;
  String comentario;
  int estado;

  ActualizarEstadoModel({
    required this.tareaComentario,
    required this.tarea,
    required this.fechaHora,
    required this.userName,
    required this.comentario,
    required this.estado,
  });

  factory ActualizarEstadoModel.fromJson(String str) =>
      ActualizarEstadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ActualizarEstadoModel.fromMap(Map<String, dynamic> json) =>
      ActualizarEstadoModel(
        tareaComentario: json["tarea_Comentario"],
        tarea: json["tarea"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        userName: json["userName"],
        comentario: json["comentario"],
        estado: json["estado"],
      );

  Map<String, dynamic> toMap() => {
        "tarea_Comentario": tareaComentario,
        "tarea": tarea,
        "fecha_Hora": fechaHora.toIso8601String(),
        "userName": userName,
        "comentario": comentario,
        "estado": estado,
      };
}
