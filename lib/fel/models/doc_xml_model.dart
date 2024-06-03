import 'dart:convert';

class DocXmlModel {
  int id;
  String userName;
  DateTime fechaHora;
  int dConsecutivoInterno;
  String xmlContenido;
  int certificadorDte;
  String xmlDocumentoFirmado;
  bool respuesta;
  String mensaje;
  String dIdUnc;

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
  });

  factory DocXmlModel.fromJson(String str) =>
      DocXmlModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocXmlModel.fromMap(Map<String, dynamic> json) => DocXmlModel(
        id: json["id"],
        userName: json["userName"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        dConsecutivoInterno: json["d_Consecutivo_Interno"],
        xmlContenido: json["xml_Contenido"],
        certificadorDte: json["certificador_DTE"],
        xmlDocumentoFirmado: json["xml_Documento_Firmado"],
        respuesta: json["respuesta"],
        mensaje: json["mensaje"],
        dIdUnc: json["d_Id_Unc"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userName": userName,
        "fecha_Hora": fechaHora.toIso8601String(),
        "d_Consecutivo_Interno": dConsecutivoInterno,
        "xml_Contenido": xmlContenido,
        "certificador_DTE": certificadorDte,
        "xml_Documento_Firmado": xmlDocumentoFirmado,
        "respuesta": respuesta,
        "mensaje": mensaje,
        "d_Id_Unc": dIdUnc,
      };
}
