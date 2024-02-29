import 'dart:convert';

class UsuarioModel {
    String email;
    String userName;
    String name;

    UsuarioModel({
        required this.email,
        required this.userName,
        required this.name,
    });

    factory UsuarioModel.fromJson(String str) => UsuarioModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(
        email: json["email"],
        userName: json["userName"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "userName": userName,
        "name": name,
    };
}
