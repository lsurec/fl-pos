import 'dart:convert';

class ViewStockModel {
  int bodega;
  String nomBodega;
  int claseProducto;
  String desClaseProducto;
  int producto;
  int unidadMedida;
  String desProducto;
  String desUnidadMedida;
  String productoId;
  double cantidad;
  double costoTotal;

  ViewStockModel({
    required this.bodega,
    required this.nomBodega,
    required this.claseProducto,
    required this.desClaseProducto,
    required this.producto,
    required this.unidadMedida,
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
        bodega: json["bodega"],
        nomBodega: json["nom_Bodega"],
        claseProducto: json["clase_Producto"],
        desClaseProducto: json["des_Clase_Producto"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        desProducto: json["des_Producto"],
        desUnidadMedida: json["des_Unidad_Medida"],
        productoId: json["producto_Id"],
        cantidad: json["cantidad"],
        costoTotal: json["costo_Total"],
      );

  Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "nom_Bodega": nomBodega,
        "clase_Producto": claseProducto,
        "des_Clase_Producto": desClaseProducto,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "des_Producto": desProducto,
        "des_Unidad_Medida": desUnidadMedida,
        "producto_Id": productoId,
        "cantidad": cantidad,
        "costo_Total": costoTotal,
      };
}
