import 'dart:convert';

class FactorConversionModel {
  int factorConversion;
  int producto;
  int unidadMedida;
  int tipoFactorConversion;
  int tipoPrecio;
  double factorVenta;
  String presentacion;
  String desTipoPrecio;
  double precioUnidad;
  dynamic descuentoPor;
  dynamic descuentoVal;
  dynamic fechaIni;
  dynamic fechaFin;
  String nombreMoneda;
  int moneda;
  String desTipoFactorConversion;
  dynamic abreviaturaTipoFactorConversion;
  String desProducto;
  String descripcionAltProducto;
  String iDProducto;
  String desUnidadMedida;

  FactorConversionModel({
    required this.factorConversion,
    required this.producto,
    required this.unidadMedida,
    required this.tipoFactorConversion,
    required this.tipoPrecio,
    required this.factorVenta,
    required this.presentacion,
    required this.desTipoPrecio,
    required this.precioUnidad,
    required this.descuentoPor,
    required this.descuentoVal,
    required this.fechaIni,
    required this.fechaFin,
    required this.nombreMoneda,
    required this.moneda,
    required this.desTipoFactorConversion,
    required this.abreviaturaTipoFactorConversion,
    required this.desProducto,
    required this.descripcionAltProducto,
    required this.iDProducto,
    required this.desUnidadMedida,
  });

  factory FactorConversionModel.fromJson(String str) =>
      FactorConversionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FactorConversionModel.fromMap(Map<String, dynamic> json) =>
      FactorConversionModel(
        factorConversion: json["factor_Conversion"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        tipoFactorConversion: json["tipo_Factor_Conversion"],
        tipoPrecio: json["tipo_Precio"],
        factorVenta: json["factor_Venta"],
        presentacion: json["presentacion"],
        desTipoPrecio: json["des_Tipo_Precio"],
        precioUnidad: json["precio_Unidad"],
        descuentoPor: json["descuento_Por"],
        descuentoVal: json["descuento_Val"],
        fechaIni: json["fecha_Ini"],
        fechaFin: json["fecha_Fin"],
        nombreMoneda: json["nombre_Moneda"],
        moneda: json["moneda"],
        desTipoFactorConversion: json["des_Tipo_Factor_Conversion"],
        abreviaturaTipoFactorConversion:
            json["abreviatura_Tipo_Factor_Conversion"],
        desProducto: json["des_Producto"],
        descripcionAltProducto: json["descripcion_Alt_Producto"],
        iDProducto: json["iD_Producto"],
        desUnidadMedida: json["des_Unidad_Medida"],
      );

  Map<String, dynamic> toMap() => {
        "factor_Conversion": factorConversion,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "tipo_Factor_Conversion": tipoFactorConversion,
        "tipo_Precio": tipoPrecio,
        "factor_Venta": factorVenta,
        "presentacion": presentacion,
        "des_Tipo_Precio": desTipoPrecio,
        "precio_Unidad": precioUnidad,
        "descuento_Por": descuentoPor,
        "descuento_Val": descuentoVal,
        "fecha_Ini": fechaIni,
        "fecha_Fin": fechaFin,
        "nombre_Moneda": nombreMoneda,
        "moneda": moneda,
        "des_Tipo_Factor_Conversion": desTipoFactorConversion,
        "abreviatura_Tipo_Factor_Conversion": abreviaturaTipoFactorConversion,
        "des_Producto": desProducto,
        "descripcion_Alt_Producto": descripcionAltProducto,
        "iD_Producto": iDProducto,
        "des_Unidad_Medida": desUnidadMedida,
      };
}
