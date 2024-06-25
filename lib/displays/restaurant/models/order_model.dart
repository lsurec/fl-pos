//estructura para una orden
import 'package:flutter_post_printer_example/displays/restaurant/models/locations_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';

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
  dynamic mesero;
  int id;
  String nombre;
  LocationModel ubicacion;
  TableModel mesa;
  List<TransaccionModel> transacciones;
}

//estructura transaccion de una orden
class TransaccionModel {
  TransaccionModel({
    required this.id,
    required this.cantidad,
    required this.precio,
    required this.producto,
    required this.observacion,
    required this.guarniciones,
  });

  int id;
  int cantidad;
  // PrecioModel precio;
  dynamic precio;
  // ProductoModel producto;
  dynamic producto;
  String observacion;
  // List<GuarnicionModel> guarniciones;
  List<dynamic> guarniciones;
}
