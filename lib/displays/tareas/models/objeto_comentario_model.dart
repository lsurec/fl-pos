import 'dart:convert';

class ObjetoComentarioModel {
  int tareaComentarioObjeto;
  String objetoNombre;
  String objetoSize;
  String objetoUrl;

  ObjetoComentarioModel({
    required this.tareaComentarioObjeto,
    required this.objetoNombre,
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
        objetoSize: json["objeto_Size"],
        objetoUrl: json["objeto_URL"],
      );

  Map<String, dynamic> toMap() => {
        "tarea_Comentario_Objeto": tareaComentarioObjeto,
        "objeto_Nombre": objetoNombre,
        "objeto_Size": objetoSize,
        "objeto_URL": objetoUrl,
      };
}
