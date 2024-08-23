//estructura para una orden
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';

class OrderModel {
  OrderModel({
    required this.consecutivo,
    required this.consecutivoRef,
    required this.mesero,
    required this.nombre,
    required this.ubicacion,
    required this.mesa,
    required this.selected,
    required this.transacciones,
  });

  // CorrentistaModel mesero;
  int consecutivo;
  int consecutivoRef;
  bool selected;
  AccountPinModel mesero;
  String nombre;
  LocationModel ubicacion;
  TableModel mesa;
  List<TraRestaurantModel> transacciones;
}

//estructura transaccion de una orden
class TraRestaurantModel {
  TraRestaurantModel({
    required this.cantidad,
    required this.precio,
    required this.producto,
    required this.observacion,
    required this.guarniciones,
    required this.selected,
    required this.bodega,
    required this.processed,
  });

  int cantidad;
  UnitarioModel precio;
  BodegaProductoModel bodega;
  ProductRestaurantModel producto;
  String observacion;
  List<GarnishTra> guarniciones;
  bool selected;
  bool processed;
}

class GarnishTra {
  List<GarnishModel> garnishs;
  GarnishModel selected;

  GarnishTra({
    required this.garnishs,
    required this.selected,
  });
}
