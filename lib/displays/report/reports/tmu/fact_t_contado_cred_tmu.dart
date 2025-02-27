import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/report/reports/tmu/utilities_tmu.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;
import 'package:flutter_post_printer_example/models/print_model.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';

class FactTContadoCredTMU {
//reports function
  static Future<PrintModel> getReport(
    BuildContext context,
    int paperDefault,
  ) async {
    List<int> bytes = [];

    final generator = Generator(
      AppData.paperSize[paperDefault],
      await CapabilityProfile.load(),
    );

    bytes += generator.setGlobalCodeTable('CP1252');

    //Reporte de xistencias
    // Encabezado
    bytes += generator.text(
      "LISTA FACTURAS, TOTALES DE CRÉDITO Y CONTADO",
      styles: UtilitiesTMU.centerBold,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "Fecha: ${UtilitiesTMU.getDateDDMMYYYY()}",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      "Usuario: ${Preferences.userName}",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      "Bodega: Bodega central",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.hr(); // Línea horizontal

    for (var i = 0; i < 10; i++) {
      bytes += generator.text(
        "ID: 445",
      );
      bytes += generator.text(
        "Monto: Q.154.00",
      );
      bytes += generator.hr(); // Línea horizontal
    }

    bytes += generator.hr(); // Línea horizontal

    bytes += generator.text(
      "Total Efectivo (Venta):",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   Q.5,330.24",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "Total:",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   Q.5,330.24",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "Cantidad Documento:",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   44",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.hr(); // Línea horizontal
    // Información adicional
    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "Powered by",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      UtilitiesTMU.author.nombre,
      styles: UtilitiesTMU.center,
    );

    bytes += generator.text(
      UtilitiesTMU.author.website,
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
