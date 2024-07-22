// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, library_prefixes, avoid_print
import 'dart:convert';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/fel/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;
import 'package:geolocator/geolocator.dart';
import 'package:xml/xml.dart' as xml;

class ConfirmDocViewModel extends ChangeNotifier {
  final PrinterManager instanceManager = PrinterManager.instance;

  //Mostrar boton para imprimir
  bool _directPrint = Preferences.directPrint;
  bool get directPrint => _directPrint;

  set directPrint(bool value) {
    _directPrint = value;
    Preferences.directPrint = value;
    notifyListeners();
  }

  //1. Cargando 2. Exitoso 3. Error
  //TODO:Pendiente de traducir por la lista
  List<LoadStepModel> steps = [
    LoadStepModel(
      text: "Creando documento...",
      status: 1,
      isLoading: true,
    ),
    LoadStepModel(
      text: "Generando firma electronica.",
      status: 1,
      isLoading: true,
    ),
  ];

  //Tareas completadas
  int stepsSucces = 0;

  //llave global del scaffold
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //input observacion
  final TextEditingController observacion = TextEditingController();

  //Mostrar boton para imprimir
  bool _showPrint = false;
  bool get showPrint => _showPrint;

  set showPrint(bool value) {
    _showPrint = value;
    notifyListeners();
  }

  //cinsecutivo para obtener plantilla (impresion)
  int consecutivoDoc = 0;
  DocEstructuraModel? docGlobal;

  //controlar proceso fel
  bool _isLoadingDTE = false;
  bool get isLoadingDTE => _isLoadingDTE;

  set isLoadingDTE(bool value) {
    _isLoadingDTE = value;
    notifyListeners();
  }

