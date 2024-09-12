import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ErrorViewModel extends ChangeNotifier {
  Future<String> createAndSavePDF(
    ErrorModel error,
    BuildContext contextP,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(contextP, listen: false);
    final vmLocal =
        Provider.of<LocalSettingsViewModel>(contextP, listen: false);

    DateTime date = error.date;

    final ByteData image = await rootBundle.load('assets/logo_demosoft.png');

    Uint8List logoData = (image).buffer.asUint8List();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "DESARROLLO MODERNO DE SOFTWARE S.A",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#1352F0"),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "${AppLocalizations.of(contextP)!.translate(
                        BlockTranslate.fecha,
                        "fecha",
                      )} - ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      height: 65,
                      child: pw.Image(
                        pw.MemoryImage(logoData),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "${AppLocalizations.of(contextP)!.translate(
                        BlockTranslate.general,
                        "usuario",
                      )}: ${vmLogin.user}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              AppLocalizations.of(contextP)!.translate(
                BlockTranslate.localConfig,
                "configuracion",
              ),
              style: pw.TextStyle(
                color: PdfColor.fromHex("#CF113C"),
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Divider(color: PdfColor.fromHex("#1352F0")),
            pw.Text(
              AppLocalizations.of(contextP)!.translate(
                BlockTranslate.localConfig,
                "empresa",
              ),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              "${vmLocal.selectedEmpresa?.empresaNombre ?? AppLocalizations.of(contextP)!.translate(
                    BlockTranslate.error,
                    "noDisponible",
                  )} (${vmLocal.selectedEmpresa?.empresa ?? AppLocalizations.of(contextP)!.translate(
                    BlockTranslate.error,
                    "noDisponible",
                  )})",
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              AppLocalizations.of(contextP)!.translate(
                BlockTranslate.localConfig,
                "estaciones",
              ),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              "${vmLocal.selectedEstacion?.descripcion ?? AppLocalizations.of(contextP)!.translate(
                    BlockTranslate.error,
                    "noDisponible",
                  )} (${vmLocal.selectedEstacion?.estacionTrabajo ?? AppLocalizations.of(contextP)!.translate(
                    BlockTranslate.error,
                    "noDisponible",
                  )})",
            ),
            // pw.SizedBox(height: 20),
            // pw.Text(
            //   "Documento",
            //   style: pw.TextStyle(
            //     color: PdfColor.fromHex("#CF113C"),
            //     fontWeight: pw.FontWeight.bold,
            //   ),
            // ),
            // pw.Divider(color: PdfColor.fromHex("#1352F0")),
            // pw.Text(
            //   "Documento:",
            //   style: pw.TextStyle(
            //     fontWeight: pw.FontWeight.bold,
            //   ),
            // ),
            // pw.Text(
            //   "46612",
            // ),
            // pw.SizedBox(height: 5),
            // pw.Text(
            //   "Serie:",
            //   style: pw.TextStyle(
            //     fontWeight: pw.FontWeight.bold,
            //   ),
            // ),
            // pw.Text(
            //   "FEL64",
            // ),
            pw.SizedBox(height: 20),
            pw.Text(
              AppLocalizations.of(contextP)!.translate(
                BlockTranslate.error,
                "errorDesc",
              ),
              style: pw.TextStyle(
                color: PdfColor.fromHex("#CF113C"),
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Divider(color: PdfColor.fromHex("#1352F0")),
            if (error.url != null)
              pw.Text(
                error.url!,
                style: const pw.TextStyle(
                  decoration: pw.TextDecoration.underline,
                ),
              ),
            pw.SizedBox(height: 5),
            if (error.storeProcedure != null)
              pw.Text(
                error.storeProcedure!,
                style: const pw.TextStyle(
                  decoration: pw.TextDecoration.underline,
                ),
              ),
            pw.SizedBox(height: 5),
            pw.Text(
              error.description,
              textAlign: pw.TextAlign.justify,
            )
          ],
        );
      }),
    );

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${error.date.toString()}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  void sharePDFFile(String filePath) {
    Share.shareFiles([filePath], text: 'Here is your PDF file');
  }

  shareDoc(ErrorModel error, BuildContext context) async {
    String pdfFilePath = await createAndSavePDF(error, context);
    sharePDFFile(pdfFilePath);
  }
}
