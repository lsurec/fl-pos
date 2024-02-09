import 'dart:convert';

class DocConvertModel {
  Documento documento;
  Documento tIpoDocumento;
  Documento serieDocumento;
  Documento empresa;
  Documento localizacion;
  Documento estacion;
  Documento fechaReg;

  DocConvertModel({
    required this.documento,
    required this.tIpoDocumento,
    required this.serieDocumento,
    required this.empresa,
    required this.localizacion,
    required this.estacion,
    required this.fechaReg,
  });

  factory DocConvertModel.fromJson(String str) =>
      DocConvertModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocConvertModel.fromMap(Map<String, dynamic> json) => DocConvertModel(
        documento: Documento.fromMap(json["documento"]),
        tIpoDocumento: Documento.fromMap(json["tIpoDocumento"]),
        serieDocumento: Documento.fromMap(json["serieDocumento"]),
        empresa: Documento.fromMap(json["empresa"]),
        localizacion: Documento.fromMap(json["localizacion"]),
        estacion: Documento.fromMap(json["estacion"]),
        fechaReg: Documento.fromMap(json["fechaReg"]),
      );

  Map<String, dynamic> toMap() => {
        "documento": documento.toMap(),
        "tIpoDocumento": tIpoDocumento.toMap(),
        "serieDocumento": serieDocumento.toMap(),
        "empresa": empresa.toMap(),
        "localizacion": localizacion.toMap(),
        "estacion": estacion.toMap(),
        "fechaReg": fechaReg.toMap(),
      };
}

class Documento {
  Documento();

  factory Documento.fromJson(String str) => Documento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Documento.fromMap(Map<String, dynamic> json) => Documento();

  Map<String, dynamic> toMap() => {};
}
