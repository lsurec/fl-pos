import 'dart:convert';

class PrecioModel {
  int bodega;
  int producto;
  int unidadMedida;
  int tipoPrecio;
  int moneda;
  double precioUnidad;
  dynamic descuentoPor;
  dynamic desTipoPrecio;
  String monedaNombre;
  String monedaIsoCode;
  dynamic precioOrden;
  dynamic tipoPrecioOrden;

  PrecioModel({
    required this.bodega,
    required this.producto,
    required this.unidadMedida,
    required this.tipoPrecio,
    required this.moneda,
    required this.precioUnidad,
    required this.descuentoPor,
    required this.desTipoPrecio,
    required this.monedaNombre,
    required this.monedaIsoCode,
    required this.precioOrden,
    required this.tipoPrecioOrden,
  });

  factory PrecioModel.fromJson(String str) =>
      PrecioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrecioModel.fromMap(Map<String, dynamic> json) => PrecioModel(
        bodega: json["bodega"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        tipoPrecio: json["tipo_Precio"],
        moneda: json["moneda"],
        precioUnidad: json["precio_Unidad"],
        descuentoPor: json["descuento_Por"],
        desTipoPrecio: json["des_Tipo_Precio"],
        monedaNombre: json["moneda_Nombre"],
        monedaIsoCode: json["moneda_ISO_Code"],
        precioOrden: json["precio_Orden"],
        tipoPrecioOrden: json["tipo_Precio_Orden"],
      );

  Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "tipo_Precio": tipoPrecio,
        "moneda": moneda,
        "precio_Unidad": precioUnidad,
        "descuento_Por": descuentoPor,
        "des_Tipo_Precio": desTipoPrecio,
        "moneda_Nombre": monedaNombre,
        "moneda_ISO_Code": monedaIsoCode,
        "precio_Orden": precioOrden,
        "tipo_Precio_Orden": tipoPrecioOrden,
      };
}
