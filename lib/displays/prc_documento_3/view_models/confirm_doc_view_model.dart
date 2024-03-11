// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/fel/models/models.dart';
import 'package:flutter_post_printer_example/fel/services/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';
import 'dart:math';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;

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
  List<LoadStepModel> steps = [
    LoadStepModel(
      text: "Creando documento...",
      status: 1,
      isLoading: true,
    ),
    LoadStepModel(
      text: "Generando firma electronica",
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

  printNetwork() async {
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

    final List<PrintDataComandaModel> detalles = res.message;

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
          "Mesa: ${element.detalles[0].desMesa.toUpperCase()}",
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
              text: 'Cant.',
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
              text: 'Descripción',
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
          "Le atendió: ${element.detalles[0].userName.toUpperCase()}",
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
        NotificationService.showSnackbar("No se pudo imprimir.");
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
  printWithoutFel() {
    //finalizar proceso
    isLoadingDTE = false;
    //Mostrar boton para imprimir
    showPrint = true;
  }

  //Volver a certificar
  Future<void> reloadCert() async {
    //cargar paso en pantalla d carga
    steps[1].isLoading = true;
    steps[1].status = 1;

    notifyListeners();

    //iniciar proceso
    ApiResModel felProcces = await certDTE();

    //No se completo el proceso fel
    if (!felProcces.succes) {
      //parar proceso
      steps[1].isLoading = false;
      steps[1].status = 3;

      //verificar tipo de error
      if (felProcces.typeError == 1) {
        //mensaje de error
        error = felProcces.message;
        viewMessage = true;
      } else {
        //si es necesario pantalla de error
        errorView = ErrorModel(
          date: DateTime.now(),
          description: felProcces.message.toString(),
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

    viewSucces = true;
    notifyListeners();
  }

  Future<void> sendDoc(
    BuildContext context,
    int screen,
  ) async {
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    if (docVM.printFel()) {
      processDocument();
    } else {
      isLoading = true;
      ApiResModel sendProcess = await sendDocument();

      if (!sendProcess.succes) {
        isLoading = false;

        NotificationService.showErrorView(context, sendProcess);

        return;
      }

      consecutivoDoc = sendProcess.message["data"];
      showPrint = true;

      if (directPrint) {
        if (screen == 1) {
          navigatePrint(context);
        } else {
          printNetwork();
        }
      }

      isLoading = false;
    }
  }

  Future<void> processDocument() async {
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
        error = sendProcess.message;
        viewMessage = true;
      } else {
        //si es necesario ventana de error
        errorView = ErrorModel(
          date: DateTime.now(),
          description: sendProcess.message,
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

    consecutivoDoc = sendProcess.message["data"];

    //Certificar documento, certificador (SAT)
    ApiResModel felProcces = await certDTE();

    if (!felProcces.succes) {
      //No se completo el proceso fel
      steps[1].isLoading = false;
      steps[1].status = 3;

      //tipo de error
      if (felProcces.typeError == 1) {
        error = felProcces.message;
        viewMessage = true;
      } else {
        //ir a pantalla de error
        errorView = ErrorModel(
          date: DateTime.now(),
          description: felProcces.message.toString(),
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
    viewSucces = true;
    notifyListeners();
  }

  //certificar DTE (Servicios del certificador)
  Future<ApiResModel> certDTE() async {
    //Proveedor de datos externo
    final loginVM = Provider.of<LoginViewModel>(
      scaffoldKey.currentContext!,
      listen: false,
    );

    //usuario token y cadena de conexion
    String conStr = loginVM.conStr;
    String user = loginVM.user;
    String tokenUser = loginVM.token;

    //Servicio para documentos
    DocumentService documentService = DocumentService();

    //Obtener plantilla xml para certificar
    ApiResModel resXmlDoc = await documentService.getDocXml(
      user,
      tokenUser,
      consecutivoDoc,
      0,
      1,
    );

    //Si el api falló
    if (!resXmlDoc.succes) return resXmlDoc;

    //plantilla del documento
    List<DocXmlModel> docs = resXmlDoc.message;

    //si no se encuntra el documento
    if (docs.isEmpty) {
      return ApiResModel(
        typeError: 1,
        succes: false,
        message: "El documento para certificar no está disponible",
        url: "",
        storeProcedure: null,
      );
    }

    //Docuemnto que se va a usar
    DocXmlModel docXMl = docs.first;
    //Certificador del que se obtiene el token
    int apiToken = -1;
    //token si es necesario
    String token = "";
    //api que se va a usar
    String apiUse = "";
    //docuemtno que se va a certificar
    String uuidDoc = docXMl.dIdUnc.toUpperCase();
    //certificador que se va a usar
    int certificador = docXMl.certificadorDte;
    //Documento xml sin firma
    String xmlContenido = docXMl.xmlContenido;

    //Servicios para obtener las crednecials
    CredencialeService credencialeService = CredencialeService();

    //obtner credenciales
    ApiResModel resCredenciales = await credencialeService.getCredenciales(
      certificador,
      user,
      conStr,
    );

    //Si el api falló
    if (!resCredenciales.succes) return resCredenciales;

    //Credenciales encontradas
    List<CredencialModel> credenciales = resCredenciales.message;

    //Si se quiere certificar un documento buscar el api que se va a usar
    for (var credencial in credenciales) {
      if (credencial.campoNombre.toLowerCase() == 'certifica') {
        //econtrar api en catalogo api (identificador)
        apiUse = credencial.campoValor;
        break;
      }
    }

    //si no se encpntró el api que se va a usar mostrar alerta
    if (apiUse.isEmpty) {
      return ApiResModel(
        typeError: 1,
        succes: false,
        message: "Los servicios para procesar documentos no están disponibles.",
        url: "",
        storeProcedure: null,
      );
    }

    //servicio para obtener las apis que se van aa usar
    CatalogoApisService catalogoApisService = CatalogoApisService();

    //Obtener api que se va a usar
    ApiResModel resApiCatalago = await catalogoApisService.getCatalogoApis(
      apiUse,
      user,
      conStr,
    );

    //Si el api para obtener la url falló
    if (!resApiCatalago.succes) return resApiCatalago;

    //catalogo de apis
    List<CatalogoApiModel> apis = resApiCatalago.message;

    //si no se encuentra el api
    if (apis.isEmpty) {
      return ApiResModel(
        typeError: 1,
        succes: false,
        message:
            "No se encontraron los datos necesarios, verifique que el catalogo de apis esté diponible.",
        storeProcedure: null,
        url: "",
      );
    }

    // api que se va ausar
    CatalogoApiModel api = apis.first;

    //verificar si es necesqrio un token
    if (api.reqAutorizacion) {
      //buscar api para el token
      for (var credencial in credenciales) {
        //encontrar y asignar api para el token
        if (credencial.campoNombre.toLowerCase() == 'token') {
          apiToken = int.parse(credencial.campoValor);
          break;
        }
      }

      //si no se encontró el api para el token mostrar alerta
      if (apiToken == -1) {
        return ApiResModel(
          typeError: 1,
          succes: false,
          message: "Autorizacion no disponible",
          url: "",
          storeProcedure: null,
        );
      }

      //servicio para obtner tokens
      TokenService tokenService = TokenService();

      //obtener token
      ApiResModel resToken = await tokenService.getToken(
        apiToken,
        certificador,
        user,
        conStr,
      );

      //Si el api falló
      if (!resToken.succes) return resToken;

      //token que se va a usar
      ResStatusModel tokenResp = resToken.message;

      //si no se ecojntró el token
      if (tokenResp.statusCode != 200) {
        return ApiResModel(
          succes: false,
          message: resToken.message,
          url: resToken.url,
          storeProcedure: resToken.storeProcedure,
        );
      }

      //El token debe contener mas de 7 caracteres
      if (tokenResp.response.length > 7) {
        token = tokenResp.response;
      } else {
        return ApiResModel(
          typeError: 1,
          succes: false,
          message: "No se encontró el token de autorización.",
          url: "",
          storeProcedure: null,
        );
      }
    }

    //Obtener parametros del api que se va a usar
    ApiResModel resParametros = await catalogoApisService.getCatalogoParametros(
      apiUse,
      user,
      conStr,
    );

    //si algo salio mal mostrar alerta
    if (!resParametros.succes) return resParametros;

    //parametros encontrados
    List<CatalogoParametroModel> parametros = resParametros.message;

    //api que se va a usar
    String urlApi = api.urlApi;

    //buscar parametros en url y reemplazar valores
    urlApi = replaceValues(
      urlApi,
      token,
      xmlContenido,
      uuidDoc,
      credenciales,
    );

    //headers del api que se va a usar
    Map<String, String> headers = {};

    //Contenido
    String content = "";

    //Buscar parametros
    for (var parametro in parametros) {
      //Obtener tipo de parametro
      switch (parametro.tipoParametro) {
        //
        case 3: //Headers
          //Buscar valores de los parametors
          for (var credencial in credenciales) {
            //si un el nombre de un valor coincide con un parametro
            if (credencial.campoNombre == parametro.descripcion &&
                parametro.descripcion != "Authorization") {
              //agregar header
              headers[credencial.campoNombre] = credencial.campoValor;
            }
          }
          break;

        case 2: //Si los parametros son el body
          //si el tipo del body es xml
          if (parametro.tipoDato == 6) {
            //Agregar header
            headers["Content-Type"] = "application/xml";
            //reemplazar avlores dentro del xml
            content = replaceValues(
              parametro.plantilla,
              token,
              xmlContenido,
              uuidDoc,
              credenciales,
            );
          } else {
            //si el parametro es json
            //agregar header
            headers["Content-Type"] = "application/json";
            //Buscar valores que se deban reemplazar
            content = replaceValuesJson(
              parametro.plantilla,
              token,
              xmlContenido,
              uuidDoc,
              credenciales,
            );
          }
          break;
        default:
      }
    }

    //Si requiere autenticacion por token agregar header
    if (api.reqAutorizacion) headers["Authorization"] = token;

    //agregar cadena de conexion
    headers["connectionStr"] = conStr;

    //Servicio generico para FEL
    ResolveApisService resolveApisService = ResolveApisService();

    //Consumir api para certificar o anular documentos
    ApiResModel resApi = await resolveApisService.resolveMethod(
      urlApi,
      headers,
      api.tipoMetodo,
      content,
    );

    //si algo salio mal mostrar alerta
    if (!resApi.succes) return resApi;

    //verificar respuesta
    //si la respuesta es el documento procesado
    if (api.nodoFirmaDocumentoResponse.isEmpty) {
      //Objeto para actualizar el documento (Agregar firma)
      PostDocXmlModel body = PostDocXmlModel(
        usuario: user,
        documento: resApi.message,
        uuid: uuidDoc,
        documentoCompleto: resApi.message,
      );

      //Consumo del servicio para atualizar el documento
      ApiResModel resPostDoc = await documentService.postDocumentXml(
        body,
        conStr,
      );

      //si algo salio mal mostrar alerta
      if (!resPostDoc.succes) return resPostDoc;

      return ApiResModel(
        typeError: 1,
        succes: true,
        message: "Documento certficado correctamente",
        url: "",
        storeProcedure: null,
      );
    }

    //si el documento está en un nodo o propiedad especifica
    switch (api.tipoRespuesta) {
      case 1: //JSON
        //Convertir obejeto de la respuesta en mapa
        final Map<String, dynamic> jsonObject = jsonDecode(resApi.message);

        //buscar propiedad donde esté el documento procesado
        final dynamic content = jsonObject[api.nodoFirmaDocumentoResponse];

        //Objeto para actualizar el documento
        PostDocXmlModel body = PostDocXmlModel(
          usuario: user,
          documento: content,
          uuid: uuidDoc,
          documentoCompleto: resApi.message,
        );

        //Actualizar el documento
        ApiResModel resPostDoc = await documentService.postDocumentXml(
          body,
          conStr,
        );

        //si algo salio mal mostrar alerta
        if (!resPostDoc.succes) return resPostDoc;
        return ApiResModel(
          typeError: 1,
          succes: true,
          message: "Documento certficado correctamente",
          storeProcedure: null,
          url: "",
        );

      case 2: //XML
        //Convertir a un objeto xml
        final docXml = XmlDocument.parse(resApi.message);

        //separar por nodos
        final List<String> nodos = api.nodoFirmaDocumentoResponse.split("/");

        //ultimo nodo
        final String nodoPadre = nodos[nodos.length - 1];

        //contenifo del nodo
        final bodyNode = docXml.findAllElements(nodoPadre).first;

        //docuemto procesado
        final bodyContent =
            bodyNode.children.map((node) => node.toString()).join('\n');

        //Objeto para actualizar
        PostDocXmlModel body = PostDocXmlModel(
          usuario: user,
          documento: bodyContent,
          uuid: uuidDoc,
          documentoCompleto: resApi.message,
        );

        //Actualizar el documento procesado
        ApiResModel resPostDoc = await documentService.postDocumentXml(
          body,
          conStr,
        );

        //si algo salio mal mostrar alerta
        if (!resPostDoc.succes) return resPostDoc;

        return ApiResModel(
          typeError: 1,
          succes: true,
          message: "Documento certficado correctamente",
          storeProcedure: null,
          url: "",
        );

      default:
        //en caso que la resouesta sea un tipo no implementado

        return ApiResModel(
          typeError: 1,
          succes: false,
          message: "El tipo de respuesta del servicio es incorrecto.",
          storeProcedure: null,
          url: "",
        );
    }
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
    final vmHome =
        Provider.of<HomeViewModel>(scaffoldKey.currentContext!, listen: false);

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
    int secondPart = random.nextInt(10000000);

    // Combinar los dos números para formar uno de 14 dígitos
    int randomNumber = firstPart * 10000000 + secondPart;

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
              traTipoCambio: vmHome.tipoCambio,
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
              traTipoCambio: vmHome.tipoCambio,
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
          traTipoCambio: vmHome.tipoCambio,
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
          tipoCambio: vmHome.tipoCambio,
          moneda: transactions[0].traMoneda,
          montoMoneda: payment.amount / vmHome.tipoCambio,
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
    final DocEstructuraModel doc = DocEstructuraModel(
      consecutivoInterno: firstPart,
      docTraMonto: detailsVM.total,
      docCaMonto: totalCA,
      docIdCertificador: 1, //TODO: Agrgar certificador
      docCuentaVendedor: cuentaVendedor,
      docIdDocumentoRef: randomNumber,
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
      estructura: doc.toJson(),
      user: user,
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

  //rreplaxar valores y armar objeto json (body)
  String replaceValuesJson(
    String param,
    String token,
    String documento,
    String uuid,
    List<CredencialModel> credenciales,
  ) {
    //json final
    Map<String, dynamic> params = {};

    //Seprar propiedades pro ","
    List<String> objects = param.split(",");

    //Recorrer todas las propiedades disponibles
    for (var object in objects) {
      //separar propiedades y valores por ":"
      List<String> properties = object.split(":");
      //buscar el valor de cada propiedad
      for (var credencial in credenciales) {
        //Reemplazar propiedad por valor encontrado
        properties[1] = properties[1].replaceAll(
          "{${credencial.campoNombre}}",
          credencial.campoValor,
        );
      }

      //Buscar y agregar token
      properties[1] = properties[1].replaceAll(
        "{token}",
        token,
      );
      //buscar y agregar docuemnto
      properties[1] = properties[1].replaceAll(
        "{xml_Contenido}",
        documento,
      );
      //Buscar y agregar identificador unico del documento
      properties[1] = properties[1].replaceAll(
        "{d_Id_Unc}",
        uuid,
      );

      //Agregar al json
      params[properties[0]] = properties[1];
    }

    //Retornar json armado
    return jsonEncode(params);
  }

  //reemplazar parametros necesarios
  String replaceValues(
    String param,
    String token,
    String documento,
    String uuid,
    List<CredencialModel> credenciales,
  ) {
    //Buscar valores que agregar
    for (var credencial in credenciales) {
      param = param.replaceAll(
        "{${credencial.campoNombre}}",
        credencial.campoValor,
      );
    }

    //Reemplazar documento
    param = param.replaceAll("{xml_Contenido}", documento);
    //Reemplazar identificador del documento
    param = param.replaceAll("{d_Id_Unc}", uuid);
    //Reemplazar token
    param = param.replaceAll("{token}", token);
    //Retornar parametros con sus valores correctos
    return param;
  }
}