  //controlar proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  newDoc() {
    consecutivoDoc = 0;
    showPrint = false;
  }

  Position? currentPosition;

  setPosition() async {
    getCurrentPosition().then((position) {
      currentPosition = position;
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si no está habilitado, retorna un error.
      return Future.error('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si los permisos están denegados, retorna un error.
        return Future.error('Permiso de ubicación denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados permanentemente.
      return Future.error('Permiso de ubicación denegado permanentemente.');
    }

    // Cuando los permisos están otorgados, obtiene la ubicación actual.
    return await Geolocator.getCurrentPosition();
  }

  //generar formato pdf para compartir
  Future<void> sheredDoc(BuildContext context) async {
    final vmShare = Provider.of<ShareDocViewModel>(context, listen: false);
    final vmDoc = Provider.of<DocumentViewModel>(context, listen: false);
    final vmDetails = Provider.of<DetailsViewModel>(context, listen: false);
    isLoading = true;
    await vmShare.sheredDoc(
      context,
      consecutivoDoc,
      vmDoc.vendedorSelect?.nomCuentaCorrentista,
      vmDoc.clienteSelect!,
      vmDetails.total,
    );
    isLoading = false;
  }

  //devuelve el tipo de transaccion que se va a usar
  int resolveTipoTransaccion(
    int tipo,
    BuildContext context,
  ) {
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    for (var i = 0; i < docVM.tiposTransaccion.length; i++) {
      final TipoTransaccionModel tipoTra = docVM.tiposTransaccion[i];

      if (tipo == tipoTra.tipo) {
        return tipoTra.tipoTransaccion;
      }
    }

    //si no encunetra el tipo
    return 0;
  }

  printNetwork(
    BuildContext context,
  ) async {
    //Proveedor de datos externo
    final loginVM = Provider.of<LoginViewModel>(
      scaffoldKey.currentContext!,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String tokenUser = loginVM.token;

    isLoading = true;

    final DocumentService documentService = DocumentService();

    final ApiResModel res = await documentService.getDataComanda(
      user, // user,
      tokenUser, // token,
      consecutivoDoc, // consecutivo,
    );

    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        scaffoldKey.currentContext!,
        res,
      );

      return;
    }

    final List<PrintDataComandaModel> detalles = res.response;

    final List<FormatoComanda> formats = [];

    for (var detalle in detalles) {
      if (formats.isEmpty) {
        formats.add(
          FormatoComanda(
            ipAdress: detalle.printerName,
            bodega: detalle.bodega,
            detalles: [detalle],
          ),
        );
      } else {
        int indexBodega = -1;

        for (var i = 0; i < formats.length; i++) {
          final FormatoComanda formato = formats[i];
          if (detalle.bodega == formato.bodega) {
            indexBodega = i;
            break;
          }
        }

        if (indexBodega == -1) {
          formats.add(
            FormatoComanda(
              ipAdress: detalle.printerName,
              bodega: detalle.bodega,
              detalles: [detalle],
            ),
          );
        } else {
          formats[indexBodega].detalles.add(detalle);
        }
      }
    }

    int paperDefault = 80; //58 //72 //80

    PosStyles center = const PosStyles(
      align: PosAlign.center,
    );

    // final ByteData data = await rootBundle.load('assets/logo_demosoft.png');
    // final Uint8List bytesImg = data.buffer.asUint8List();
    // final img.Image? image = decodeImage(bytesImg);

    for (var element in formats) {
      try {
        List<int> bytes = [];
        final generator = Generator(
          AppData.paperSize[paperDefault],
          await CapabilityProfile.load(),
        );

        bytes += generator.setGlobalCodeTable('CP1252');

        // bytes += generator.image(
        //   img.copyResize(image!, height: 200, width: 250),
        // );
        bytes += generator.text(
          element.detalles[0].desUbicacion,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
          ),
        );

        bytes += generator.text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'mesa',
          )}: ${element.detalles[0].desMesa.toUpperCase()}",
          styles: center,
        );

        bytes += generator.text(
          "${element.detalles[0].desSerieDocumento} - ${element.detalles[0].idDocumento}",
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
          ),
        );

        bytes += generator.emptyLines(1);

        //Incio del formato
        bytes += generator.row(
          [
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.tiket,
                'cantidad',
              ),
              width: 2,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.general,
                'descripcion',
              ),
              width: 9,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
          ],
        );

        for (var tra in element.detalles) {
          bytes += generator.row(
            [
              PosColumn(
                text: "${tra.cantidad}",
                width: 2,
                styles: const PosStyles(
                  height: PosTextSize.size2,
                  align: PosAlign.right,
                ),
              ),
              PosColumn(
                text: "",
                width: 1,
              ), // Anc/ Ancho 2
              PosColumn(
                text: tra.desProducto,
                width: 9,
                styles: const PosStyles(
                  height: PosTextSize.size2,
                  align: PosAlign.left,
                ),
              ), // Ancho 6
            ],
          );
        }

        bytes += generator.emptyLines(1);

        bytes += generator.text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'atencion',
          )}: ${element.detalles[0].userName.toUpperCase()}",
          styles: center,
        );

        final now = element.detalles[0].fechaHora;

        bytes += generator.text(
          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}",
          styles: center,
        );

        bytes += generator.emptyLines(2);

        bytes += generator.text(
          "----------------------------",
          styles: center,
        );

        bytes += generator.text(
          "Powered By:",
          styles: center,
        );

        bytes += generator.text(
          "Desarrollo Moderno de Software S.A.",
          styles: center,
        );
        bytes += generator.text(
          "www.demosoft.com.gt",
          styles: center,
        );

        bytes += generator.cut();

        await PrinterManager.instance.connect(
          type: PrinterType.network,
          model: TcpPrinterInput(
            ipAddress: element.ipAdress,
          ),
        );

        await instanceManager.send(
          type: PrinterType.network,
          bytes: bytes,
        );
      } catch (e) {
        print(e.toString());
        isLoading = false;
        NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'noImprimio',
        ));
        return;
      }
    }

    isLoading = false;
  }

  //Navgar a pantalla de impresion
  navigatePrint(BuildContext context) {
    final vmDoc = Provider.of<DocumentViewModel>(context, listen: false);

    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(
        opcion: 2,
        consecutivoDoc: consecutivoDoc,
        cuentaCorrentistaRef: vmDoc.vendedorSelect?.nomCuentaCorrentista,
        client: vmDoc.clienteSelect,
      ),
    );
  }

  //Ver infromes o errores
  bool viewMessage = false;
  bool viewError = false;

  //Ver voton reintentar firma
  bool viewErrorFel = false;

  //Ver boton reintentar proceso
  bool viewErrorProcess = false;

  //ver boton proceso exitoso
  bool viewSucces = false;

  //Error si es necesrio
  String error = "";
  //eror model para informe
  ErrorModel? errorView;

  //Ir a la pantalla de error
  navigateError() {
    Navigator.pushNamed(
      scaffoldKey.currentContext!,
      "error",
      arguments: errorView,
    );
  }

  //Immprimir sin firma fel
  printWithoutFel(BuildContext context) {
    //finalizar proceso
    isLoadingDTE = false;
    //Mostrar boton para imprimir
    showPrint = true;
    //boton proceso correto

    if (directPrint) {
      // if (screen == 1) {
      navigatePrint(context);
      // } else {
      // printNetwork(context);
      // }
    }
  }

  //Volver a certificar
  Future<void> reloadCert(
    BuildContext context,
  ) async {
    //cargar paso en pantalla d carga
    steps[1].isLoading = true;
    steps[1].status = 1;

    notifyListeners();

    //iniciar proceso
    ApiResModel felProcces = await genericFel(context);

    //No se completo el proceso fel
    if (!felProcces.succes) {
      //parar proceso
      steps[1].isLoading = false;
      steps[1].status = 3;

      //verificar tipo de error
      if (felProcces.typeError == 1) {
        //mensaje de error
        error = felProcces.response;
        viewMessage = true;
      } else {
        //si es necesario pantalla de error
        errorView = ErrorModel(
          date: DateTime.now(),
          description: felProcces.response.toString(),
          url: felProcces.url,
          storeProcedure: felProcces.storeProcedure,
        );

        //ver mensaje de error
        viewError = true;
      }

      //ver botones de error
      viewErrorFel = true;

      notifyListeners();

      return;
    }

    //se completo el proceso fel
    //actualizar status del paso
    for (var step in steps) {
      step.isLoading = false;
      step.status = 2;
    }

    stepsSucces++;

    //boton proceso correto
    isLoadingDTE = false;
    showPrint = true;

    if (directPrint) {
      // if (screen == 1) {
      navigatePrint(context);
      // } else {
      // printNetwork(context);
      // }
    }
    notifyListeners();
  }

  Future<void> sendDoc(
    BuildContext context,
    int screen,
  ) async {
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    //TODO: Proceso FEL
    // if (docVM.printFel()) {
    if (true) {
      processDocument(context);
    } else {
      isLoading = true;
      ApiResModel sendProcess = await sendDocument();

      if (!sendProcess.succes) {
        isLoading = false;

        NotificationService.showErrorView(context, sendProcess);

        return;
      }

      consecutivoDoc = sendProcess.response["data"];
      showPrint = true;

      if (directPrint) {
        if (screen == 1) {
          navigatePrint(context);
        } else {
          printNetwork(context);
        }
      }

      isLoading = false;
    }
  }

  Future<void> processDocument(
    BuildContext context,
  ) async {
    //iniciar cargas (steps)
    stepsSucces = 0;

    //iniciar cargas
    for (var step in steps) {
      step.isLoading = true;
      step.status = 1;
    }

    //ocultar botones y mensajes
    viewMessage = false;
    viewError = false;
    viewErrorFel = false;
    viewErrorProcess = false;
    viewSucces = false;

    notifyListeners();
    //Iniciar el proceso

    isLoadingDTE = true;

    //Enviar documento a demosoft
    ApiResModel sendProcess = await sendDocument();

    //Verificar si el documento se creo
    if (!sendProcess.succes) {
      //No se completo el proceso
      for (var step in steps) {
        step.isLoading = false;
        step.status = 3;
      }

      //verificar tipo de error
      if (sendProcess.typeError == 1) {
        error = sendProcess.response;
        viewMessage = true;
      } else {
        //si es necesario ventana de error
        errorView = ErrorModel(
          date: DateTime.now(),
          description: sendProcess.response,
          url: sendProcess.url,
          storeProcedure: sendProcess.storeProcedure,
        );

        viewError = true;
      }

      //ver botones de error
      viewErrorProcess = true;
      notifyListeners();

      return;
    }

    //Si todo salio bien
    //verificar si hay mas pasos o no
    steps[0].isLoading = false;
    steps[0].status = 2;
    stepsSucces++;

    notifyListeners();

    consecutivoDoc = sendProcess.response["data"];

    //Certificar documento, certificador (SAT)
    ApiResModel felProcces = await genericFel(context);

    if (!felProcces.succes) {
      //No se completo el proceso fel
      steps[1].isLoading = false;
      steps[1].status = 3;

      //tipo de error
      if (felProcces.typeError == 1) {
        error = felProcces.response;
        viewMessage = true;
      } else {
        //ir a pantalla de error
        errorView = ErrorModel(
          date: DateTime.now(),
          description: felProcces.response.toString(),
          url: felProcces.url,
          storeProcedure: felProcces.storeProcedure,
        );

        viewError = true;
      }

      viewErrorFel = true;

      notifyListeners();

      return;
    }

    //si todo esta coorecto
    for (var step in steps) {
      step.isLoading = false;
      step.status = 2;
    }
    stepsSucces++;

    //boton proceso correto
    isLoadingDTE = false;
    showPrint = true;

    if (directPrint) {
      // if (screen == 1) {
      navigatePrint(context);
      // } else {
      // printNetwork(context);
      // }
    }
    notifyListeners();
  }

  Future<ApiResModel> updateDTE(
    BuildContext context,
    PostDocXmlModel paramUpdate,
  ) async {
    //Proveedor de datos externo
    final loginVM = Provider.of<LoginViewModel>(
      scaffoldKey.currentContext!,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String token = loginVM.token;

    final FelService felService = FelService();

    final ApiResModel resUpdateXml = await felService.postXmlUpdate(
      token,
      paramUpdate,
    );

    if (!resUpdateXml.succes) return resUpdateXml;

    final List<DataFelModel> dataFel = resUpdateXml.response;

    if (dataFel.isNotEmpty) {
      final DataFelModel fel = dataFel.first;

      docGlobal!.docFelSerie = fel.serieDocumento;
      docGlobal!.docFelUUID = fel.numeroAutorizacion;
      docGlobal!.docFelFechaCertificacion =
          fel.fechaHoraCertificacion.toIso8601String();
      docGlobal!.docFelNumeroDocumento = fel.numeroDocumento;

      final PostDocumentModel estructuraupdate = PostDocumentModel(
        estructura: docGlobal!.toJson(),
        user: user,
        estado: 11,
      );

      final DocumentService documentService = DocumentService();

      final ApiResModel resUpdateEstructura =
          await documentService.updateDocument(
        estructuraupdate,
        token,
        consecutivoDoc,
      );

      if (!resUpdateEstructura.succes) {
        NotificationService.showSnackbar(
          "No se pudo actalizar documento estructura",
        );
      }
    }

    return ApiResModel(
      typeError: 1,
      succes: true,
      response: AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'docCertificado',
      ),
      storeProcedure: null,
      url: "",
    );
  }

  Future<ApiResModel> genericFel(BuildContext context) async {
    const int certificador = 1; //1 infile, 2 tekra
    DocXmlModel doc;
    String apiUse = "";
    ApiModel api;

    //Proveedor de datos externo
    final loginVM = Provider.of<LoginViewModel>(
      scaffoldKey.currentContext!,
      listen: false,
    );

    final localVM = Provider.of<LocalSettingsViewModel>(
      scaffoldKey.currentContext!,
      listen: false,
    );

    //usuario token y cadena de conexion
    int empresa = localVM.selectedEmpresa!.empresa;
    String user = loginVM.user;
    String token = loginVM.token;

    final FelService felService = FelService();

    //Obtener plantilla xml para certificar
    ApiResModel resXmlDoc = await felService.getDocXml(
      user,
      token,
      consecutivoDoc,
    );

    //Si el api falló
    if (!resXmlDoc.succes) return resXmlDoc;

    //plantilla del documento
    List<DocXmlModel> docs = resXmlDoc.response;

    //si no se encuntra el documento
    if (docs.isEmpty) {
      return ApiResModel(
        typeError: 1,
        succes: false,
        response: AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'noDispoDocCert',
        ),
        url: "",
        storeProcedure: null,
      );
    }

    //Docuemnto que se va a usar
    doc = docs.first;

    //Obtener credenciales
    final ApiResModel resCrdenciales = await felService.getCredenciales(
      certificador,
      empresa,
      user,
      token,
    );

    if (!resCrdenciales.succes) return resCrdenciales;

    final List<CredencialModel> credenciales = resCrdenciales.response;

    //Buscar api que se va a usar

    for (var i = 0; i < credenciales.length; i++) {
      CredencialModel credencial = credenciales[i];

      if (credencial.campoNombre == "certificar") {
        apiUse = credencial.campoValor;
        break;
      }
    }

    //si el campo que se va a usar no esta disponible mostrar mensaje
    if (apiUse.isEmpty) {
      resCrdenciales.response =
          "No se pudo obtener la credencial n\"certificarn\"";

      return resCrdenciales;
    }

    //Obtener catalogos de apis

    final ApiResModel resApis = await felService.getApiCatalogo(
      user,
      token,
      apiUse,
    );

    if (!resApis.succes) return resApis;

    final List<ApiModel> apis = resApis.response;

    if (apis.isEmpty) {
      resApis.response = "No se econtró el api en el catalago.";

      return resApis;
    }

    api = apis.first;

    //Busar árametros
    final ApiResModel resApiParams = await felService.getApiParametros(
      user,
      token,
      api.api,
    );

    if (!resApiParams.succes) return resApiParams;

    final List<ApiParamModel> params = resApiParams.response;

    //replace params in url
    api.urlApi = replaceValues(api.urlApi, doc, credenciales);

    //Set headers
    final headers = <String, String>{};

    String content = "";

    for (var param in params) {
      switch (param.tipoParametro) {
        case 3: // headers

          for (var i = 0; i < credenciales.length; i++) {
            final CredencialModel credencial = credenciales[i];

            if (param.descripcion == credencial.campoNombre) {
              headers[credencial.campoNombre] = credencial.campoValor;
              break;
            }
          }

          break;
        case 2:
          switch (param.tipoDato) {
            case 5: //json
              headers["Content-Type"] = "application/json";
              content = replaceValuesJson(param.plantilla, doc, credenciales);
              break;
            case 6: //xml

              headers["Content-Type"] = "application/xml";
              content = replaceValues(param.plantilla, doc, credenciales);
              break;
            default:
          }

          break;
        default:
      }
    }

    final ApiResModel resDte = await felService.postDte(
      api.urlApi,
      headers,
      content,
      token,
    );

    if (!resDte.succes) return resDte;

    if (api.nodoFirmaDocumentoResponse.isEmpty) {
      final PostDocXmlModel paramUpdate = PostDocXmlModel(
        usuario: user,
        documento: resDte.response,
        uuid: doc.dIdUnc,
        documentoCompleto: resDte.response,
      );

      final ApiResModel resUpdateDTe = await updateDTE(context, paramUpdate);

      return resUpdateDTe;
    }

    if (api.tipoRespuesta == 2) {
      //Tipo respuesta XML
      // Crear un objeto XML a partir del string `resDteResponse`
      final document = xml.XmlDocument.parse(resDte.response);

      final xmlNode =
          document.findAllElements(api.nodoFirmaDocumentoResponse).first;

      final PostDocXmlModel paramUpdate = PostDocXmlModel(
        usuario: user,
        documento: xmlNode.toXmlString(),
        uuid: doc.dIdUnc,
        documentoCompleto: resDte.response,
      );

      final ApiResModel resUpdateDTe = await updateDTE(context, paramUpdate);

      return resUpdateDTe;
    } else if (api.tipoRespuesta == 1) {
      //json
      final jsonObject = jsonDecode(resDte.response);

      // Acceder a la propiedad específica
      final xmlValue = jsonObject[api.nodoFirmaDocumentoResponse];

      final PostDocXmlModel paramUpdate = PostDocXmlModel(
        usuario: user,
        documento: xmlValue,
        uuid: doc.dIdUnc,
        documentoCompleto: resDte.response,
      );

      final ApiResModel resUpdateDTe = await updateDTE(context, paramUpdate);

      return resUpdateDTe;
    }

    return ApiResModel(
      url: "",
      succes: false,
      response: "Fallo al procesar el  documento",
      storeProcedure: null,
    );
  }

  String replaceValuesJson(
    String param,
    DocXmlModel document,
    List<CredencialModel> credenciales,
  ) {
    // Crear un mapa para los parámetros
    Map<String, dynamic> objParam = {};

    // Dividir el parámetro en subcadenas
    List<String> subs = param.split(',');

    for (var i in subs) {
      List<String> subs2 = i.split(':');

      // Reemplazar credenciales en las subcadenas
      for (var credencial in credenciales) {
        subs2[1] = subs2[1].replaceAll(
          '{${credencial.campoNombre}}',
          credencial.campoValor,
        );
      }

      // Reemplazar otros valores
      subs2[1] = subs2[1].replaceAll('{xml_Contenido}', document.xmlContenido);
      subs2[1] = subs2[1].replaceAll(
        '{d_Id_Unc}',
        document.dIdUnc.toUpperCase(),
      );

      // Agregar propiedades y valores al objeto
      objParam[subs2[0]] = subs2[1];
    }

    // Convertir el objeto a JSON
    return jsonEncode(objParam);
  }

  String replaceValues(
      String param, DocXmlModel document, List<CredencialModel> credenciales) {
    // Reemplazar parámetros con valores de la lista de credenciales
    for (var credencial in credenciales) {
      param = param.replaceAll(
        '{${credencial.campoNombre}}',
        credencial.campoValor,
      );
    }

    // Reemplazar otros valores
    param = param.replaceAll('{xml_Contenido}', document.xmlContenido);
    param = param.replaceAll('{d_Id_Unc}', document.dIdUnc.toUpperCase());

    return param;
  }

  //certificar DTE (Servicios del certificador)
