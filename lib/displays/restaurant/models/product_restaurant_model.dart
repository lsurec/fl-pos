import 'dart:convert';

class ProductRestaurantModel {
  int producto;
  int unidadMedida;
  String productoId;
  String? objetoImagen;
  String objBackColor;
  String objTextForeColor;
  String imageWidth;
  String imageHeight;
  String objWidth;
  String objHeight;
  String desProductoUM;
  String desProductoUM1;
  String desProducto;
  String desUnidadMedida;
  dynamic textFontSize;

  ProductRestaurantModel({
    required this.producto,
    required this.unidadMedida,
    required this.productoId,
    required this.objetoImagen,
    required this.objBackColor,
    required this.objTextForeColor,
    required this.imageWidth,
    required this.imageHeight,
    required this.objWidth,
    required this.objHeight,
    required this.desProductoUM,
    required this.desProductoUM1,
    required this.desProducto,
    required this.desUnidadMedida,
    required this.textFontSize,
  });

  factory ProductRestaurantModel.fromJson(String str) =>
      ProductRestaurantModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductRestaurantModel.fromMap(Map<String, dynamic> json) =>
      ProductRestaurantModel(
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        productoId: json["producto_Id"],
        objetoImagen: json["objeto_Imagen"],
        objBackColor: json["obj_BackColor"],
        objTextForeColor: json["obj_Text_ForeColor"],
        imageWidth: json["image_Width"],
        imageHeight: json["image_Height"],
        objWidth: json["obj_Width"],
        objHeight: json["obj_Height"],
        desProductoUM: json["des_Producto_U_M"],
        desProductoUM1: json["des_Producto_U_M_1"],
        desProducto: json["des_Producto"],
        desUnidadMedida: json["des_Unidad_Medida"],
        textFontSize: json["text_FontSize"],
      );

  Map<String, dynamic> toMap() => {
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "producto_Id": productoId,
        "objeto_Imagen": objetoImagen,
        "obj_BackColor": objBackColor,
        "obj_Text_ForeColor": objTextForeColor,
        "image_Width": imageWidth,
        "image_Height": imageHeight,
        "obj_Width": objWidth,
        "obj_Height": objHeight,
        "des_Producto_U_M": desProductoUM,
        "des_Producto_U_M_1": desProductoUM1,
        "des_Producto": desProducto,
        "des_Unidad_Medida": desUnidadMedida,
        "text_FontSize": textFontSize,
      };
}
