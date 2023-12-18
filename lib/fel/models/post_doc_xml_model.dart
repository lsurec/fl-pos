import 'dart:convert';

class PostDocXmlModel {
  String usuario;
  String documento;
  String uuid;
  String documentoCompleto;

  PostDocXmlModel({
    required this.usuario,
    required this.documento,
    required this.uuid,
    required this.documentoCompleto,
  });

  factory PostDocXmlModel.fromJson(String str) =>
      PostDocXmlModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostDocXmlModel.fromMap(Map<String, dynamic> json) => PostDocXmlModel(
        usuario: json["usuario"],
        documento: json["documento"],
        uuid: json["uuid"],
        documentoCompleto: json["documentoCompleto"],
      );

  Map<String, dynamic> toMap() => {
        "usuario": usuario,
        "documento": documento,
        "uuid": uuid,
        "documentoCompleto": documentoCompleto,
      };
}
