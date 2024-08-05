// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

import '../displays/prc_documento_3/services/services.dart';

class ShareDocViewModel extends ChangeNotifier {
  //generar formato pdf para compartir
  Future<void> sheredDoc(
    BuildContext contextP,
    int consecutivoDoc,
    String? vendedorDoc,
    ClientModel? clientDoc,
    double totalDoc,
  ) async {
    //instancia del servicio
    DocumentService documentService = DocumentService();
    //Proveedores externos
    final loginVM = Provider.of<LoginViewModel>(contextP, listen: false);

    //usario y token
    String user = loginVM.user;
    String token = loginVM.token;

    //consumir servicio obtener encabezados
    ApiResModel resEncabezado = await documentService.getEncabezados(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    //Si el api falló
    if (!resEncabezado.succes) {
      await NotificationService.showErrorView(contextP, resEncabezado);

      return;
    }

    //encabezados encontrados
    List<EncabezadoModel> encabezadoTemplate = resEncabezado.response;

    //consumir servicio obetener detalles del documento
    ApiResModel resDetalle = await documentService.getDetalles(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resDetalle.succes) {
      //finalozar el proceso

      //mostrar alerta
      await NotificationService.showErrorView(contextP, resDetalle);

      return;
    }

    //Detalles del documento
    List<DetalleModel> detallesTemplate = resDetalle.response;

    //validar que haya datos para imprimir
    if (encabezadoTemplate.isEmpty || detallesTemplate.isEmpty) {
      NotificationService.showSnackbar(AppLocalizations.of(contextP)!.translate(
        BlockTranslate.notificacion,
        'sinDatosImprimir',
      ));

      return;
    }

    //Encabezado
    final EncabezadoModel encabezado = encabezadoTemplate.first;

    //Empresa (impresion)
    Empresa empresa = Empresa(
      razonSocial: encabezado.razonSocial!,
      nombre: encabezado.empresaNombre!,
      direccion: encabezado.empresaDireccion!,
      nit: encabezado.empresaNit!,
      tel: encabezado.empresaTelefono!,
    );

    //TODO: Remplazar datos de certificacion
    Documento documento = Documento(
      consecutivoInterno: consecutivoDoc,
      titulo: encabezado.tipoDocumento!,
      descripcion: AppLocalizations.of(contextP)!.translate(
        BlockTranslate.tiket,
        'docTributario',
      ), //Documenyo generico
      fechaCert: encabezado.feLFechaCertificacion ?? "",
      serie: encabezado.feLSerie ?? "",
      no: encabezado.feLNumeroDocumento ?? "",
      autorizacion: encabezado.feLUuid ?? "",
      noInterno: encabezado.iDDocumentoRef ?? "",
      serieInterna: encabezado.serieDocumento ?? "",
    );

    //fecha del usuario
    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    //Cliente seleccionado
    Cliente cliente = Cliente(
      nombre: clientDoc?.facturaNombre ?? "",
      direccion: clientDoc?.facturaDireccion ?? "",
      nit: clientDoc?.facturaNit ?? "",
      fecha: formattedDate,
      tel: clientDoc?.telefono ?? "",
      email: clientDoc?.eMail ?? "",
    );

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: detallesTemplate[0]
          .simboloMoneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    //Logos para el pdf
    final ByteData logoEmpresa = await rootBundle.load('assets/empresa.png');
    final ByteData imgFel = await rootBundle.load('assets/fel.png');
    final ByteData imgDemo = await rootBundle.load('assets/logo_demosoft.png');

    //formato de imagenes valido
    Uint8List logoData = (logoEmpresa).buffer.asUint8List();
    Uint8List logoFel = (imgFel).buffer.asUint8List();
    Uint8List logoDemo = (imgDemo).buffer.asUint8List();

    //Estilos para el pdf
    pw.TextStyle font8 = const pw.TextStyle(fontSize: 8);

    pw.TextStyle font8Bold = pw.TextStyle(
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle font8BoldWhite = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    );

    PdfColor backCell = PdfColor.fromHex("134895");

    bool isFel = documento.autorizacion.isNotEmpty ? true : false;

    //Docuemnto pdf nuevo
    final pdf = pw.Document();

    // Agrega páginas con encabezado y pie de página
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
            // Contenido de la página 1
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 20),
                //No interno y vendedor
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${AppLocalizations.of(contextP)!.translate(
                        BlockTranslate.tiket,
                        'interno',
                      )} ${documento.noInterno}',
                      style: font8,
                    ),
                    pw.Text(
                      '${AppLocalizations.of(contextP)!.translate(
                        BlockTranslate.tiket,
                        'vendedor',
                      )} ${vendedorDoc ?? ""} '
                      '',
                      style: font8,
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                //Datos del cliente
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black, // Color del borde
                      width: 1, // Ancho del borde
                    ),
                  ),
                  width: double.infinity,
                  child: pw.Row(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        width: PdfPageFormat.letter.width * 0.70,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.tiket,
                                    'nombre',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  cliente.nombre,
                                  style: font8,
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 2),
                            pw.Row(
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.tiket,
                                    'direccion',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  cliente.direccion,
                                  style: font8,
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 2),
                            pw.Row(
                              children: [
                                pw.Text(
                                  "NIT:",
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  cliente.nit,
                                  style: font8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.fecha,
                                    'fecha',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  cliente.fecha,
                                  style: font8,
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 2),
                            pw.Row(
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.tiket,
                                    'tel',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  cliente.tel,
                                  style: font8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                //Detalles del documento
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
                          color: backCell,
                          border: const pw.Border(
                            bottom: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        width: PdfPageFormat.letter.width,
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
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'codigo',
                                ),
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'cantidadT',
                                ),
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'uniMedida',
                                ),
                                textAlign: pw.TextAlign.center,
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.40,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.general,
                                  'descripcion',
                                ),
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'unitario',
                                ),
                                textAlign: pw.TextAlign.center,
                                style: font8BoldWhite,
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'totalT',
                                ),
                                textAlign: pw.TextAlign.center,
                                style: font8BoldWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      //Deatlles (Prductos/transacciones)
                      pw.ListView.builder(
                        itemCount: detallesTemplate.length,
                        itemBuilder: (context, index) {
                          //Detalle
                          final DetalleModel detalle = detallesTemplate[index];
                          return pw.Row(
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.productoId,
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  "${detalle.cantidad}",
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.simbolo,
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.40,
                                child: pw.Text(
                                  detalle.desProducto,
                                  textAlign: pw.TextAlign.left,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.montoUMTipoMoneda,
                                  textAlign: pw.TextAlign.right,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.montoTotalTipoMoneda,
                                  textAlign: pw.TextAlign.right,
                                  style: font8,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      pw.SizedBox(height: 5),
                      //Total del documento
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        width: PdfPageFormat.letter.width,
                        child: pw.Row(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                color: backCell,
                                border: const pw.Border(
                                  right: pw.BorderSide(
                                    color: PdfColors.black, // Color del borde
                                    width: 1.0, // Ancho del borde
                                  ),
                                ),
                              ),
                              width: PdfPageFormat.letter.width * 0.80,
                              child: pw.Text(
                                "TOTAL:",
                                style: font8BoldWhite,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(
                                  currencyFormat.format(totalDoc),
                                  style: font8Bold,
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        width: PdfPageFormat.letter.width,
                        padding: const pw.EdgeInsets.all(5),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        child: pw.Text(
                          "${AppLocalizations.of(contextP)!.translate(
                            BlockTranslate.tiket,
                            'letrasTotal',
                          )} ${encabezado.montoLetras}."
                              .toUpperCase(),
                          style: font8Bold,
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO: Mostrar frase
                // pw.SizedBox(height: 10),
                // pw.Center(
                //   child: pw.Text(
                //     "**SUJETO A PAGOS TRIMESTRALES**",
                //     style: pw.TextStyle(
                //       fontSize: 9,
                //       fontWeight: pw.FontWeight.bold,
                //     ),
                //   ),
                // ),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Text(
                    AppLocalizations.of(contextP)!.translate(
                      BlockTranslate.tiket,
                      'sinCambios',
                    ),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ];
        },
        //encabezado
        header: (pw.Context context) => buildHeader(
          contextP,
          logoData,
          empresa,
          documento,
          isFel,
        ),
        //pie de pagina
        footer: (pw.Context context) => buildFooter(
          contextP,
          logoDemo,
          logoFel,
          encabezado,
          isFel,
        ),
      ),
    );

    //Crear y guardar el pdf
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${DateTime.now().toString()}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    //Detener proceso de carag
    //compartir documento
    Share.shareFiles(
      [filePath],
      text: AppLocalizations.of(contextP)!.translate(
        BlockTranslate.tiket,
        'pdf',
      ),
    );
  }

  //para crear pdf de cotizacoin

  Future<void> sheredDocCotiAlfayOmega(
    BuildContext contextP,
    int consecutivoDoc,
    String? vendedorDoc,
    ClientModel? clientDoc,
    double totalDoc,
  ) async {
    //instancia del servicio
    DocumentService documentService = DocumentService();
    //Proveedores externos
    final loginVM = Provider.of<LoginViewModel>(contextP, listen: false);

    //usario y token
    String user = loginVM.user;
    String token = loginVM.token;

    //consumir servicio obtener encabezados
    ApiResModel resEncabezado = await documentService.getEncabezados(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    //Si el api falló
    if (!resEncabezado.succes) {
      await NotificationService.showErrorView(contextP, resEncabezado);

      return;
    }

    //encabezados encontrados
    List<EncabezadoModel> encabezadoTemplate = resEncabezado.response;

    //consumir servicio obetener detalles del documento
    ApiResModel resDetalle = await documentService.getDetalles(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resDetalle.succes) {
      //finalozar el proceso

      //mostrar alerta
      await NotificationService.showErrorView(contextP, resDetalle);

      return;
    }

    //Detalles del documento
    List<DetalleModel> detallesTemplate = resDetalle.response;

    //validar que haya datos para imprimir
    if (encabezadoTemplate.isEmpty || detallesTemplate.isEmpty) {
      NotificationService.showSnackbar(AppLocalizations.of(contextP)!.translate(
        BlockTranslate.notificacion,
        'sinDatosImprimir',
      ));

      return;
    }

    //Encabezado
    final EncabezadoModel encabezado = encabezadoTemplate.first;

    //Empresa (impresion)
    Empresa empresa = Empresa(
      razonSocial: encabezado.razonSocial!,
      nombre: encabezado.empresaNombre!,
      direccion: encabezado.empresaDireccion!,
      nit: encabezado.empresaNit!,
      tel: encabezado.empresaTelefono!,
    );

    //TODO: Remplazar datos de certificacion
    Documento documento = Documento(
      consecutivoInterno: consecutivoDoc,
      titulo: encabezado.tipoDocumento!,
      descripcion: AppLocalizations.of(contextP)!.translate(
        BlockTranslate.tiket,
        'docTributario',
      ), //Documenyo generico
      fechaCert: encabezado.feLFechaCertificacion ?? "",
      serie: encabezado.feLSerie ?? "",
      no: encabezado.feLNumeroDocumento ?? "",
      autorizacion: encabezado.feLUuid ?? "",
      noInterno: encabezado.iDDocumentoRef ?? "",
      serieInterna: encabezado.serieDocumento ?? "",
    );

    //fecha del usuario
    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    //Cliente seleccionado
    Cliente cliente = Cliente(
      nombre: clientDoc?.facturaNombre ?? "",
      direccion: clientDoc?.facturaDireccion ?? "",
      nit: clientDoc?.facturaNit ?? "",
      fecha: formattedDate,
      tel: clientDoc?.telefono ?? "",
      email: clientDoc?.eMail ?? "",
    );

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: detallesTemplate[0]
          .simboloMoneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    //Logos para el pdf
    final ByteData logoEmpresa = await rootBundle.load('assets/empresa.png');
    final ByteData imgFel = await rootBundle.load('assets/fel.png');
    final ByteData imgDemo = await rootBundle.load('assets/logo_demosoft.png');

    //formato de imagenes valido
    Uint8List logoData = (logoEmpresa).buffer.asUint8List();
    Uint8List logoFel = (imgFel).buffer.asUint8List();
    Uint8List logoDemo = (imgDemo).buffer.asUint8List();

    //Estilos para el pdf
    pw.TextStyle font8 = const pw.TextStyle(fontSize: 8);

    pw.TextStyle font8Bold = pw.TextStyle(
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    );

    pw.TextStyle font8BoldWhite = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    );

    PdfColor backCell = PdfColor.fromHex("b2b2b2");


    //Docuemnto pdf nuevo
    final pdf = pw.Document();

    // Agrega páginas con encabezado y pie de página
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
            // Contenido de la página 1
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 10),
//informacion del cliente y fechas
                pw.Container(
                  width: double.infinity,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.only(
                          left: 0,
                          right: 10,
                          bottom: 5,
                        ),
                        width: PdfPageFormat.letter.width * 0.45,
                        child: pw.Column(
                          children: [
                            //titulos e informacion
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.10,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!
                                        .translate(
                                          BlockTranslate.tiket,
                                          'cliente',
                                        )
                                        .toUpperCase(),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.35,
                                  child: pw.Text(
                                    cliente.nombre,
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),

                            //telefono
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.10,
                                  child: pw.Text(
                                    '${AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.cuenta,
                                      'telefono',
                                    )}: '
                                        .toUpperCase(),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.35,
                                  child: pw.Text(
                                    cliente.tel.isNotEmpty
                                        ? cliente.tel
                                        : AppLocalizations.of(contextP)!
                                            .translate(
                                              BlockTranslate.general,
                                              'noRegistrado',
                                            )
                                            .toUpperCase(),
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),

                            //nit
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.10,
                                  child: pw.Text(
                                    'NIT: ',
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.35,
                                  child: pw.Text(
                                    cliente.nit,
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),

                            //email
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.10,
                                  child: pw.Text(
                                    '${AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.cuenta,
                                      'correo',
                                    )}: '
                                        .toUpperCase(),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.35,
                                  child: pw.Text(
                                    cliente.email.isNotEmpty
                                        ? cliente.email
                                        : AppLocalizations.of(contextP)!
                                            .translate(
                                              BlockTranslate.general,
                                              'noRegistrado',
                                            )
                                            .toUpperCase(),
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),

                            //direccion
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.10,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!
                                        .translate(
                                          BlockTranslate.tiket,
                                          'direccion',
                                        )
                                        .toUpperCase(),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.35,
                                  child: pw.Text(
                                    cliente.direccion,
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        width: PdfPageFormat.letter.width * 0.03,
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.only(
                          left: 0,
                          right: 10,
                          bottom: 5,
                        ),
                        width: PdfPageFormat.letter.width * 0.45,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            //vendedor
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.15,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.tiket,
                                      'vendedor',
                                    ),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.30,
                                  child: pw.Text(
                                    vendedorDoc ??
                                        AppLocalizations.of(contextP)!
                                            .translate(
                                          BlockTranslate.general,
                                          'noDisponible',
                                        ),
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),
                            //correo vendedor
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.15,
                                  child: pw.Text(
                                    '${AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.cuenta,
                                      'correo',
                                    )}: ',
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.30,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.general,
                                      'noRegistrado',
                                    ),
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),
                            //evento
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.15,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.fecha,
                                      'eventoF',
                                    ),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.30,
                                  child: pw.Text(
                                    '${Utilities.formatoFechaString(encabezado.fechaIni)} - ${Utilities.formatoFechaString(encabezado.refFechaFin)}',
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),
                            //entrega
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.15,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.fecha,
                                      'entrega',
                                    ),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.30,
                                  child: pw.Text(
                                    Utilities.formatoFechaString(
                                      encabezado.refFechaIni,
                                    ),
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),
                            //recoger
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.15,
                                  child: pw.Text(
                                    AppLocalizations.of(contextP)!.translate(
                                      BlockTranslate.fecha,
                                      'recoger',
                                    ),
                                    style: font8Bold,
                                  ),
                                ),
                                pw.Container(
                                  width: PdfPageFormat.letter.width * 0.30,
                                  child: pw.Text(
                                    Utilities.formatoFechaString(
                                      encabezado.refFechaFin,
                                    ),
                                    style: font8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
//Observaciones
                pw.Container(
                  width: double.infinity,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(
                              left: 0,
                              right: 10,
                              bottom: 5,
                            ),
                            width: PdfPageFormat.letter.width * 0.45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.tiket,
                                    'contacto',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  encabezado.refObservacion2,
                                  style: font8,
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            width: PdfPageFormat.letter.width * 0.03,
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(
                              left: 0,
                              right: 10,
                              bottom: 5,
                            ),
                            width: PdfPageFormat.letter.width * 0.45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.general,
                                    'descripcion',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  encabezado.refDescripcion,
                                  style: font8,
                                  textAlign: pw.TextAlign.justify,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //Segunda fila de observaciones
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(
                              left: 0,
                              right: 10,
                              bottom: 5,
                            ),
                            width: PdfPageFormat.letter.width * 0.45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.cotizacion,
                                    'direEntrega',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  encabezado.refObservacion3,
                                  style: font8,
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            width: PdfPageFormat.letter.width * 0.03,
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(
                              left: 0,
                              right: 10,
                              bottom: 5,
                            ),
                            width: PdfPageFormat.letter.width * 0.45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  AppLocalizations.of(contextP)!.translate(
                                    BlockTranslate.general,
                                    'observacion',
                                  ),
                                  style: font8Bold,
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  encabezado.refObservacion,
                                  style: font8,
                                  textAlign: pw.TextAlign.justify,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                pw.Row(
                  children: [
                    pw.Container(
                      width: PdfPageFormat.letter.width * 0.10,
                      child: pw.Text(
                        '${AppLocalizations.of(contextP)!.translate(
                          BlockTranslate.calcular,
                          'cantDias',
                        )}: ',
                        style: font8Bold,
                      ),
                    ),
                    pw.Text(
                      "${encabezado.cantidadDiasFechaIniFin}",
                      style: font8,
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),

                //Detalles del documento
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
                          color: backCell,
                          border: const pw.Border(
                            bottom: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        width: PdfPageFormat.letter.width,
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
                                'P Reposicion',
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'codigo',
                                ),
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'cantidadT',
                                ),
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'uniMedida',
                                ),
                                textAlign: pw.TextAlign.center,
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.30,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.general,
                                  'descripcion',
                                ),
                                style: font8BoldWhite,
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
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'unitario',
                                ),
                                textAlign: pw.TextAlign.center,
                                style: font8BoldWhite,
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              width: PdfPageFormat.letter.width * 0.10,
                              child: pw.Text(
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'totalT',
                                ),
                                textAlign: pw.TextAlign.center,
                                style: font8BoldWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      //Deatlles (Prductos/transacciones)
                      pw.ListView.builder(
                        itemCount: detallesTemplate.length,
                        itemBuilder: (context, index) {
                          //Detalle
                          final DetalleModel detalle = detallesTemplate[index];
                          return pw.Row(
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  "${detalle.precioReposicion ?? "00.00"}",
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.productoId,
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  "${detalle.cantidad}",
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.simbolo,
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.30,
                                child: pw.Text(
                                  detalle.desProducto,
                                  textAlign: pw.TextAlign.left,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.montoUMTipoMoneda,
                                  textAlign: pw.TextAlign.right,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.montoTotalTipoMoneda,
                                  textAlign: pw.TextAlign.right,
                                  style: font8,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      pw.SizedBox(height: 5),
                      //Total del documento
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        width: PdfPageFormat.letter.width,
                        child: pw.Row(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                color: backCell,
                                border: const pw.Border(
                                  right: pw.BorderSide(
                                    color: PdfColors.black, // Color del borde
                                    width: 1.0, // Ancho del borde
                                  ),
                                ),
                              ),
                              width: PdfPageFormat.letter.width * 0.80,
                              child: pw.Text(
                                "TOTAL:",
                                style: font8BoldWhite,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(
                                  currencyFormat.format(totalDoc),
                                  style: font8Bold,
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        width: PdfPageFormat.letter.width,
                        padding: const pw.EdgeInsets.all(5),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(
                              color: PdfColors.black, // Color del borde
                              width: 1.0, // Ancho del borde
                            ),
                          ),
                        ),
                        child: pw.Text(
                          "${AppLocalizations.of(contextP)!.translate(
                            BlockTranslate.tiket,
                            'letrasTotal',
                          )} ${encabezado.montoLetras}."
                              .toUpperCase(),
                          style: font8Bold,
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO: Mostrar frase
                // pw.SizedBox(height: 10),
                // pw.Center(
                //   child: pw.Text(
                //     "**SUJETO A PAGOS TRIMESTRALES**",
                //     style: pw.TextStyle(
                //       fontSize: 9,
                //       fontWeight: pw.FontWeight.bold,
                //     ),
                //   ),
                // ),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Text(
                    AppLocalizations.of(contextP)!.translate(
                      BlockTranslate.tiket,
                      'sinCambios',
                    ),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ];
        },
        //encabezado
        header: (pw.Context context) => buildAlfayOmegaHeader(
          contextP,
          logoData,
          empresa,
          documento,
          cliente.fecha,
        ),
        //pie de pagina
        footer: (pw.Context context) => buildFooter(
          contextP,
          logoDemo,
          logoFel,
          encabezado,
          false,
        ),
      ),
    );

    //Crear y guardar el pdf
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${DateTime.now().toString()}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    //Detener proceso de carag
    //compartir documento
    Share.shareFiles(
      [filePath],
      text: AppLocalizations.of(contextP)!.translate(
        BlockTranslate.tiket,
        'pdf',
      ),
    );
  }

  //encabezado del pdf
  pw.Widget buildHeader(
    BuildContext context,
    Uint8List logo,
    Empresa empresa,
    Documento documento,
    bool isFel,
  ) {
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
            width: PdfPageFormat.letter.width * 0.10,
          ),
          // Item 2 (25%)
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 15),
            width: PdfPageFormat.letter.width * 0.40,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  empresa.razonSocial,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  empresa.nombre,
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  empresa.direccion,
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "NIT: ${empresa.nit}",
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "${AppLocalizations.of(context)!.translate(
                    BlockTranslate.tiket,
                    'tel',
                  )} ${empresa.tel}",
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
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
            child: isFel
                ? pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        documento.descripcion,
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        documento.titulo,
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'serie',
                        )}: ${documento.serie}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      pw.Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'numero',
                        )} ${documento.no}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      pw.Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'certificacion',
                        )} ${documento.fechaCert}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      pw.Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'firma',
                        ),
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      pw.Text(
                        documento.autorizacion,
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ],
                  )
                : pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'generico',
                        ),
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        documento.titulo,
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

