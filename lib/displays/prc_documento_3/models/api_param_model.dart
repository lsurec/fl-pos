import 'dart:convert';

class ApiParamModel {
  int parametro;
  String descripcion;
  int api;
  int tipoDato;
  String plantilla;
  int tipoParametro;
  String nomTipoDato;
  String nomTipoParametro;

  ApiParamModel({
    required this.parametro,
    required this.descripcion,
    required this.api,
    required this.tipoDato,
    required this.plantilla,
    required this.tipoParametro,
    required this.nomTipoDato,
    required this.nomTipoParametro,
  });

  factory ApiParamModel.fromJson(String str) =>
      ApiParamModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiParamModel.fromMap(Map<String, dynamic> json) => ApiParamModel(
        parametro: json["parametro"],
        descripcion: json["descripcion"],
        api: json["api"],
        tipoDato: json["tipo_Dato"],
        plantilla: json["plantilla"],
        tipoParametro: json["tipo_Parametro"],
        nomTipoDato: json["nom_Tipo_Dato"],
        nomTipoParametro: json["nom_Tipo_Parametro"],
      );

  Map<String, dynamic> toMap() => {
        "parametro": parametro,
        "descripcion": descripcion,
        "api": api,
        "tipo_Dato": tipoDato,
        "plantilla": plantilla,
        "tipo_Parametro": tipoParametro,
        "nom_Tipo_Dato": nomTipoDato,
        "nom_Tipo_Parametro": nomTipoParametro,
      };
}
