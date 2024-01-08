// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentViewModel extends ChangeNotifier {
  //Controlador input buscar cliente
  final TextEditingController client = TextEditingController();

  //Seleccionar consummidor final
  bool cf = false;

  //Key for form
  GlobalKey<FormState> formKeyClient = GlobalKey<FormState>();

  //Cliente selecciinado
  ClientModel? clienteSelect;

  //Vendedor seleccionado selccionado
  SellerModel? vendedorSelect;

  //serie seleccionada
  SerieModel? serieSelect;

  //listas globales
  final List<ClientModel> cuentasCorrentistas = []; //cunetas correntisat
  final List<SellerModel> cuentasCorrentistasRef = []; //cuenta correntisat ref
  final List<SerieModel> series = [];
  final List<TipoTransaccionModel> tiposTransaccion = [];
  final List<ParametroModel> parametros = [];

  //limmpiar campos de la vista del usuario
  void clearView() {
    client.text = "";
    clienteSelect = null;
    vendedorSelect = null;
    cf = false;
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

    //niciar proceso
    vmFactura.isLoading = true;

    //Buscar vendedores de la serie
    await loadSellers(context, serieSelect!.serieDocumento!, vmMenu.documento!);
    await loadTipoTransaccion(context);
    await vmPayment.loadPayments(context);
    await loadParametros(context);

    //finalizar proceso
    vmFactura.isLoading = false;

    notifyListeners();
  }

  String getTextCuenta() {
    String fileName = "Cuenta";

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel param = parametros[i];

      //buscar nombre del campo en el parametro 57
      if (param.parametro == 57) {
        fileName = param.paCaracter ?? "Cuenta";
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

    String user = loginVM.nameUser;
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
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //Agregar series encontradas
    parametros.addAll(res.message);
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
      loginVM.nameUser, // user,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //Agregar series encontradas
    tiposTransaccion.addAll(res.message);
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
    String user = loginVM.nameUser;
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
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //Agregar series encontradas
    series.addAll(res.message);

    // si sololo hay una serie seleccionarla por defecto
    if (series.length == 1) {
      serieSelect = series.first;
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

    //Datos necesarios
    int empresa = localVM.selectedEmpresa!.empresa;
    String user = loginVM.nameUser;
    String token = loginVM.token;

    //instancia del servicio
    CuentaService cuentaService = CuentaService();

    //Consummo del api
    ApiResModel res = await cuentaService.getSeller(
      user, // user,
      tipoDocumento, // doc,
      serie, // serie,
      empresa, // empresa,
      token, // token,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //agregar vendedores
    cuentasCorrentistasRef.addAll(res.message);

    //si solo hay un vendedor agregarlo por defecto
    if (cuentasCorrentistasRef.length == 1) {
      vendedorSelect = cuentasCorrentistasRef.first;
    }

    notifyListeners();
  }

  //agregar consumidor final
  changeCF(bool value) {
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
        limiteCredito: 10000000.00,
        permitirCxC: true,
      );
      //Mensaje de confirmacion
      NotificationService.showSnackbar("Cliente seleccionado.");
    } else {
      //no seleccionar
      clienteSelect = null;
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
    String user = loginVM.nameUser;
    String token = loginVM.token;

    //limpiar lista clientes
    cuentasCorrentistas.clear();

    //intancia del servicio
    CuentaService cuentaService = CuentaService();

    //load prosses
    vmFactura.isLoading = true;

    //Consumo del api
    ApiResModel res = await cuentaService.getClient(
      empresa, // empresa,
      client.text, // filter,
      user, // user,
      token, // token,
    );

    //Stop process
    vmFactura.isLoading = false;

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //agregar clientes seleccionados
    cuentasCorrentistas.addAll(res.message);

    // si no se encontró nada mostrar mensaje
    if (cuentasCorrentistas.isEmpty) {
      NotificationService.showSnackbar('No se encontró ningún registro.');
      return;
    }

    //Si solo hay un cliente seleccionarlo por defecto
    if (cuentasCorrentistas.length == 1) {
      clienteSelect = cuentasCorrentistas.first;
      notifyListeners();
      return;
    }

    //si son varias coicidencias navegar a pantalla seleccionar cliente
    Navigator.pushNamed(context, "selectClient",
        arguments: cuentasCorrentistas);
  }

  //Seleccionar clinte
  void selectClient(ClientModel client, BuildContext context) {
    clienteSelect = client;
    notifyListeners();
    Navigator.pop(context);
  }
}
