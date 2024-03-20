import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';

class FormatoComanda {
  String bodega;
  String ipAdress;
  List<PrintDataComandaModel> detalles;

  FormatoComanda({
    required this.bodega,
    required this.detalles,
    required this.ipAdress,
  });
}
