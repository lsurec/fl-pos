import 'dart:convert';

class CuentaCorrentistaModel {
  int? cuenta;
  String cuentaCuenta;
  String nombre;
  String direccion;
  String telefono;
  String correo;
  String nit;
  int? grupoCuenta;

  CuentaCorrentistaModel({
    required this.cuenta,
    required this.cuentaCuenta,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.nit,
    required this.grupoCuenta,
  });

  factory CuentaCorrentistaModel.fromJson(String str) =>
      CuentaCorrentistaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CuentaCorrentistaModel.fromMap(Map<String, dynamic> json) =>
      CuentaCorrentistaModel(
        cuenta: json["cuenta"],
        cuentaCuenta: json["cuentaCuenta"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        correo: json["correo"],
        nit: json["nit"],
        grupoCuenta: json["grupoCuenta"],
      );

  Map<String, dynamic> toMap() => {
        "cuenta": cuenta,
        "cuentaCuenta": cuentaCuenta,
        "nombre": nombre,
        "direccion": direccion,
        "telefono": telefono,
        "correo": correo,
        "nit": nit,
        "grupoCuenta": grupoCuenta,
      };
}
