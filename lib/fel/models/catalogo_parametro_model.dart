import 'dart:convert';

class CatalogoParametroModel {
  int parametro;
  String descripcion;
  int api;
  int tipoDato;
  String plantilla;
  int tipoParametro;
  String nomTipoDato;
  String nomTipoParametro;

  CatalogoParametroModel({
    required this.parametro,
    required this.descripcion,
    required this.api,
    required this.tipoDato,
    required this.plantilla,
    required this.tipoParametro,
    required this.nomTipoDato,
    required this.nomTipoParametro,
  });

  factory CatalogoParametroModel.fromJson(String str) =>
      CatalogoParametroModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CatalogoParametroModel.fromMap(Map<String, dynamic> json) =>
      CatalogoParametroModel(
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
