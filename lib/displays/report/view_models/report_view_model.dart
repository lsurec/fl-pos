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

  DateTime? startDate;
  DateTime? endDate;
  String? selectedSerie;
  String? selectedBodega;

  final List<String> series = ['Serie A', 'Serie B', 'Serie C'];
  final List<String> bodegas = ['Bodega 1', 'Bodega 2', 'Bodega 3'];

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (isStartDate) {
        startDate = pickedDate;
      } else {
        endDate = pickedDate;
      }
    }
    notifyListeners();
  }

  changeSerie(String value) {
    selectedSerie = value;
    notifyListeners();
  }

  changeBodega(String value) {
    selectedBodega = value;
    notifyListeners();
  }
}
