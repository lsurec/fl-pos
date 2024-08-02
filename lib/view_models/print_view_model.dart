// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/reception_service.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PrintViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<PrintModel> printReceiveTest(
      BuildContext context, int paperDefault) async {
    List<int> bytes = [];
    final generator = Generator(
        AppData.paperSize[paperDefault], await CapabilityProfile.load());
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.tiket,
          "generico",
        ),
        styles: PosStyles(
            align: AppData.posAlign["center"],
            width: AppData.posTextSize[2],
            height: AppData.posTextSize[2]));
    bytes += generator.text("CENTER",
        styles: PosStyles(
            align: AppData.posAlign["center"],
            width: AppData.posTextSize[1],
            height: AppData.posTextSize[1]));
    bytes += generator.text("LEFT",
        styles: PosStyles(align: AppData.posAlign["left"]));
    bytes += generator.text("RIGHT",
        styles: PosStyles(align: AppData.posAlign["right"]));
    bytes += generator.text("normal",
        styles: PosStyles(bold: AppData.boolText["normal"]));
    bytes += generator.text("Bool",
        styles: PosStyles(bold: AppData.boolText["bool"]));

    return PrintModel(
      bytes: bytes,
      generator: generator,
    );
  }

  Future printDocConversion(
    BuildContext context,
    int paperDefault,
    DocDestinationModel document,
  ) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
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

    isLoading = false;

    //si el consumo salió mal
    if (!res.succes) {
      NotificationService.showErrorView(
        context,
        res,
      );

      return;
    }

    final List<PrintConvertModel> data = res.response;

    if (data.isEmpty) {
      res.response = AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        "sinDatos",
      );
      NotificationService.showErrorView(context, res);

      return;
    }

    final vmHome = Provider.of<HomeViewModel>(context, listen: false);

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
      descripcion: AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        "generico",
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
    );

    List<Item> items = [];

    for (var detail in data) {
      items.add(
        Item(
          descripcion: detail.desProducto ?? "",
          cantidad: detail.cantidad ?? 0,
          unitario: detail.montoUMTipoMoneda ?? "",
          total: detail.montoTotalTipoMoneda ?? "",
          sku: detail.productoId ?? "",
          precioDia: detail.montoTotalTipoMoneda ?? "",
        ),
      );
    }

    Montos montos = Montos(
      subtotal: encabezado.subTotal ?? 0,
      cargos: 0,
      descuentos: encabezado.descuento ?? 0,
      total: (encabezado.subTotal ?? 0) + (encabezado.descuento ?? 0),
      totalLetras: encabezado.montoLetras!.toUpperCase(),
    );

    String vendedor = encabezado.atendio ?? "";

    List<String> mensajes = [
      //TODO: Mostrar frase
      // "**Sujeto a pagos trimestrales**",
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        "sinCambios",
      ),
    ];

    PoweredBy poweredBy = PoweredBy(
      nombre: "Desarrollo Moderno de Software S.A.",
      website: "www.demosoft.com.gt",
    );

    DocPrintModel docPrintModel = DocPrintModel(
      empresa: empresa,
      documento: documento,
      cliente: cliente,
      items: items,
      montos: montos,
      pagos: [],
      vendedor: vendedor,
      certificador: Certificador(nombre: "", nit: ""),
      observacion: encabezado.observacion1 ?? "",
      mensajes: mensajes,
      poweredBy: poweredBy,
      noDoc: encabezado.refIdDocumento ?? "",
    );

    List<int> bytes = [];

    final generator = Generator(
      AppData.paperSize[paperDefault],
      await CapabilityProfile.load(),
    );

    PosStyles center = const PosStyles(
      align: PosAlign.center,
    );
    PosStyles centerBold = const PosStyles(
      align: PosAlign.center,
      bold: true,
    );

    bytes += generator.setGlobalCodeTable('CP1252');

    bytes += generator.text(
      docPrintModel.empresa.razonSocial,
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.empresa.nombre,
      styles: center,
    );

    bytes += generator.text(
      docPrintModel.empresa.direccion,
      styles: center,
    );

    bytes += generator.text(
      "NIT: ${docPrintModel.empresa.nit}",
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        "noVinculada",
      )} ${docPrintModel.empresa.tel}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      docPrintModel.documento.titulo,
      styles: centerBold,
    );

    bytes += generator.text(
      docPrintModel.documento.descripcion,
      styles: centerBold,
    );

    bytes += generator.emptyLines(1);
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'interno',
      )} ${docPrintModel.documento.noInterno}",
      styles: center,
    );
    bytes += generator.emptyLines(1);
    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'cliente',
      ),
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'nombre',
      )} ${docPrintModel.cliente.nombre}",
      styles: center,
    );
    bytes += generator.text(
      "NIT: ${docPrintModel.cliente.nit}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'direccion',
      )} ${docPrintModel.cliente.direccion}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'tel',
      )}: ${docPrintModel.cliente.tel}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.fecha,
        'fecha',
      )}: ${docPrintModel.cliente.fecha}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
          text: "Pre Repo.",
          width: 2,
        ),
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'cantidad',
          ),
          width: 2,
        ), // Ancho 2
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.general,
            'descripcion',
          ),
          width: 4,
        ), // Ancho 6
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'precioU',
          ),
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'monto',
          ),
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
      ],
    );

    for (var transaction in docPrintModel.items) {
      bytes += generator.row(
        [
          PosColumn(
            text: "${transaction.cantidad}",
            width: 2,
          ), // Ancho 2
          PosColumn(
            text: transaction.descripcion,
            width: 4,
          ), // Ancho 6
          PosColumn(
            text: transaction.unitario,
            width: 3,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ), // Ancho 4
          PosColumn(
            text: transaction.total,
            width: 3,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ), // Ancho 4
        ],
      );
    }

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'subTotal',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.subtotal),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'cargos',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.cargos),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'descuentos',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.descuentos),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
            text: AppLocalizations.of(context)!.translate(
              BlockTranslate.tiket,
              'totalT',
            ),
            styles: const PosStyles(
              bold: true,
              width: PosTextSize.size2,
            ),
            width: 6,
            containsChinese: false),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.total),
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            width: PosTextSize.size2,
            underline: true,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.text(
      docPrintModel.montos.totalLetras,
      styles: centerBold,
    );

    bytes += generator.emptyLines(1);

    //Si la lista de vendedores no está vacia imprimir
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'vendedor',
      )} ${docPrintModel.vendedor}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    for (var mensaje in docPrintModel.mensajes) {
      bytes += generator.text(
        mensaje,
        styles: centerBold,
      );
    }

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "--------------------",
      styles: center,
    );

    bytes += generator.text(
      "Powered by",
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.poweredBy.nombre,
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.poweredBy.website,
      styles: center,
    );
    return PrintModel(
      bytes: bytes,
      generator: generator,
    );
  }

  int findTipoProducto(BuildContext context, tipoTra) {
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    List<TipoTransaccionModel> transacciones = docVM.tiposTransaccion;

    for (var transaccion in transacciones) {
      if (transaccion.tipoTransaccion == tipoTra) {
        return transaccion.tipo;
      }
    }

    return 0;
  }

  Future printDocument(
    BuildContext context,
    int paperDefault,
    int consecutivoDoc,
    String? cuentaCorrentistaRef,
    ClientModel clinetDoc,
  ) async {
    //instancia del servicio
    DocumentService documentService = DocumentService();
    //Proveedores externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //usario y token
    String user = loginVM.user;
    String token = loginVM.token;

    //iniciar proceso
    isLoading = true;

    //consumir servicio
    ApiResModel resEncabezado = await documentService.getEncabezados(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resEncabezado.succes) {
      //finalozar el proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resEncabezado,
      );

      return;
    }

    List<EncabezadoModel> encabezadoTemplate = resEncabezado.response;

    //consumir servicio
    ApiResModel resDetalle = await documentService.getDetalles(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resDetalle.succes) {
      //finalozar el proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resDetalle,
      );
      return;
    }

    List<DetalleModel> detallesTemplate = resDetalle.response;

    //consumir servicio
    ApiResModel resPago = await documentService.getPagos(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resPago.succes) {
      //finalozar el proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resPago,
      );
      return;
    }

    List<PagoModel> pagosTemplate = resPago.response;

    isLoading = false;

    //validar que haya datos

    if (encabezadoTemplate.isEmpty) {
      resEncabezado.response = AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'sinEncabezados',
      );
      NotificationService.showErrorView(context, resEncabezado);

      return;
    }

    final vmHome = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: vmHome
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    // Decodifica el JSON

    // Crea un objeto DocPrintModel
    // final docPrintModel = DocPrintModel.fromMap(jsonData);

    final EncabezadoModel encabezado = encabezadoTemplate.first;

    Empresa empresa = Empresa(
      razonSocial: encabezado.razonSocial!,
      nombre: encabezado.empresaNombre!,
      direccion: encabezado.empresaDireccion!,
      nit: encabezado.empresaNit!,
      tel: encabezado.empresaTelefono!,
    );

    String formattedDateCert = "";

    if (encabezado.feLFechaCertificacion != null) {
      DateTime dateTimeCert = DateTime.parse(encabezado.feLFechaCertificacion);
      formattedDateCert =
          "${dateTimeCert.day}/${dateTimeCert.month}/${dateTimeCert.year} ${dateTimeCert.hour}:${dateTimeCert.minute}:${dateTimeCert.second}";
    }

    //TODO: Certificar
    Documento documento = Documento(
      titulo: encabezado.tipoDocumento!,
      descripcion: AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'docTributario',
      ),
      fechaCert: formattedDateCert,
      serie: encabezado.feLSerie ?? "",
      no: encabezado.feLNumeroDocumento ?? "",
      autorizacion: encabezado.feLUuid ?? "",
      noInterno: encabezado.iDDocumentoRef ?? "",
      serieInterna: encabezado.serieDocumento ?? "",
      consecutivoInterno: consecutivoDoc,
    );

    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    Cliente cliente = Cliente(
      nombre: clinetDoc.facturaNombre,
      direccion: clinetDoc.facturaDireccion,
      nit: clinetDoc.facturaNit,
      fecha: formattedDate,
      tel: clinetDoc.telefono,
    );

    //totales
    double cargo = 0;
    double descuento = 0;
    double subtotal = 0;
    double total = 0;

    List<Item> items = [];

    for (var detail in detallesTemplate) {
      int tipoTra = findTipoProducto(
        context,
        detail.tipoTransaccion,
      );

      if (tipoTra == 4) {
        //4 cargo
        cargo += detail.monto;
      } else if (tipoTra == 3) {
        //5 descuento
        descuento += detail.monto;
      } else {
        //cualquier otro
        subtotal += detail.monto;
      }

      items.add(
        Item(
          descripcion: detail.desProducto,
          cantidad: detail.cantidad,
          unitario: tipoTra == 3
              ? "- ${detail.montoUMTipoMoneda}"
              : detail.montoUMTipoMoneda,
          total: tipoTra == 3
              ? "- ${detail.montoTotalTipoMoneda}"
              : detail.montoTotalTipoMoneda,
          sku: detail.productoId,
          precioDia: tipoTra == 3
              ? "- ${detail.montoTotalTipoMoneda}"
              : detail.montoTotalTipoMoneda,
        ),
      );
    }

    total += (subtotal + cargo) + descuento;

    Montos montos = Montos(
      subtotal: subtotal,
      cargos: cargo,
      descuentos: descuento,
      total: total,
      totalLetras: encabezado.montoLetras!.toUpperCase(),
    );

    List<Pago> pagos = [];

    for (var pago in pagosTemplate) {
      pagos.add(
        Pago(
          tipoPago: pago.fDesTipoCargoAbono,
          monto: pago.monto,
          pago: pago.monto + pago.cambio,
          cambio: pago.cambio,
        ),
      );
    }

    String vendedor = cuentaCorrentistaRef ?? "";

    Certificador certificador = Certificador(
      nombre: encabezado.certificadorDteNombre!,
      nit: encabezado.certificadorDteNit!,
    );

    final confirmVM = Provider.of<ConfirmDocViewModel>(context, listen: false);

    List<String> mensajes = [
      //TODO: Mostrar frase
      // "**Sujeto a pagos trimestrales**",
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'sinCambios',
      ),
    ];

    PoweredBy poweredBy = PoweredBy(
      nombre: "Desarrollo Moderno de Software S.A.",
      website: "demosoft.com.gt",
    );

    DocPrintModel docPrintModel = DocPrintModel(
      empresa: empresa,
      documento: documento,
      cliente: cliente,
      items: items,
      montos: montos,
      pagos: pagos,
      vendedor: vendedor,
      certificador: certificador,
      observacion: confirmVM.observacion.text,
      mensajes: mensajes,
      poweredBy: poweredBy,
      noDoc: encabezado.iDDocumentoRef ?? "",
    );

    List<int> bytes = [];

    final generator = Generator(
      AppData.paperSize[paperDefault],
      await CapabilityProfile.load(),
    );

    PosStyles center = const PosStyles(
      align: PosAlign.center,
    );
    PosStyles centerBold = const PosStyles(
      align: PosAlign.center,
      bold: true,
    );

    bytes += generator.setGlobalCodeTable('CP1252');

    bytes += generator.text(
      docPrintModel.empresa.razonSocial,
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.empresa.nombre,
      styles: center,
    );

    bytes += generator.text(
      docPrintModel.empresa.direccion,
      styles: center,
    );

    bytes += generator.text(
      "NIT: ${docPrintModel.empresa.nit}",
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'tel',
      )} ${docPrintModel.empresa.tel}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      docPrintModel.documento.titulo,
      styles: centerBold,
    );

    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    final bool isFel = docVM.printFel(); //TODO:Parametrizar

    if (!isFel) {
      bytes += generator.text(
        "DOCUMENTO GENERICO",
        styles: centerBold,
      );
      bytes += generator.emptyLines(1);
    }

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'serie',
      )} ${docPrintModel.documento.serieInterna}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'interno',
      )} ${docPrintModel.documento.noInterno}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'consInt',
      )} ${docPrintModel.documento.consecutivoInterno}",
      styles: center,
    );
    bytes += generator.emptyLines(1);

    if (isFel) {
      bytes += generator.text(
        docPrintModel.documento.descripcion,
        styles: centerBold,
      );
      bytes += generator.emptyLines(1);

      bytes += generator.text("Serie: ${docPrintModel.documento.serie}",
          styles: center);
      bytes +=
          generator.text("No: ${docPrintModel.documento.no}", styles: center);
      bytes += generator.text("Fecha: ${docPrintModel.documento.fechaCert}",
          styles: center);

      bytes += generator.text(
        "Autorizacion:",
        styles: centerBold,
      );

      bytes += generator.text(
        docPrintModel.documento.autorizacion,
        styles: centerBold,
      );
    }

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'cliente',
      ),
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'nombre',
      )} ${docPrintModel.cliente.nombre}",
      styles: center,
    );
    bytes += generator.text(
      "NIT: ${docPrintModel.cliente.nit}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'direccion',
      )} ${docPrintModel.cliente.direccion}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.fecha,
        'fecha',
      )} ${docPrintModel.cliente.fecha}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(text: 'Cant.', width: 2), // Ancho 2
        PosColumn(text: 'Descripcion', width: 4), // Ancho 6
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'precioU',
          ),
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'monto',
          ),
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
      ],
    );

    for (var transaction in docPrintModel.items) {
      bytes += generator.row(
        [
          PosColumn(
            text: "${transaction.cantidad}",
            width: 2,
          ), // Ancho 2
          PosColumn(
            text: transaction.descripcion,
            width: 4,
          ), // Ancho 6
          PosColumn(
            text: transaction.unitario,
            width: 3,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ), // Ancho 4
          PosColumn(
            text: transaction.total,
            width: 3,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ), // Ancho 4
        ],
      );
    }

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'subTotal',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.subtotal),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'cargos',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.cargos),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'descuentos',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.descuentos),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
            text: AppLocalizations.of(context)!.translate(
              BlockTranslate.tiket,
              'totalT',
            ),
            styles: const PosStyles(
              bold: true,
              width: PosTextSize.size2,
            ),
            width: 6,
            containsChinese: false),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.total),
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            width: PosTextSize.size2,
            underline: true,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.text(
      docPrintModel.montos.totalLetras,
      styles: centerBold,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'detallePago',
      ),
      styles: center,
    );

    for (var pago in docPrintModel.pagos) {
      bytes += generator.row(
        [
          PosColumn(
            text: "",
            width: 6,
          ),
          PosColumn(
            text: pago.tipoPago,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
            width: 6,
          ),
        ],
      );
      bytes += generator.row(
        [
          PosColumn(
            text: AppLocalizations.of(context)!.translate(
              BlockTranslate.tiket,
              'recibido',
            ),
            width: 6,
          ),
          PosColumn(
            text: currencyFormat.format(pago.pago),
            styles: const PosStyles(
              align: PosAlign.right,
            ),
            width: 6,
          ),
        ],
      );
      bytes += generator.row(
        [
          PosColumn(
            text: AppLocalizations.of(context)!.translate(
              BlockTranslate.tiket,
              'monto',
            ),
            width: 6,
          ),
          PosColumn(
            text: currencyFormat.format(pago.monto),
            styles: const PosStyles(
              align: PosAlign.right,
            ),
            width: 6,
          ),
        ],
      );
      bytes += generator.row(
        [
          PosColumn(
            text: AppLocalizations.of(context)!.translate(
              BlockTranslate.tiket,
              'cambio',
            ),
            width: 6,
          ),
          PosColumn(
            text: currencyFormat.format(pago.cambio),
            styles: const PosStyles(
              align: PosAlign.right,
            ),
            width: 6,
          ),
        ],
      );
    }

    bytes += generator.emptyLines(1);

    //Si la lista de vendedores no está vacia imprimir
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'vendedor',
      )} ${docPrintModel.vendedor}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    for (var mensaje in docPrintModel.mensajes) {
      bytes += generator.text(
        mensaje,
        styles: centerBold,
      );
    }
    bytes += generator.emptyLines(1);

    if (isFel) {
      bytes += generator.text(
        "Ceritificador:",
        styles: center,
      );

      bytes += generator.text(
        docPrintModel.certificador.nombre,
        styles: center,
      );

      bytes += generator.text(
        docPrintModel.certificador.nit,
        styles: center,
      );
    }
    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "--------------------",
      styles: center,
    );

    bytes += generator.text(
      "Powered by",
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.poweredBy.nombre,
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.poweredBy.website,
      styles: center,
    );
    return PrintModel(
      bytes: bytes,
      generator: generator,
    );
  }

  //impresion para cotizacion: Alfa y omega

  Future printDocumentAlfayOmega(
    BuildContext context,
    int paperDefault,
    int consecutivoDoc,
    String? cuentaCorrentistaRef,
    ClientModel? clinetDoc,
  ) async {
    //instancia del servicio
    DocumentService documentService = DocumentService();
    //Proveedores externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //usario y token
    String user = loginVM.user;
    String token = loginVM.token;

    //iniciar proceso
    isLoading = true;

    //consumir servicio
    ApiResModel resEncabezado = await documentService.getEncabezados(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resEncabezado.succes) {
      //finalozar el proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resEncabezado,
      );

      return;
    }

    List<EncabezadoModel> encabezadoTemplate = resEncabezado.response;

    //consumir servicio
    ApiResModel resDetalle = await documentService.getDetalles(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resDetalle.succes) {
      //finalozar el proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resDetalle,
      );
      return;
    }

    List<DetalleModel> detallesTemplate = resDetalle.response;

    //consumir servicio
    ApiResModel resPago = await documentService.getPagos(
      consecutivoDoc, // doc,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resPago.succes) {
      //finalozar el proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resPago,
      );
      return;
    }

    List<PagoModel> pagosTemplate = resPago.response;

    isLoading = false;

    //validar que haya datos

    if (encabezadoTemplate.isEmpty) {
      resEncabezado.response = AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'sinEncabezados',
      );
      NotificationService.showErrorView(context, resEncabezado);

      return;
    }

    final vmHome = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: vmHome
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    // Decodifica el JSON

    // Crea un objeto DocPrintModel
    // final docPrintModel = DocPrintModel.fromMap(jsonData);

    final EncabezadoModel encabezado = encabezadoTemplate.first;

    Empresa empresa = Empresa(
      razonSocial: encabezado.razonSocial!,
      nombre: encabezado.empresaNombre!,
      direccion: encabezado.empresaDireccion!,
      nit: encabezado.empresaNit!,
      tel: encabezado.empresaTelefono!,
    );

    //fechas
    Fechas fechas = Fechas(
      fechaInicioRef: encabezado.refFechaIni,
      fechaFinRef: encabezado.refFechaFin,
      fechaInicio: encabezado.fechaIni,
      fechaFin: encabezado.fechaFin,
    );

    ObservacionesRef observacionesRef = ObservacionesRef(
      descripcion: encabezado.refDescripcion ?? "",
      observacion: encabezado.refObservacion ?? "",
      observacion2: encabezado.refObservacion2 ?? "",
      observacion3: encabezado.refObservacion3 ?? "",
    );

    String formattedDateCert = "";

    if (encabezado.feLFechaCertificacion != null) {
      DateTime dateTimeCert = DateTime.parse(encabezado.feLFechaCertificacion);
      formattedDateCert =
          "${dateTimeCert.day}/${dateTimeCert.month}/${dateTimeCert.year} ${dateTimeCert.hour}:${dateTimeCert.minute}:${dateTimeCert.second}";
    }

    //TODO: Certificar
    Documento documento = Documento(
      titulo: encabezado.tipoDocumento!,
      descripcion: AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'docTributario',
      ),
      fechaCert: formattedDateCert,
      serie: encabezado.feLSerie ?? "",
      no: encabezado.feLNumeroDocumento ?? "",
      autorizacion: encabezado.feLUuid ?? "",
      noInterno: encabezado.iDDocumentoRef ?? "",
      serieInterna: encabezado.serieDocumento ?? "",
      consecutivoInterno: consecutivoDoc,
    );

    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    Cliente cliente = Cliente(
      nombre: clinetDoc?.facturaNombre ?? "",
      direccion: clinetDoc?.facturaDireccion ?? "",
      nit: clinetDoc?.facturaNit ?? "",
      fecha: formattedDate,
      tel: clinetDoc?.telefono ?? "",
    );

    //totales
    double cargo = 0;
    double descuento = 0;
    double subtotal = 0;
    double total = 0;

    final menuVM = Provider.of<MenuViewModel>(context, listen: false);

    List<Item> items = [];

    for (var detail in detallesTemplate) {
      if (detail.cantidad == 0 && detail.monto > 0) {
        //4 cargo
        cargo += detail.monto;
      } else if (detail.cantidad == 0 && detail.monto < 0) {
        //5 descuento
        descuento += detail.monto;
      } else {
        //cualquier otro
        subtotal += detail.monto;
      }

      double precioUni = menuVM.documento! == 20
          ? detail.cantidad > 0
              ? (detail.monto / encabezado.cantidadDiasFechaIniFin) /
                  detail.cantidad
              : detail.monto
          : detail.cantidad > 0
              ? detail.monto / detail.cantidad
              : detail.monto;

      items.add(
        Item(
            descripcion: detail.desProducto,
            cantidad: detail.cantidad,
            unitario: precioUni.toString(),
            total: detail.monto.toString(),
            sku: detail.productoId,
            precioDia: detail.monto.toString(),
            precioReposicion: detail.precioReposicion.toString().isNotEmpty &&
                    detail.precioReposicion != null
                ? detail.precioReposicion.toString()
                : "00.00"),
      );
    }

    total += (subtotal + cargo) + descuento;

    Montos montos = Montos(
      subtotal: subtotal,
      cargos: cargo,
      descuentos: descuento,
      total: total,
      totalLetras: encabezado.montoLetras!.toUpperCase(),
    );

    List<Pago> pagos = [];

    for (var pago in pagosTemplate) {
      pagos.add(
        Pago(
          tipoPago: pago.fDesTipoCargoAbono,
          monto: pago.monto,
          pago: pago.monto + pago.cambio,
          cambio: pago.cambio,
        ),
      );
    }

    String vendedor = cuentaCorrentistaRef ?? "";

    Certificador certificador = Certificador(
      nombre: encabezado.certificadorDteNombre!,
      nit: encabezado.certificadorDteNit!,
    );

    final confirmVM = Provider.of<ConfirmDocViewModel>(context, listen: false);
    //View model para obtenerla empresa
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    EmpresaModel empresaImg = vmLocal.selectedEmpresa!;

    List<String> mensajes = [
      //TODO: Mostrar frase
      // "**Sujeto a pagos trimestrales**",
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'sinCambios',
      ),
    ];

    PoweredBy poweredBy = PoweredBy(
      nombre: "Desarrollo Moderno de Software S.A.",
      website: "demosoft.com.gt",
    );

    //Enviamos las propiedades de fechas, referencias, vededrores, img empresa,
    DocPrintModel docPrintModel = DocPrintModel(
      empresa: empresa,
      documento: documento,
      cliente: cliente,
      items: items,
      montos: montos,
      pagos: pagos,
      vendedor: vendedor,
      certificador: certificador,
      observacion: confirmVM.observacion.text,
      mensajes: mensajes,
      poweredBy: poweredBy,
      noDoc: encabezado.iDDocumentoRef ?? "",
      evento: encabezado.fDesTipoReferencia ?? "",
      emailVendedor: encabezado.cuentaCorrentistaRefEMail ?? "",
      cantidadDias: encabezado.cantidadDiasFechaIniFin,
      fechas: fechas,
      refObservaciones: observacionesRef,
      image64Empresa: empresaImg.empresaImg,
    );

    List<int> bytes = [];

    final generator = Generator(
      AppData.paperSize[paperDefault],
      await CapabilityProfile.load(),
    );

    PosStyles center = const PosStyles(
      align: PosAlign.center,
    );

    PosStyles centerBold = const PosStyles(
      align: PosAlign.center,
      bold: true,
    );

    bytes += generator.setGlobalCodeTable('CP1252');

    bytes += generator.text(
      docPrintModel.empresa.razonSocial,
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.empresa.nombre,
      styles: center,
    );

    bytes += generator.text(
      docPrintModel.empresa.direccion,
      styles: center,
    );

    bytes += generator.text(
      "NIT: ${docPrintModel.empresa.nit}",
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'tel',
      )} ${docPrintModel.empresa.tel}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      docPrintModel.documento.titulo,
      styles: centerBold,
    );

    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    final bool isFel = docVM.printFel(); //TODO:Parametrizar

    if (!isFel) {
      bytes += generator.text(
        "DOCUMENTO GENERICO",
        styles: centerBold,
      );
      bytes += generator.emptyLines(1);
    }

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'serie',
      )} ${docPrintModel.documento.serieInterna}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'interno',
      )} ${docPrintModel.documento.noInterno}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'consInt',
      )} ${docPrintModel.documento.consecutivoInterno}",
      styles: center,
    );
    bytes += generator.emptyLines(1);

