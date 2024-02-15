import 'dart:convert';

class DocConvertModel {
  int documento;
  int tipoDocumento;
  String serieDocumento;
  int empresa;
  int localizacion;
  int estacion;
  int fechaReg;

  DocConvertModel({
    required this.documento,
    required this.tipoDocumento,
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
        documento: json["documento"],
        tipoDocumento: json["tipoDocumento"],
        serieDocumento: json["serieDocumento"],
        empresa: json["empresa"],
        localizacion: json["localizacion"],
        estacion: json["estacion"],
        fechaReg: json["fechaReg"],
      );

  Map<String, dynamic> toMap() => {
        "documento": documento,
        "tipoDocumento": tipoDocumento,
        "serieDocumento": serieDocumento,
        "empresa": empresa,
        "localizacion": localizacion,
        "estacion": estacion,
        "fechaReg": fechaReg,
      };
}
