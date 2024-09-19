// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/fel/models/credencial_model.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentViewModel extends ChangeNotifier {
  //Controlador input buscar cliente
  final TextEditingController client = TextEditingController();

  //input descipcion
  final TextEditingController refObservacionParam384 = TextEditingController();

  //input observaciones
  final TextEditingController refDescripcionParam383 = TextEditingController();

  //input contacto parametro: 385
  final TextEditingController refContactoParam385 = TextEditingController();

  //input direccion de entrega
  final TextEditingController refDirecEntregaParam386 = TextEditingController();

  //Seleccionar consummidor final
  bool cf = false;

  //Key for form
  GlobalKey<FormState> formKeyClient = GlobalKey<FormState>();

  //Cliente selecciinado
  ClientModel? clienteSelect;

  //Vendedor seleccionado selccionado
  SellerModel? vendedorSelect;

  //Vendedor seleccionado selccionado
  TipoReferenciaModel? referenciaSelect;

  //serie seleccionada
  SerieModel? serieSelect;

  bool confirmarCotizacion = false;

  //listas globales
  final List<ClientModel> cuentasCorrentistas = []; //cunetas correntisat
  final List<SellerModel> cuentasCorrentistasRef = []; //cuenta correntisat ref
  final List<SerieModel> series = [];
  final List<TipoTransaccionModel> tiposTransaccion = [];
  final List<ParametroModel> parametros = [];
  final List<TipoReferenciaModel> referencias = []; //tipos de referencia

  //limmpiar campos de la vista del usuario
  void clearView() {
    client.text = "";
    clienteSelect = null;
    vendedorSelect = null;
    cf = false;
    serieSelect = null;
    referenciaSelect = null;
    refObservacionParam384.text = "";
    refDescripcionParam383.text = "";
    refContactoParam385.text = "";
    refDirecEntregaParam386.text = "";
    cuentasCorrentistasRef.clear();

    notifyListeners();
  }

  //True if form is valid search client
  bool isValidFormClient() {
    return formKeyClient.currentState?.validate() ?? false;
  }

  addClient(ClientModel? client) {
    clienteSelect = client;
    notifyListeners();
  }

  //Seleccioanr tipo precio
  void changeSeller(SellerModel? value) {
    vendedorSelect = value;
    notifyListeners();
  }

  //Seleccioanr una referencia
  void changeRef(
    BuildContext context,
    TipoReferenciaModel? value,
  ) {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    referenciaSelect = value;
    notifyListeners();

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }
  }

  bool monitorPrint() {
    bool showPrint = false;
    //el parametro que indica si se imprime en mmonitor o no es 272

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel parametro = parametros[i];

      if (parametro.parametro == 272) {
        showPrint = true;
        break;
      }
    }

    return showPrint;
  }

  bool editPrice() {
    bool edit = false;
    //el parametro que indica si se puede esitar el precio o no es 351

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel parametro = parametros[i];

      if (parametro.parametro == 351) {
        edit = true;
        break;
      }
    }

    return edit;
  }

  bool printFel() {
    bool fel = false;

    //el parametro que indica si genera fel o no es 349

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel parametro = parametros[i];

      if (parametro.parametro == 349) {
        fel = true;
        break;
      }
    }

    return fel;
  }

  bool valueParametro(int param) {
    bool value = false;

    //sino existe serie, retornar false
    if (serieSelect == null) return false;

    //validar que exista el parametro

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel parametro = parametros[i];

      if (parametro.parametro == param) {
        value = true;
        break;
      }
    }

    return value;
  }

  String? getTextParam(int param) {
    // Texto por defecto
    String? name;

    //sino existe serie, retornar false
    if (serieSelect == null) return name;

    // Recorrer lista de parámetros
    for (var parametro in parametros) {
      // Buscar el nombre en el parámetro 57
      if (parametro.parametro == param) {
        // Si nombre es nulo, agregar el texto por defecto
        name = parametro.paCaracter;
        break;
      }
    }

    // Retornar texto
    return name;
  }

  obtenerReferencias(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmHome = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );

    final String user = vmLogin.user;
    final String token = vmLogin.token;

    //evaluar el parametro 58
    TipoReferenciaService referenciaService = TipoReferenciaService();

    if (valueParametro(58)) {
      referencias.clear();
      referenciaSelect = null;

      //Consumo del servicio
      ApiResModel resTiposRef = await referenciaService.getTiposReferencia(
        user, //user
        token, // token,
      );

      //valid succes response
      if (!resTiposRef.succes) {
        //si algo salio mal mostrar alerta
        await NotificationService.showErrorView(
          context,
          resTiposRef,
        );
        return;
      }

      //agregar formas de pago encontradas
      referencias.addAll(resTiposRef.response);
      notifyListeners();

      vmHome.isLoading = false;
    }
  }

  bool getPosition() {
    bool position = false;

    //el parametro que indica si genera fel o no es 349

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel parametro = parametros[i];

      if (parametro.parametro == 318) {
        position = true;
        break;
      }
    }

    return position;
  }

  //seleccionar serie
  Future<void> changeSerie(
    SerieModel? value,
    BuildContext context,
  ) async {
    //Seleccionar serie
    serieSelect = value;

    //view model externo
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    final vmMenu = Provider.of<MenuViewModel>(context, listen: false);
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);
    final vmDoc = Provider.of<DocumentViewModel>(context, listen: false);

    //niciar proceso
    vmFactura.isLoading = true;

    //Buscar vendedores de la serie
    await loadSellers(context, serieSelect!.serieDocumento!, vmMenu.documento!);
    await loadTipoTransaccion(context);
    await loadParametros(context);
    await obtenerReferencias(context); //cargar las referencias
    await vmPayment.loadPayments(context);
    vmDoc.restaurarFechas();
    //finalizar proceso
    vmFactura.isLoading = false;

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  String getTextCuenta(BuildContext context) {
    String fileName = AppLocalizations.of(context)!.translate(
      BlockTranslate.factura,
      'cuenta',
    );

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel param = parametros[i];

      //buscar nombre del campo en el parametro 57
      if (param.parametro == 57) {
        fileName = param.paCaracter ??
            AppLocalizations.of(context)!.translate(
              BlockTranslate.factura,
              'cuenta',
            );
        break;
      }
    }

    fileName = capitalizeFirstLetter(fileName);

    return fileName;
  }

  String capitalizeFirstLetter(String text) {
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> loadParametros(BuildContext context) async {
    parametros.clear();
    ParametroService parametroService = ParametroService();

    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    String user = loginVM.user;
    String token = loginVM.token;
    int tipoDoc = menuVM.documento!;
    String serie = serieSelect!.serieDocumento!;
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;

    ApiResModel res = await parametroService.getParametro(
      user,
      tipoDoc,
      serie,
      empresa,
      estacion,
      token,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //Agregar series encontradas
    parametros.addAll(res.response);
  }

  Future<void> loadTipoTransaccion(
    BuildContext context,
  ) async {
    //instancia del servicio
    tiposTransaccion.clear();
    TipoTransaccionService tipoTransaccionService = TipoTransaccionService();

    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //consumo del api
    ApiResModel res = await tipoTransaccionService.getTipoTransaccion(
      menuVM.documento!, // documento,
      serieSelect!.serieDocumento!, // serie,
      localVM.selectedEmpresa!.empresa, // empresa,
      loginVM.token, // token,
      loginVM.user, // user,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //Agregar series encontradas
    tiposTransaccion.addAll(res.response);
  }

  //Cargar series
  Future<void> loadSeries(
    BuildContext context,
    int tipoDocumento,
  ) async {
    //View models externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //Datos necesarios
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;
    String user = loginVM.user;
    String token = loginVM.token;

    //limpiar serie seleccionada
    serieSelect = null;
    //simpiar lista serie
    series.clear();

    //instancia del servicio
    SerieService serieService = SerieService();

    //consumo del api
    ApiResModel res = await serieService.getSerie(
      tipoDocumento, // documento,
      empresa, // empresa,
      estacion, // estacion,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //Agregar series encontradas
    series.addAll(res.response);

    //Para realizar pruebas con una sola serie
    // if (series.length > 1) {
    //   if (series.length > 1) {
    //     series.removeRange(
    //       1,
    //       series.length,
    //     ); // Borra todos los elementos excepto el primero
    //   }
    //   serieSelect = series.first;
    // }

    // si sololo hay una serie seleccionarla por defecto
    if (series.length == 1) {
      serieSelect = series.first;

      //cargar las referencias si solo hay una serie y está seleccionada
      await obtenerReferencias(context);
    }

    notifyListeners();
  }

  //cargar vendedores
  Future<void> loadSellers(
    BuildContext context,
    String serie,
    int tipoDocumento,
  ) async {
    //limpiar vendedor seleccionado
    vendedorSelect = null;

    //limmpiar lista vendedor
    cuentasCorrentistasRef.clear();

    //View models externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);

    //Datos necesarios
    int empresa = localVM.selectedEmpresa!.empresa;
    String user = loginVM.user;
    String token = loginVM.token;

    //instancia del servicio
    CuentaService cuentaService = CuentaService();

    //Consummo del api
    ApiResModel res = await cuentaService.getCeuntaCorrentistaRef(
      user, // user,
      tipoDocumento, // doc,
      serie, // serie,
      empresa, // empresa,
      token, // token,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //agregar vendedores
    cuentasCorrentistasRef.addAll(res.response);

    //si solo hay un vendedor agregarlo por defecto
    if (cuentasCorrentistasRef.length == 1) {
      vendedorSelect = cuentasCorrentistasRef.first;
      if (!vmFactura.editDoc) {
        DocumentService.saveDocumentLocal(context);
      }
    }

    if (cuentasCorrentistasRef.isNotEmpty) {
      //Buscar y seleccionar el item con el numero menor en el campo orden
      vendedorSelect = cuentasCorrentistasRef.reduce((prev, curr) {
        return (curr.orden < prev.orden) ? curr : prev;
      });

      if (!vmFactura.editDoc) {
        DocumentService.saveDocumentLocal(context);
      }
    }

    notifyListeners();
  }

  confirmarOrden(
    bool value,
  ) {
    confirmarCotizacion = value;
    notifyListeners();
  }

  //agregar consumidor final
  changeCF(
    BuildContext context,
    bool value,
  ) {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    cf = value;

    //si cf es verdadero
    if (cf) {
      //seleccionar consumidor final
      clienteSelect = ClientModel(
        cuentaCorrentista: 1,
        cuentaCta: "1",
        facturaNombre: "CONSUMIDOR FINAL",
        facturaNit: "C/F",
        facturaDireccion: "CIUDAD",
        cCDireccion: "Ciudad",
        desCuentaCta: "C/F",
        direccion1CuentaCta: "Ciudad",
        eMail: "",
        telefono: "",
        limiteCredito: 0,
        permitirCxC: false,
        celular: null,
        desGrupoCuenta: null,
        grupoCuenta: 0,
      );
      //Mensaje de confirmacion
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'clienteSelec',
        ),
      );

      if (!vmFactura.editDoc) {
        DocumentService.saveDocumentLocal(context);
      }
    } else {
      //no seleccionar
      clienteSelect = null;
      if (!vmFactura.editDoc) {
        DocumentService.saveDocumentLocal(context);
      }
    }

    notifyListeners();
  }

  setText(String value) {
    client.text = value;
    notifyListeners();
  }

  //Buscar clientes
  Future<void> performSearchClient(BuildContext context) async {
    //ocultar cliente
    FocusScope.of(context).unfocus();

    //Validar formualarios
    if (!isValidFormClient()) return;

    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //Datos necesarios
    int empresa = localVM.selectedEmpresa!.empresa;
    String user = loginVM.user;
    String token = loginVM.token;

    //limpiar lista clientes
    cuentasCorrentistas.clear();

    //intancia del servicio
    CuentaService cuentaService = CuentaService();

    //load prosses
    vmFactura.isLoading = true;

    //Consumo del api
    ApiResModel res = await cuentaService.getCuentaCorrentista(
      empresa, // empresa,
      client.text, // filter,
      user, // user,
      token, // token,
    );

    //Stop process

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      vmFactura.isLoading = false;

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //agregar clientes seleccionados
    cuentasCorrentistas.addAll(res.response);

    // si no se encontró nada mostrar mensaje
    if (cuentasCorrentistas.isEmpty) {
      //buscar nit cui en sat

      final docVM = Provider.of<DocumentViewModel>(context, listen: false);

      if (!docVM.printFel()) {
        vmFactura.isLoading = false;

        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinRegistros',
          ),
        );
        return;
      }

      final FelService felService = FelService();

      final ApiResModel resCredenciales = await felService.getCredenciales(
        1, //TODO:Parametrizar certificador
        empresa,
        user,
        token,
      );

      if (!resCredenciales.succes) {
        //si algo salio mal mostrar alerta
        vmFactura.isLoading = false;

        NotificationService.showErrorView(
          context,
          resCredenciales,
        );
        return;
      }

      final List<CredencialModel> credenciales = resCredenciales.response;

      String llaveApi = "";
      String usuarioApi = "";

      for (var credencial in credenciales) {
        switch (credencial.campoNombre) {
          case "LlaveApi":
            llaveApi = credencial.campoValor;

            break;
          case "UsuarioApi":
            usuarioApi = credencial.campoValor;
            break;
          default:
            break;
        }
      }

      //elimar guines
      final receptor = client.text.replaceAll(RegExp(r'[\s\-]'), '');

      final ApiResModel resRecpetor = await felService.getReceptor(
        token,
        llaveApi,
        usuarioApi,
        receptor,
      );

      if (!resRecpetor.succes) {
        //si algo salio mal mostrar alerta
        vmFactura.isLoading = false;

        NotificationService.showErrorView(
          context,
          resRecpetor,
        );
        return;
      }

      if (resRecpetor.response.toString().isEmpty) {
        vmFactura.isLoading = false;

        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinRegistros',
          ),
        );
        return;
      }

      CuentaCorrentistaModel cuenta = CuentaCorrentistaModel(
        cuentaCuenta: "",
        grupoCuenta: 0,
        cuenta: 0,
        nombre: resRecpetor.response,
        direccion: "",
        telefono: "",
        correo: "",
        nit: client.text,
      );

      ApiResModel resNewAccount = await cuentaService.postCuenta(
        user,
        empresa,
        token,
        cuenta,
      );

      //validar respuesta del servico, si es incorrecta
      if (!resNewAccount.succes) {
        //si algo salio mal mostrar alerta
        vmFactura.isLoading = false;

        NotificationService.showErrorView(
          context,
          resNewAccount,
        );
        return;
      }

      ApiResModel resClient = await cuentaService.getCuentaCorrentista(
        empresa,
        cuenta.nit,
        user,
        token,
      );

      //validar respuesta del servico, si es incorrecta
      if (!resClient.succes) {
        vmFactura.isLoading = false;

        await NotificationService.showErrorView(
          context,
          resClient,
        );

        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'cuentaCreadaNoSelec',
          ),
        );
        return;
      }

      final List<ClientModel> clients = resClient.response;

      if (clients.isEmpty) {
        vmFactura.isLoading = false;

        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'cuentaCreadaNoSelec',
          ),
        );
        return;
      }

      if (clients.length == 1) {
        vmFactura.isLoading = false;

        selectClient(false, clients.first, context);
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'cuentaCreadaSelec',
          ),
        );

        if (!vmFactura.editDoc) {
          DocumentService.saveDocumentLocal(context);
        }

        return;
      }

      for (var i = 0; i < clients.length; i++) {
        final ClientModel client = clients[i];
        if (client.facturaNit == cuenta.nit) {
          selectClient(false, client, context);
          break;
        }
      }

      setText(clienteSelect?.facturaNombre ?? "");

      //mapear respuesta servicio
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'cuentaCreadaSelec',
        ),
      );
    }

    //Si solo hay un cliente seleccionarlo por defecto
    if (cuentasCorrentistas.length == 1) {
      vmFactura.isLoading = false;

      clienteSelect = cuentasCorrentistas.first;
      notifyListeners();
      return;
    }

    vmFactura.isLoading = false;

    //si son varias coicidencias navegar a pantalla seleccionar cliente
    Navigator.pushNamed(
      context,
      "selectClient",
      arguments: cuentasCorrentistas,
    );
  }

  //Seleccionar clinte
  void selectClient(
    bool back,
    ClientModel client,
    BuildContext context,
  ) {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    clienteSelect = client;

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
    if (back) Navigator.pop(context);
  }

  //Fechas
  DateTime fechaInicial = DateTime.now();
  DateTime fechaFinal = DateTime.now();
  DateTime fechaRefIni = DateTime.now();
  DateTime fechaRefFin = DateTime.now();

  //Abrir picker de fecha inicial
  Future<void> abrirFechaInicial(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    DateTime fechaHoraActual = DateTime.now();

    if (compararFechas(fechaHoraActual, fechaInicial)) {
      fechaInicial = addDate30Min(fechaActual);
      fechaFinal = addDate30Min(fechaInicial);
      fechaRefFin = addDate30Min(fechaFinal);
    }

    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: fechaHoraActual,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha con la fecha seleccionada en el picker
    fechaInicial = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaInicial.hour,
      fechaInicial.minute,
    );

    //Recalcular precios cuando se cambia la fechas Inicio
    validarFecha(context);

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  validarFecha(BuildContext context) async {
    final vmDetails = Provider.of<DetailsViewModel>(context, listen: false);

    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;

    if (valueParametro(44)) {
      if (Utilities.fechaIgualOMayorSinSegundos(fechaFinal, fechaInicial)) {
        //
        if (vmDetails.traInternas.isNotEmpty) {
          // Calcular nuevos totales
          for (int i = 0; i < vmDetails.traInternas.length; i++) {
            var tra = vmDetails.traInternas[i];
            int count = 0;

            vmFactura.isLoading = true;

            ProductService productService = ProductService();

            // Suponiendo que getFormulaPrecioU es una función asíncrona que devuelve un Future<ResApiInterface>
            ApiResModel res = await productService.getFormulaPrecioU(
              token,
              fechaInicial,
              fechaFinal,
              tra.precioCantidad!.toString(),
            );

            vmFactura.isLoading = false;

            if (!res.succes) {
              NotificationService.showSnackbar(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.notificacion,
                  'noCalculoDias',
                ),
              );

              return;
            }

            List<PrecioDiaModel> calculoDias = res.response;

            if (calculoDias.isEmpty) {
              res.response =
                  "No se están obteniendo valores del procedimiento almacenado";

              NotificationService.showSnackbar(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.notificacion,
                  'noCalculoDias',
                ),
              );

              return;
            }

            vmDetails.traInternas[count].precioDia =
                calculoDias[0].montoCalculado;
            vmDetails.traInternas[count].total = calculoDias[0].montoCalculado;
            vmDetails.traInternas[count].cantidadDias =
                calculoDias[0].cantidadDia;

            count++;
          }

          vmDetails.calculateTotales(context); //actualizar totales

          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'recalcularFechas',
            ),
          );
        }
      } else {
        //Fechas invalidas
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.fecha,
            'restriccion',
          ),
        );
      }
    }
  }

  //Abrir y seleccionar hora inicial
  Future<void> abrirHoraInicial(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    //inicializar picker de la hora con la hora recibida
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaInicial.hour,
      minute: fechaInicial.minute,
    );

    //abre el time picker con la hora inicial
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //si la hora seleccionada es null, no hacer nada.
    if (pickedTime == null) return;

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaInicial = DateTime(
      fechaInicial.year,
      fechaInicial.month,
      fechaInicial.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  //para la final
  Future<void> abrirFechaFinal(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);

    DateTime fechaHoraActual = DateTime.now();

    if (compararFechas(fechaHoraActual, fechaFinal)) {
      fechaFinal = addDate30Min(fechaInicial);
      fechaRefFin = addDate30Min(fechaFinal);
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaFinal,
      firstDate: fechaHoraActual,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha final con la fecha seleccionada en el picker
    fechaFinal = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaFinal.hour,
      fechaFinal.minute,
    );

    //Recalcular precios cuando se cambia la fecha Fin
    validarFecha(context);

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  //Abrir picker de la fecha final
  Future<void> abrirHoraFinal(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);

    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaFinal.hour,
      minute: fechaFinal.minute,
    );

    //abre el time picker con la hora creada con la fecha final
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //si la hora es null no hace nada
    if (pickedTime == null) return;

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaFinal = DateTime(
      fechaFinal.year,
      fechaFinal.month,
      fechaFinal.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  //Fecha entrega
  //Abrir picker de fecha entrega
  Future<void> abrirFechaEntrega(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);

    DateTime fechaHoraActual = DateTime.now();

    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaRefIni,
      firstDate: fechaHoraActual,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha con la fecha seleccionada en el picker
    fechaRefIni = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaRefIni.hour,
      fechaRefIni.minute,
    );

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  //Abrir y seleccionar hora inicial
  Future<void> abrirHoraEntrega(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );
    //inicializar picker de la hora con la hora recibida
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaRefIni.hour,
      minute: fechaRefIni.minute,
    );

    //abre el time picker con la hora inicial
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //si la hora seleccionada es null, no hacer nada.
    if (pickedTime == null) return;

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaRefIni = DateTime(
      fechaRefIni.year,
      fechaRefIni.month,
      fechaRefIni.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  Future<void> abrirFechaRecoger(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    DateTime fechaHoraActual = DateTime.now();

    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaRefFin,
      firstDate: fechaHoraActual,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha con la fecha seleccionada en el picker
    fechaRefFin = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaRefFin.hour,
      fechaRefFin.minute,
    );

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  //Abrir y seleccionar hora inicial
  Future<void> abrirHoraRecoger(BuildContext context) async {
    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    DateTime fechaHoraActual = DateTime.now();

    //inicializar picker de la hora con la hora recibida
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaRefFin.hour,
      minute: fechaRefFin.minute,
    );

    //abre el time picker con la hora inicial
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //si la hora seleccionada es null, no hacer nada.
    if (pickedTime == null) return;

    if (compararFechas(fechaHoraActual, fechaHoraActual)) {
      print("no ${compararFechas(fechaRefIni, fechaHoraActual)}");
    }

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaRefFin = DateTime(
      fechaRefFin.year,
      fechaRefFin.month,
      fechaRefFin.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (!vmFactura.editDoc) {
      DocumentService.saveDocumentLocal(context);
    }

    notifyListeners();
  }

  //Recibe una fecha y le asigna 10 minutos más.
  DateTime addDate30Min(DateTime fecha) {
    return fecha.add(
      const Duration(
        minutes: 30,
      ),
    );
  }

  restaurarFechas() {
    fechaRefIni = DateTime.now();
    fechaInicial = addDate30Min(fechaRefIni);
    fechaFinal = addDate30Min(fechaInicial);
    fechaRefFin = addDate30Min(fechaFinal);
    // fechaInicial = DateTime.now();
    // fechaFinal = DateTime.now();
    // fechaRecoger = DateTime.now();

    notifyListeners();
  }

  bool compararFechas(
    DateTime fechaInicial,
    DateTime fechaFinal,
  ) {
    return fechaInicial.isAfter(fechaFinal);
  }

  //Funcion para validar las fechas

  DateTime fechaActual = DateTime.now();

  bool validateDates() {
    // Remover los segundos de las fechas para la comparación
    fechaActual = DateTime(
      fechaActual.year,
      fechaActual.month,
      fechaActual.day,
      fechaActual.hour,
      fechaActual.minute,
    );

    fechaRefIni = DateTime(
      fechaRefIni.year,
      fechaRefIni.month,
      fechaRefIni.day,
      fechaRefIni.hour,
      fechaRefIni.minute,
    );

    fechaRefFin = DateTime(
      fechaRefFin.year,
      fechaRefFin.month,
      fechaRefFin.day,
      fechaRefFin.hour,
      fechaRefFin.minute,
    );

    fechaInicial = DateTime(
      fechaInicial.year,
      fechaInicial.month,
      fechaInicial.day,
      fechaInicial.hour,
      fechaInicial.minute,
    );

    fechaFinal = DateTime(
      fechaFinal.year,
      fechaFinal.month,
      fechaFinal.day,
      fechaFinal.hour,
      fechaFinal.minute,
    );

    // Validaciones según las condiciones especificadas
    if (validarFechas(fechaActual, fechaRefIni) &&
        fechaRefIni.isBefore(fechaRefFin) &&
        fechaRefFin.isAfter(fechaRefIni) &&
        fechaInicial.isAfter(fechaRefIni) &&
        fechaInicial.isBefore(fechaRefFin) &&
        fechaFinal.isAfter(fechaInicial) &&
        fechaFinal.isBefore(fechaRefFin)) {
      return true;
    }
    return false;
  }

  notificacionFechas(BuildContext context) {
    //fecha ref inicial no puede ser menor a la fecha actual
    if (!validarFechas(fechaActual, fechaRefIni)) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.fecha,
          'fechaEntregaNoActual',
        ),
      );
      return;
    }

    //fecha ref inicial no puede ser menor a la fecha final
    if (!fechaRefIni.isBefore(fechaRefFin)) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.fecha,
          'fechaRecogerNoEntrega',
        ),
      );
      return;
    }

    //fecha inicial debe ser mayor a la fecha ref inicial
    if (!fechaInicial.isAfter(fechaRefIni)) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.fecha,
          'fechaInicialNoEntrega',
        ),
      );
      return;
    }

    //la fecha inicial no puede ser mayor a la fecha ref fin
    if (!fechaInicial.isBefore(fechaRefFin)) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.fecha,
          'fechaRecogerNoInicial',
        ),
      );
      return;
    }

    //la fecha final debe ser mayor a la fecha inicial
    if (!fechaFinal.isAfter(fechaInicial)) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.fecha,
          'fechaFinalNoInicial',
        ),
      );
      return;
    }

    //la fecha final debe ser menor a la fecha ref final
    if (!fechaFinal.isBefore(fechaRefFin)) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.fecha,
          'fechaRecogerNoFinal',
        ),
      );
      return;
    }
  }

  bool validarFechas(DateTime fechaActual, DateTime fechaRecibida) {
    // Comparar día, mes y año
    if (fechaActual.year == fechaRecibida.year &&
        fechaActual.month == fechaRecibida.month &&
        fechaActual.day == fechaRecibida.day) {
      // Verificar si fechaRecibida es igual o mayor a fechaActual
      return !fechaRecibida.isBefore(fechaActual);
    }
    return false;
  }
}
