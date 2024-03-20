import 'dart:convert';

class ComentarModel {
  int tarea;
  String userName;
  String comentario;

  ComentarModel({
    required this.tarea,
    required this.userName,
    required this.comentario,
  });

  factory ComentarModel.fromJson(String str) =>
      ComentarModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ComentarModel.fromMap(Map<String, dynamic> json) => ComentarModel(
        tarea: json["tarea"],
        userName: json["userName"],
        comentario: json["comentario"],
      );

  Map<String, dynamic> toMap() => {
        "tarea": tarea,
        "userName": userName,
        "comentario": comentario,
      };
}
