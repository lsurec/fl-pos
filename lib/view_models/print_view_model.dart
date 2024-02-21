// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/reception_service.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
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

  Future<PrintModel> printReceiveTest(int paperDefault) async {
    List<int> bytes = [];
    final generator = Generator(
        AppData.paperSize[paperDefault], await CapabilityProfile.load());
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text("PRUEBA TICKET",
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
    final String user = loginVM.nameUser;

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
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    final List<PrintConvertModel> data = res.message;

    if (data.isEmpty) {
      final ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description:
            "No se han encontrado datos para la impresion del documento, verifique el procedimiento almacenado.",
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(context, error);

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
      titulo: encabezado.tipoDocumento!,
      descripcion: "DOCUMENTO GENERICO",
      fechaCert: "",
      serie: "",
      no: "",
      autorizacion: "",
      noInterno: "${encabezado.serieDocumento}-${encabezado.idDocumento}",
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
      "*NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES*"
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
      "Tel: ${docPrintModel.empresa.tel}",
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
      "No. Interno: ${docPrintModel.documento.noInterno}",
      styles: center,
    );
    bytes += generator.emptyLines(1);
    bytes += generator.text(
      "Cliente:",
      styles: center,
    );

    bytes += generator.text(
      "Nombre: ${docPrintModel.cliente.nombre}",
      styles: center,
    );
    bytes += generator.text(
      "NIT: ${docPrintModel.cliente.nit}",
      styles: center,
    );
    bytes += generator.text(
      "Direccion: ${docPrintModel.cliente.direccion}",
      styles: center,
    );
    bytes += generator.text(
      "Tel: ${docPrintModel.cliente.tel}",
      styles: center,
    );
    bytes += generator.text(
      "Fecha: ${docPrintModel.cliente.fecha}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(text: 'Cant.', width: 2), // Ancho 2
        PosColumn(text: 'Descripcion', width: 4), // Ancho 6
        PosColumn(
          text: 'Precio U',
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
        PosColumn(
          text: 'Monto',
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
          text: "Sub-Total",
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
          text: "Cargos",
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
          text: "Descuentos",
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
            text: "TOTAL",
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
      "Vendedor: ${docPrintModel.vendedor}",
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
  ) async {
    //instancia del servicio
    DocumentService documentService = DocumentService();
    //Proveedores externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //usario y token
    String user = loginVM.nameUser;
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

      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resEncabezado.message,
        url: resEncabezado.url,
        storeProcedure: resEncabezado.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    List<EncabezadoModel> encabezadoTemplate = resEncabezado.message;

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

      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resDetalle.message,
        url: resDetalle.url,
        storeProcedure: resDetalle.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    List<DetalleModel> detallesTemplate = resDetalle.message;

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

      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resPago.message,
        url: resPago.url,
        storeProcedure: resPago.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    List<PagoModel> pagosTemplate = resPago.message;

    isLoading = false;

    //validar que haya datos

    if (encabezadoTemplate.isEmpty) {
      final ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description:
            "No se han encontrado encabezados para la impresion del documento, verifique el procedimiento almacenado.",
        storeProcedure: resEncabezado.storeProcedure,
      );

      NotificationService.showErrorView(context, error);

      return;
    }

    //TODO:parametrizar rplantilla, elininar

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

    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    bool isFel = docVM.printFel();

    final EncabezadoModel encabezado = encabezadoTemplate.first;

    Empresa empresa = Empresa(
      razonSocial: encabezado.razonSocial!,
      nombre: encabezado.empresaNombre!,
      direccion: encabezado.empresaDireccion!,
      nit: encabezado.empresaNit!,
      tel: encabezado.empresaTelefono!,
    );

    //TODO: Certificar
    Documento documento = Documento(
      titulo: encabezado.tipoDocumento!,
      descripcion: "FEL DOCUMENTO TRIBUTARIO ELECTRONICO",
      fechaCert: encabezado.feLFechaCertificacion ?? "",
      serie: encabezado.feLSerie ?? "",
      no: encabezado.feLNumeroDocumento ?? "",
      autorizacion: encabezado.feLUuid ?? "",
      noInterno: "${encabezado.serieDocumento}-${encabezado.idDocumento}",
    );

    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    Cliente cliente = Cliente(
      nombre: docVM.clienteSelect!.facturaNombre,
      direccion: docVM.clienteSelect!.facturaDireccion,
      nit: docVM.clienteSelect!.facturaNit,
      fecha: formattedDate,
      tel: "",
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
      "*NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES*"
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
      "Tel: ${docPrintModel.empresa.tel}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text(
      docPrintModel.documento.titulo,
      styles: centerBold,
    );

    if (!isFel) {
      bytes += generator.text(
        "DOCUMENTO GENERICO",
        styles: centerBold,
      );
    }

    if (isFel) {
      bytes += generator.text(
        docPrintModel.documento.descripcion,
        styles: centerBold,
      );
      bytes += generator.text(
          "Fecha certificacion: ${docPrintModel.documento.fechaCert}",
          styles: center);
      bytes += generator.row(
        [
          PosColumn(
            text: "Factura No.",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.center,
            ),
          ),
          PosColumn(
            text: "Serie:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.center,
            ),
          ),
        ],
      );

      bytes += generator.row(
        [
          PosColumn(
            text: docPrintModel.documento.no,
            styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              align: PosAlign.center,
            ),
            width: 6,
          ),
          PosColumn(
            text: docPrintModel.documento.serie,
            styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              align: PosAlign.center,
            ),
            width: 6,
          ),
        ],
      );

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
      "No. Interno: ${docPrintModel.documento.noInterno}",
      styles: center,
    );
    bytes += generator.emptyLines(1);
    bytes += generator.text(
      "Cliente:",
      styles: center,
    );

    bytes += generator.text(
      "Nombre: ${docPrintModel.cliente.nombre}",
      styles: center,
    );
    bytes += generator.text(
      "NIT: ${docPrintModel.cliente.nit}",
      styles: center,
    );
    bytes += generator.text(
      "Direccion: ${docPrintModel.cliente.direccion}",
      styles: center,
    );
    bytes += generator.text(
      "Fecha: ${docPrintModel.cliente.fecha}",
      styles: center,
    );

    bytes += generator.emptyLines(1);

    bytes += generator.row(
      [
        PosColumn(text: 'Cant.', width: 2), // Ancho 2
        PosColumn(text: 'Descripcion', width: 4), // Ancho 6
        PosColumn(
          text: 'Precio U',
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ), // Ancho 4
        PosColumn(
          text: 'Monto',
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
          text: "Sub-Total",
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
          text: "Cargos",
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
          text: "Descuentos",
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
            text: "TOTAL",
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
      "Detalle Pago:",
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
            text: "Recibido",
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
            text: "Monto:",
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
            text: "Cambio: ",
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
    if (docVM.cuentasCorrentistasRef.isNotEmpty) {
      bytes += generator.text(
        "Vendedor: ${docPrintModel.vendedor}",
        styles: center,
      );
    }

    bytes += generator.emptyLines(1);

    if (isFel) {
      bytes += generator.text(
        "Ceritificador: ${docPrintModel.certificador.nombre}",
        styles: center,
      );

      bytes += generator.text(
        "Nit: ${docPrintModel.certificador.nit}",
        styles: center,
      );
    }

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
}