//   Future<ApiResModel> certDTE(
//     BuildContext context,
//   ) async {
//     //Proveedor de datos externo
//     final loginVM = Provider.of<LoginViewModel>(
//       scaffoldKey.currentContext!,
//       listen: false,
//     );

//     final localVM = Provider.of<LocalSettingsViewModel>(
//       scaffoldKey.currentContext!,
//       listen: false,
//     );

//     //usuario token y cadena de conexion
//     int empresa = localVM.selectedEmpresa!.empresa;
//     String user = loginVM.user;
//     String token = loginVM.token;
//     String uuid = "";
//     String apiUse = "";
//     int certificador = 1; //TODO:parametrizar

//     //Servicio para documentos

//     final FelService felService = FelService();

//     //Obtener plantilla xml para certificar
//     ApiResModel resXmlDoc = await felService.getDocXml(
//       user,
//       token,
//       consecutivoDoc,
//     );

//     //Si el api falló
//     if (!resXmlDoc.succes) return resXmlDoc;

//     //plantilla del documento
//     List<DocXmlModel> docs = resXmlDoc.response;

//     //si no se encuntra el documento
//     if (docs.isEmpty) {
//       return ApiResModel(
//         typeError: 1,
//         succes: false,
//         response: AppLocalizations.of(context)!.translate(
//           BlockTranslate.notificacion,
//           'noDispoDocCert',
//         ),
//         url: "",
//         storeProcedure: null,
//       );
//     }

