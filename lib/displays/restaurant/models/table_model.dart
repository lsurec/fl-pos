// To parse this JSON data, do
//
//     final mesaModel = mesaModelFromMap(jsonString);

import 'dart:convert';

class TableModel {
  TableModel({
    required this.elementoAsignado,
    required this.descripcion,
    required this.elementoId,
    required this.raiz,
    required this.nivel,
    required this.elementoAsignadoPadre,
    required this.estado,
    required this.ubicacionMesa,
    required this.objHeight,
    required this.objWidth,
    required this.objElementoAsignado,
    this.orders,
  });

  int elementoAsignado;
  String descripcion;
  String elementoId;
  int raiz;
  int nivel;
  int elementoAsignadoPadre;
  int estado;
  int ubicacionMesa;
  int objHeight;
  int objWidth;
  String objElementoAsignado;
  List<int>? orders;

  factory TableModel.fromJson(String str) =>
      TableModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TableModel.fromMap(Map<String, dynamic> json) => TableModel(
        elementoAsignado: json["elemento_Asignado"],
        descripcion: json["descripcion"],
        elementoId: json["elemento_Id"],
        raiz: json["raiz"],
        nivel: json["nivel"],
        elementoAsignadoPadre: json["elemento_Asignado_Padre"],
        estado: json["estado"],
        ubicacionMesa: json["ubicacion_Mesa"],
        objHeight: json["obj_Height"],
        objWidth: json["obj_Width"],
        objElementoAsignado: json["obj_Elemento_Asignado"],
      );

  Map<String, dynamic> toMap() => {
        "elemento_Asignado": elementoAsignado,
        "descripcion": descripcion,
        "elemento_Id": elementoId,
        "raiz": raiz,
        "nivel": nivel,
        "elemento_Asignado_Padre": elementoAsignadoPadre,
        "estado": estado,
        "ubicacion_Mesa": ubicacionMesa,
        "obj_Height": objHeight,
        "obj_Width": objWidth,
        "obj_Elemento_Asignado": objElementoAsignado,
      };
}
