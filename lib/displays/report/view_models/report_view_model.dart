import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:provider/provider.dart';

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

  navigatePrintScreen(BuildContext context, ReportModel report) {
    final PrintReportViewModel printReportVM =
        Provider.of<PrintReportViewModel>(
      context,
      listen: false,
    );

    printReportVM.report = report;

    Navigator.pushNamed(context, AppRoutes.printReport);
  }
}
