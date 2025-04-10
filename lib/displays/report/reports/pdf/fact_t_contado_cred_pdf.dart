import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/reports/pdf/utilities_pdf.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/empresa_model.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/picture_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FactTContadoCredPdf {
  Future<void> getReport(
    BuildContext context,
    ReportFactContCredModel data,
  ) async {
    PictureService pictureService = PictureService();

    final EmpresaModel empresa = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    ).selectedEmpresa!;

    final LoginViewModel loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final ByteData logo = await pictureService.getLogo(
      empresa.absolutePathPicture,
    );

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
                          width: PdfPageFormat.letter.width * 0.31,
                          child: pw.Text(
                            "ID",
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
                          width: PdfPageFormat.letter.width * 0.31,
                          child: pw.Text(
                            "Tipo",
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
                          width: PdfPageFormat.letter.width * 0.31,
                          child: pw.Text(
                            "Monto",
                            style: UtilitiesPdf.textBoldWhite,
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  //Deatlles (Prductos/transacciones)
                  ...data.docs
                      .map(
                        (doc) => pw.Row(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              width: PdfPageFormat.letter.width * 0.31,
                              child: pw.Text(
                                "${doc.id}",
                                style: UtilitiesPdf.text,
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              width: PdfPageFormat.letter.width * 0.31,
                              child: pw.Text(
                                doc.tipo,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              width: PdfPageFormat.letter.width * 0.31,
                              child: pw.Text(
                                doc.monto.toStringAsFixed(2),
                                textAlign: pw.TextAlign.right,
                                style: UtilitiesPdf.text,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            pw.SizedBox(height: 5),
            //Total del documento
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black, // Color del borde
                  width: 1, // Ancho del borde
                ),
              ),
              width: PdfPageFormat.letter.width,
              child: pw.Row(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      color: UtilitiesPdf.backgroundCell,
                      border: const pw.Border(
                        right: pw.BorderSide(
                          color: PdfColors.black, // Color del borde
                          width: 1.0, // Ancho del borde
                        ),
                      ),
                    ),
                    width: PdfPageFormat.letter.width * 0.62,
                    child: pw.Text(
                      "Total Contado (Venta):",
                      style: UtilitiesPdf.textBoldWhite,
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    width: PdfPageFormat.letter.width * 0.31,
                    child: pw.Text(
                      data.totalContado.toStringAsFixed(2),
                      style: UtilitiesPdf.textBold,
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 5),
            //Total del documento
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black, // Color del borde
                  width: 1, // Ancho del borde
                ),
              ),
              width: PdfPageFormat.letter.width,
              child: pw.Row(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      color: UtilitiesPdf.backgroundCell,
                      border: const pw.Border(
                        right: pw.BorderSide(
                          color: PdfColors.black, // Color del borde
                          width: 1.0, // Ancho del borde
                        ),
                      ),
                    ),
                    width: PdfPageFormat.letter.width * 0.62,
                    child: pw.Text(
                      "Total Crédito (Venta):",
                      style: UtilitiesPdf.textBoldWhite,
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    width: PdfPageFormat.letter.width * 0.31,
                    child: pw.Text(
                      data.totalCredito.toStringAsFixed(2),
                      style: UtilitiesPdf.textBold,
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 5),
            //Total del documento
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black, // Color del borde
                  width: 1, // Ancho del borde
                ),
              ),
              width: PdfPageFormat.letter.width,
              child: pw.Row(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      color: UtilitiesPdf.backgroundCell,
                      border: const pw.Border(
                        right: pw.BorderSide(
                          color: PdfColors.black, // Color del borde
                          width: 1.0, // Ancho del borde
                        ),
                      ),
                    ),
                    width: PdfPageFormat.letter.width * 0.62,
                    child: pw.Text(
                      "TOTAL:",
                      style: UtilitiesPdf.textBoldWhite,
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    width: PdfPageFormat.letter.width * 0.31,
                    child: pw.Text(
                      data.totalContCred.toStringAsFixed(2),
                      style: UtilitiesPdf.textBold,
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        header: (_) => UtilitiesPdf.buildHeader(
          logo,
          [
            "LISTA FACTURAS, TOTALES DE CREDITO Y CONTADO",
            "Fecha inicio: ${Utilities.formatearFecha(data.startDate)}",
            "Fecha fin: ${Utilities.formatearFecha(data.endDate)}",
            "Bodega: (${data.idBodega}) ${data.bodega}",
            "Usuario: ${loginVM.user}",
          ],
          [
            "Documentos: ${data.docs.length}",
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
    final filePath = '${directory.path}/RptFactTCredCont.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    //Detener proceso de carag
    //compartir documento
    Share.shareFiles(
      [filePath],
      text: "RptFactTCredCont",
    );
  }
}
