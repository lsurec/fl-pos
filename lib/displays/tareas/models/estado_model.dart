import 'dart:convert';

class EstadoModel {
  int estado;
  String descripcion;

  EstadoModel({
    required this.estado,
    required this.descripcion,
  });

  factory EstadoModel.fromJson(String str) =>
      EstadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstadoModel.fromMap(Map<String, dynamic> json) => EstadoModel(
        estado: json["estado"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "estado": estado,
        "descripcion": descripcion,
      };
}
