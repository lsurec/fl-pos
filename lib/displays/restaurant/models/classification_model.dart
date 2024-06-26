import 'dart:convert';

class ClassificationModel {
  int clasificacion;
  String desClasificacion;
  String objBackColor;
  String objTextForeColor;
  String imageWidth;
  String imageHeight;
  String objWidth;
  String objHeight;
  int poseeNodos;

  ClassificationModel({
    required this.clasificacion,
    required this.desClasificacion,
    required this.objBackColor,
    required this.objTextForeColor,
    required this.imageWidth,
    required this.imageHeight,
    required this.objWidth,
    required this.objHeight,
    required this.poseeNodos,
  });

  factory ClassificationModel.fromJson(String str) =>
      ClassificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClassificationModel.fromMap(Map<String, dynamic> json) =>
      ClassificationModel(
        clasificacion: json["clasificacion"],
        desClasificacion: json["des_Clasificacion"],
        objBackColor: json["obj_BackColor"],
        objTextForeColor: json["obj_Text_ForeColor"],
        imageWidth: json["image_Width"],
        imageHeight: json["image_Height"],
        objWidth: json["obj_Width"],
        objHeight: json["obj_Height"],
        poseeNodos: json["posee_Nodos"],
      );

  Map<String, dynamic> toMap() => {
        "clasificacion": clasificacion,
        "des_Clasificacion": desClasificacion,
        "obj_BackColor": objBackColor,
        "obj_Text_ForeColor": objTextForeColor,
        "image_Width": imageWidth,
        "image_Height": imageHeight,
        "obj_Width": objWidth,
        "obj_Height": objHeight,
        "posee_Nodos": poseeNodos,
      };
}
