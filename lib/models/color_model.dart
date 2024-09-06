import 'dart:convert';

import 'package:flutter_post_printer_example/models/models.dart';

class ColorModel {
  int id;
  String valor;
  String nombre;
  TemaModel tema;

  ColorModel({
    required this.id,
    required this.valor,
    required this.nombre,
    required this.tema,
  });

  // Método para crear una instancia de ColorModel a partir de una cadena JSON
  factory ColorModel.fromJson(String str) =>
      ColorModel.fromMap(json.decode(str));

  // Método para convertir una instancia de ColorModel a una cadena JSON
  String toJson() => json.encode(toMap());

  // Método para crear una instancia de ColorModel a partir de un mapa
  factory ColorModel.fromMap(Map<String, dynamic> json) => ColorModel(
        id: json["id"],
        valor: json["valor"],
        nombre: json["nombre"],
        tema: json["theme"],
      );

  // Método para convertir una instancia de ColorModel a un mapa
  Map<String, dynamic> toMap() => {
        "id": id,
        "valor": valor,
        "nombre": nombre,
        "theme": tema,
      };
}