//     //Docuemnto que se va a usar
//     DocXmlModel docXMl = docs.first;
//     uuid = docXMl.dIdUnc;
//     //Certificador del que se obtiene el token

//     //obtner credenciales
//     ApiResModel resCredenciales = await felService.getCredenciales(
//       certificador,
//       empresa,
//       user,
//       token,
//     );

//     //Si el api falló
//     if (!resCredenciales.succes) return resCredenciales;

//     //Credenciales encontradas
//     List<CredencialModel> credenciales = resCredenciales.response;

//     //Si se quiere certificar un documento buscar el api que se va a usar
//     for (var credencial in credenciales) {
//       if (credencial.campoNombre == 'apiUnificadaInfile') {
//         //econtrar api en catalogo api (identificador)
//         apiUse = credencial.campoValor;
//         break;
//       }
//     }

//     //si no se encpntró el api que se va a usar mostrar alerta
//     if (apiUse.isEmpty) {
//       return ApiResModel(
//         typeError: 1,
//         succes: false,
//         response: AppLocalizations.of(context)!.translate(
//           BlockTranslate.notificacion,
//           'noDispoServiProceDoc',
//         ),
//         url: "",
//         storeProcedure: null,
//       );
//     }

//     String llaveApi = "";
//     String llaveFirma = "";
//     String usuarioApi = "";
//     String usuarioFirma = "";

