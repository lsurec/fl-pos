// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/services/report_service.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ReportViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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

  final List<ViewVentasModel> ventas = [];

  Future<ApiResModel> loadViewVentas(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final String token = vmLogin.token;

    ReportService reportService = ReportService();

    final ApiResModel resViewVentas = await reportService.getViewVentas(token);

    if (!resViewVentas.succes) return resViewVentas;

    ventas.clear();
    ventas.addAll(resViewVentas.response);

    return resViewVentas;
  }

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
