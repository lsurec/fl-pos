import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/reports/pdf/utilities_pdf.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

class UnidadesVendidasPdf {
  Future<void> getReport(
    ReportUnidadesVendidasModel data,
  ) async {
    final ByteData logo = await rootBundle.load('assets/empresa.png');

    final ByteData logoDemo = await rootBundle.load('assets/logo_demosoft.png');

    //Docuemnto pdf nuevo
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(
          marginBottom: 20,
          marginLeft: 20,
          marginTop: 20,
          marginRight: 20,
        ),
        build: (pw.Context context) {
          return [
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black, // Color del borde
                  width: 1, // Ancho del borde
                ),
                // borderRadius: pw.BorderRadius.circular(8.0),
              ),
              width: double.infinity,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  //Titulos de las columnas
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      color: UtilitiesPdf.backgroundCell,
                      border: const pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.black, // Color del borde
                          width: 1.0, // Ancho del borde
                        ),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Container(
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              right: pw.BorderSide(
                                color: PdfColors.black, // Color del borde
                                width: 1.0, // Ancho del borde
                              ),
                            ),
                          ),
                          padding: const pw.EdgeInsets.all(5),
                          width: PdfPageFormat.letter.width * 0.10,
                          child: pw.Text(
                            "ID",
                            style: UtilitiesPdf.textBoldWhite,
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              right: pw.BorderSide(
                                color: PdfColors.black, // Color del borde
                                width: 1.0, // Ancho del borde
                              ),
                            ),
                          ),
                          padding: const pw.EdgeInsets.all(5),
                          width: PdfPageFormat.letter.width * 0.63,
                          child: pw.Text(
                            "Producto",
                            style: UtilitiesPdf.textBoldWhite,
                          ),
                        ),
                        pw.Container(
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              right: pw.BorderSide(
                                color: PdfColors.black, // Color del borde
                                width: 1.0, // Ancho del borde
                              ),
                            ),
                          ),
                          padding: const pw.EdgeInsets.all(5),
                          width: PdfPageFormat.letter.width * 0.20,
                          child: pw.Text(
                            "Unidades",
                            style: UtilitiesPdf.textBoldWhite,
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  //Deatlles (Prductos/transacciones)
                  ...data.products
                      .map((product) => pw.Row(
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  product.id,
                                  textAlign: pw.TextAlign.center,
                                  style: UtilitiesPdf.text,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.63,
                                child: pw.Text(
                                  product.desc,
                                  style: UtilitiesPdf.text,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.20,
                                child: pw.Text(
                                  "${product.unidades}",
                                  textAlign: pw.TextAlign.center,
                                  style: UtilitiesPdf.text,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ],
              ),
            ),
          ];
        },
        header: (_) => UtilitiesPdf.buildHeader(
          logo,
          [
            "REPORTE DE UNIDADES VENDIDAS",
            "Bodega: (${data.idBodega}) ${data.bodega}",
            "Usuario: ${Preferences.userName}",
          ],
        ),
        // //pie de pagina
        footer: (pw.Context context) => UtilitiesPdf.buildFooter(
          logoDemo,
          context,
        ),
      ),
    );

    //Crear y guardar el pdf
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/RptUnidadesVendidas.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    //Detener proceso de carag
    //compartir documento
    Share.shareFiles(
      [filePath],
      text: "RptUnidadesVendidas",
    );
  }
}
