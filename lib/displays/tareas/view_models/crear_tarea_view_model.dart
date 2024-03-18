// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CrearTareaViewModel extends ChangeNotifier {
  final List<TipoTareaModel> tiposTarea = [];
  final List<EstadoModel> estados = [];
  final List<PrioridadModel> prioridades = [];
  final List<PeriodicidadModel> periodicidades = [];

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  loadData(BuildContext context) async {
    await obtenerTiposTarea(context);
  }

  TextEditingController fechaInicial = TextEditingController();
  TextEditingController fechaFinal = TextEditingController();
  TextEditingController horaInicial = TextEditingController();
  TextEditingController horaFinal = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController tiempoController = TextEditingController();

  TextEditingController observacionController = TextEditingController();

  DateTime fechaActual = DateTime.now();
  DateTime? nuevaFechaInicial;
  DateTime? nuevaFechaFinal;
  DateTime? nuevaHoraInicial;
  TimeOfDay? _horaInicial;
  TimeOfDay? _horaFinal;
  TimeOfDay? get horaInicial1 => _horaInicial;
  TimeOfDay? get horaFinal1 => _horaFinal;

  TipoTareaModel? tipoTarea;
  EstadoModel? estado;
  PrioridadModel? prioridad;
  String? observacion;
  String? titulo;
  String tiempo = "10";
  IdReferenciaModel? idReferencia;

  UsuarioModel? responsable;
  List<UsuarioModel> invitados = [];

  PeriodicidadModel? periodicidad;

  CrearTareaViewModel() {
    tiempoController.text = "10";
    nuevaFechaInicial = fechaActual;
    nuevaFechaFinal = fechaActual;

    fechaInicial.text = DateFormat('dd/MM/yyyy').format(fechaActual);

    final DateTime fecha10 = addDate10Min(fechaActual);

    fechaFinal.text = DateFormat('dd/MM/yyyy').format(fecha10);
    //pickers hora inicial y final
    _horaInicial =
        TimeOfDay(hour: fechaActual.hour, minute: fechaActual.minute);
    _horaFinal = addTime10Min(_horaInicial!);

    horaInicial.text = horaFormato(fechaActual);
    horaFinal.text = horaFormato(fecha10);

    nuevaFechaInicial = fechaActual;
    nuevaFechaFinal = addDate10Min(fechaActual);
  }

  irIdReferencia(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectReferenceId);
  }

  irUsuarios(BuildContext context, int tipo) {
    final vmUsuario = Provider.of<UsuariosViewModel>(context, listen: false);
    invitados = [];
    vmUsuario.tipoBusqueda = tipo;
    Navigator.pushNamed(context, AppRoutes.selectResponsibleUser);
  }

  //recibe el Date time y devuelve la hora formateada
  String horaFormato(DateTime fecha) => DateFormat('h:mm a').format(fecha);

  formatoHora(TimeOfDay pickedTime) {
    String formattedTime = DateFormat('h:mm a').format(
      DateTime(2022, 1, 1, pickedTime.hour, pickedTime.minute),
    );

    return formattedTime;
  }

  TimeOfDay addTime10Min(TimeOfDay pickedTime) {
    int newMinute = pickedTime.minute + 10;
    int newHour = pickedTime.hour;

    if (newMinute >= 60) {
      newHour += newMinute ~/ 60;
      newMinute %= 60;
    }

    if (newHour >= 24) {
      newHour %= 24;
    }

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  TimeOfDay subtract10Min(TimeOfDay pickedTime) {
    int newMinute = pickedTime.minute - 10;
    int newHour = pickedTime.hour;

    if (newMinute < 0) {
      newHour -= 1;
      newMinute += 60;
    }

    if (newHour < 0) {
      newHour += 24;
    }

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  DateTime addDate10Min(DateTime fecha) =>
      fecha.add(const Duration(minutes: 10));

  horaFinal10Min(TimeOfDay pickedTime) {
    return DateFormat('h:mm a').format(
      DateTime(2022, 1, 1, pickedTime.hour, pickedTime.minute + 10),
    );
  }

  crear() {
    if (!isValidForm()) return;

    print("Formulario valido");

    if (titulo == null ||
        observacion == null ||
        tipoTarea == null ||
        estado == null ||
        prioridad == null) {
      print('Falta completar campos');
    } else {
      print('Sí se puede crear la tarea');
      print('Titulo: $titulo');
      print('Observación: $observacion');
      print('Tipo de tarea: $tipoTarea');
      print('Tipo de tarea: $estado');
      print('Tipo de tarea: $prioridad');
      print('Fecha y hora inicial: ${fechaInicial.text} - ${horaInicial.text}');
      print('Fecha y hora final: ${fechaFinal.text} - ${horaFinal.text}');
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  limpiar() {
    tituloController.text = "";
    observacionController.text = "";
    tiempoController.text = "10";
    responsable = null;
    idReferencia = null;
    invitados = [];
  }

  Future crearTarea(BuildContext context) async {
    if (!isValidForm()) {
      NotificationService.showSnackbar(
          "Complete todos loa campos obligarorios para continuar");
      return;
    }
    if (idReferencia == null) {
      NotificationService.showSnackbar("Añada Id Referencia para continuar.");
      return;
    }

    if (responsable == null) {
      NotificationService.showSnackbar("Añada un responsable para continuar.");
      return;
    }

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    String token = vmLogin.token;
    String user = vmLogin.user;
    int empresa = vmLocal.selectedEmpresa!.empresa;

    final TareaService tareaService = TareaService();

    NuevaTareaModel tarea = NuevaTareaModel(
      tarea: 0,
      descripcion: tituloController.text,
      fechaIni: construirFechaCompleta(nuevaFechaInicial!, _horaInicial!),
      fechaFin: construirFechaCompleta(nuevaFechaFinal!, _horaFinal!),
      referencia: idReferencia!.referencia,
      userName: user,
      observacion1: observacionController.text,
      tipoTarea: tipoTarea!.tipoTarea,
      cuentaCorrentista: 1110,
      cuentaCta: null,
      cantidadContacto: null,
      nombreContacto: null,
      tipoDocumento: null,
      idDocumento: null,
      refSerie: null,
      fechaDocumento: null,
      elementoAsignado: null,
      actividadPaso: null,
      ejecutado: null,
      ejecutadoPor: null,
      ejecutadoFecha: null,
      ejecutadoFechaHora: null,
      producto: null,
      estado: estado!.estado,
      empresa: empresa,
      nivelPrioridad: prioridad!.nivelPrioridad,
      tareaPadre: null,
      tiempoEstimadoTipoPeriocidad: periodicidad!.tipoPeriodicidad,
      tiempoEstimado: tiempoController.text,
      mUserName: null,
      observacion2: null,
    );

    isLoading = true;

//Realizar consumo de api para crear tareas
    final ApiResModel res = await tareaService.postTarea(token, tarea);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return false;
    }

    NuevaTareaModel creada = res.message[0];

    TareaModel resCreada = TareaModel(
      tarea: tarea,
      iDTarea: creada.tarea,
      usuarioCreador: user,
      emailCreador: "",
      usuarioResponsable: null,
      descripcion: tituloController.text,
      fechaInicial: construirFechaCompleta(nuevaFechaInicial!, _horaInicial!),
      fechaFinal: construirFechaCompleta(nuevaFechaFinal!, _horaFinal!),
      referencia: idReferencia!.referencia,
      iDReferencia: idReferencia!.referenciaId,
      descripcionReferencia: idReferencia!.descripcion,
      ultimoComentario: "",
      fechaUltimoComentario: null,
      usuarioUltimoComentario: null,
      tareaObservacion1: observacionController.text,
      tareaFechaIni: construirFechaCompleta(nuevaFechaInicial!, _horaInicial!),
      tareaFechaFin: construirFechaCompleta(nuevaFechaFinal!, _horaFinal!),
      tipoTarea: tipoTarea!.tipoTarea,
      descripcionTipoTarea: tipoTarea!.descripcion,
      estadoObjeto: estado!.estado,
      tareaEstado: estado!.descripcion,
      usuarioTarea: user,
      backColor: "#000",
      nivelPrioridad: prioridad!.nivelPrioridad,
      nomNivelPrioridad: prioridad!.nombre,
    );

    //usuario nuevo
    NuevoUsuarioModel usuarioResponsable = NuevoUsuarioModel(
      tarea: creada.tarea,
      userResInvi: responsable!.userName,
      user: user,
    );
    print(usuarioResponsable.userResInvi);
    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel resResponsable = await tareaService.postResponsable(
      token,
      usuarioResponsable,
    );

    //si el consumo salió mal
    if (!resResponsable.succes) {
      isLoading = false;

      //Abrir dialogo de error
      NotificationService.showErrorView(context, resResponsable);

      ApiResModel responsable = ApiResModel(
        message: resResponsable.message,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return responsable;
    }

    ResNuevoUsuarioModel seleccionado = resResponsable.message[0];

    resCreada.usuarioResponsable =
        responsable != null ? responsable!.name : seleccionado.userName;
    notifyListeners();

    //si hay invitados seleccionados
    if (invitados.isNotEmpty) {
      for (var usuario in invitados) {
        //usuario nuevo
        NuevoUsuarioModel usuarioInvitado = NuevoUsuarioModel(
          tarea: creada.tarea,
          userResInvi: usuario.userName,
          user: user,
        );

        print(usuarioInvitado.userResInvi);

        isLoading = true; //cargar pantalla

        //consumo de api
        final ApiResModel resInvitado = await tareaService.postInvitados(
          token,
          usuarioInvitado,
        );

        //si el consumo salió mal
        if (!resInvitado.succes) {
          isLoading = false;

          //Abrir dialogo de error
          NotificationService.showErrorView(context, resInvitado);

          ApiResModel invitado = ApiResModel(
            message: resInvitado.message,
            succes: false,
            url: "",
            storeProcedure: '',
          );

          return invitado;
        }
      }
    }

    //insertar tarea al inicio de la lista de tareas
    vmTarea.insertarTarea(resCreada);
    //mostrra mensaje
    NotificationService.showSnackbar(
      "Tarea creada correctamente.",
    );

    isLoading = false;

    return true;
  }

  Future<DateTime?> abrirFechaInicial(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: nuevaFechaInicial ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    // Verifica si el usuario seleccionó una fecha
    if (pickedDate != null) {
      // Puedes almacenar la fecha en una variable, imprimirlo, o realizar cualquier acción que desees.
      nuevaFechaInicial = pickedDate;
      nuevaFechaFinal = pickedDate;

      fechaInicial.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      fechaFinal.text = DateFormat('dd/MM/yyyy').format(pickedDate);

      notifyListeners();
      // Puedes devolver la fecha si es necesario en el lugar donde llamaste a esta función.
      return pickedDate;
    }

    // Si el usuario cancela la selección, puedes devolver null o cualquier otro valor según tus necesidades.
    return null;
  }

//para la final

  Future<DateTime?> abrirFechaFinal(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: nuevaFechaFinal ?? nuevaFechaInicial ?? fechaActual,
      //fecha minima la fecha actual o lafecha inicial seleciconada
      firstDate: nuevaFechaInicial ?? fechaActual,
      lastDate: DateTime(2100),
    );
    // Verifica si el usuario seleccionó una fecha
    if (pickedDate != null) {
      // Puedes almacenar la fecha en una variable, imprimirlo, o realizar cualquier acción que desees.
      nuevaFechaFinal = pickedDate;

      fechaFinal.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      notifyListeners();
      // Puedes devolver la fecha si es necesario en el lugar donde llamaste a esta función.
      return pickedDate;
    }

    // Si el usuario cancela la selección, puedes devolver null o cualquier otro valor según tus necesidades.
    return null;
  }

  //Abrir y seleccionar hora inicial
  Future<void> abrirHoraInicial(BuildContext context) async {
    DateTime inicio = fechaActual; //hora en que se abri el formulario
    //busca la hora inicial o apartir de Inicio se crea la hora en que iniciara el picker
    TimeOfDay? initialTime =
        _horaInicial ?? TimeOfDay(hour: inicio.hour, minute: inicio.minute);

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime != null && pickedTime != _horaInicial) {
      //asignar la nueva hora inicial seleccionada al picker
      _horaInicial = pickedTime;
      //nombre de la nueva hora inicial
      horaInicial.text = formatoHora(_horaInicial!);
      // Inicialmente, establecer la hora final 10 minutos más tarde que la hora inicial.
      _horaFinal = addTime10Min(pickedTime);

      //nombre de la hora final asignada arriba
      horaFinal.text = horaFinal10Min(_horaInicial!);
      notifyListeners();
    }
  }

  bool validarHora(TimeOfDay horaFinal, TimeOfDay horaInicial) {
    if (horaFinal.hour < horaInicial.hour ||
        (horaFinal.hour == horaInicial.hour &&
            horaFinal.minute <= horaInicial.minute)) {
      return false;
    } else {
      return true;
    }
  }

  bool compararFechas(DateTime fechaInicio, DateTime fechaFinal) {
    return fechaInicio.month == fechaFinal.month &&
        fechaInicio.day == fechaFinal.day;
  }

  Future<void> abrirHoraFinal(BuildContext context) async {
    if (_horaInicial == null) {
      // Si _horaInicial es nulo, asigna la hora actual.
      DateTime inicio = DateTime.now();
      _horaInicial = TimeOfDay(hour: inicio.hour, minute: inicio.minute);
    }

    // Definir la hora inicial del picker y la hora final reestablecida
    TimeOfDay resetFinalTime = _horaFinal != null &&
            (_horaFinal!.hour < _horaInicial!.hour ||
                (_horaFinal!.hour == _horaInicial!.hour &&
                    _horaFinal!.minute < _horaInicial!.minute))
        ? TimeOfDay(hour: _horaInicial!.hour, minute: _horaInicial!.minute + 10)
        : _horaFinal!;

    // Abre el picker con la última hora seleccionada o la hora inicial + 10 minutos si la hora final es menor que la hora inicial.
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _horaFinal != null &&
              (_horaFinal!.hour < _horaInicial!.hour ||
                  (_horaFinal!.hour == _horaInicial!.hour &&
                      _horaFinal!.minute < _horaInicial!.minute))
          ? resetFinalTime
          : _horaFinal ?? _horaInicial!,
    );

    // Almacena la nueva hora seleccionada en el picker.
    if (pickedTime != null) {
      _horaFinal = pickedTime;

      // Verifica si las fechas son iguales (mismo día, mes y año).
      if (compararFechas(nuevaFechaInicial!, nuevaFechaFinal!)) {
        if (!validarHora(_horaFinal!, _horaInicial!)) {
          NotificationService.showSnackbar(
            'La hora final no puede ser menor que la fecha y hora inicial. Modifique primero la fecha final.',
          );
          return;
        }
      }

      // Actualiza el campo de texto con la nueva hora seleccionada.
      horaFinal.text = formatoHora(_horaFinal!);
      notifyListeners();
    }
  }

  //Obtener Tipos
  Future<bool> obtenerTiposTarea(
    BuildContext context,
  ) async {
    tiposTarea.clear();
    tipoTarea = null;

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getTipoTarea(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return false;
    }

    tiposTarea.addAll(res.message);

    for (var i = 0; i < tiposTarea.length; i++) {
      TipoTareaModel tipo = tiposTarea[i];
      if (tipo.descripcion.toLowerCase() == "tarea") {
        tipoTarea = tipo;
        break;
      }
    }

    isLoading = false;

    return true;
  }

  //Obtener Estados
  Future<bool> obtenerEstados(
    BuildContext context,
  ) async {
    estados.clear();
    estado = null;

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    // String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getEstado(token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return false;
    }

    estados.addAll(res.message);

    for (var i = 0; i < estados.length; i++) {
      EstadoModel e = estados[i];
      if (e.descripcion.toLowerCase() == "activo") {
        estado = e;
        break;
      }
    }

    isLoading = false;

    return true;
  }

  //Obtener Prioridades
  Future<bool> obtenerPrioridades(
    BuildContext context,
  ) async {
    prioridades.clear();
    prioridad = null;

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getPrioridad(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return false;
    }

    prioridades.addAll(res.message);

    for (var i = 0; i < prioridades.length; i++) {
      PrioridadModel p = prioridades[i];
      if (p.nombre.toLowerCase() == "normal") {
        prioridad = p;
        break;
      }
    }

    isLoading = false;

    return true;
  }

  //Obtener Periodicidades
  Future<bool> obtenerPeriodicidad(
    BuildContext context,
  ) async {
    periodicidades.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getPeriodicidad(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);

      return false;
    }

    periodicidades.addAll(res.message);

    for (var i = 0; i < periodicidades.length; i++) {
      PeriodicidadModel t = periodicidades[i];
      if (t.descripcion.toLowerCase() == "minutos") {
        periodicidad = t;
        break;
      }
    }

    isLoading = false;
    return true;
  }

  seleccionarIdRef(
    BuildContext context,
    IdReferenciaModel idRefe,
  ) {
    idReferencia = idRefe;

    notifyListeners();

    if (idReferencia != null) {
      Navigator.pop(context);
    }
  }

  seleccionarResponsable(
    BuildContext context,
    UsuarioModel respon,
  ) {
    responsable = respon;
    notifyListeners();

    if (responsable != null) {
      Navigator.pop(context);
    }
  }

  guardarUsuarios(
    BuildContext context,
  ) {
    final vmUsuarios = Provider.of<UsuariosViewModel>(context, listen: false);
    final vmDetalle =
        Provider.of<DetalleTareaViewModel>(context, listen: false);

    vmUsuarios.usuariosSeleccionados.clear();

    for (var usuario in vmUsuarios.usuarios) {
      if (usuario.select) {
        vmUsuarios.usuariosSeleccionados.add(usuario);
      }
    }
    notifyListeners();
    final vm = Provider.of<CrearTareaViewModel>(context, listen: false);

    if (vmUsuarios.usuariosSeleccionados.isNotEmpty) {
      vm.invitados.addAll(vmUsuarios.usuariosSeleccionados);
      Navigator.pop(context);
    }

    if (vmUsuarios.tipoBusqueda == 4) vmDetalle.guardarInvitados(context);
  }

  void eliminarInvitado(int index) {
    invitados[index].select = false;
    invitados.removeAt(index);
    notifyListeners();
  }

  void eliminarResponsable() {
    responsable = null;
    notifyListeners();
  }

  Future agregarResponsable(
    BuildContext context,
    TareaModel tarea,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String user = vmLogin.user;
    String token = vmLogin.token;

    final TareaService tareaService = TareaService();

    //usuario nuevo
    NuevoUsuarioModel usuarioResponsable = NuevoUsuarioModel(
      tarea: tarea.iDTarea,
      userResInvi: responsable!.userName,
      user: user,
    );

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res = await tareaService.postResponsable(
      token,
      usuarioResponsable,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      //Abrir dialogo de error
      // NotificationService.showErrorView(context, res);

      ApiResModel responsable = ApiResModel(
        message: res.message,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return responsable;
    }

    ResponsableModel seleccionado = res.message;

    ResponsableModel reponsableSeleccionado = ResponsableModel(
      tUserName: responsable!.email,
      estado: "activo",
      userName: seleccionado.userName,
      fechaHora: seleccionado.fechaHora,
      mUserName: seleccionado.mUserName,
      mFechaHora: seleccionado.mFechaHora,
      dHm: seleccionado.dHm,
      consecutivoInterno: seleccionado.consecutivoInterno,
    );

    tarea.usuarioResponsable = reponsableSeleccionado.userName;

    notifyListeners();

    isLoading = false;
    //
  }

  //armar fecha
  DateTime construirFechaCompleta(DateTime fecha, TimeOfDay hora) {
    // Obteniendo la fecha y la hora de entrada
    final year = fecha.year;
    final month = fecha.month;
    final day = fecha.day;
    final hour = hora.hour;
    final minute = hora.minute;

    // Construyendo y retornando la fecha completa
    return DateTime(year, month, day, hour, minute);
  }
}
