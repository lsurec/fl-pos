import 'dart:convert';

class TipoTransaccionModel {
  int tipoTransaccion;
  String descripcion;
  int tipo;
  bool altCantidad;

  TipoTransaccionModel({
    required this.tipoTransaccion,
    required this.descripcion,
    required this.tipo,
    required this.altCantidad,
  });

  factory TipoTransaccionModel.fromJson(String str) =>
      TipoTransaccionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoTransaccionModel.fromMap(Map<String, dynamic> json) =>
      TipoTransaccionModel(
        tipoTransaccion: json["tipo_Transaccion"],
        descripcion: json["descripcion"],
        tipo: json["tipo"],
        altCantidad: json["alt_Cantidad"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "tipo_Transaccion": tipoTransaccion,
        "descripcion": descripcion,
        "tipo": tipo,
        "alt_Cantidad": altCantidad,
      };
}
