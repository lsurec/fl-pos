import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/reports/tmu/utilities_tmu.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;
import 'package:flutter_post_printer_example/models/print_model.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';

class UnidadesVendidasTMU {
//reports function
  static Future<PrintModel> getReport(
    BuildContext context,
    int paperDefault,
    ReportUnidadesVendidasModel data,
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
      "REPORTE DE UNIDADES VENDIDAS",
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

    for (var element in data.products) {
      bytes += generator.text(
        "ID: ${element.id}",
      );
      bytes += generator.text(
        "Producto: ${element.desc}",
      );
      bytes += generator.row(
        [
          PosColumn(
            text: "Cantidad: ${element.desc}",
            width: 6,
          ),
          PosColumn(
            text: "Unidades: ${element.unidades}",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ], // Ancho 2
      );
      bytes += generator.hr(); // Línea horizontal
    }

    bytes += generator.hr(); // Línea horizontal

    bytes += generator.text(
      "Total Unidades Vendidas: ${data.total}",
      styles: UtilitiesTMU.centerBold,
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
