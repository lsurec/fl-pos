import 'dart:convert';

class OriginDetailModel {
  int relacionConsecutivoInterno;
  double disponible;
  String clase;
  dynamic marca;
  String id;
  String productoDescripcion;
  String bodegaDescripcion;
  double cantidad;
  int producto; //para tener erroe pasar a string
  int unidadMedida;
  String fDesUnidadMedida;
  int tipoPrecio;
  int bodega;
  double monto;
  int transaccionConsecutivoInterno;

  OriginDetailModel({
    required this.relacionConsecutivoInterno,
    required this.disponible,
    required this.clase,
    required this.marca,
    required this.id,
    required this.productoDescripcion,
    required this.bodegaDescripcion,
    required this.cantidad,
    required this.producto,
    required this.unidadMedida,
    required this.fDesUnidadMedida,
    required this.tipoPrecio,
    required this.bodega,
    required this.monto,
    required this.transaccionConsecutivoInterno,
  });

  factory OriginDetailModel.fromJson(String str) =>
      OriginDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OriginDetailModel.fromMap(Map<String, dynamic> json) =>
      OriginDetailModel(
        relacionConsecutivoInterno: json["relacion_Consecutivo_Interno"],
        disponible: json["disponible"],
        clase: json["clase"],
        marca: json["marca"],
        id: json["id"],
        productoDescripcion: json["producto_Descripcion"],
        bodegaDescripcion: json["bodega_Descripcion"],
        cantidad: json["cantidad"],
        producto: json["producto"],
        unidadMedida: json["unidad_Medida"],
        fDesUnidadMedida: json["fDes_Unidad_Medida"],
        tipoPrecio: json["tipo_Precio"],
        bodega: json["bodega"],
        monto: json["monto"],
        transaccionConsecutivoInterno: json["transaccion_Consecutivo_Interno"],
      );

  Map<String, dynamic> toMap() => {
        "relacion_Consecutivo_Interno": relacionConsecutivoInterno,
        "disponible": disponible,
        "clase": clase,
        "marca": marca,
        "id": id,
        "producto_Descripcion": productoDescripcion,
        "bodega_Descripcion": bodegaDescripcion,
        "cantidad": cantidad,
        "producto": producto,
        "unidad_Medida": unidadMedida,
        "fDes_Unidad_Medida": fDesUnidadMedida,
        "tipo_Precio": tipoPrecio,
        "bodega": bodega,
        "monto": monto,
        "transaccion_Consecutivo_Interno": transaccionConsecutivoInterno,
      };
}

class DetailOriginDocInterModel {
  double disponibleMod;
  bool checked;
  OriginDetailModel detalle;

  DetailOriginDocInterModel({
    required this.disponibleMod,
    required this.checked,
    required this.detalle,
  });

  factory DetailOriginDocInterModel.fromJson(String str) =>
      DetailOriginDocInterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailOriginDocInterModel.fromMap(Map<String, dynamic> json) =>
      DetailOriginDocInterModel(
        disponibleMod: json["disponibleMod"],
        checked: json["checked"],
        detalle: OriginDetailModel.fromMap(json["detalle"] ?? {}),
      );

  Map<String, dynamic> toMap() => {
        "disponibleMod": disponibleMod,
        "checked": checked,
        "detalle": detalle.toMap(),
      };
}
