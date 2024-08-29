import 'dart:convert';

class ProductModel {
  int id;
  int producto;
  int unidadMedida;
  String productoId;
  String desProducto;
  String desUnidadMedida;
  int tipoProducto;
  dynamic orden;
  int rows;

  ProductModel({
    required this.id,
    required this.producto,
    required this.unidadMedida,
    required this.productoId,
    required this.desProducto,
    required this.desUnidadMedida,
    required this.tipoProducto,
    required this.orden,
    required this.rows,
  });

  factory ProductModel.fromJson(String str) =>
      ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        rows: json["rows"],
        id: json["id"],
        orden: json["orden"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        productoId: json["producto_Id"],
        desProducto: json["des_Producto"],
        desUnidadMedida: json["des_Unidad_Medida"],
        tipoProducto: json["tipo_Producto"],
      );

  Map<String, dynamic> toMap() => {
        "rows": rows,
        "id": id,
        "orden": orden,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "producto_Id": productoId,
        "des_Producto": desProducto,
        "des_Unidad_Medida": desUnidadMedida,
        "tipo_Producto": tipoProducto,
      };
}

class ObjetoProductoModel {
  int productoObjeto;
  int producto;
  int unidadMedida;
  int consecutivoInterno;
  String urlImg;

  ObjetoProductoModel({
    required this.productoObjeto,
    required this.producto,
    required this.unidadMedida,
    required this.consecutivoInterno,
    required this.urlImg,
  });

  factory ObjetoProductoModel.fromJson(String str) =>
      ObjetoProductoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObjetoProductoModel.fromMap(Map<String, dynamic> json) =>
      ObjetoProductoModel(
        productoObjeto: json["producto_Objeto"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        consecutivoInterno: json["consecutivo_Interno"],
        urlImg: json["url_Img"],
      );

  Map<String, dynamic> toMap() => {
        "producto_Objeto": productoObjeto,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "consecutivo_Interno": consecutivoInterno,
        "url_Img": urlImg,
      };
}
