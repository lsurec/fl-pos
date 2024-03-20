import 'dart:convert';

class NuevoUsuarioModel {
  int tarea;
  String userResInvi;
  String user;

  NuevoUsuarioModel({
    required this.tarea,
    required this.userResInvi,
    required this.user,
  });

  factory NuevoUsuarioModel.fromJson(String str) =>
      NuevoUsuarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NuevoUsuarioModel.fromMap(Map<String, dynamic> json) =>
      NuevoUsuarioModel(
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