//encabezado del pdf
  pw.Widget buildAlfayOmegaHeader(
    BuildContext context,
    Uint8List logo,
    Empresa empresa,
    Documento documento,
    String fechaClientDoc,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Item 1 (35%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.35,
            height: 115,
            child: pw.Image(
              pw.MemoryImage(logo),
              width: 125,
            ),
          ),
          pw.Container(
            width: PdfPageFormat.letter.width * 0.05,
          ),
          // Item 2 (30%)
          pw.Container(
            alignment: pw.Alignment.centerRight,
            padding: const pw.EdgeInsets.only(top: 10),
            width: PdfPageFormat.letter.width * 0.30,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  empresa.razonSocial,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  empresa.nombre,
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  empresa.direccion,
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "NIT: ${empresa.nit}",
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "${AppLocalizations.of(context)!.translate(
                    BlockTranslate.tiket,
                    'tel',
                  )} ${empresa.tel}",
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
          pw.Container(
            width: PdfPageFormat.letter.width * 0.05,
          ),
          // Item 3 (35%)
          pw.Container(
            padding: const pw.EdgeInsets.only(top: 10),
            width: PdfPageFormat.letter.width * 0.35,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      width: 0.5,
                      color: PdfColors.black,
                    ),
                  ),
                  child: pw.Text(
                    "COTIZACION",
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(3),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              width: 0.5,
                              color: PdfColors.black,
                            ),
                          ),
                          child: pw.Text(
                            "NO. COTIZACION",
                            style: pw.TextStyle(
                              fontSize: 7,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          documento.noInterno,
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.normal,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 10),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(3),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              width: 0.5,
                              color: PdfColors.black,
                            ),
                          ),
                          child: pw.Text(
                            "FECHA DE COTIZACION",
                            style: pw.TextStyle(
                              fontSize: 7,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          (fechaClientDoc),
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.normal,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget buildFooter(
    BuildContext context,
    Uint8List logoDemo,
    Uint8List logoFel,
    EncabezadoModel encabezado,
    bool isFel,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        children: [
          // Item 1 (50%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.20,
            height: 35,
            child: pw.Image(
              pw.MemoryImage(logoFel),
            ),
          ),

          // Item 2 (25%)
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 15),
            width: PdfPageFormat.letter.width * 0.70,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                if (isFel)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'certificador',
                        ),
                        style: const pw.TextStyle(
                            fontSize: 8, color: PdfColors.grey),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "NIT: ${encabezado.certificadorDteNit}",
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'nombre',
                        )} ${encabezado.certificadorDteNombre}",
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      "Powered By:",
                      style: const pw.TextStyle(
                          fontSize: 8, color: PdfColors.grey),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      "Desarrollo Moderno de Software S.A",
                      style: const pw.TextStyle(
                          fontSize: 8, color: PdfColors.grey),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      "www.demosoft.com.gt",
                      style: const pw.TextStyle(
                          fontSize: 8, color: PdfColors.grey),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Item 3 (25%)
          pw.Container(
            width: PdfPageFormat.letter.width * 0.20,
            height: 45,
            child: pw.Image(
              pw.MemoryImage(logoDemo),
            ),
          ),
        ],
      ),
    );
  }
}
