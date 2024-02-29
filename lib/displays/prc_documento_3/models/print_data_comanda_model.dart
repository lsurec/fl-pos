import 'dart:convert';

class PrintDataComandaModel {
  String idDocumento;
  String tipoDocumento;
  String serieDocumento;
  String iDDocumentoRef;
  String comensal;
  int consecutivoInterno;
  String productoId;
  String unidadMedida;
  String desProducto;
  String bodega;
  double cantidad;
  int tipoTransaccion;
  String printerName;
  int dConsecutivoInterno;

  PrintDataComandaModel({
    required this.idDocumento,
    required this.tipoDocumento,
    required this.serieDocumento,
    required this.iDDocumentoRef,
    required this.comensal,
    required this.consecutivoInterno,
    required this.productoId,
    required this.unidadMedida,
    required this.desProducto,
    required this.bodega,
    required this.cantidad,
    required this.tipoTransaccion,
    required this.printerName,
    required this.dConsecutivoInterno,
  });

  factory PrintDataComandaModel.fromJson(String str) =>
      PrintDataComandaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintDataComandaModel.fromMap(Map<String, dynamic> json) =>
      PrintDataComandaModel(
        idDocumento: json["id_Documento"],
        tipoDocumento: json["tipo_Documento"],
        serieDocumento: json["serie_Documento"],
        iDDocumentoRef: json["iD_Documento_Ref"],
        comensal: json["comensal"],
        consecutivoInterno: json["consecutivo_Interno"],
        productoId: json["producto_Id"],
        unidadMedida: json["unidad_Medida"],
        desProducto: json["des_Producto"],
        bodega: json["bodega"],
        cantidad: json["cantidad"],
        tipoTransaccion: json["tipo_Transaccion"],
        printerName: json["printerName"],
        dConsecutivoInterno: json["d_Consecutivo_Interno"],
      );

  Map<String, dynamic> toMap() => {
        "id_Documento": idDocumento,
        "tipo_Documento": tipoDocumento,
        "serie_Documento": serieDocumento,
        "iD_Documento_Ref": iDDocumentoRef,
        "comensal": comensal,
        "consecutivo_Interno": consecutivoInterno,
        "producto_Id": productoId,
        "unidad_Medida": unidadMedida,
        "des_Producto": desProducto,
        "bodega": bodega,
        "cantidad": cantidad,
        "tipo_Transaccion": tipoTransaccion,
        "printerName": printerName,
        "d_Consecutivo_Interno": dConsecutivoInterno,
      };
}
