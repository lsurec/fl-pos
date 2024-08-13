import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';

class TraInternaModel {
  TraInternaModel({
    required this.isChecked,
    required this.producto,
    required this.precio,
    required this.cantidad,
    required this.total,
    required this.descuento,
    required this.cargo,
    required this.operaciones,
    required this.bodega,
    required this.cantidadDias,
    required this.precioDia,
    required this.precioCantidad,
    required this.consecutivo,
    required this.estadoTra,
  });

  bool isChecked;
  ProductModel producto;
  BodegaProductoModel? bodega;
  UnitarioModel? precio;
  int cantidad;
  double total;
  List<TraInternaModel> operaciones;
  double descuento;
  double cargo;
  int cantidadDias;
  double? precioDia;
  double? precioCantidad;
  int consecutivo;
  int estadoTra;

  factory TraInternaModel.fromJson(String str) =>
      TraInternaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TraInternaModel.fromMap(Map<String, dynamic> json) => TraInternaModel(
        isChecked: json["isChecked"],
        producto: ProductModel.fromMap(json["producto"]),
        precio: json["precio"] == null
            ? null
            : UnitarioModel.fromMap(json["precio"]),
        cantidad: json["cantidad"],
        total: json["total"],
        descuento: json["descuento"],
        cargo: json["cargo"],
        operaciones: List<TraInternaModel>.from(
          json["operaciones"].map((x) => TraInternaModel.fromMap(x)),
        ),
        bodega: json["bodega"] == null
            ? null
            : BodegaProductoModel.fromMap(json["bodega"]),
        cantidadDias: json["cantidadDias"],
        precioDia: json["precioDia"]?.toDouble(),
        precioCantidad: json["precioCantidad"]?.toDouble(),
        consecutivo: json["consecutivo"],
        estadoTra: json["estadoTra"],
      );

  Map<String, dynamic> toMap() => {
        "isChecked": isChecked,
        "producto": producto.toMap(),
        "precio": precio?.toMap(),
        "cantidad": cantidad,
        "total": total,
        "descuento": descuento,
        "cargo": cargo,
        "operaciones": List<dynamic>.from(operaciones.map((x) => x.toMap())),
        "bodega": bodega?.toMap(),
        "cantidadDias": cantidadDias,
        "precioDia": precioDia,
        "precioCantidad": precioCantidad,
        "consecutivo": consecutivo,
        "estadoTra": estadoTra,
      };
}
