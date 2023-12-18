import 'dart:convert';

class CredencialModel {
  int certificadorDteId;
  int empresa;
  String campoNombre;
  String campoValor;
  int consecutivoInterno;
  String fechaHora;

  CredencialModel({
    required this.certificadorDteId,
    required this.empresa,
    required this.campoNombre,
    required this.campoValor,
    required this.consecutivoInterno,
    required this.fechaHora,
  });

  factory CredencialModel.fromJson(String str) =>
      CredencialModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CredencialModel.fromMap(Map<String, dynamic> json) => CredencialModel(
        certificadorDteId: json["certificador_DTE_ID"],
        empresa: json["empresa"],
        campoNombre: json["campo_Nombre"],
        campoValor: json["campo_Valor"],
        consecutivoInterno: json["consecutivo_Interno"],
        fechaHora: json["fecha_Hora"],
      );

  Map<String, dynamic> toMap() => {
        "certificador_DTE_ID": certificadorDteId,
        "empresa": empresa,
        "campo_Nombre": campoNombre,
        "campo_Valor": campoValor,
        "consecutivo_Interno": consecutivoInterno,
        "fecha_Hora": fechaHora,
      };
}
