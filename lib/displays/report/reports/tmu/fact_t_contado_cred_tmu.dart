import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/report/models/report_fact_cont_cred_model.dart';
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
    ReportFactContCredModel data,
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
      "Bodega: (${data.idBodega}) ${data.bodega}",
      styles: UtilitiesTMU.center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.hr(); // Línea horizontal

    for (var element in data.docs) {
      bytes += generator.text(
        "ID: ${element.id}",
      );
      bytes += generator.text(
        "Monto: ${element.monto.toStringAsFixed(2)}",
      );
      bytes += generator.hr(); // Línea horizontal
    }

    bytes += generator.hr(); // Línea horizontal

    bytes += generator.text(
      "Total Contado (Venta):",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   ${data.totalContado}",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "Total Credito (Venta):",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   ${data.totalCredito}",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "Total:",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   ${data.totalContCred}",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "Cantidad Documentos:",
      styles: UtilitiesTMU.startBold,
    );
    bytes += generator.text(
      "   ${data.docs.length}",
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
