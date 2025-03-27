// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/reports/pdf/existencias_pdf.dart';
import 'package:flutter_post_printer_example/displays/report/reports/pdf/fact_t_contado_cred_pdf.dart';
import 'package:flutter_post_printer_example/displays/report/reports/pdf/unidades_vendidas_pdf.dart';
import 'package:flutter_post_printer_example/displays/report/services/bodega_user_service.dart';
import 'package:flutter_post_printer_example/displays/report/services/report_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/local_settings_view_model.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
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

  ReportStockModel? reportStockModel;
  ReportUnidadesVendidasModel? reportUnidadesVendidasModel;
  ReportFactContCredModel? reportFactContCredModel;

  loadData(BuildContext context) async {
    DateTime currentTime = DateTime.now();

    startDate = currentTime;
    endDate = currentTime;

    notifyListeners();

    ApiResponseModel resBodega = await loadBodegas(context);

    if (!resBodega.status) {
      NotificationService.showInfoErrorView(context, resBodega);
      return;
    }

    bodega = null;
    bodegas.clear();
    bodegas.addAll(resBodega.data);

    if (bodegas.isNotEmpty) {
      bodegas.sort((a, b) => a.orden.compareTo(b.orden));
      bodega = bodegas.first;
    }

    notifyListeners();
  }

  Future<bool> prepareDataStock(BuildContext context) async {
    isLoading = true;
    final ApiResponseModel res = await loadViewExistencias(context);
    isLoading = false;

    if (!res.status) {
      NotificationService.showInfoErrorView(context, res);
      return false;
    }

    final List<ViewStockModel> existencias = [];

    existencias.addAll(res.data);

    if (existencias.isEmpty) {
      NotificationService.showSnackbar("No hay datos para imprimir");
      return false;
    }

    final ViewStockModel data = existencias.first;

    final List<ProductReportStockModel> products = [];

    for (var element in existencias) {
      products.add(
        ProductReportStockModel(
          id: element.productoId,
          desc: element.desProducto,
          existencias: element.cantidad,
        ),
      );
    }

    reportStockModel = ReportStockModel(
      bodega: data.nomBodega,
      idBodega: data.bodega,
      products: products,
    );

    return true;
  }

  Future<bool> prepareDataUnidadesVendidas(BuildContext context) async {
    isLoading = true;

    final ApiResModel res = await loadViewVentas(context);

    isLoading = false;

    if (!res.succes) {
      NotificationService.showErrorView(context, res);
      return false;
    }

    final List<ViewVentasModel> ventas = [];
    ventas.addAll(res.response);

    if (ventas.isEmpty) {
      NotificationService.showSnackbar("No hay datos para imprimir");
      return false;
    }

    final ViewVentasModel data = ventas.first;

    List<ProductReportUnidadesVendidas> products = [];
    double total = 0;

    for (var element in ventas) {
      products.add(
        ProductReportUnidadesVendidas(
          id: element.productoId,
          desc: element.desProducto,
          unidades: element.cantidad,
        ),
      );
      total += element.cantidad;
    }

    reportUnidadesVendidasModel = ReportUnidadesVendidasModel(
      bodega: data.desBodega,
      idBodega: data.bodega,
      products: products,
      total: total,
    );

    return true;
  }

  Future<bool> prepareDataFactContCred(BuildContext context) async {
    isLoading = true;

    final ApiResponseModel res = await loadViewFacturas(context);

    isLoading = false;

    if (!res.status) {
      NotificationService.showInfoErrorView(context, res);
      return false;
    }

    final List<ViewFacturaModel> facturas = [];

    facturas.addAll(res.data);

    if (facturas.isEmpty) {
      NotificationService.showSnackbar("No hay datos para imprimir");
      return false;
    }

    final ViewFacturaModel data = facturas.first;

    final List<DocReportModel> docs = [];
    double totalCredito = 0;
    double totalContado = 0;

    for (var element in facturas) {
      docs.add(
        DocReportModel(
          id: element.idDocumento,
          monto: element.monto,
          tipo: element.tipoCargoAbono ?? "",
        ),
      );

      if (element.tipoCargoAbono
          .toLowerCase()
          .contains("cuentas por cobrar".toLowerCase())) {
        totalCredito += element.monto;
      } else {
        totalContado += element.monto;
      }
    }

    reportFactContCredModel = ReportFactContCredModel(
      bodega: data.desBodega,
      idBodega: data.bodega,
      docs: docs,
      totalContado: totalContado,
      totalCredito: totalCredito,
      totalContCred: totalContado + totalCredito,
      startDate: startDate!,
      endDate: endDate!,
    );

    return true;
  }

  Future<void> getReport(
      BuildContext context, ReportModel value, bool isPrint) async {
    //validaciones
    switch (value.id) {
      case 5: //existencias
        //si no hay bodega seleccioanda
        if (bodega == null) {
          //TODO:Translate
          NotificationService.showSnackbar("Por favor selecciona una bodega.");
          return;
        }

        final bool succes = await prepareDataStock(context);

        if (!succes) return;

        if (!isPrint) {
          //TODO:Funcion llama datos
          ExistenciasPdf existenciasPdf = ExistenciasPdf();

          isLoading = true;

          await existenciasPdf.getReport(context, reportStockModel!);
          isLoading = false;

          return;
        }
        break;
      case 6: //unidades vendidas
        if (!isPrint) {
          //TODO:Funcion llama datos

          UnidadesVendidasPdf unidadesVendidasPdf = UnidadesVendidasPdf();

          final bool success = await prepareDataUnidadesVendidas(context);

          if (!success) return;

          isLoading = true;
          await unidadesVendidasPdf.getReport(
              context, reportUnidadesVendidasModel!);
          isLoading = false;

          return;
        }
        break;
      case 7: //facturas

        //TODO:Descomentar en produccion
        final menuVM = Provider.of<MenuViewModel>(
          context,
          listen: false,
        );

        if (menuVM.documento == null) {
          NotificationService.showSnackbar(
              "No hay se ha asignado tipo de documento.");
          return;
        }

        if (bodega == null) {
          //TODO:Translate
          NotificationService.showSnackbar("Por favor selecciona una bodega.");
          return;
        }

        if (startDate == null) {
          //TODO:Translates
          NotificationService.showSnackbar(
              "Por favor selecciona una fecha inical.");
          return;
        }
        if (endDate == null) {
          //TODO:Translate
          NotificationService.showSnackbar(
              "Por favor selecciona una fecha final.");

          return;
        }

        if (!isPrint) {
          FactTContadoCredPdf factTContadoCredPdf = FactTContadoCredPdf();

          final bool success = await prepareDataFactContCred(context);

          if (!success) return;

          isLoading = true;
          await factTContadoCredPdf.getReport(
              context, reportFactContCredModel!);
          isLoading = false;

          return;
        }

        break;
      default:
    }

    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(
        opcion: value.id,
        report: value,
      ),
    );
  }

  Future<ApiResponseModel> loadBodegas(BuildContext context) async {
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

    return await bodegaUserService.getBodega(
      token,
      user,
      empresa,
      estacion,
    );
  }

  Future<ApiResModel> loadViewVentas(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final String token = vmLogin.token;

    ReportService reportService = ReportService();

    return reportService.getViewVentas(token);
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

    return await reportService.getRptExistencias(
      token,
      user,
      empresa,
      estacion,
      bodega!.bodega,
    );
  }

  Future<ApiResponseModel> loadViewFacturas(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final menuVM = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    // final String token = vmLogin.token;
    // final String user = vmLogin.user;
    // final int empresa = vmLocal.selectedEmpresa!.empresa;
    // final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    // final int tipoDoc = menuVM.documento!;

    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTcxODYzODI3OSwiZXhwIjoxNzQ5NzQyMjc5LCJpYXQiOjE3MTg2MzgyNzl9.s1ZpBmweXkrfGXi71aYbm8OfHx4xF9ne9MkuQoWR3c8";
    final String user = "admin";
    final int empresa = 1;
    final int estacion = 1;
    final int tipoDoc = 3;

    ReportService reportService = ReportService();

    return await reportService.getRptFacturas(
      token,
      user,
      startDate!,
      endDate!,
      tipoDoc,
      empresa,
      estacion,
      bodega!.bodega,
    );
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

        if (startDate!.isAfter(endDate!)) {
          endDate = startDate;
        }
      } else {
        endDate = pickedDate;

        if (endDate!.isBefore(startDate!)) {
          startDate = endDate;
        }
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
