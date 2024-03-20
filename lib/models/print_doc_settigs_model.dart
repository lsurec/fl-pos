import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/client_model.dart';

class PrintDocSettingsModel {
  int opcion;
  DocDestinationModel? destination;
  int? consecutivoDoc;
  String? cuentaCorrentistaRef;
  ClientModel? client;

  PrintDocSettingsModel({
    required this.opcion,
    this.consecutivoDoc,
    this.destination,
    this.cuentaCorrentistaRef,
    this.client,
  });
}
