import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/reports/tmu/utilities_tmu.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;
import 'package:flutter_post_printer_example/models/print_model.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ExistenciasTMU {
//reports function
  static Future<PrintModel> getReport(
    BuildContext context,
    int paperDefault,
    ReportStockModel data,
  ) async {
    final LoginViewModel loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    List<int> bytes = [];

    final generator = Generator(
      AppData.paperSize[paperDefault],
      await CapabilityProfile.load(),
    );

    bytes += generator.setGlobalCodeTable('CP1252');

    //Reporte de xistencias
    // Encabezado
    bytes += generator.text(
      "REPORTE DE EXISTENCIAS",
      styles: UtilitiesTMU.centerBold,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "Fecha: ${Utilities.getDateDDMMYYYY()}",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      "Bodega: (${data.idBodega}) ${data.bodega}",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      "Usuario: ${loginVM.user}",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.hr(); // Línea horizontal

    for (var element in data.products) {
      bytes += generator.text(
        "ID: ${element.id}",
      );
      bytes += generator.text(
        "Producto: ${element.desc}",
      );
      bytes += generator.text(
        "Existenacia: ${element.existencias}",
      );
      bytes += generator.hr(); // Línea horizontal
    }

    // Información adicional
    bytes += generator.emptyLines(1);
    bytes += generator.text(
      "Total: ${data.total}",
    );
    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "Powered by",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      Utilities.author.nombre,
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      Utilities.author.website,
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      "Version: ${SplashViewModel.versionLocal}",
      styles: UtilitiesTMU.center,
    );

    return PrintModel(
      bytes: bytes,
      generator: generator,
    );
  }
}