//     for (var i = 0; i < credenciales.length; i++) {
//       final CredencialModel credencial = credenciales[i];

//       switch (credencial.campoNombre) {
//         case "LlaveApi":
//           llaveApi = credencial.campoValor;

//           break;
//         case "LlaveFirma":
//           llaveFirma = credencial.campoValor;
//           break;

//         case "UsuarioApi":
//           usuarioApi = credencial.campoValor;
//           break;
//         case "UsuarioFirma":
//           usuarioFirma = credencial.campoValor;
//           break;
//         default:
//           break;
//       }
//     }

//     final DataInfileModel paramFel = DataInfileModel(
//       usuarioFirma: usuarioFirma,
//       llaveFirma: llaveFirma,
//       usuarioApi: usuarioApi,
//       llaveApi: llaveApi,
//       identificador: uuid,
//       docXml: docXMl.xmlContenido,
// //       docXml:
// //           """<dte:GTDocumento xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0" Version="0.1">
// //   <dte:SAT ClaseDocumento="dte">
// //     <dte:DTE ID="DatosCertificados">
// //       <dte:DatosEmision ID="DatosEmision">
// //         <dte:DatosGenerales CodigoMoneda="GTQ" FechaHoraEmision="2024-06-03T02:53:51.000-06:00" Tipo="FCAM" />
// //         <dte:Emisor AfiliacionIVA="GEN" CodigoEstablecimiento="1" CorreoEmisor="" NITEmisor="9300000118K" NombreComercial="TEXAS MUEBLES Y MAS" NombreEmisor="CORPORACION NR, SOCIEDAD ANONIMA">
// //           <dte:DireccionEmisor>
// //             <dte:Direccion>4 AVENIDA 5-99 ZONA 1</dte:Direccion>
// //             <dte:CodigoPostal>010020</dte:CodigoPostal>
// //             <dte:Municipio>SANTA LUCIA COTZULMALGUAPA</dte:Municipio>
// //             <dte:Departamento>ESCUINTLA</dte:Departamento>
// //             <dte:Pais>GT</dte:Pais>
// //           </dte:DireccionEmisor>
// //         </dte:Emisor>
// //         <dte:Receptor CorreoReceptor="" IDReceptor="2768220480502" NombreReceptor="MELVIN DANIEL ,SOMA MÉNDEZ" TipoEspecial="CUI">
// //           <dte:DireccionReceptor>
// //             <dte:Direccion>Ciudad</dte:Direccion>
// //             <dte:CodigoPostal>01007</dte:CodigoPostal>
// //             <dte:Municipio>Guatemala</dte:Municipio>
// //             <dte:Departamento>Guatemala</dte:Departamento>
// //             <dte:Pais>GT</dte:Pais>
// //           </dte:DireccionReceptor>
// //         </dte:Receptor>
// //         <dte:Frases>
// //           <dte:Frase CodigoEscenario="1" TipoFrase="1" />
// //         </dte:Frases>
// //         <dte:Items>
// //           <dte:Item NumeroLinea="1" BienOServicio="B">
// //             <dte:Cantidad>1.0000</dte:Cantidad>
// //             <dte:UnidadMedida>UND</dte:UnidadMedida>
// //             <dte:Descripcion>457224|TELEFONO SAMSUNG GALAXY A34 457224RFCWA0SDV8Y     IMEI1: 350350681547282 IMEI2:351525681547288</dte:Descripcion>
// //             <dte:PrecioUnitario>2200.0000</dte:PrecioUnitario>
// //             <dte:Precio>2200.0000</dte:Precio>
// //             <dte:Descuento>0</dte:Descuento>
// //             <dte:Impuestos>
// //               <dte:Impuesto>
// //                 <dte:NombreCorto>IVA</dte:NombreCorto>
// //                 <dte:CodigoUnidadGravable>1</dte:CodigoUnidadGravable>
// //                 <dte:MontoGravable>1964.29</dte:MontoGravable>
// //                 <dte:MontoImpuesto>235.7143</dte:MontoImpuesto>
// //               </dte:Impuesto>
// //             </dte:Impuestos>
// //             <dte:Total>2200.0000</dte:Total>
// //           </dte:Item>
// //         </dte:Items>
// //         <dte:Totales>
// //           <dte:TotalImpuestos>
// //             <dte:TotalImpuesto NombreCorto="IVA" TotalMontoImpuesto="235.7143" />
// //           </dte:TotalImpuestos>
// //           <dte:GranTotal>2200.0000</dte:GranTotal>
// //         </dte:Totales>
// //         <dte:Complementos>
// //           <dte:Complemento IDComplemento="Cambiaria" NombreComplemento="Cambiaria" URIComplemento="http://www.sat.gob.gt/fel/cambiaria.xsd">
// //             <cfc:AbonosFacturaCambiaria xmlns:cfc="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0" Version="1">
// //               <cfc:Abono>
// //                 <cfc:NumeroAbono>1</cfc:NumeroAbono>
// //                 <cfc:FechaVencimiento>2024-03-29</cfc:FechaVencimiento>
// //                 <cfc:MontoAbono>2200.00</cfc:MontoAbono>
// //               </cfc:Abono>
// //             </cfc:AbonosFacturaCambiaria>
// //           </dte:Complemento>
// //         </dte:Complementos>
// //       </dte:DatosEmision>
// //     </dte:DTE>
// //   </dte:SAT>
// // </dte:GTDocumento>""",
//     );

