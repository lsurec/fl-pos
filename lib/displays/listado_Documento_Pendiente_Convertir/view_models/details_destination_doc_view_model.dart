// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

class DetailsDestinationDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Detalles del documento destino
  final List<DestinationDetailModel> detalles = [];

  //cargar datos necesarios
  Future<void> loadData(
    BuildContext context,
    DocDestinationModel document, //Documento destino
  ) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.user;

    //Servicio
    final ReceptionService receptionService = ReceptionService();

    //limmpiar detlles previos
    detalles.clear();

    //Iniciar pantalla de carga
    isLoading = true;

    //Consumo del api para obtenr los detalles del documento destino
    final ApiResModel res = await receptionService.getDetallesDocDestino(
        token, // token,
        user, // user,
        document.data.documento, // documento,
        document.data.tipoDocumento, // tipoDocumento,
        document.data.serieDocumento, // serieDocumento,
        document.data.empresa, // epresa,
        document.data.localizacion, // localizacion,
        document.data.estacion, // estacion,
        document.data.fechaReg // fechaReg,
        );

    //detener carga
    isLoading = false;

    //si el consumo salió mal
    if (!res.succes) {
      NotificationService.showErrorView(
        context,
        res,
      );

      return;
    }

    //agregar detalles
    detalles.addAll(res.response);
  }

  //Salir de la pantalla
  Future<bool> backPage(BuildContext context) async {
    //proveedores externos de datos
    final vmPend = Provider.of<PendingDocsViewModel>(context, listen: false);
    final vmConvert = Provider.of<ConvertDocViewModel>(context, listen: false);

    //desmarcar csilla seleccionar transacciones
    vmConvert.selectAllTra = false;

    //iniciar carga
    isLoading = true;

    //cardar documentos origrn
    await vmPend.laodData(context);

    //regresar a docuemntos pendientes de recepcionar
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.pendingDocs));

    //Detener carga
    isLoading = false;

    return false;
  }

  //imprimir docuemnto
  printDoc(
    BuildContext context,
    DocDestinationModel document,
  ) {
    //navegar a pantalla de impresion
    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(
        opcion: 3,
        destination: document,
      ),
    );
  }

  Future shareDoc(
    BuildContext contextP,
    DocDestinationModel document,
  ) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(contextP, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.user;

    //Buscar datos paar imprimir
    final ReceptionService receptionService = ReceptionService();

    isLoading = true;

    final ApiResModel res = await receptionService.getDataPrint(
      token, //token,
      user, //user,
      document.data.documento, //documento,
      document.data.tipoDocumento, //tipoDocumento,
      document.data.serieDocumento, //serieDocumento,
      document.data.empresa, //empresa,
      document.data.localizacion, //localizacion,
      document.data.estacion, //estacion,
      document.data.fechaReg, //fechaReg,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        contextP,
        res,
      );

      return;
    }

    final List<PrintConvertModel> data = res.response;

    if (data.isEmpty) {
      isLoading = false;

      res.response = AppLocalizations.of(contextP)!.translate(
        BlockTranslate.notificacion,
        'sinDatos',
      );

      NotificationService.showErrorView(contextP, res);

      return;
    }

    final vmHome = Provider.of<HomeViewModel>(contextP, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: vmHome
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    final PrintConvertModel encabezado = data.first;

    Empresa empresa = Empresa(
      razonSocial: encabezado.razonSocial ?? "",
      nombre: encabezado.empresaNombre ?? "",
      direccion: encabezado.empresaDireccion ?? "",
      nit: encabezado.empresaNit ?? "",
      tel: encabezado.empresaTelefono ?? "",
    );

    //TODO: Certificar
    Documento documento = Documento(
      consecutivoInterno: 0,
      titulo: encabezado.tipoDocumento!,
      descripcion: AppLocalizations.of(contextP)!.translate(
        BlockTranslate.tiket,
        'generico',
      ),
      fechaCert: "",
      serie: "",
      no: "",
      autorizacion: "",
      noInterno: encabezado.refIdDocumento ?? "",
      serieInterna: encabezado.serieDocumento ?? "",
    );

    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    Cliente cliente = Cliente(
      nombre: encabezado.documentoNombre ?? "",
      direccion: encabezado.documentoDireccion ?? "",
      nit: encabezado.documentoNit ?? "",
      fecha: formattedDate,
      tel: encabezado.documentoTelefono ?? "",
      email: "", //Cambiar aqui,
    );

    String vendedor = encabezado.atendio ?? "";

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
                      )} $vendedor',
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
                                  'cantidad',
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
                                "UM",
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          //Detalle
                          final PrintConvertModel detalle = data[index];
                          return pw.Row(
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.productoId ?? "",
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
                                  detalle.simbolo ?? "",
                                  textAlign: pw.TextAlign.center,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.40,
                                child: pw.Text(
                                  detalle.desProducto ?? "",
                                  textAlign: pw.TextAlign.left,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.montoUMTipoMoneda ?? "",
                                  textAlign: pw.TextAlign.right,
                                  style: font8,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                width: PdfPageFormat.letter.width * 0.10,
                                child: pw.Text(
                                  detalle.montoTotalTipoMoneda ?? "",
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
                                AppLocalizations.of(contextP)!.translate(
                                  BlockTranslate.tiket,
                                  'totalT',
                                ),
                                style: font8BoldWhite,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(
                                  currencyFormat.format(
                                      (encabezado.subTotal ?? 0) +
                                          (encabezado.descuento ?? 0)),
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
                    "*NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES*",
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
          false,
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
    isLoading = false;
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
                  "TEL: ${empresa.tel}",
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
                          BlockTranslate.tiket,
                          'serie',
                        )} ${documento.serie}',
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

  pw.Widget buildFooter(
    BuildContext context,
    Uint8List logoDemo,
    Uint8List logoFel,
    PrintConvertModel encabezado,
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
                      // pw.Text(
                      //   AppLocalizations.of(context)!.translate(
                      //     BlockTranslate.tiket,
                      //     'certificador',
                      //   ),
                      //   style: const pw.TextStyle(
                      //     fontSize: 8,
                      //     color: PdfColors.grey,
                      //   ),
                      //   textAlign: pw.TextAlign.center,
                      // ),
                      // pw.Text(
                      //   "Nit: ${encabezado.certificadorDteNit}",
                      //   style: const pw.TextStyle(
                      //     fontSize: 8,
                      //     color: PdfColors.grey,
                      //   ),
                      //   textAlign: pw.TextAlign.center,
                      // ),
                      // pw.Text(
                      //   "${AppLocalizations.of(context)!.translate(
                      //     BlockTranslate.tiket,
                      //     'nombre',
                      //   )} ${encabezado.certificadorDteNombre}",
                      //   style: const pw.TextStyle(
                      //     fontSize: 8,
                      //     color: PdfColors.grey,
                      //   ),
                      //   textAlign: pw.TextAlign.center,
                      // ),
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
