//estructura para una orden
import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';

class OrderModel {
  // CorrentistaModel mesero;
  int consecutivo;
  int consecutivoRef;
  bool selected;
  AccountPinModel mesero;
  String nombre;
  LocationModel ubicacion;
  TableModel mesa;
  List<TraRestaurantModel> transacciones;

  OrderModel({
    required this.consecutivo,
    required this.consecutivoRef,
    required this.selected,
    required this.mesero,
    required this.nombre,
    required this.ubicacion,
    required this.mesa,
    required this.transacciones,
  });

  factory OrderModel.fromJson(String str) =>
      OrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        consecutivo: json["consecutivo"],
        consecutivoRef: json["consecutivoRef"],
        selected: json["selected"],
        mesero: AccountPinModel.fromMap(json["mesero"]),
        nombre: json["nombre"],
        ubicacion: LocationModel.fromMap(json["ubicacion"]),
        mesa: TableModel.fromMap(json["mesa"]),
        transacciones: List<TraRestaurantModel>.from(
            json["transacciones"].map((x) => TraRestaurantModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "consecutivo": consecutivo,
        "consecutivoRef": consecutivoRef,
        "selected": selected,
        "mesero": mesero.toMap(),
        "nombre": nombre,
        "ubicacion": ubicacion.toMap(),
        "mesa": mesa.toMap(),
        "transacciones":
            List<dynamic>.from(transacciones.map((x) => x.toMap())),
      };
}

class TraRestaurantModel {
  int cantidad;
  UnitarioModel precio;
  BodegaProductoModel bodega;
  ProductRestaurantModel producto;
  String observacion;
  List<GarnishTra> guarniciones;
  bool selected;
  bool processed;

  TraRestaurantModel({
    required this.cantidad,
    required this.precio,
    required this.bodega,
    required this.producto,
    required this.observacion,
    required this.guarniciones,
    required this.selected,
    required this.processed,
  });

  factory TraRestaurantModel.fromJson(String str) =>
      TraRestaurantModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TraRestaurantModel.fromMap(Map<String, dynamic> json) =>
      TraRestaurantModel(
        cantidad: json["cantidad"],
        precio: UnitarioModel.fromMap(json["precio"]),
        bodega: BodegaProductoModel.fromMap(json["bodega"]),
        producto: ProductRestaurantModel.fromMap(json["producto"]),
        observacion: json["observacion"],
        guarniciones: List<GarnishTra>.from(
            json["guarniciones"].map((x) => GarnishTra.fromMap(x))),
        selected: json["selected"],
        processed: json["processed"],
      );

  Map<String, dynamic> toMap() => {
        "cantidad": cantidad,
        "precio": precio.toMap(),
        "bodega": bodega.toMap(),
        "producto": producto.toMap(),
        "observacion": observacion,
        "guarniciones": List<dynamic>.from(guarniciones.map((x) => x.toMap())),
        "selected": selected,
        "processed": processed,
      };
}

class GarnishTra {
  List<GarnishModel> garnishs;
  GarnishModel selected;

  GarnishTra({
    required this.garnishs,
    required this.selected,
  });

  factory GarnishTra.fromJson(String str) =>
      GarnishTra.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GarnishTra.fromMap(Map<String, dynamic> json) => GarnishTra(
        garnishs: List<GarnishModel>.from(
            json["garnishs"].map((x) => GarnishModel.fromMap(x))),
        selected: GarnishModel.fromMap(json["selected"]),
      );

  Map<String, dynamic> toMap() => {
        "garnishs": List<dynamic>.from(garnishs.map((x) => x.toMap())),
        "selected": selected.toMap(),
      };
}
