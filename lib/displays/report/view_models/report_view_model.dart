import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';

class ReportViewModel extends ChangeNotifier {
  final List<ReportModel> reports = [
    ReportModel(
      id: 5,
      name: "Existencias",
    ),
    ReportModel(
      id: 6,
      name: "Unidades vendidas",
    ),
    ReportModel(
      id: 7,
      name: "Lista Facturas, totales de crédito y contado",
    ),
  ];
}
