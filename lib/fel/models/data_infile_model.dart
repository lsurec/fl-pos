import 'dart:convert';

class DataInfileModel {
  String usuarioFirma;
  String llaveFirma;
  String usuarioApi;
  String llaveApi;
  String identificador;
  String docXml;

  DataInfileModel({
    required this.usuarioFirma,
    required this.llaveFirma,
    required this.usuarioApi,
    required this.llaveApi,
    required this.identificador,
    required this.docXml,
  });

  factory DataInfileModel.fromJson(String str) =>
      DataInfileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataInfileModel.fromMap(Map<String, dynamic> json) => DataInfileModel(
        usuarioFirma: json["usuarioFirma"],
        llaveFirma: json["llaveFirma"],
        usuarioApi: json["usuarioApi"],
        llaveApi: json["llaveApi"],
        identificador: json["identificador"],
        docXml: json["docXML"],
      );

  Map<String, dynamic> toMap() => {
        "usuarioFirma": usuarioFirma,
        "llaveFirma": llaveFirma,
        "usuarioApi": usuarioApi,
        "llaveApi": llaveApi,
        "identificador": identificador,
        "docXML": docXml,
      };
}
