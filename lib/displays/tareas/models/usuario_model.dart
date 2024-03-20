import 'dart:convert';

class UsuarioModel {
  String email;
  String userName;
  String name;
  bool select;

  UsuarioModel({
    required this.email,
    required this.userName,
    required this.name,
    required this.select,
  });

  factory UsuarioModel.fromJson(String str) =>
      UsuarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(
        email: json["email"],
        userName: json["userName"],
        name: json["name"],
        select: json["select"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "userName": userName,
        "name": name,
        "select": select,
      };
}
