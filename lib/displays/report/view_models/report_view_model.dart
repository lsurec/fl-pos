// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/services/bodega_user_service.dart';
import 'package:flutter_post_printer_example/displays/report/services/report_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/local_settings_view_model.dart';
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
  BodegaUserModel? bodega;

  final List<String> series = ['Serie A', 'Serie B', 'Serie C'];
  final List<BodegaUserModel> bodegas = [];

  final List<ViewVentasModel> ventas = [];
  final List<ViewStockModel> existencias = [];

  loadData(BuildContext context) async {
    DateTime currentTime = DateTime.now();

    startDate = currentTime;
    endDate = currentTime;

    await loadBodegas(context);
  }

  Future<void> loadBodegas(BuildContext context) async {
    final LoginViewModel loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final LocalSettingsViewModel localVM = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    // final String token = loginVM.token;
    // final String user = loginVM.user;
    // final int empresa = localVM.selectedEmpresa!.empresa;
    // final int estacion = localVM.selectedEstacion!.estacionTrabajo;

    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTcxODYzODI3OSwiZXhwIjoxNzQ5NzQyMjc5LCJpYXQiOjE3MTg2MzgyNzl9.s1ZpBmweXkrfGXi71aYbm8OfHx4xF9ne9MkuQoWR3c8";
    final String user = "admin";
    final int empresa = 1;
    final int estacion = 1;

    BodegaUserService bodegaUserService = BodegaUserService();

    isLoading = true;

    final ApiResponseModel res = await bodegaUserService.getBodega(
      token,
      user,
      empresa,
      estacion,
    );
    isLoading = false;

    if (!res.status) {
      NotificationService.showInfoErrorView(context, res);
      return;
    }

    bodega = null;
    bodegas.clear();
    bodegas.addAll(res.data);
    bodegas.sort((a, b) => a.orden.compareTo(b.orden));
    bodega = bodegas.first;
    //
  }

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

  Future<ApiResponseModel> loadViewExistencias(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    // final String token = vmLogin.token;
    // final String user = vmLogin.user;
    // final int empresa = vmLocal.selectedEmpresa!.empresa;
    // final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;

    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTcxODYzODI3OSwiZXhwIjoxNzQ5NzQyMjc5LCJpYXQiOjE3MTg2MzgyNzl9.s1ZpBmweXkrfGXi71aYbm8OfHx4xF9ne9MkuQoWR3c8";
    final String user = "admin";
    final int empresa = 1;
    final int estacion = 1;

    ReportService reportService = ReportService();

    if (bodega == null) {
      //TODO:Translate
      NotificationService.showSnackbar("Por favor selecciona una bodega.");
      return ApiResponseModel(
        status: false,
        message: "No hay bodega seleccionada",
        error: "",
        storeProcedure: "",
        parameters: null,
        data: null,
        timestamp: DateTime.now(),
        version: "Desconocido",
      );
    }

    final ApiResponseModel res = await reportService.getRptExistencias(
      token,
      user,
      empresa,
      estacion,
      bodega!.bodega,
    );

    if (!res.status) return res;

    existencias.clear();
    existencias.addAll(res.data);

    return res;
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

  changeBodega(BodegaUserModel value) {
    bodega = value;
    notifyListeners();
  }
}
