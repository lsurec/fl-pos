import 'dart:convert';

class ComentarioModel {
  int tareaComentario;
  int tarea;
  String comentario;
  DateTime fechaHora;
  String userName;
  String nameUser;

  ComentarioModel({
    required this.tareaComentario,
    required this.tarea,
    required this.comentario,
    required this.fechaHora,
    required this.userName,
    required this.nameUser,
  });

  factory ComentarioModel.fromJson(String str) =>
      ComentarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ComentarioModel.fromMap(Map<String, dynamic> json) => ComentarioModel(
        tareaComentario: json["tarea_Comentario"],
        tarea: json["tarea"],
        comentario: json["comentario"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        userName: json["userName"],
        nameUser: json["nameUser"],
      );

  Map<String, dynamic> toMap() => {
        "tarea_Comentario": tareaComentario,
        "tarea": tarea,
        "comentario": comentario,
        "fecha_Hora": fechaHora.toIso8601String(),
        "userName": userName,
        "nameUser": nameUser,
      };
}