//Traducir
    if (isFel) {
      bytes += generator.text(
        docPrintModel.documento.descripcion,
        styles: centerBold,
      );
      bytes += generator.emptyLines(1);

      bytes += generator.text(
        "Serie: ${docPrintModel.documento.serie}",
        styles: center,
      );
      bytes += generator.text(
        "No: ${docPrintModel.documento.no}",
        styles: center,
      );

      bytes += generator.text(
        "Fecha: ${docPrintModel.documento.fechaCert}",
        styles: center,
      );

      bytes += generator.text(
        "Autorizacion:",
        styles: centerBold,
      );

      bytes += generator.text(
        docPrintModel.documento.autorizacion,
        styles: centerBold,
      );

      bytes += generator.emptyLines(1);
    }

    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'cliente',
      ),
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'nombre',
      )} ${docPrintModel.cliente.nombre}",
      styles: center,
    );
    bytes += generator.text(
      "NIT: ${docPrintModel.cliente.nit}",
      styles: center,
    );
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'direccion',
      )} ${docPrintModel.cliente.direccion}",
      styles: center,
    );

    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.fecha,
        'fecha',
      )} ${docPrintModel.cliente.fecha}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

//Nuevos campos

    //Evento tipo ref
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.tiket,
        'tipoRef',
      )}: ${docPrintModel.evento}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    //fecha evento
    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.fecha,
        'eventoF',
      ),
      styles: center,
    );

    //fecha inicio - fin evento
    bytes += generator.text(
      "${Utilities.formatoFechaString(docPrintModel.fechas?.fechaInicio)} - ${Utilities.formatoFechaString(docPrintModel.fechas?.fechaFin)}",
      styles: center,
    );

    //Fecha entrega
    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.fecha,
        'entrega',
      ),
      styles: center,
    );

    bytes += generator.text(
      Utilities.formatoFechaString(docPrintModel.fechas?.fechaInicioRef),
      styles: center,
    );

    //Fecha recoger
    bytes += generator.text(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.fecha,
        'recoger',
      ),
      styles: center,
    );

    bytes += generator.text(
      Utilities.formatoFechaString(docPrintModel.fechas?.fechaFinRef),
      styles: center,
    );

    bytes += generator.emptyLines(1);

    //Cantidad de dias
    bytes += generator.text(
      "${AppLocalizations.of(context)!.translate(
        BlockTranslate.calcular,
        'cantDias',
      )}: ${docPrintModel.cantidadDias}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(text: 'P.Repo', width: 2), // Ancho 1
        PosColumn(text: 'Cant.', width: 2), // Ancho 2
        PosColumn(text: 'Descripcion', width: 3), // Ancho 6
        PosColumn(
          text: 'P/U',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'monto',
          ),
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
      ],
    );

    for (var transaction in docPrintModel.items) {
      bytes += generator.row(
        [
          PosColumn(
            text: "${transaction.precioReposicion}",
            width: 2,
          ),
          PosColumn(
            text: "${transaction.cantidad}",
            width: 2,
          ), // Ancho 2
          PosColumn(
            text: transaction.descripcion,
            width: 3,
          ), // Ancho 6
          PosColumn(
            text: transaction.unitario,
            width: 2,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ), // Ancho 4
          PosColumn(
            text: transaction.total,
            width: 3,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ), // Ancho 4
        ],
      );
    }

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'subTotal',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.subtotal),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'cargos',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.cargos),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'descuentos',
          ),
          width: 6,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.descuentos),
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(
          text: AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'totalT',
          ),
          styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
          ),
          width: 6,
          containsChinese: false,
        ),
        PosColumn(
          text: currencyFormat.format(docPrintModel.montos.total),
          styles: const PosStyles(
            bold: true,
            align: PosAlign.right,
            width: PosTextSize.size2,
            underline: true,
          ),
          width: 6,
        ),
      ],
    );

    bytes += generator.text(
      docPrintModel.montos.totalLetras,
      styles: centerBold,
    );

    bytes += generator.emptyLines(1);

    //si hay pagos
    if (docPrintModel.pagos.isNotEmpty) {
      bytes += generator.text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.tiket,
          'detallePago',
        ),
        styles: center,
      );

      for (var pago in docPrintModel.pagos) {
        bytes += generator.row(
          [
            PosColumn(
              text: "",
              width: 6,
            ),
            PosColumn(
              text: pago.tipoPago,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
              width: 6,
            ),
          ],
        );
        bytes += generator.row(
          [
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.tiket,
                'recibido',
              ),
              width: 6,
            ),
            PosColumn(
              text: currencyFormat.format(pago.pago),
              styles: const PosStyles(
                align: PosAlign.right,
              ),
              width: 6,
            ),
          ],
        );
        bytes += generator.row(
          [
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.tiket,
                'monto',
              ),
              width: 6,
            ),
            PosColumn(
              text: currencyFormat.format(pago.monto),
              styles: const PosStyles(
                align: PosAlign.right,
              ),
              width: 6,
            ),
          ],
        );
        bytes += generator.row(
          [
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.tiket,
                'cambio',
              ),
              width: 6,
            ),
            PosColumn(
              text: currencyFormat.format(pago.cambio),
              styles: const PosStyles(
                align: PosAlign.right,
              ),
              width: 6,
            ),
          ],
        );
      }

      bytes += generator.emptyLines(1);
    }

    //Si la lista de vendedores no está vacia imprimir
    //vendedor
    if (docPrintModel.vendedor.isNotEmpty) {
      bytes += generator.text(
        "${AppLocalizations.of(context)!.translate(
          BlockTranslate.tiket,
          'vendedor',
        )} ${docPrintModel.vendedor}",
        styles: center,
      );
    }

    //email vendedor
    if (docPrintModel.emailVendedor != null &&
        docPrintModel.emailVendedor!.isNotEmpty) {
      bytes += generator.text(
        "${AppLocalizations.of(context)!.translate(
          BlockTranslate.cuenta,
          'correo',
        )} ${docPrintModel.emailVendedor}",
        styles: center,
      );
    }

    bytes += generator.emptyLines(1);

    //Descripcion

    if (docPrintModel.refObservaciones?.descripcion != null &&
        docPrintModel.refObservaciones!.descripcion.isNotEmpty) {
      bytes += generator.text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.general,
          'descripcion',
        ),
        styles: center,
      );

      //contenido descrioxion
      bytes += generator.text(
        "${docPrintModel.refObservaciones?.descripcion}",
        styles: center,
      );

      bytes += generator.emptyLines(1);
    }

    //Observacion
    if (docPrintModel.refObservaciones?.observacion != null &&
        docPrintModel.refObservaciones!.observacion.isNotEmpty) {
      bytes += generator.text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.general,
          'observacion',
        ),
        styles: center,
      );

      //contenido obsercacion
      bytes += generator.text(
        "${docPrintModel.refObservaciones?.observacion}",
        styles: center,
      );

      bytes += generator.emptyLines(1);
    }

    //Observacion 2 = Contacto
    if (docPrintModel.refObservaciones?.observacion2 != null &&
        docPrintModel.refObservaciones!.observacion2.isNotEmpty) {
      bytes += generator.text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.tiket,
          'contacto',
        ),
        styles: center,
      );

      //contenido contato
      bytes += generator.text(
        "${docPrintModel.refObservaciones?.observacion2}",
        styles: center,
      );

      bytes += generator.emptyLines(1);
    }

    //Observacion 3 = Direccion entrega

    if (docPrintModel.refObservaciones?.observacion3 != null &&
        docPrintModel.refObservaciones!.observacion3.isNotEmpty) {
      bytes += generator.text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.cotizacion,
          'direEntrega',
        ),
        styles: center,
      );

      //contenido dreccio entrega
      bytes += generator.text(
        "${docPrintModel.refObservaciones?.observacion3}",
        styles: center,
      );

      bytes += generator.emptyLines(1);
    }

    bytes += generator.text(
      "CONTRATO DE TERMINOS Y CONDICIONES",
      styles: center,
    );

    bytes += generator.text(
      " DE LA COTIZACION",
      styles: center,
    );

    bytes += generator.emptyLines(1);
    //1:
    bytes += generator.text(
      "1. Esta Cotización no es reservación.",
      styles: center,
    );
    //2:
    bytes += generator.text(
      "2. Al confrmar su cotizacion se requiere de contrato firmado.",
      styles: center,
    );
    //3:
    bytes += generator.text(
      "3. Los precios cotizados estan sujetos a cambios.",
      styles: center,
    );
    //4:
    bytes += generator.text(
      "4. Se cobrara Q 125.00 por cheque rechazado por cargos administrativos.",
      styles: center,
    );
    //5:
    bytes += generator.text(
      "5. Se solicitara cheque de garantía.",
      styles: center,
    );
    //6:
    bytes += generator.text(
      "6. Se cobrará por daños al mobiliario y equipo según contrato.",
      styles: center,
    );

    bytes += generator.text(
      "--------------------",
      styles: center,
    );

    bytes += generator.text(
      "Powered by",
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.poweredBy.nombre,
      styles: center,
    );
    bytes += generator.text(
      docPrintModel.poweredBy.website,
      styles: center,
    );
    return PrintModel(
      bytes: bytes,
      generator: generator,
    );
  }
}
