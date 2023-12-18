import 'dart:convert';

class SerieModel {
  int tipoDocumento;
  String? serieDocumento;
  int empresa;
  int bodega;
  String? descripcion;
  int serieIni;
  int serieFin;
  int estado;
  String? campo01;
  String? campo02;
  String? campo03;
  String? campo04;
  String? campo05;
  String? campo06;
  String? campo07;
  String? campo08;
  String? campo09;
  String? campo10;
  int documentoDisp;
  int documentoAviso;
  dynamic documentoFrecuencia;
  String? fechaHora;
  dynamic docDet;
  dynamic limiteImpresion;
  String? userName;
  String? mFechaHora;
  String? mUserName;
  dynamic orden;
  int grupo;
  dynamic opcVenta;
  bool bloquearImprimir;
  String? desTipoDocumento;

  SerieModel({
    required this.tipoDocumento,
    required this.serieDocumento,
    required this.empresa,
    required this.bodega,
    required this.descripcion,
    required this.serieIni,
    required this.serieFin,
    required this.estado,
    required this.campo01,
    required this.campo02,
    required this.campo03,
    required this.campo04,
    required this.campo05,
    required this.campo06,
    required this.campo07,
    required this.campo08,
    required this.campo09,
    required this.campo10,
    required this.documentoDisp,
    required this.documentoAviso,
    required this.documentoFrecuencia,
    required this.fechaHora,
    required this.docDet,
    required this.limiteImpresion,
    required this.userName,
    required this.mFechaHora,
    required this.mUserName,
    required this.orden,
    required this.grupo,
    required this.opcVenta,
    required this.bloquearImprimir,
    required this.desTipoDocumento,
  });

  factory SerieModel.fromJson(String str) =>
      SerieModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SerieModel.fromMap(Map<String, dynamic> json) => SerieModel(
        tipoDocumento: json["tipo_Documento"],
        serieDocumento: json["serie_Documento"],
        empresa: json["empresa"],
        bodega: json["bodega"],
        descripcion: json["descripcion"],
        serieIni: json["serie_Ini"],
        serieFin: json["serie_Fin"],
        estado: json["estado"],
        campo01: json["campo01"],
        campo02: json["campo02"],
        campo03: json["campo03"],
        campo04: json["campo04"],
        campo05: json["campo05"],
        campo06: json["campo06"],
        campo07: json["campo07"],
        campo08: json["campo08"],
        campo09: json["campo09"],
        campo10: json["campo10"],
        documentoDisp: json["documento_Disp"],
        documentoAviso: json["documento_Aviso"],
        documentoFrecuencia: json["documento_Frecuencia"],
        fechaHora: json["fecha_Hora"],
        docDet: json["doc_Det"],
        limiteImpresion: json["limite_Impresion"],
        userName: json["userName"],
        mFechaHora: json["m_Fecha_Hora"],
        mUserName: json["m_UserName"],
        orden: json["orden"],
        grupo: json["grupo"],
        opcVenta: json["opc_Venta"],
        bloquearImprimir: json["bloquear_Imprimir"],
        desTipoDocumento: json["des_Tipo_Documento"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Documento": tipoDocumento,
        "serie_Documento": serieDocumento,
        "empresa": empresa,
        "bodega": bodega,
        "descripcion": descripcion,
        "serie_Ini": serieIni,
        "serie_Fin": serieFin,
        "estado": estado,
        "campo01": campo01,
        "campo02": campo02,
        "campo03": campo03,
        "campo04": campo04,
        "campo05": campo05,
        "campo06": campo06,
        "campo07": campo07,
        "campo08": campo08,
        "campo09": campo09,
        "campo10": campo10,
        "documento_Disp": documentoDisp,
        "documento_Aviso": documentoAviso,
        "documento_Frecuencia": documentoFrecuencia,
        "fecha_Hora": fechaHora,
        "doc_Det": docDet,
        "limite_Impresion": limiteImpresion,
        "userName": userName,
        "m_Fecha_Hora": mFechaHora,
        "m_UserName": mUserName,
        "orden": orden,
        "grupo": grupo,
        "opc_Venta": opcVenta,
        "bloquear_Imprimir": bloquearImprimir,
        "des_Tipo_Documento": desTipoDocumento,
      };
}
