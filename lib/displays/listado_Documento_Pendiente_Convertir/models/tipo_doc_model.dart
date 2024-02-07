import 'dart:convert';

class TipoDocModel {
  int tipoDocumento;
  String fDesTipoDocumento;

  TipoDocModel({
    required this.tipoDocumento,
    required this.fDesTipoDocumento,
  });

  factory TipoDocModel.fromJson(String str) =>
      TipoDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoDocModel.fromMap(Map<String, dynamic> json) => TipoDocModel(
        tipoDocumento: json["tipo_Documento"],
        fDesTipoDocumento: json["fDes_Tipo_Documento"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Documento": tipoDocumento,
        "fDes_Tipo_Documento": fDesTipoDocumento,
      };
}
