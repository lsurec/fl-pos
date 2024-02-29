import 'dart:convert';

class PeriodicidadModel {
  int tipoPeriodicidad;
  String descripcion;

  PeriodicidadModel({
    required this.tipoPeriodicidad,
    required this.descripcion,
  });

  factory PeriodicidadModel.fromJson(String str) =>
      PeriodicidadModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PeriodicidadModel.fromMap(Map<String, dynamic> json) =>
      PeriodicidadModel(
        tipoPeriodicidad: json["tipo_Periodicidad"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Periodicidad": tipoPeriodicidad,
        "descripcion": descripcion,
      };
}
