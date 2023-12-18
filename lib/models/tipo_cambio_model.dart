import 'dart:convert';

class TipoCambioModel {
  double tipoCambio;

  TipoCambioModel({
    required this.tipoCambio,
  });

  factory TipoCambioModel.fromJson(String str) =>
      TipoCambioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoCambioModel.fromMap(Map<String, dynamic> json) => TipoCambioModel(
        tipoCambio: json["tipo_Cambio"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Cambio": tipoCambio,
      };
}
