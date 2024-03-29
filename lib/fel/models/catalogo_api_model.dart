import 'dart:convert';

class CatalogoApiModel {
  int api;
  String nombreApi;
  String urlApi;
  bool reqAutorizacion;
  int tipoMetodo;
  int tipoRespuesta;
  String urlDocumentacion;
  int certificadorDte;
  String userName;
  String fechaHora;
  int tipoServicio;
  String nomTipoMetodo;
  String nomTipoRespuesta;
  String nomCertificador;
  String nomTipoServicio;
  String nodoFirmaDocumentoResponse;

  CatalogoApiModel({
    required this.api,
    required this.nombreApi,
    required this.urlApi,
    required this.reqAutorizacion,
    required this.tipoMetodo,
    required this.tipoRespuesta,
    required this.urlDocumentacion,
    required this.certificadorDte,
    required this.userName,
    required this.fechaHora,
    required this.tipoServicio,
    required this.nomTipoMetodo,
    required this.nomTipoRespuesta,
    required this.nomCertificador,
    required this.nomTipoServicio,
    required this.nodoFirmaDocumentoResponse,
  });

  factory CatalogoApiModel.fromJson(String str) =>
      CatalogoApiModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CatalogoApiModel.fromMap(Map<String, dynamic> json) =>
      CatalogoApiModel(
        api: json["api"],
        nombreApi: json["nombre_Api"],
        urlApi: json["url_Api"],
        reqAutorizacion: json["req_Autorizacion"],
        tipoMetodo: json["tipo_Metodo"],
        tipoRespuesta: json["tipo_Respuesta"],
        urlDocumentacion: json["url_Documentacion"],
        certificadorDte: json["certificador_DTE"],
        userName: json["userName"],
        fechaHora: json["fecha_Hora"],
        tipoServicio: json["tipo_Servicio"],
        nomTipoMetodo: json["nom_Tipo_Metodo"],
        nomTipoRespuesta: json["nom_Tipo_Respuesta"],
        nomCertificador: json["nom_Certificador"],
        nomTipoServicio: json["nom_Tipo_Servicio"],
        nodoFirmaDocumentoResponse: json["nodo_FirmaDocumentoResponse"],
      );

  Map<String, dynamic> toMap() => {
        "api": api,
        "nombre_Api": nombreApi,
        "url_Api": urlApi,
        "req_Autorizacion": reqAutorizacion,
        "tipo_Metodo": tipoMetodo,
        "tipo_Respuesta": tipoRespuesta,
        "url_Documentacion": urlDocumentacion,
        "certificador_DTE": certificadorDte,
        "userName": userName,
        "fecha_Hora": fechaHora,
        "tipo_Servicio": tipoServicio,
        "nom_Tipo_Metodo": nomTipoMetodo,
        "nom_Tipo_Respuesta": nomTipoRespuesta,
        "nom_Certificador": nomCertificador,
        "nom_Tipo_Servicio": nomTipoServicio,
        "nodo_FirmaDocumentoResponse": nodoFirmaDocumentoResponse,
      };
}
