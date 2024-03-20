import 'dart:convert';

class EliminarUsuarioModel {
  int tarea;
  String userResInvi;
  String user;

  EliminarUsuarioModel({
    required this.tarea,
    required this.userResInvi,
    required this.user,
  });

  factory EliminarUsuarioModel.fromJson(String str) =>
      EliminarUsuarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EliminarUsuarioModel.fromMap(Map<String, dynamic> json) =>
      EliminarUsuarioModel(
        tarea: json["tarea"],
        userResInvi: json["user_Res_Invi"],
        user: json["user"],
      );

  Map<String, dynamic> toMap() => {
        "tarea": tarea,
        "user_Res_Invi": userResInvi,
        "user": user,
      };
}
