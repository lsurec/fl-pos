import 'dart:convert';

class GarnishModel {
  int productoCaracteristica;
  int? productoCaracteristicaPadre;
  int nivel;
  int raiz;
  String descripcion;
  int producto;
  int unidadMedida;
  int? fProducto;
  int? fUnidadMedida;
  int? fBodega;
  int? cantidad;
  String desProducto;
  String desUnidadMedida;
  String? fDesProducto;
  String? fDesUnidadMedida;
  String? nomBodega;

  GarnishModel({
    required this.productoCaracteristica,
    required this.productoCaracteristicaPadre,
    required this.nivel,
    required this.raiz,
    required this.descripcion,
    required this.producto,
    required this.unidadMedida,
    required this.fProducto,
    required this.fUnidadMedida,
    required this.fBodega,
    required this.cantidad,
    required this.desProducto,
    required this.desUnidadMedida,
    required this.fDesProducto,
    required this.fDesUnidadMedida,
    required this.nomBodega,
  });

  factory GarnishModel.fromJson(String str) =>
      GarnishModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GarnishModel.fromMap(Map<String, dynamic> json) => GarnishModel(
        productoCaracteristica: json["producto_Caracteristica"],
        productoCaracteristicaPadre: json["producto_Caracteristica_Padre"],
        nivel: json["nivel"],
        raiz: json["raiz"],
        descripcion: json["descripcion"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        fProducto: json["f_Producto"],
        fUnidadMedida: json["f_Unidad_Medida"],
        fBodega: json["f_Bodega"],
        cantidad: json["cantidad"],
        desProducto: json["des_Producto"],
        desUnidadMedida: json["des_Unidad_Medida"],
        fDesProducto: json["f_Des_Producto"],
        fDesUnidadMedida: json["f_Des_Unidad_Medida"],
        nomBodega: json["nom_Bodega"],
      );

  Map<String, dynamic> toMap() => {
        "producto_Caracteristica": productoCaracteristica,
        "producto_Caracteristica_Padre": productoCaracteristicaPadre,
        "nivel": nivel,
        "raiz": raiz,
        "descripcion": descripcion,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "f_Producto": fProducto,
        "f_Unidad_Medida": fUnidadMedida,
        "f_Bodega": fBodega,
        "cantidad": cantidad,
        "des_Producto": desProducto,
        "des_Unidad_Medida": desUnidadMedida,
        "f_Des_Producto": fDesProducto,
        "f_Des_Unidad_Medida": fDesUnidadMedida,
        "nom_Bodega": nomBodega,
      };
}
