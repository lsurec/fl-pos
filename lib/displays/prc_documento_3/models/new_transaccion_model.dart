import 'dart:convert';

class NewTransactionModel {
  int empresa;
  int localizacion;
  int estacionTrabajo;
  int tipoTransaccion;
  String usuario;
  int bodega;
  int producto;
  int unidadMedida;
  int cantidad;
  double monto;
  double tipoCambio;
  int moneda;
  double montoMoneda;
  int tipoPrecio;
  int documentoConsecutivoInterno;
  int transaccionConsecutivoInterno;

  NewTransactionModel({
    required this.empresa,
    required this.localizacion,
    required this.estacionTrabajo,
    required this.tipoTransaccion,
    required this.usuario,
    required this.bodega,
    required this.producto,
    required this.unidadMedida,
    required this.cantidad,
    required this.monto,
    required this.tipoCambio,
    required this.moneda,
    required this.montoMoneda,
    required this.tipoPrecio,
    required this.documentoConsecutivoInterno,
    required this.transaccionConsecutivoInterno,
  });

  factory NewTransactionModel.fromJson(String str) =>
      NewTransactionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NewTransactionModel.fromMap(Map<String, dynamic> json) =>
      NewTransactionModel(
        empresa: json["empresa"],
        localizacion: json["localizacion"],
        estacionTrabajo: json["estacionTrabajo"],
        tipoTransaccion: json["tipoTransaccion"],
        usuario: json["usuario"],
        bodega: json["bodega"],
        producto: json["producto"],
        unidadMedida: json["unidadMedida"],
        cantidad: json["cantidad"],
        monto: json["monto"].toDouble(),
        tipoCambio: json["tipoCambio"].toDouble(),
        moneda: json["moneda"],
        montoMoneda: json["montoMoneda"].toDouble(),
        tipoPrecio: json["tipoPrecio"],
        documentoConsecutivoInterno: json["documentoConsecutivoInterno"],
        transaccionConsecutivoInterno: json["transaccionConsecutivoInterno"],
      );

  Map<String, dynamic> toMap() => {
        "empresa": empresa,
        "localizacion": localizacion,
        "estacionTrabajo": estacionTrabajo,
        "tipoTransaccion": tipoTransaccion,
        "usuario": usuario,
        "bodega": bodega,
        "producto": producto,
        "unidadMedida": unidadMedida,
        "cantidad": cantidad,
        "monto": monto,
        "tipoCambio": tipoCambio,
        "moneda": moneda,
        "montoMoneda": montoMoneda,
        "tipoPrecio": tipoPrecio,
        "documentoConsecutivoInterno": documentoConsecutivoInterno,
        "transaccionConsecutivoInterno": transaccionConsecutivoInterno,
      };
}
