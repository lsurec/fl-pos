import 'dart:convert';

class CuentaCorrentistaModel {
  int id;
  String nombre;
  String direccion;
  String telefono;
  String correo;
  String nit;

  CuentaCorrentistaModel({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.nit,
  });

  factory CuentaCorrentistaModel.fromJson(String str) =>
      CuentaCorrentistaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CuentaCorrentistaModel.fromMap(Map<String, dynamic> json) =>
      CuentaCorrentistaModel(
        id: json["id"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        correo: json["correo"],
        nit: json["nit"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "direccion": direccion,
        "telefono": telefono,
        "correo": correo,
        "nit": nit,
      };
}
