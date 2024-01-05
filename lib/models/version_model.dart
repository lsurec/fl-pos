import 'dart:convert';

class VersionModel {
  int referencia;
  String idVersion;
  String idApp;
  String url;
  int estado;

  VersionModel({
    required this.referencia,
    required this.idVersion,
    required this.idApp,
    required this.url,
    required this.estado,
  });

  factory VersionModel.fromJson(String str) =>
      VersionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VersionModel.fromMap(Map<String, dynamic> json) => VersionModel(
        referencia: json["referencia"],
        idVersion: json["id_Version"],
        idApp: json["id_App"],
        url: json["url"],
        estado: json["estado"],
      );

  Map<String, dynamic> toMap() => {
        "referencia": referencia,
        "id_Version": idVersion,
        "id_App": idApp,
        "url": url,
        "estado": estado,
      };
}
