import 'dart:convert';

class EstacionModel {
  int estacionTrabajo;
  String nombre;
  String descripcion;

  EstacionModel({
    required this.estacionTrabajo,
    required this.nombre,
    required this.descripcion,
  });

  factory EstacionModel.fromJson(String str) =>
      EstacionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstacionModel.fromMap(Map<String, dynamic> json) => EstacionModel(
        estacionTrabajo: json["estacion_Trabajo"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "estacion_Trabajo": estacionTrabajo,
        "nombre": nombre,
        "descripcion": descripcion,
      };

  // Sobrescribimos el método de comparación
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstacionModel &&
          runtimeType == other.runtimeType &&
          estacionTrabajo == other.estacionTrabajo &&
          nombre == other.nombre &&
          descripcion == other.descripcion;

  @override
  int get hashCode =>
      estacionTrabajo.hashCode ^ nombre.hashCode ^ descripcion.hashCode;
}
