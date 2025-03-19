import 'dart:convert';

class ViewStockModel {
  String nomBodega;
  String desClaseProducto;
  String desProducto;
  String desUnidadMedida;
  String productoId;
  double cantidad;
  double costoTotal;

  ViewStockModel({
    required this.nomBodega,
    required this.desClaseProducto,
    required this.desProducto,
    required this.desUnidadMedida,
    required this.productoId,
    required this.cantidad,
    required this.costoTotal,
  });

  factory ViewStockModel.fromJson(String str) =>
      ViewStockModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewStockModel.fromMap(Map<String, dynamic> json) => ViewStockModel(
        nomBodega: json["nom_Bodega"],
        desClaseProducto: json["des_Clase_Producto"],
        desProducto: json["des_Producto"],
        desUnidadMedida: json["des_Unidad_Medida"],
        productoId: json["producto_Id"],
        cantidad: json["cantidad"],
        costoTotal: json["costo_Total"],
      );

  Map<String, dynamic> toMap() => {
        "nom_Bodega": nomBodega,
        "des_Clase_Producto": desClaseProducto,
        "des_Producto": desProducto,
        "des_Unidad_Medida": desUnidadMedida,
        "producto_Id": productoId,
        "cantidad": cantidad,
        "costo_Total": costoTotal,
      };
}
