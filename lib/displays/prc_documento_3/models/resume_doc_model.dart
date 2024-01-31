import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';

class ResumeDocModel {
  ResumeDocModel({
    required this.item,
    required this.documento,
    required this.subtotal,
    required this.cargo,
    required this.descuento,
    required this.total,
  });

  GetDocModel item;
  DocEstructuraModel documento;
  double subtotal;
  double cargo;
  double descuento;
  double total;
}
