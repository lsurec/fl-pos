import 'dart:convert';

class TypeDocModel {
  int tipoDocumento;
  String fDesTipoDocumento;

  TypeDocModel({
    required this.tipoDocumento,
    required this.fDesTipoDocumento,
  });

  factory TypeDocModel.fromJson(String str) =>
      TypeDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TypeDocModel.fromMap(Map<String, dynamic> json) => TypeDocModel(
        tipoDocumento: json["tipo_Documento"],
        fDesTipoDocumento: json["fDes_Tipo_Documento"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Documento": tipoDocumento,
        "fDes_Tipo_Documento": fDesTipoDocumento,
      };
}
