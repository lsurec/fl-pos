import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';

class PrintDocSettingsModel {
  int opcion;
  DocDestinationModel? destination;
  int? consecutivoDoc;
  String? cuentaCorrentistaRef;

  PrintDocSettingsModel({
    required this.opcion,
    this.consecutivoDoc,
    this.destination,
    this.cuentaCorrentistaRef,
  });
}
