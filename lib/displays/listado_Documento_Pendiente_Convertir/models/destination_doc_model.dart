import 'dart:convert';

class DestinationDocModel {
  int fTipoDocumento;
  String fSerieDocumento;
  int fEmpresa;
  String documento;
  String serie;

  DestinationDocModel({
    required this.fTipoDocumento,
    required this.fSerieDocumento,
    required this.fEmpresa,
    required this.documento,
    required this.serie,
  });

  factory DestinationDocModel.fromJson(String str) =>
      DestinationDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DestinationDocModel.fromMap(Map<String, dynamic> json) =>
      DestinationDocModel(
        fTipoDocumento: json["f_Tipo_Documento"],
        fSerieDocumento: json["f_Serie_Documento"],
        fEmpresa: json["f_Empresa"],
        documento: json["documento"],
        serie: json["serie"],
      );

  Map<String, dynamic> toMap() => {
        "f_Tipo_Documento": fTipoDocumento,
        "f_Serie_Documento": fSerieDocumento,
        "f_Empresa": fEmpresa,
        "documento": documento,
        "serie": serie,
      };
}
