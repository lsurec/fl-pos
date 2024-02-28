import 'dart:convert';

class TipoTareaModel {
  int tipoTarea;
  String descripcion;
  bool documento;
  dynamic descripcionAlterna;

  TipoTareaModel({
    required this.tipoTarea,
    required this.descripcion,
    required this.documento,
    required this.descripcionAlterna,
  });

  factory TipoTareaModel.fromJson(String str) =>
      TipoTareaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoTareaModel.fromMap(Map<String, dynamic> json) => TipoTareaModel(
        tipoTarea: json["tipo_Tarea"],
        descripcion: json["descripcion"],
        documento: json["documento"],
        descripcionAlterna: json["descripcion_alterna"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Tarea": tipoTarea,
        "descripcion": descripcion,
        "documento": documento,
        "descripcion_alterna": descripcionAlterna,
      };
}

class DescripcionAlternaClass {
  DescripcionAlternaClass();

  factory DescripcionAlternaClass.fromJson(String str) =>
      DescripcionAlternaClass.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DescripcionAlternaClass.fromMap(Map<String, dynamic> json) =>
      DescripcionAlternaClass();

  Map<String, dynamic> toMap() => {};
}
