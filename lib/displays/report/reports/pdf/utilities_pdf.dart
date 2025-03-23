import 'dart:typed_data';

import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class UtilitiesPdf {
  static PdfColor backgroundCell = PdfColor.fromHex("134895");

  static pw.TextStyle textBoldWhite = pw.TextStyle(
    color: PdfColors.white,
    fontSize: 8,
    fontWeight: pw.FontWeight.bold,
  );

  static pw.TextStyle text = const pw.TextStyle(fontSize: 8);

  //encabezado del pdf
  static pw.Widget buildHeader(
    ByteData logoByte,
    List<String> headers,
  ) {
    //Logos para el pdf

    //formato de imagenes valido
    Uint8List logo = (logoByte).buffer.asUint8List();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        children: [
          // Item 1 (50%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.20,
            height: 65,
            child: pw.Image(
              pw.MemoryImage(logo),
            ),
          ),
          pw.Container(
            width: PdfPageFormat.letter.width * 0.15,
          ),
          // Item 2 (25%)
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 15),
            width: PdfPageFormat.letter.width * 0.35,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                ...headers.map(
                  (text) => pw.Text(
                    text,
                    style: const pw.TextStyle(
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          pw.Container(
            width: PdfPageFormat.letter.width * 0.02,
          ),
          // Item 3 (25%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.30,
            child: pw.Text(
              "Fecha: ${Utilities.getDateDDMMYYYY()}",
              style: const pw.TextStyle(
                fontSize: 9,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildFooter(
    ByteData logoByte,
    pw.Context context,
  ) {
    //formato de imagenes valido
    Uint8List logo = (logoByte).buffer.asUint8List();

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        children: [
          // Item 1 (50%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.20,
            height: 65,
            child: pw.Image(
              pw.MemoryImage(logo),
            ),
          ),
          pw.Container(
            width: PdfPageFormat.letter.width * 0.15,
          ),
          // Item 2 (25%)
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 15),
            width: PdfPageFormat.letter.width * 0.35,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "Powered By:",
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  Utilities.author.nombre,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  Utilities.author.website,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Version: ${SplashViewModel.versionLocal}",
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
          pw.Container(
            width: PdfPageFormat.letter.width * 0.02,
          ),
          // Item 3 (25%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.30,
            child: pw.Text(
              "Página ${context.pageNumber} de ${context.pagesCount}",
              style: const pw.TextStyle(
                fontSize: 9,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
