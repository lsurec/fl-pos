import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ReportViewModel extends ChangeNotifier {
  final List<String> reports = [
    "Existencias",
    "Unidades vendidas",
    "Facturas",
  ];

  navigatePrintScreen(BuildContext context, String textSelect) {
    final PrintReportViewModel printReportVM =
        Provider.of<PrintReportViewModel>(
      context,
      listen: false,
    );

    printReportVM.title = textSelect;

    Navigator.pushNamed(context, AppRoutes.printReport);
  }
}
