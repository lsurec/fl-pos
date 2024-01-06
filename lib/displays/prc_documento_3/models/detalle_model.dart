import 'dart:convert';

class DetalleModel {
  String productoId;
  String unidadMedida;
  String simbolo;
  String desProducto;
  String bodega;
  double cantidad;
  String montoUMTipoMoneda;
  String montoTotalTipoMoneda;
  double monto;
  int moneda;
  String simboloMoneda;
  int tipoTransaccion;

  DetalleModel({
    required this.productoId,
    required this.unidadMedida,
    required this.simbolo,
    required this.desProducto,
    required this.bodega,
    required this.cantidad,
    required this.montoUMTipoMoneda,
    required this.montoTotalTipoMoneda,
    required this.monto,
    required this.moneda,
    required this.simboloMoneda,
    required this.tipoTransaccion,
  });

  factory DetalleModel.fromJson(String str) =>
      DetalleModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetalleModel.fromMap(Map<String, dynamic> json) => DetalleModel(
        productoId: json["producto_Id"],
        unidadMedida: json["unidad_Medida"],
        simbolo: json["simbolo"],
        desProducto: json["des_Producto"],
        bodega: json["bodega"],
        cantidad: json["cantidad"],
        montoUMTipoMoneda: json["monto_U_M_Tipo_Moneda"],
        montoTotalTipoMoneda: json["monto_Total_Tipo_Moneda"],
        monto: json["monto"]?.toDouble(),
        moneda: json["moneda"],
        simboloMoneda: json["simbolo_Moneda"],
        tipoTransaccion: json["tipo_Transaccion"],
      );

  Map<String, dynamic> toMap() => {
        "producto_Id": productoId,
        "unidad_Medida": unidadMedida,
        "simbolo": simbolo,
        "des_Producto": desProducto,
        "bodega": bodega,
        "cantidad": cantidad,
        "monto_U_M_Tipo_Moneda": montoUMTipoMoneda,
        "monto_Total_Tipo_Moneda": montoTotalTipoMoneda,
        "monto": monto,
        "moneda": moneda,
        "simbolo_Moneda": simboloMoneda,
        "tipo_Transaccion": tipoTransaccion,
      };
}