//     final ApiResModel resCertDoc = await felService.postInfile(
//       apiUse,
//       paramFel,
//       token,
//     );

//     if (!resCertDoc.succes) return resCertDoc;

//     final dynamic doc = resCertDoc.response;

//     final PostDocXmlModel paramUpdate = PostDocXmlModel(
//       usuario: user,
//       documento: doc,
//       uuid: uuid,
//       documentoCompleto: doc,
//     );

//     final ApiResModel resUpdateXml = await felService.postXmlUpdate(
//       token,
//       paramUpdate,
//     );

//     if (!resUpdateXml.succes) return resUpdateXml;

//     final List<DataFelModel> dataFel = resUpdateXml.response;

//     if (dataFel.isNotEmpty) {
//       final DataFelModel fel = dataFel.first;

//       docGlobal!.docFelSerie = fel.serieDocumento;
//       docGlobal!.docFelUUID = fel.numeroAutorizacion;
//       docGlobal!.docFelFechaCertificacion =
//           fel.fechaHoraCertificacion.toIso8601String();
//       docGlobal!.docFelNumeroDocumento = fel.numeroDocumento;

//       final PostDocumentModel estructuraupdate = PostDocumentModel(
//         estructura: docGlobal!.toJson(),
//         user: user,
//         estado: 11,
//       );

