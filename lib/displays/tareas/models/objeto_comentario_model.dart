import 'dart:convert';

class ObjetoComentarioModel {
  int tareaComentarioObjeto;
  String objetoNombre;
  String observacion1;
  String objetoSize;
  String objetoUrl;

  ObjetoComentarioModel({
    required this.tareaComentarioObjeto,
    required this.objetoNombre,
    required this.observacion1,
    required this.objetoSize,
    required this.objetoUrl,
  });

  factory ObjetoComentarioModel.fromJson(String str) =>
      ObjetoComentarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObjetoComentarioModel.fromMap(Map<String, dynamic> json) =>
      ObjetoComentarioModel(
        tareaComentarioObjeto: json["tarea_Comentario_Objeto"],
        objetoNombre: json["objeto_Nombre"],
        observacion1: json["observacion_1"],
        objetoSize: json["objeto_Size"],
        objetoUrl: json["objeto_URL"],
      );

  Map<String, dynamic> toMap() => {
        "tarea_Comentario_Objeto": tareaComentarioObjeto,
        "objeto_Nombre": objetoNombre,
        "observacion_1": observacion1,
        "objeto_Size": objetoSize,
        "objeto_URL": objetoUrl,
      };
}
