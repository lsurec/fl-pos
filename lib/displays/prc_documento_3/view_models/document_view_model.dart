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

  final TextEditingController inputContacto = TextEditingController();
  final TextEditingController inputDescripcion = TextEditingController();
  final TextEditingController inputDireccionEntrega = TextEditingController();
  final TextEditingController inputObservacion = TextEditingController();

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

  TipoReferenciaModel? tipoReferenciaSelect;

  //listas globales
  final List<ClientModel> cuentasCorrentistas = []; //cunetas correntisat
  final List<SellerModel> cuentasCorrentistasRef = []; //cuenta correntisat ref
  final List<SerieModel> series = [];
  final List<TipoTransaccionModel> tiposTransaccion = [];
  final List<ParametroModel> parametros = [];
  final List<TipoReferenciaModel> tiposReferencia = [];

  DateTime fechaEntrega = DateTime.now();
  DateTime fechaRecoger = DateTime.now();
  DateTime fechaInicio = DateTime.now();
  DateTime fechaFin = DateTime.now();

  Future<void> showDateEntrega(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaEntrega,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    // Verifica si el usuario seleccionó una fecha
    if (pickedDate == null) return;

    fechaEntrega = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaEntrega.hour,
      fechaEntrega.minute,
    );

    if (fechaEntrega.isAfter(fechaRecoger)) {
      fechaRecoger = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        fechaRecoger.hour,
        fechaRecoger.minute,
      );
    }

    notifyListeners();
  }

  //Abrir y seleccionar hora inicial
  Future<void> showTimeEntrega(BuildContext context) async {
    //busca la hora inicial o apartir de Inicio se crea la hora en que iniciara el picker
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaEntrega.hour,
      minute: fechaEntrega.minute,
    );

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime == null) return;

    fechaEntrega = DateTime(
      fechaEntrega.year,
      fechaEntrega.month,
      fechaEntrega.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (fechaEntrega.isAfter(fechaRecoger)) {
      fechaRecoger = DateTime(
        fechaRecoger.year,
        fechaRecoger.month,
        fechaRecoger.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    notifyListeners();
  }

  Future<void> showDateRecoger(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaRecoger,
      firstDate: fechaEntrega,
      lastDate: DateTime(2100),
    );

    // Verifica si el usuario seleccionó una fecha
    if (pickedDate == null) return;

    fechaRecoger = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaRecoger.hour,
      fechaRecoger.minute,
    );

    notifyListeners();
  }

  //Abrir y seleccionar hora inicial
  Future<void> showTimeRecoger(BuildContext context) async {
    //busca la hora inicial o apartir de Inicio se crea la hora en que iniciara el picker
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaEntrega.hour,
      minute: fechaEntrega.minute,
    );

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime == null) return;

    if (fechasSonIguales(fechaEntrega, fechaRecoger)) {
      final dateValue = DateTime(
        fechaRecoger.year,
        fechaRecoger.month,
        fechaRecoger.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (dateValue.isBefore(fechaRecoger)) {
        NotificationService.showSnackbar(
            "La hora debe ser mayor a la hora inical");
        return;
      }
    }

    fechaRecoger = DateTime(
      fechaRecoger.year,
      fechaRecoger.month,
      fechaRecoger.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    notifyListeners();
  }

  Future<void> showDateInicio(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaInicio,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    // Verifica si el usuario seleccionó una fecha
    if (pickedDate == null) return;

    fechaInicio = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaInicio.hour,
      fechaInicio.minute,
    );

    if (fechaInicio.isAfter(fechaFin)) {
      fechaFin = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        fechaFin.hour,
        fechaFin.minute,
      );
    }

    notifyListeners();
  }

  //Abrir y seleccionar hora inicial
  Future<void> showTimeInicio(BuildContext context) async {
    //busca la hora inicial o apartir de Inicio se crea la hora en que iniciara el picker
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaInicio.hour,
      minute: fechaInicio.minute,
    );

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime == null) return;

    fechaInicio = DateTime(
      fechaInicio.year,
      fechaInicio.month,
      fechaInicio.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (fechaInicio.isAfter(fechaFin)) {
      fechaFin = DateTime(
        fechaFin.year,
        fechaFin.month,
        fechaFin.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    notifyListeners();
  }

  Future<void> showDateFin(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: fechaInicio,
      initialDate: fechaFin,
      lastDate: DateTime(2100),
    );

    // Verifica si el usuario seleccionó una fecha
    if (pickedDate == null) return;

    fechaFin = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaFin.hour,
      fechaFin.minute,
    );

    notifyListeners();
  }

  //Abrir y seleccionar hora inicial
  Future<void> showTimeFin(BuildContext context) async {
    //busca la hora inicial o apartir de Inicio se crea la hora en que iniciara el picker
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaInicio.hour,
      minute: fechaInicio.minute,
    );

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime == null) return;

    if (fechasSonIguales(fechaInicio, fechaFin)) {
      final dateValue = DateTime(
        fechaFin.year,
        fechaFin.month,
        fechaFin.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (dateValue.isBefore(fechaFin)) {
        NotificationService.showSnackbar(
            "La hora debe ser mayor a la hora inical");
        return;
      }
    }

    fechaFin = DateTime(
      fechaFin.year,
      fechaFin.month,
      fechaFin.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    notifyListeners();
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  bool fechasSonIguales(DateTime fecha1, DateTime fecha2) {
    return fecha1.year == fecha2.year &&
        fecha1.month == fecha2.month &&
        fecha1.day == fecha2.day;
  }

  getDateStr(DateTime date) {
    return "${_addLeadingZero(date.day)}/${_addLeadingZero(date.month)}/${_addLeadingZero(date.year)}";
  }

  String getTimeStr(DateTime date) {
    String period = 'AM';
    int hour = date.hour;

    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }

    if (hour == 0) {
      hour = 12;
    }

    String hourStr = _addLeadingZero(hour);
    String minuteStr = _addLeadingZero(date.minute);

    return "$hourStr:$minuteStr $period";
  }

  //limmpiar campos de la vista del usuario
  void clearView() {
    fechaEntrega = DateTime.now();
    fechaRecoger = DateTime.now();
    fechaInicio = DateTime.now();
    fechaFin = DateTime.now();
    client.text = "";
    clienteSelect = null;
    vendedorSelect = null;

    inputContacto.text = "";
    inputDescripcion.text = "";
    inputDireccionEntrega.text = "";
    inputObservacion.text = "";

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

  bool valueParam(int param) {
    bool exist = false;
    //el parametro que indica si se puede esitar el precio o no es 351

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel parametro = parametros[i];

      if (parametro.parametro == param) {
        exist = true;
        break;
      }
    }

    return exist;
  }

  String? getTextParam(int paramValue) {
    String? name;

    for (var i = 0; i < parametros.length; i++) {
      final ParametroModel param = parametros[i];

      if (param.parametro == paramValue) {
        name = param.paCaracter;
        break;
      }
    }

    return name == null ? name : capitalizeFirstLetter(name);
  }

  changeTipoReferencia(TipoReferenciaModel? referencia) {
    tipoReferenciaSelect = referencia;
    notifyListeners();
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
        limiteCredito: 0,
        permitirCxC: false,
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
    vmFactura.isLoading = false;

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        res,
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
