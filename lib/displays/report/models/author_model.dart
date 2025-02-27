import 'dart:convert';

class AuthorModel {
  String nombre;
  String website;

  AuthorModel({
    required this.nombre,
    required this.website,
  });

  factory AuthorModel.fromJson(String str) => AuthorModel.fromMap(
        json.decode(str),
      );

  String toJson() => json.encode(
        toMap(),
      );

  factory AuthorModel.fromMap(Map<String, dynamic> json) => AuthorModel(
        nombre: json["nombre"],
        website: json["website"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "website": website,
      };
}
