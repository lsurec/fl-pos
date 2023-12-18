import 'dart:convert';

class TipoTransaccionModel {
  int tipoTransaccion;
  String descripcion;

  TipoTransaccionModel({
    required this.tipoTransaccion,
    required this.descripcion,
  });

  factory TipoTransaccionModel.fromJson(String str) =>
      TipoTransaccionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoTransaccionModel.fromMap(Map<String, dynamic> json) =>
      TipoTransaccionModel(
        tipoTransaccion: json["tipo_Transaccion"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Transaccion": tipoTransaccion,
        "descripcion": descripcion,
      };
}
