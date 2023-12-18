import 'dart:convert';

class DocXmlModel {
  int id;
  String userName;
  String fechaHora;
  int dConsecutivoInterno;
  String xmlContenido;
  int certificadorDte;
  String xmlDocumentoFirmado;
  bool respuesta;
  dynamic mensaje;
  String dIdUnc;
  bool certificacion;
  bool anulacion;

  DocXmlModel({
    required this.id,
    required this.userName,
    required this.fechaHora,
    required this.dConsecutivoInterno,
    required this.xmlContenido,
    required this.certificadorDte,
    required this.xmlDocumentoFirmado,
    required this.respuesta,
    required this.mensaje,
    required this.dIdUnc,
    required this.certificacion,
    required this.anulacion,
  });

  factory DocXmlModel.fromJson(String str) =>
      DocXmlModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocXmlModel.fromMap(Map<String, dynamic> json) => DocXmlModel(
        id: json["id"],
        userName: json["userName"],
        fechaHora: json["fecha_Hora"],
        dConsecutivoInterno: json["d_Consecutivo_Interno"],
        xmlContenido: json["xml_Contenido"],
        certificadorDte: json["certificador_DTE"],
        xmlDocumentoFirmado: json["xml_Documento_Firmado"],
        respuesta: json["respuesta"],
        mensaje: json["mensaje"],
        dIdUnc: json["d_Id_Unc"],
        certificacion: json["certificacion"],
        anulacion: json["anulacion"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userName": userName,
        "fecha_Hora": fechaHora,
        "d_Consecutivo_Interno": dConsecutivoInterno,
        "xml_Contenido": xmlContenido,
        "certificador_DTE": certificadorDte,
        "xml_Documento_Firmado": xmlDocumentoFirmado,
        "respuesta": respuesta,
        "mensaje": mensaje,
        "d_Id_Unc": dIdUnc,
        "certificacion": certificacion,
        "anulacion": anulacion,
      };
}
