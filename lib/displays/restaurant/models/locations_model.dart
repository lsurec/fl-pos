import 'dart:convert';

class LocationModel {
  int id;
  int elementoAsignado;
  String descripcion;
  String elementoId;
  int raiz;
  int nivel;
  dynamic elementoAsignadoPadre;
  int estado;
  int ubicacionMesa;
  int objHeight;
  int objWidth;

  LocationModel({
    required this.id,
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
  });

  factory LocationModel.fromJson(String str) =>
      LocationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
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
      );

  Map<String, dynamic> toMap() => {
        "id": id,
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
      };
}