//       final DocumentService documentService = DocumentService();

//       final ApiResModel resUpdateEstructura =
//           await documentService.updateDocument(
//         estructuraupdate,
//         token,
//         consecutivoDoc,
//       );

//       if (!resUpdateEstructura.succes) {
//         NotificationService.showSnackbar(
//           "No se pudo actalizar documento estructura",
//         );
//       }
//     }

//     return ApiResModel(
//       typeError: 1,
//       succes: true,
//       response: AppLocalizations.of(context)!.translate(
//         BlockTranslate.notificacion,
//         'docCertificado',
//       ),
//       storeProcedure: null,
//       url: "",
//     );
//   }

  int idDocumentoRef = 0;

  void setIdDocumentoRef() {
    DateTime dateConsecutivo = DateTime.now();
    int randomNumber1 = Random().nextInt(900) + 100;

    // Combinar los dos números para formar uno de 14 dígitos
    String strNum1 = randomNumber1.toString();
    String combinedStr = strNum1 +
        dateConsecutivo.day.toString().padLeft(2, '0') +
        dateConsecutivo.month.toString().padLeft(2, '0') +
        dateConsecutivo.year.toString() +
        dateConsecutivo.hour.toString().padLeft(2, '0') +
        dateConsecutivo.minute.toString().padLeft(2, '0') +
        dateConsecutivo.second.toString().padLeft(2, '0');

    // ref id
    idDocumentoRef = int.parse(combinedStr);
    notifyListeners();
  }

  //enviar el odcumento
  Future<ApiResModel> sendDocument() async {
    //view models ecternos
    final docVM = Provider.of<DocumentViewModel>(scaffoldKey.currentContext!,
        listen: false);
    final menuVM =
        Provider.of<MenuViewModel>(scaffoldKey.currentContext!, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(
        scaffoldKey.currentContext!,
        listen: false);
    final loginVM =
        Provider.of<LoginViewModel>(scaffoldKey.currentContext!, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(scaffoldKey.currentContext!,
        listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(scaffoldKey.currentContext!,
        listen: false);

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String tokenUser = loginVM.token;

    //valores necesarios para el docuemento
    int? cuentaVendedor = docVM.cuentasCorrentistasRef.isEmpty
        ? null
        : docVM.vendedorSelect!.cuentaCorrentista;
    int cuentaCorrentisata = docVM.clienteSelect!.cuentaCorrentista;
    String cuentaCta = docVM.clienteSelect!.cuentaCta;
    int tipoDocumento = menuVM.documento!;
    String serieDocumento = docVM.serieSelect!.serieDocumento!;
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;
    List<AmountModel> amounts = paymentVM.amounts;
    List<TraInternaModel> products = detailsVM.traInternas;

    //pagos agregados
    final List<DocCargoAbono> payments = [];
    //transaciciones agregadas
    final List<DocTransaccion> transactions = [];

    var random = Random();

    // Generar dos números aleatorios de 7 dígitos cada uno
    int firstPart = random.nextInt(10000000);

    int consectivo = 1;
    //Objeto transaccion documento para estructura documento
    for (var transaction in products) {
      int padre = consectivo;
      final List<DocTransaccion> cargos = [];
      final List<DocTransaccion> descuentos = [];

      for (var operacion in transaction.operaciones) {
        //Cargo
        if (operacion.cargo != 0) {
          consectivo++;
          cargos.add(
            DocTransaccion(
              dConsecutivoInterno: firstPart,
              traConsecutivoInterno: consectivo,
              traConsecutivoInternoPadre: padre,
              traBodega: transaction.bodega!.bodega,
              traProducto: transaction.producto.producto,
              traUnidadMedida: transaction.producto.unidadMedida,
              traCantidad: 0,
              traTipoCambio: menuVM.tipoCambio,
              traMoneda: transaction.precio!.moneda,
              traTipoPrecio:
                  transaction.precio!.precio ? transaction.precio!.id : null,
              traFactorConversion:
                  !transaction.precio!.precio ? transaction.precio!.id : null,
              traTipoTransaccion:
                  resolveTipoTransaccion(4, scaffoldKey.currentContext!),
              traMonto: operacion.cargo,
            ),
          );
        }

        //Descuento
        if (operacion.descuento != 0) {
          consectivo++;

          descuentos.add(
            DocTransaccion(
              dConsecutivoInterno: firstPart,
              traConsecutivoInterno: consectivo,
              traConsecutivoInternoPadre: padre,
              traBodega: transaction.bodega!.bodega,
              traProducto: transaction.producto.producto,
              traUnidadMedida: transaction.producto.unidadMedida,
              traCantidad: 0,
              traTipoCambio: menuVM.tipoCambio,
              traMoneda: transaction.precio!.moneda,
              traTipoPrecio:
                  transaction.precio!.precio ? transaction.precio!.id : null,
              traFactorConversion:
                  !transaction.precio!.precio ? transaction.precio!.id : null,
              traTipoTransaccion:
                  resolveTipoTransaccion(3, scaffoldKey.currentContext!),
              traMonto: operacion.descuento,
            ),
          );
        }
      }

      transactions.add(
        DocTransaccion(
          dConsecutivoInterno: firstPart,
          traConsecutivoInterno: padre,
          traConsecutivoInternoPadre: null,
          traBodega: transaction.bodega!.bodega,
          traProducto: transaction.producto.producto,
          traUnidadMedida: transaction.producto.unidadMedida,
          traCantidad: transaction.cantidad,
          traTipoCambio: menuVM.tipoCambio,
          traMoneda: transaction.precio!.moneda,
          traTipoPrecio:
              transaction.precio!.precio ? transaction.precio!.id : null,
          traFactorConversion:
              !transaction.precio!.precio ? transaction.precio!.id : null,
          traTipoTransaccion: resolveTipoTransaccion(
              transaction.producto.tipoProducto, scaffoldKey.currentContext!),
          traMonto: transaction.cantidad * transaction.precio!.precioU,
        ),
      );

      for (var cargo in cargos) {
        transactions.add(cargo);
      }

      for (var descuento in descuentos) {
        transactions.add(descuento);
      }

      consectivo++;
    }

    int consecutivoPago = 1;
    //objeto cargo abono para documento cargo abono
    for (var payment in amounts) {
      payments.add(
        DocCargoAbono(
          dConsecutivoInterno: firstPart,
          consecutivoInterno: consecutivoPago,
          tipoCargoAbono: payment.payment.tipoCargoAbono,
          monto: payment.amount,
          cambio: payment.diference,
          tipoCambio: menuVM.tipoCambio,
          moneda: transactions[0].traMoneda,
          montoMoneda: payment.amount / menuVM.tipoCambio,
          referencia: payment.reference,
          autorizacion: payment.authorization,
          banco: payment.bank?.banco,
          cuentaBancaria: payment.account?.idCuentaBancaria,
        ),
      );

      consecutivoPago++;
    }

    double totalCA = 0;

    for (var amount in amounts) {
      totalCA += amount.amount;
    }

    DateTime myDateTime = DateTime.now();
    String serializedDateTime = myDateTime.toIso8601String();
    //Objeto documento estrucutra
    docGlobal = DocEstructuraModel(
      docLatitdud: currentPosition?.latitude.toString(),
      docLongitud: currentPosition?.longitude.toString(),
      consecutivoInterno: firstPart,
      docTraMonto: detailsVM.total,
      docCaMonto: totalCA,
      docIdCertificador: 1, //TODO: Agrgar certificador
      docCuentaVendedor: cuentaVendedor,
      docIdDocumentoRef: idDocumentoRef,
      docFelNumeroDocumento: null,
      docFelSerie: null,
      docFelUUID: null,
      docFelFechaCertificacion: null,
      docCuentaCorrentista: cuentaCorrentisata,
      docCuentaCta: cuentaCta,
      docFechaDocumento: serializedDateTime,
      docTipoDocumento: tipoDocumento,
      docSerieDocumento: serieDocumento,
      docEmpresa: empresa,
      docEstacionTrabajo: estacion,
      docUserName: user,
      docObservacion1: observacion.text,
      docTipoPago: 1, //TODO: preguntar
      docElementoAsignado: 1, //TODO:preguntar,
      docTransaccion: transactions,
      docCargoAbono: payments,
    );

    //objeto enviar documento
    PostDocumentModel document = PostDocumentModel(
      estructura: docGlobal!.toJson(),
      user: user,
      estado: docVM.printFel() ? 1 : 11,
    );

    //instancia del servicio
    DocumentService documentService = DocumentService();

    //consumo del api
    ApiResModel res = await documentService.postDocument(document, tokenUser);

    return res;
  }

  backButton(BuildContext context) {
    consecutivoDoc = 0;
    showPrint = false;
    Navigator.pop(context);
  }
}
