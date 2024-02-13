import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';

class DocDestinationModel {
  int tipoDocumento;
  String desTipoDocumento;
  String serie;
  String desSerie;
  DocConvertModel data;

  DocDestinationModel({
    required this.tipoDocumento,
    required this.desTipoDocumento,
    required this.serie,
    required this.desSerie,
    required this.data,
  });
}
