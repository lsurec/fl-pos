import 'dart:convert';

class PrecioDiaModel {
  double montoCalculado;
  int cantidadDia;

  PrecioDiaModel({
    required this.montoCalculado,
    required this.cantidadDia,
  });

  factory PrecioDiaModel.fromJson(String str) =>
      PrecioDiaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrecioDiaModel.fromMap(Map<String, dynamic> json) => PrecioDiaModel(
        montoCalculado: json["monto_Calculado"].toDouble(),
        cantidadDia: json["catidad_Dia"],
      );

  Map<String, dynamic> toMap() => {
        "monto_Calculado": montoCalculado,
        "catidad_Dia": cantidadDia,
      };
}
