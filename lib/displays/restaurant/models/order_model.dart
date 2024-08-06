//estructura para una orden
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';

class OrderModel {
  OrderModel({
    required this.mesero,
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.mesa,
    required this.transacciones,
  });

  // CorrentistaModel mesero;
  AccountPinModel mesero;
  int id;
  String nombre;
  LocationModel ubicacion;
  TableModel mesa;
  List<TraRestaurantModel> transacciones;
}

//estructura transaccion de una orden
class TraRestaurantModel {
  TraRestaurantModel({
    required this.id,
    required this.cantidad,
    required this.precio,
    required this.producto,
    required this.observacion,
    required this.guarniciones,
  });

  int id;
  int cantidad;
  UnitarioModel precio;
  ProductRestaurantModel producto;
  String observacion;
  List<GarnishTra> guarniciones;
}

class GarnishTra {
  GarnishModel garnish;
  GarnishModel selected;

  GarnishTra({
    required this.garnish,
    required this.selected,
  });
}
