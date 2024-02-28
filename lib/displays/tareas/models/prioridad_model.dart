import 'dart:convert';

class PrioridadModel {
  int nivelPrioridad;
  String id;
  String nombre;
  String descripcion;
  dynamic tarea;
  String backColor;
  bool defaultNp;

  PrioridadModel({
    required this.nivelPrioridad,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tarea,
    required this.backColor,
    required this.defaultNp,
  });

  factory PrioridadModel.fromJson(String str) =>
      PrioridadModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrioridadModel.fromMap(Map<String, dynamic> json) => PrioridadModel(
        nivelPrioridad: json["nivel_Prioridad"],
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        tarea: json["tarea"],
        backColor: json["backColor"],
        defaultNp: json["default_NP"],
      );

  Map<String, dynamic> toMap() => {
        "nivel_Prioridad": nivelPrioridad,
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "tarea": tarea,
        "backColor": backColor,
        "default_NP": defaultNp,
      };
}
